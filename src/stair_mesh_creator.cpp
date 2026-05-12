#include "stair_mesh_creator.h"
#include <cmath>

void StairMeshCreator::add_step_wall(float x, float y, float z, GridSurface& surf) {
    float sx = x - 0.5f;
    float sy = y - 0.5f;
    float sz = z - 0.5f;
    int a = surf.add_vertex(GridVertex(sx,        sy,        sz, 0.f, 0.f, -1.f, (int)COLOR_WHITE, 0.f,  0.2f));
    int b = surf.add_vertex(GridVertex(sx + 1.f,  sy,        sz, 0.f, 0.f, -1.f, (int)COLOR_WHITE, 1.f,  0.2f));
    int c = surf.add_vertex(GridVertex(sx + 1.f,  sy + 0.2f, sz, 0.f, 0.f, -1.f, (int)COLOR_WHITE, 1.f,  0.f));
    int d = surf.add_vertex(GridVertex(sx,         sy + 0.2f, sz, 0.f, 0.f, -1.f, (int)COLOR_WHITE, 0.f,  0.f));
    surf.add_index(a); surf.add_index(d); surf.add_index(c);
    surf.add_index(a); surf.add_index(c); surf.add_index(b);
}

void StairMeshCreator::add_step_floor(float x, float y, float z, GridSurface& surf) {
    float sx = x - 0.5f;
    float sy = y - 0.5f;
    float sz = z - 0.5f;
    int a = surf.add_vertex(GridVertex(sx,       sy, sz,         0.f, 1.f, 0.f, (int)COLOR_WHITE, 0.f, 0.25f));
    int b = surf.add_vertex(GridVertex(sx + 1.f, sy, sz,         0.f, 1.f, 0.f, (int)COLOR_WHITE, 1.f, 0.25f));
    int c = surf.add_vertex(GridVertex(sx + 1.f, sy, sz + 0.25f, 0.f, 1.f, 0.f, (int)COLOR_WHITE, 1.f, 0.f));
    int d = surf.add_vertex(GridVertex(sx,       sy, sz + 0.25f, 0.f, 1.f, 0.f, (int)COLOR_WHITE, 0.f, 0.f));
    surf.add_index(a); surf.add_index(c); surf.add_index(b);
    surf.add_index(a); surf.add_index(d); surf.add_index(c);
}

void StairMeshCreator::create(float x, float y, float z, float yaw, GridSurface& target) {
    GridSurface local;
    add_step_wall(0.f, 0.f,  0.f,   local);
    add_step_wall(0.f, 0.2f, 0.25f, local);
    add_step_wall(0.f, 0.4f, 0.50f, local);
    add_step_wall(0.f, 0.6f, 0.75f, local);
    add_step_wall(0.f, 0.8f, 1.f,   local);
    add_step_floor(0.f, 0.2f, 0.f,   local);
    add_step_floor(0.f, 0.4f, 0.25f, local);
    add_step_floor(0.f, 0.6f, 0.50f, local);
    add_step_floor(0.f, 0.8f, 0.75f, local);

    int base = target.num_vertices();
    float rad = yaw * (float)M_PI / 180.f;
    float c   = cosf(rad);
    float s   = sinf(rad);

    for (const auto& v : local.verts) {
        target.add_vertex(GridVertex(
            v.x * c + v.z * s + x,
            v.y + y,
            -v.x * s + v.z * c + z,
            v.nx * c + v.nz * s,
            v.ny,
            -v.nx * s + v.nz * c,
            v.color, v.u, v.v
        ));
    }
    for (int idx : local.idxs)
        target.add_index(base + idx);
}
