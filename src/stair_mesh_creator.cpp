#include "stair_mesh_creator.h"

void StairMeshCreator::add_step_wall(float x, float y, float z, GridSurface &surf)
{
    float sx = x - 0.5f;
    float sy = y - 0.5f;
    float sz = z - 0.5f;
    int a = surf.add_vertex(GridVertex(sx, sy, sz, 0.f, 0.f, -1.f, (int)COLOR_WHITE, 0.f, 0.25f));
    int b = surf.add_vertex(GridVertex(sx + 1.f, sy, sz, 0.f, 0.f, -1.f, (int)COLOR_WHITE, 1.f, 0.25f));
    int c = surf.add_vertex(GridVertex(sx + 1.f, sy + 0.25f, sz, 0.f, 0.f, -1.f, (int)COLOR_WHITE, 1.f, 0.f));
    int d = surf.add_vertex(GridVertex(sx, sy + 0.25f, sz, 0.f, 0.f, -1.f, (int)COLOR_WHITE, 0.f, 0.f));
    surf.add_index(a);
    surf.add_index(d);
    surf.add_index(c);
    surf.add_index(a);
    surf.add_index(c);
    surf.add_index(b);
}

void StairMeshCreator::add_step_floor(float x, float y, float z, GridSurface &surf)
{
    float sx = x - 0.5f;
    float sy = y - 0.5f;
    float sz = z - 0.5f;
    int a = surf.add_vertex(GridVertex(sx, sy, sz, 0.f, 1.f, 0.f, (int)COLOR_WHITE, 0.f, 0.25f));
    int b = surf.add_vertex(GridVertex(sx + 1.f, sy, sz, 0.f, 1.f, 0.f, (int)COLOR_WHITE, 1.f, 0.25f));
    int c = surf.add_vertex(GridVertex(sx + 1.f, sy, sz + 0.25f, 0.f, 1.f, 0.f, (int)COLOR_WHITE, 1.f, 0.f));
    int d = surf.add_vertex(GridVertex(sx, sy, sz + 0.25f, 0.f, 1.f, 0.f, (int)COLOR_WHITE, 0.f, 0.f));
    surf.add_index(a);
    surf.add_index(c);
    surf.add_index(b);
    surf.add_index(a);
    surf.add_index(d);
    surf.add_index(c);
}

SMesh *StairMeshCreator::create(float x, float y, float z, float yaw)
{
    GridSurface surf;
    add_step_wall(0.f, 0.f, 0.25f, surf);
    add_step_wall(0.f, 0.25f, 0.5f, surf);
    add_step_wall(0.f, 0.50f, 0.75f, surf);
    add_step_wall(0.f, 0.75f, 1.f, surf);
    add_step_floor(0.f, 0.0f, 0.f, surf);
    add_step_floor(0.f, 0.25f, 0.25f, surf);
    add_step_floor(0.f, 0.50f, 0.50f, surf);
    add_step_floor(0.f, 0.75f, 0.75f, surf);

    auto *mesh = new SMesh();
    surf.add_to_mesh(mesh);

    if (yaw != 0.f)
    {
        matrix4 m;
        m.setRotationDegrees(vector3df(0.f, yaw, 0.f));
        App::smgr->getMeshManipulator()->transform(mesh, m);
    }
    matrix4 tm;
    tm.setTranslation(vector3df(x, y, z));
    App::smgr->getMeshManipulator()->transform(mesh, tm);
    App::update_mesh(mesh);
    return mesh;
}
