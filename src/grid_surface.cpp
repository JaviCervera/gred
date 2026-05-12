#include "grid_surface.h"

GridSurface::GridSurface(const std::string& tex)
    : tex_name(tex)
{}

int GridSurface::add_vertex(const GridVertex& v) {
    verts.push_back(v);
    return (int)verts.size() - 1;
}

void GridSurface::add_index(int idx) {
    idxs.push_back(idx);
}

int GridSurface::num_vertices() const { return (int)verts.size(); }
int GridSurface::num_indices()  const { return (int)idxs.size(); }

void GridSurface::add_to_mesh(Mesh* mesh, int filter) const {
    if (verts.empty()) return;

    u32_t surf_idx = GetNumMeshSurfaces(mesh);
    Surface* surf = CreateSurface(RENDER_TRIANGLES);

    for (const auto& v : verts)
        AddVertex(surf, v.x, v.y, v.z, v.nx, v.ny, v.nz, (u32_t)v.color, v.u, v.v);

    for (int i = 0; i + 2 < (int)idxs.size(); i += 3)
        AddTriangle(surf, (u32_t)idxs[i], (u32_t)idxs[i+1], (u32_t)idxs[i+2]);

    RebuildSurface(surf);
    AddMeshSurface(mesh, surf);
    FreeSurface(surf);

    if (!tex_name.empty()) {
        Material* mat = GetMeshMaterial(mesh, surf_idx);
        SetMaterialColorTexture(mat, CacheTexture(tex_name.c_str(), filter));
        SetMaterialLightingEnabled(mat, FALSE);
    }
}
