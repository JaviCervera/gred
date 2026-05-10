#pragma once
#include "i_command.h"
#include "../grid.h"
#include <string>

class SetTileCommand : public ICommand {
public:
    SetTileCommand(Grid& grid, int x, int y, int z, int kind,
                   const std::string& ceiling_tex,
                   const std::string& wall_tex,
                   const std::string& floor_tex);

    std::shared_ptr<ICommand> execute() override;

private:
    Grid&       grid;
    int         x, y, z;
    int         kind;
    std::string ceiling_tex;
    std::string wall_tex;
    std::string floor_tex;
};
