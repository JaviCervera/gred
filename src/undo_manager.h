#pragma once
#include "command/i_command.h"
#include <vector>
#include <memory>

class UndoManager {
public:
    UndoManager();

    void add_undo(std::shared_ptr<ICommand> cmd);
    bool can_undo() const;
    bool can_redo() const;
    void undo();
    void redo();
    void update();
    void reset();

private:
    std::vector<std::shared_ptr<ICommand>> undo_stack;
    std::vector<std::shared_ptr<ICommand>> redo_stack;
};
