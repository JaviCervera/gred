#pragma once
#include "app.h"
#include "grid_surface.h"

class StairMeshCreator {
public:
    static SMesh* create(float x, float y, float z, float yaw);

private:
    static void add_step_wall(float x, float y, float z, GridSurface& surf);
    static void add_step_floor(float x, float y, float z, GridSurface& surf);
};
