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

static std::string enable_disable(bool state)
{
    return state ? "Disable" : "Enable";
}

int main()
{
    const std::string TEX_PATH = "textures/";

    App::init(1024, 768, 32, SCREEN_RESIZABLE | SCREEN_VSYNC);

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
