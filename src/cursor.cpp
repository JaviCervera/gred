#include "cursor.h"
#include <algorithm>

Cursor::Cursor(Grid& g) : grid(g), mesh(nullptr), alpha(0.5f), alpha_dir(1.f) {
    mesh = App::smgr->getGeometryCreator()->createCubeMesh(vector3df(1.f, 1.f, 1.f));
    // Fix material on all buffers
    for (u32 i = 0; i < mesh->getMeshBufferCount(); ++i)
        App::fix_material(mesh->getMeshBuffer(i)->getMaterial());
    entity = App::smgr->addMeshSceneNode(mesh);
    // Keep our own reference so getMesh() is not needed later; scene node holds another ref
    // (mesh->drop() not called here to keep the pointer valid)

    SMaterial& mat = entity->getMaterial(0);
    App::set_material_type(mat, MATERIAL_ALPHA);
    App::set_material_flag(mat, FLAG_LIGHTING, false);
    App::set_material_flag(mat, FLAG_VERTEXCOLORS, true);
    reset();
}

void Cursor::reset() {
    App::set_entity_position(entity,
        (float)grid.tiles_x() / 2.f,
        (float)grid.tiles_y() / 2.f,
        (float)grid.tiles_z() / 2.f);
}

void Cursor::update(bool editing) {
    if (editing && !entity->isVisible())  entity->setVisible(true);
    if (!editing && entity->isVisible())  entity->setVisible(false);

    if (!editing) return;

    alpha += alpha_dir * 0.5f * App::delta_time;
    if (alpha <= 0.25f || alpha >= 0.75f) {
        alpha     = std::min(std::max(alpha, 0.25f), 0.75f);
        alpha_dir = -alpha_dir;
    }

    u32 color = App::fade_color(COLOR_ORANGE, (int)(alpha * 255.f));
    App::smgr->getMeshManipulator()->setVertexColors(mesh, SColor(color));
    App::update_mesh(mesh);

    if (App::key_hit[KEY_UP])    App::translate_entity(entity, 0.f,  0.f,  1.f);
    if (App::key_hit[KEY_DOWN])  App::translate_entity(entity, 0.f,  0.f, -1.f);
    if (App::key_hit[KEY_LEFT])  App::translate_entity(entity, -1.f, 0.f,  0.f);
    if (App::key_hit[KEY_RIGHT]) App::translate_entity(entity, 1.f,  0.f,  0.f);
    if (App::key_hit[KEY_KEY_Q]) App::translate_entity(entity, 0.f,  1.f,  0.f);
    if (App::key_hit[KEY_KEY_A]) App::translate_entity(entity, 0.f, -1.f,  0.f);

    float cx = std::min(std::max(App::entity_x(entity), 1.f), (float)grid.tiles_x());
    float cy = std::min(std::max(App::entity_y(entity), 1.f), (float)grid.tiles_y());
    float cz = std::min(std::max(App::entity_z(entity), 1.f), (float)grid.tiles_z());
    App::set_entity_position(entity, cx, cy, cz);
}
