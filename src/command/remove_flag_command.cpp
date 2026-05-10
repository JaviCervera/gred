#include "remove_flag_command.h"
#include "place_flag_command.h"

RemoveFlagCommand::RemoveFlagCommand(FlagManager& f, int id_)
    : fm(f), id(id_)
{}

std::shared_ptr<ICommand> RemoveFlagCommand::execute() {
    auto* flag = fm.find(id);
    if (!flag) return nullptr;
    auto undo = std::make_shared<PlaceFlagCommand>(fm, id, flag->x(), flag->y(), flag->z());
    fm.remove(id);
    return undo;
}
