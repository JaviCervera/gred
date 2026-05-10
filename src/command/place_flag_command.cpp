#include "place_flag_command.h"
#include "remove_flag_command.h"

PlaceFlagCommand::PlaceFlagCommand(FlagManager& f, int id_, int x_, int y_, int z_)
    : fm(f), id(id_), x(x_), y(y_), z(z_)
{}

std::shared_ptr<ICommand> PlaceFlagCommand::execute() {
    auto prev = fm.find(id);
    if (prev) {
        auto undo = std::make_shared<PlaceFlagCommand>(fm, id, prev->x(), prev->y(), prev->z());
        fm.place(id, x, y, z);
        return undo;
    }
    fm.place(id, x, y, z);
    return std::make_shared<RemoveFlagCommand>(fm, id);
}
