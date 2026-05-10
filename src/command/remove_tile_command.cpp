#include "remove_tile_command.h"
#include "set_tile_command.h"

RemoveTileCommand::RemoveTileCommand(Grid& g, int x_, int y_, int z_)
    : grid(g), x(x_), y(y_), z(z_)
{}

std::shared_ptr<ICommand> RemoveTileCommand::execute() {
    if (!grid.has_tile(x, y, z)) return nullptr;
    auto undo = std::make_shared<SetTileCommand>(
        grid, x, y, z,
        grid.get_tile_type(x, y, z),
        grid.ceiling_texture_name(x, y, z),
        grid.wall_texture_name(x, y, z),
        grid.floor_texture_name(x, y, z));
    grid.remove_tile(x, y, z);
    return undo;
}
