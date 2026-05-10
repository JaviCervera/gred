#include "app.h"
#include "grid.h"
#include "cursor.h"
#include "camera.h"
#include "flag_manager.h"
#include "undo_manager.h"
#include "texture_reader.h"
#include "texture_viewer.h"
#include "grid_manager.h"
#include <string>
#include <cmath>
#include <algorithm>
#include <dirent.h>
#include <vector>

#ifdef _WIN32
#include <direct.h>
#else
#include <unistd.h>
#endif

#ifdef __APPLE__
#include <CoreFoundation/CoreFoundation.h>
#endif

static std::string enable_disable(bool state)
{
    return state ? "Disable" : "Enable";
}

static std::string normalize_slashes(std::string path)
{
    std::replace(path.begin(), path.end(), '\\', '/');
    return path;
}

static std::string with_trailing_slash(std::string path)
{
    path = normalize_slashes(path);
    if (!path.empty() && path.back() != '/')
        path.push_back('/');
    return path;
}

static std::string join_path(const std::string &base, const std::string &child)
{
    if (base.empty())
        return normalize_slashes(child);
    return normalize_slashes(with_trailing_slash(base) + child);
}

static bool directory_exists(const std::string &path)
{
    DIR *dir = opendir(path.c_str());
    if (!dir)
        return false;
    closedir(dir);
    return true;
}

static std::string current_working_dir()
{
    char buf[2048];
#ifdef _WIN32
    if (_getcwd(buf, sizeof(buf)) != nullptr)
#else
    if (getcwd(buf, sizeof(buf)) != nullptr)
#endif
        return with_trailing_slash(buf);
    return "./";
}

static bool has_assets_at(const std::string &base)
{
    return directory_exists(base + "textures") && directory_exists(base + "icons");
}

static std::string detect_resource_root(const char *argv0)
{
    std::vector<std::string> candidates;
    auto add_candidate = [&](const std::string &p)
    {
        std::string c = with_trailing_slash(p);
        if (!c.empty() && std::find(candidates.begin(), candidates.end(), c) == candidates.end())
            candidates.push_back(c);
    };

    const std::string cwd = current_working_dir();
    add_candidate(cwd);
    add_candidate(join_path(cwd, "_build"));

    if (argv0 && argv0[0] != '\0')
    {
        std::string exe = normalize_slashes(argv0);
        bool is_absolute = (!exe.empty() && exe[0] == '/') || (exe.size() > 1 && exe[1] == ':');
        std::size_t slash_pos = exe.find_last_of('/');
        std::string exe_dir;
        if (slash_pos == std::string::npos)
            exe_dir = cwd;
        else
            exe_dir = exe.substr(0, slash_pos);

        if (!is_absolute)
            exe_dir = join_path(cwd, exe_dir);

        add_candidate(exe_dir);
        add_candidate(join_path(exe_dir, "../Resources"));
        add_candidate(join_path(exe_dir, ".."));
        add_candidate(join_path(exe_dir, "../.."));
        add_candidate(join_path(exe_dir, "../../.."));
        add_candidate(join_path(exe_dir, "../../../_build"));
    }

#ifdef __APPLE__
    CFBundleRef bundle = CFBundleGetMainBundle();
    if (bundle)
    {
        CFURLRef resources_url = CFBundleCopyResourcesDirectoryURL(bundle);
        if (resources_url)
        {
            char path[PATH_MAX];
            if (CFURLGetFileSystemRepresentation(resources_url, true, reinterpret_cast<UInt8 *>(path), sizeof(path)))
            {
                add_candidate(path);
            }
            CFRelease(resources_url);
        }
    }
#endif

    for (const auto &base : candidates)
    {
        if (has_assets_at(base))
            return base;
    }

    return "./";
}

int main(int argc, char **argv)
{
    const char *argv0 = (argc > 0 && argv && argv[0]) ? argv[0] : nullptr;
    const std::string resource_root = detect_resource_root(argv0);
    const std::string TEX_PATH = resource_root + "textures/";

    if (!App::init(1024, 768, 32, SCREEN_RESIZABLE | SCREEN_VSYNC))
        return 1;

    App::set_resource_root(resource_root);
    App::device->getFileSystem()->changeWorkingDirectoryTo(resource_root.c_str());

    auto texture_names = TextureReader::read(TEX_PATH);

    TextureViewer ceiling_tex(texture_names, 1, TEX_PATH, KEY_KEY_W, KEY_KEY_E);
    TextureViewer wall_tex(texture_names, 2, TEX_PATH, KEY_KEY_S, KEY_KEY_D);
    TextureViewer floor_tex(texture_names, 3, TEX_PATH, KEY_KEY_X, KEY_KEY_C);

    Grid grid(64, 16, 64, TEX_PATH);
    Cursor cursor(grid);
    FlagManager flag_mgr;
    UndoManager undo_mgr;
    GridManager grid_mgr(grid, cursor, ceiling_tex, wall_tex, floor_tex, flag_mgr, undo_mgr);
    Camera cam(cursor);

    while (App::run())
    {
        undo_mgr.update();
        cursor.update(grid_mgr.is_editing());
        cam.update(grid_mgr.is_editing());
        grid_mgr.update();
        if (grid_mgr.is_editing())
        {
            ceiling_tex.update();
            wall_tex.update();
            floor_tex.update();
        }
        flag_mgr.update(grid_mgr.current_flag());

        App::draw_world(cam.entity);
        flag_mgr.draw_flag_numbers(cam.entity);

        if (grid_mgr.is_editing())
        {
            int sw = App::driver->getScreenSize().Width;
            int sh = App::driver->getScreenSize().Height;

            ceiling_tex.draw(sw - 144, 16, 128, 128);
            wall_tex.draw(sw - 144, 160, 128, 128);
            floor_tex.draw(sw - 144, 304, 128, 128);

            App::draw_text("[F1] New -- [F2] Load -- [F3] Save -- [F4] Mode: " + grid_mgr.mode_name() + " -- [ENTER] Preview", 8, 8, COLOR_WHITE);

            App::draw_text(
                "[F] " + enable_disable(grid.filtering_enabled()) + " texture filtering -- "
                                                                    "[L] " +
                    enable_disable(grid_mgr.lighting_enabled()) + " lighting -- "
                                                                  "[R] " +
                    enable_disable(grid.wireframe_enabled()) + " wireframe",
                8, 24, COLOR_WHITE);

            App::draw_text(
                "[U/I] Select flag number (current: " + std::to_string(grid_mgr.current_flag()) + ") -- [P] Place flag -- [O] Delete flag",
                8, 40, COLOR_WHITE);

            int cx = (int)std::round(App::entity_x(cursor.entity));
            int cy = (int)std::round(App::entity_y(cursor.entity));
            int cz = (int)std::round(App::entity_z(cursor.entity));
            App::draw_text(
                "Cursor Position " + std::to_string(cx) + "x" + std::to_string(cy) + "x" + std::to_string(cz),
                8, sh - 24, COLOR_WHITE);
        }

        App::refresh_screen();
    }

    App::device->drop();
    return 0;
}
