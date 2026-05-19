#pragma once
#include "app.h"
#include "grid.h"
#include "cursor.h"
#include "texture_viewer.h"
#include "flag_manager.h"
#include "undo_manager.h"
#include "grid_obj_exporter.h"
#include <string>
#include <optional>

class GridManager {
public:
    GridManager(Grid& grid, Cursor& cursor,
                TextureViewer& ceiling_tex, TextureViewer& wall_tex, TextureViewer& floor_tex,
                FlagManager& flag_mgr, UndoManager& undo_mgr);

    void reset();
    void update();
    void toggle_lighting();
    bool lighting_enabled() const;
    void place_flag();
    void delete_flag();
    int         current_flag() const;
    bool        is_editing()   const;
    std::string mode_name()    const;

private:
    Grid&          grid;
    Cursor&        cursor;
    TextureViewer& ceiling_tex;
    TextureViewer& wall_tex;
    TextureViewer& floor_tex;
    FlagManager&   flag_mgr;
    UndoManager&   undo_mgr;

    bool            editing;
    int             mode;
    int             cur_flag;
    std::optional<std::string> filename;
    ISceneNode*     lights;
    GridOBJExporter obj_exporter;
};
