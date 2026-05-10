#pragma once
#include "i_command.h"
#include "../grid.h"

class RemoveTileCommand : public ICommand {
public:
    RemoveTileCommand(Grid& grid, int x, int y, int z);
    std::shared_ptr<ICommand> execute() override;

private:
    Grid& grid;
    int   x, y, z;
};
