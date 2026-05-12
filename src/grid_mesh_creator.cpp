#include "grid_mesh_creator.h"
#include "grid.h"
#include "stair_mesh_creator.h"

Mesh* GridMeshCreator::create(Grid* g) {
    GridMeshCreator creator(g);
    for (int x = 1; x <= g->tiles_x(); ++x)
        for (int y = 1; y <= g->tiles_y(); ++y)
            for (int z = 1; z <= g->tiles_z(); ++z)
                creator.add_grid_mesh_tile(x, y, z);

    int filter = g->filtering_enabled() ? FILTER_TRILINEAR : FILTER_NONE;
    Mesh* mesh = CreateMesh();
    for (auto& kv : creator.surfs)
        kv.second.add_to_mesh(mesh, filter);
    RebuildMesh(mesh);
    return mesh;
}

GridMeshCreator::GridMeshCreator(Grid* g) : grid(g) {}

void GridMeshCreator::add_grid_mesh_tile(int x, int y, int z) {
    if (!grid->has_tile(x, y, z)) return;
    int t = grid->get_tile_type(x, y, z);
    if (t == Grid::TILE)             add_block(x, y, z);
    if (t == Grid::STAIRS_FORWARD)   add_stairs(x, y, z, 0.f);
    if (t == Grid::STAIRS_RIGHT)     add_stairs(x, y, z, 90.f);
    if (t == Grid::STAIRS_BACKWARDS) add_stairs(x, y, z, 180.f);
    if (t == Grid::STAIRS_LEFT)      add_stairs(x, y, z, 270.f);
}

