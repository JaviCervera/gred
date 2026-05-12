#include "grid_manager.h"
#include "grid_loader.h"
#include "grid_saver.h"
#include "dialogs.h"
#include "command/set_tile_command.h"
#include "command/remove_tile_command.h"
#include "command/place_flag_command.h"
#include "command/remove_flag_command.h"
#include <algorithm>
#include <cmath>

static const std::string MODE_NAMES[] = {
    "Tile", "Stairs Forward", "Stairs Right", "Stairs Backwards", "Stairs Left"
};

GridManager::GridManager(Grid& g, Cursor& cur,
                          TextureViewer& ceil_tex, TextureViewer& wall_tex_, TextureViewer& floor_tex_,
                          FlagManager& fm, UndoManager& um)
    : grid(g), cursor(cur)
    , ceiling_tex(ceil_tex), wall_tex(wall_tex_), floor_tex(floor_tex_)
    , flag_mgr(fm), undo_mgr(um)
{
    reset();
}

void GridManager::reset() {
    filename   = std::nullopt;
    editing    = true;
    mode       = Grid::TILE;
    cur_flag   = 1;
    grid.reset(grid.tiles_x(), grid.tiles_y(), grid.tiles_z());
    cursor.reset();
    undo_mgr.reset();
    flag_mgr.clear();
}

void GridManager::update() {
    if (App::key_hit[GLFW_KEY_ENTER]) editing = !editing;
    if (App::key_hit[GLFW_KEY_F])  grid.toggle_filtering();
    if (App::key_hit[GLFW_KEY_L])  toggle_lighting();
    if (App::key_hit[GLFW_KEY_R])  grid.toggle_wireframe();
    if (App::key_hit[GLFW_KEY_U])  cur_flag = std::max(1, cur_flag - 1);
    if (App::key_hit[GLFW_KEY_I])  cur_flag = std::min(100, cur_flag + 1);
    if (App::key_hit[GLFW_KEY_P])  place_flag();
    if (App::key_hit[GLFW_KEY_O])  delete_flag();

    if (editing) {
        if (App::key_hit[GLFW_KEY_F1]) reset();

        if (App::key_hit[GLFW_KEY_F2]) {
            std::string current = filename.value_or("");
            std::string selected = Dialogs::request_file("Grid filename", "*.grd", false, current);
            if (!selected.empty()) {
                GridLoader::load(grid, flag_mgr, selected);
                filename = selected;
                undo_mgr.reset();
            }
        }

        if (App::key_hit[GLFW_KEY_F3]) {
            if (!filename.has_value()) {
                std::string selected = Dialogs::request_file("Grid filename", "*.grd", true, "");
                if (!selected.empty()) filename = selected;
            }
            if (filename.has_value())
                GridSaver::save(grid, flag_mgr, filename.value());
        }

        if (App::key_hit[GLFW_KEY_F4]) {
            ++mode;
            if (mode > Grid::STAIRS_LEFT) mode = Grid::TILE;
        }

        if (App::key_down[GLFW_KEY_SPACE]) {
            int cx = (int)std::round(App::entity_x((Entity*)cursor.entity));
            int cy = (int)std::round(App::entity_y((Entity*)cursor.entity));
            int cz = (int)std::round(App::entity_z((Entity*)cursor.entity));
            auto cmd = std::make_shared<SetTileCommand>(
                grid, cx, cy, cz, mode,
                ceiling_tex.texture_name(),
                wall_tex.texture_name(),
                floor_tex.texture_name());
            undo_mgr.add_undo(cmd->execute());
        }

        if (App::key_down[GLFW_KEY_DELETE]) {
            int cx = (int)std::round(App::entity_x((Entity*)cursor.entity));
            int cy = (int)std::round(App::entity_y((Entity*)cursor.entity));
            int cz = (int)std::round(App::entity_z((Entity*)cursor.entity));
            auto cmd = std::make_shared<RemoveTileCommand>(grid, cx, cy, cz);
            undo_mgr.add_undo(cmd->execute());
        }
    }
}

void GridManager::toggle_lighting() {
    bool on = !grid.lighting_enabled();
    if (on) {
        SetAmbientLightColor(COLOR_LIGHTGRAY);
        SetSunColor(COLOR_WHITE);
        SetSunPitch(45.f);
        SetSunYaw(30.f);
    } else {
        SetAmbientLightColor(COLOR_WHITE);
        SetSunColor(COLOR_BLACK);
    }
    grid.set_lighting(on);
}

bool GridManager::lighting_enabled() const { return grid.lighting_enabled(); }

void GridManager::place_flag() {
    int cx = (int)std::round(App::entity_x((Entity*)cursor.entity));
    int cy = (int)std::round(App::entity_y((Entity*)cursor.entity));
    int cz = (int)std::round(App::entity_z((Entity*)cursor.entity));
    auto cmd = std::make_shared<PlaceFlagCommand>(flag_mgr, cur_flag, cx, cy, cz);
    undo_mgr.add_undo(cmd->execute());
}

void GridManager::delete_flag() {
    auto cmd = std::make_shared<RemoveFlagCommand>(flag_mgr, cur_flag);
    undo_mgr.add_undo(cmd->execute());
}

int         GridManager::current_flag() const { return cur_flag; }
bool        GridManager::is_editing()   const { return editing; }

std::string GridManager::mode_name() const {
    int idx = mode - 1; // TILE=1 → idx=0
    if (idx < 0 || idx >= (int)(sizeof(MODE_NAMES)/sizeof(MODE_NAMES[0]))) return "";
    return MODE_NAMES[idx];
}
