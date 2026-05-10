#include "grid_surface.h"

GridSurface::GridSurface(const std::string& tex)
    : tex_name(tex)
{}

int GridSurface::add_vertex(const GridVertex& v) {
    verts.push_back(v);
    return (int)verts.size() - 1;
}

void GridSurface::add_index(int idx) {
    idxs.push_back((u16)idx);
}

int GridSurface::num_vertices() const { return (int)verts.size(); }
int GridSurface::num_indices()  const { return (int)idxs.size(); }

IMeshBuffer* GridSurface::add_to_mesh(SMesh* mesh) const {
    auto* buffer = new SMeshBuffer();
    App::fix_material(buffer->getMaterial());

    buffer->Vertices.reallocate((u32)verts.size());
    for (const auto& v : verts) {
        buffer->Vertices.push_back(S3DVertex(
            v.x, v.y, v.z,
            v.nx, v.ny, v.nz,
            SColor((u32)v.color),
            v.u, v.v));
    }

    buffer->Indices.reallocate((u32)idxs.size());
    for (u16 idx : idxs)
        buffer->Indices.push_back(idx);

    buffer->recalculateBoundingBox();

    if (!tex_name.empty())
        buffer->getMaterial().setTexture(0, App::driver->getTexture(tex_name.c_str()));

    mesh->addMeshBuffer(buffer);
    buffer->drop();
    return buffer;
}
