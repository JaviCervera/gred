#pragma once
#include "i_command.h"
#include "../flag_manager.h"

class PlaceFlagCommand : public ICommand {
public:
    PlaceFlagCommand(FlagManager& fm, int id, int x, int y, int z);
    std::shared_ptr<ICommand> execute() override;

private:
    FlagManager& fm;
    int id, x, y, z;
};