void GridMeshCreator::add_block(int x, int y, int z,
                                bool do_floor, bool front, bool right, bool back, bool left) {
    // Floor
    if (do_floor && !grid->has_tile(x, y - 1, z)) {
        auto& surf = find_surface(grid->floor_texture_name(x, y, z));
        float sx = (float)x - 0.5f, sy = (float)y - 0.5f, sz = (float)z - 0.5f;
        int a = surf.add_vertex(GridVertex(sx,       sy, sz,       0.f, 1.f, 0.f, (int)COLOR_WHITE, 0.f, 1.f));
        int b = surf.add_vertex(GridVertex(sx + 1.f, sy, sz,       0.f, 1.f, 0.f, (int)COLOR_WHITE, 1.f, 1.f));
        int c = surf.add_vertex(GridVertex(sx + 1.f, sy, sz + 1.f, 0.f, 1.f, 0.f, (int)COLOR_WHITE, 1.f, 0.f));
        int d = surf.add_vertex(GridVertex(sx,       sy, sz + 1.f, 0.f, 1.f, 0.f, (int)COLOR_WHITE, 0.f, 0.f));
        surf.add_index(a); surf.add_index(c); surf.add_index(b);
        surf.add_index(a); surf.add_index(d); surf.add_index(c);
    }

    // Ceiling
    if (!grid->has_tile(x, y + 1, z)) {
        auto& surf = find_surface(grid->ceiling_texture_name(x, y, z));
        float sx = (float)x - 0.5f, sy = (float)y + 0.5f, sz = (float)z - 0.5f;
        int a = surf.add_vertex(GridVertex(sx,       sy, sz,       0.f, -1.f, 0.f, (int)COLOR_WHITE, 0.f, 1.f));
        int b = surf.add_vertex(GridVertex(sx + 1.f, sy, sz,       0.f, -1.f, 0.f, (int)COLOR_WHITE, 1.f, 1.f));
        int c = surf.add_vertex(GridVertex(sx + 1.f, sy, sz + 1.f, 0.f, -1.f, 0.f, (int)COLOR_WHITE, 1.f, 0.f));
        int d = surf.add_vertex(GridVertex(sx,       sy, sz + 1.f, 0.f, -1.f, 0.f, (int)COLOR_WHITE, 0.f, 0.f));
        surf.add_index(a); surf.add_index(b); surf.add_index(c);
        surf.add_index(a); surf.add_index(c); surf.add_index(d);
    }

    {
        auto& surf = find_surface(grid->wall_texture_name(x, y, z));

        // Left wall
        if (left && !grid->has_tile(x - 1, y, z)) {
            float sx = (float)x - 0.5f, sy = (float)y - 0.5f, sz = (float)z - 0.5f;
            int a = surf.add_vertex(GridVertex(sx, sy,       sz,       1.f, 0.f, 0.f, (int)COLOR_WHITE, 0.f, 1.f));
            int b = surf.add_vertex(GridVertex(sx, sy,       sz + 1.f, 1.f, 0.f, 0.f, (int)COLOR_WHITE, 1.f, 1.f));
            int c = surf.add_vertex(GridVertex(sx, sy + 1.f, sz + 1.f, 1.f, 0.f, 0.f, (int)COLOR_WHITE, 1.f, 0.f));
            int d = surf.add_vertex(GridVertex(sx, sy + 1.f, sz,       1.f, 0.f, 0.f, (int)COLOR_WHITE, 0.f, 0.f));
            surf.add_index(a); surf.add_index(c); surf.add_index(b);
            surf.add_index(a); surf.add_index(d); surf.add_index(c);
        }

        // Right wall
        if (right && !grid->has_tile(x + 1, y, z)) {
            float sx = (float)x + 0.5f, sy = (float)y - 0.5f, sz = (float)z - 0.5f;
            int a = surf.add_vertex(GridVertex(sx, sy,       sz,       -1.f, 0.f, 0.f, (int)COLOR_WHITE, 0.f, 1.f));
            int b = surf.add_vertex(GridVertex(sx, sy,       sz + 1.f, -1.f, 0.f, 0.f, (int)COLOR_WHITE, 1.f, 1.f));
            int c = surf.add_vertex(GridVertex(sx, sy + 1.f, sz + 1.f, -1.f, 0.f, 0.f, (int)COLOR_WHITE, 1.f, 0.f));
            int d = surf.add_vertex(GridVertex(sx, sy + 1.f, sz,       -1.f, 0.f, 0.f, (int)COLOR_WHITE, 0.f, 0.f));
            surf.add_index(b); surf.add_index(c); surf.add_index(a);
            surf.add_index(a); surf.add_index(c); surf.add_index(d);
        }

        // Front wall
        if (front && !grid->has_tile(x, y, z + 1)) {
            float sx = (float)x - 0.5f, sy = (float)y - 0.5f, sz = (float)z + 0.5f;
            int a = surf.add_vertex(GridVertex(sx,       sy,       sz, 0.f, 0.f, -1.f, (int)COLOR_WHITE, 0.f, 1.f));
            int b = surf.add_vertex(GridVertex(sx + 1.f, sy,       sz, 0.f, 0.f, -1.f, (int)COLOR_WHITE, 1.f, 1.f));
            int c = surf.add_vertex(GridVertex(sx + 1.f, sy + 1.f, sz, 0.f, 0.f, -1.f, (int)COLOR_WHITE, 1.f, 0.f));
            int d = surf.add_vertex(GridVertex(sx,       sy + 1.f, sz, 0.f, 0.f, -1.f, (int)COLOR_WHITE, 0.f, 0.f));
            surf.add_index(a); surf.add_index(d); surf.add_index(c);
            surf.add_index(a); surf.add_index(c); surf.add_index(b);
        }

        // Back wall
        if (back && !grid->has_tile(x, y, z - 1)) {
            float sx = (float)x - 0.5f, sy = (float)y - 0.5f, sz = (float)z - 0.5f;
            int a = surf.add_vertex(GridVertex(sx,       sy,       sz, 0.f, 0.f, 1.f, (int)COLOR_WHITE, 0.f, 1.f));
            int b = surf.add_vertex(GridVertex(sx + 1.f, sy,       sz, 0.f, 0.f, 1.f, (int)COLOR_WHITE, 1.f, 1.f));
            int c = surf.add_vertex(GridVertex(sx + 1.f, sy + 1.f, sz, 0.f, 0.f, 1.f, (int)COLOR_WHITE, 1.f, 0.f));
            int d = surf.add_vertex(GridVertex(sx,       sy + 1.f, sz, 0.f, 0.f, 1.f, (int)COLOR_WHITE, 0.f, 0.f));
            surf.add_index(a); surf.add_index(b); surf.add_index(d);
            surf.add_index(b); surf.add_index(c); surf.add_index(d);
        }
    }
}

void GridMeshCreator::add_stairs(int x, int y, int z, float yaw) {
    add_block(x, y, z, false,
              yaw != 0.f,   // front
              yaw != 90.f,  // right
              yaw != 180.f, // back
              yaw != 270.f);// left

    auto& surf = find_surface(grid->floor_texture_name(x, y, z));
    StairMeshCreator::create((float)x, (float)y, (float)z, yaw, surf);
}

GridSurface& GridMeshCreator::find_surface(const std::string& tex_name) {
    if (surfs.count(tex_name) == 0) {
        std::string full = grid->get_texture_path() + tex_name;
        surfs.emplace(tex_name, GridSurface(full));
    }
    return surfs.at(tex_name);
}
