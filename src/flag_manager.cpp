#include "flag_manager.h"

FlagManager::FlagManager() {}

void FlagManager::update(std::optional<int> active_flag) {
    if (active_flag != current_active) {
        if (current_active.has_value()) {
            Flag* f = find(*current_active);
            if (f) f->set_active(false);
            current_active = std::nullopt;
        }
        if (active_flag.has_value()) {
            Flag* f = find(*active_flag);
            if (f) {
                f->set_active(true);
                current_active = active_flag;
            }
        }
    }
}

void FlagManager::draw_flag_numbers(Camera* cam) {
    for (Flag* flag : lst) {
        App::world_to_screen(cam, flag->x(), flag->y(), flag->z());
        std::string label = std::to_string(flag->id);
        int w = App::text_width(label);
        int h = App::text_height(label);
        App::draw_rect((int)App::point_x, (int)App::point_y, w, h, COLOR_BLACK);
        App::draw_text(label, (int)App::point_x, (int)App::point_y, COLOR_YELLOW);
    }
}

void FlagManager::clear() {
    for (Flag* f : lst) f->destroy();
    lst.clear();
    current_active = std::nullopt;
}

void FlagManager::place(int flag_id, float x, float y, float z) {
    auto idx = find_index(flag_id);
    if (!idx.has_value()) {
        lst.push_back(new Flag(flag_id, x, y, z));
        std::sort(lst.begin(), lst.end(), [](Flag* a, Flag* b){ return a->id < b->id; });
    } else {
        lst[*idx]->position(x, y, z);
    }
}

void FlagManager::remove(int flag_id) {
    auto idx = find_index(flag_id);
    if (!idx.has_value()) return;
    lst[*idx]->destroy();
    lst.erase(lst.begin() + *idx);
}

Flag* FlagManager::find(int flag_id) {
    auto idx = find_index(flag_id);
    return idx.has_value() ? lst[*idx] : nullptr;
}

std::optional<int> FlagManager::find_index(int flag_id) const {
    for (int i = 0; i < (int)lst.size(); ++i)
        if (lst[i]->id == flag_id) return i;
    return std::nullopt;
}

int FlagManager::size() const { return (int)lst.size(); }

Flag* FlagManager::at(int index) {
    if (index <= 0 || index > size()) return nullptr;
    return lst[index - 1];
}
