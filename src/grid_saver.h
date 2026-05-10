#pragma once
#include "app.h"
#include "grid.h"
#include "flag_manager.h"
#include <string>
#include <vector>
#include <cstdint>

class GridSaver {
public:
    static void save(Grid& grid, FlagManager& flag_mgr, const std::string& filename);
};
