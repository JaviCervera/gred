#pragma once
#include "app.h"
#include "grid_vertex.h"
#include <vector>
#include <string>

class GridSurface {
public:
    std::string             tex_name;
    std::vector<GridVertex> verts;
    std::vector<int>        idxs;

    GridSurface(const std::string& tex = "");

    int  add_vertex(const GridVertex& v);
    void add_index(int idx);
    int  num_vertices() const;
    int  num_indices() const;
    void add_to_mesh(Mesh* mesh, int filter) const;
};
