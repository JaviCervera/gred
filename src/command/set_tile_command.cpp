#include "set_tile_command.h"
#include "remove_tile_command.h"

SetTileCommand::SetTileCommand(Grid& g, int x_, int y_, int z_, int kind_,
                               const std::string& ceil,
                               const std::string& wall,
                               const std::string& floor)
    : grid(g), x(x_), y(y_), z(z_), kind(kind_)
    , ceiling_tex(ceil), wall_tex(wall), floor_tex(floor)
{}

std::shared_ptr<ICommand> SetTileCommand::execute() {
    std::shared_ptr<ICommand> undo_cmd;
    if (grid.has_tile(x, y, z)) {
        if (grid.get_tile_type(x, y, z) != kind
         || grid.ceiling_texture_name(x, y, z) != ceiling_tex
         || grid.wall_texture_name(x, y, z)    != wall_tex
         || grid.floor_texture_name(x, y, z)   != floor_tex)
        {
            undo_cmd = std::make_shared<SetTileCommand>(
                grid, x, y, z,
                grid.get_tile_type(x, y, z),
                grid.ceiling_texture_name(x, y, z),
                grid.wall_texture_name(x, y, z),
                grid.floor_texture_name(x, y, z));
        }
    } else {
        undo_cmd = std::make_shared<RemoveTileCommand>(grid, x, y, z);
    }
    grid.set_tile(x, y, z, kind, ceiling_tex, wall_tex, floor_tex);
    return undo_cmd;
}
