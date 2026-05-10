#pragma once
#include "i_command.h"
#include "../flag_manager.h"

class RemoveFlagCommand : public ICommand {
public:
    RemoveFlagCommand(FlagManager& fm, int id);
    std::shared_ptr<ICommand> execute() override;

private:
    FlagManager& fm;
    int id;
};
