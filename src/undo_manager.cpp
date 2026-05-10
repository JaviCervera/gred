#include "undo_manager.h"
#include "app.h"

UndoManager::UndoManager() {}

void UndoManager::add_undo(std::shared_ptr<ICommand> cmd) {
    if (cmd) {
        undo_stack.push_back(cmd);
        redo_stack.clear();
    }
}

bool UndoManager::can_undo() const { return !undo_stack.empty(); }
bool UndoManager::can_redo() const { return !redo_stack.empty(); }

void UndoManager::undo() {
    if (!can_undo()) return;
    auto result = undo_stack.back()->execute();
    undo_stack.pop_back();
    if (result) redo_stack.push_back(result);
}

void UndoManager::redo() {
    if (!can_redo()) return;
    auto result = redo_stack.back()->execute();
    redo_stack.pop_back();
    if (result) undo_stack.push_back(result);
}

void UndoManager::update() {
    bool ctrl = App::key_down[KEY_LCONTROL] || App::key_down[KEY_RCONTROL];
    if (ctrl) {
        if (App::key_hit[KEY_KEY_Z]) undo();
        if (App::key_hit[KEY_KEY_Y]) redo();
    }
}

void UndoManager::reset() {
    undo_stack.clear();
    redo_stack.clear();
}
