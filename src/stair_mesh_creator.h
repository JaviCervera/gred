#pragma once
#include "grid_surface.h"

class StairMeshCreator {
public:
    static void create(float x, float y, float z, float yaw, GridSurface& target);

private:
    static void add_step_wall(float x, float y, float z, GridSurface& surf);
    static void add_step_floor(float x, float y, float z, GridSurface& surf);
};
