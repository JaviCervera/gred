#pragma once
#include "flag.h"
#include <vector>
#include <optional>
#include <algorithm>
#include <string>

class FlagManager {
public:
    FlagManager();

    void update(std::optional<int> active_flag);
    void draw_flag_numbers(Camera* cam);
    void clear();
    void place(int flag_id, float x, float y, float z);
    void remove(int flag_id);
    Flag* find(int flag_id);
    std::optional<int> find_index(int flag_id) const;
    int  size() const;
    Flag* at(int index); // 1-based

private:
    std::vector<Flag*>  lst;
    std::optional<int>  current_active;
};
