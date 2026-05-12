#pragma once
#include "app.h"
#include "grid_surface.h"
#include <map>
#include <string>

class Grid;

class GridMeshCreator {
public:
    static Mesh* create(Grid* grid);

private:
    Grid* grid;
    std::map<std::string, GridSurface> surfs;

    GridMeshCreator(Grid* grid);
    void add_grid_mesh_tile(int x, int y, int z);
    void add_block(int x, int y, int z,
                   bool floor = true, bool front = true,
                   bool right  = true, bool back  = true, bool left = true);
    void add_stairs(int x, int y, int z, float yaw);
    GridSurface& find_surface(const std::string& tex_name);
};
