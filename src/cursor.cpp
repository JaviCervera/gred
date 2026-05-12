#include "cursor.h"
#include <algorithm>

Cursor::Cursor(Grid& g) : grid(g), alpha(0.5f), alpha_dir(1.f) {
    Mesh* mesh = CreateCubeMesh();
    entity = CreateModel(mesh, nullptr);
    FreeMesh(mesh);

    Material* mat = GetEntityMaterial((Entity*)entity, 0);
    SetMaterialBlendMode(mat, BLEND_ALPHA);
    SetMaterialLightingEnabled(mat, FALSE);
    SetMaterialColor(mat, ChangeAlpha(COLOR_ORANGE, (int)(alpha * 255.f)));
    reset();
}

Cursor::~Cursor() {
    if (entity) FreeModel(entity);
}

void Cursor::reset() {
    App::set_entity_position((Entity*)entity,
        (float)grid.tiles_x() / 2.f,
        (float)grid.tiles_y() / 2.f,
        (float)grid.tiles_z() / 2.f);
}

void Cursor::update(bool editing) {
    SetEntityVisible((Entity*)entity, editing ? TRUE : FALSE);

    if (!editing) return;

    alpha += alpha_dir * 0.5f * App::delta_time;
    if (alpha <= 0.25f || alpha >= 0.75f) {
        alpha     = std::min(std::max(alpha, 0.25f), 0.75f);
        alpha_dir = -alpha_dir;
    }

    Material* mat = GetEntityMaterial((Entity*)entity, 0);
    SetMaterialColor(mat, ChangeAlpha(COLOR_ORANGE, (int)(alpha * 255.f)));

    if (App::key_hit[GLFW_KEY_UP])    App::translate_entity((Entity*)entity, 0.f,  0.f,  1.f);
    if (App::key_hit[GLFW_KEY_DOWN])  App::translate_entity((Entity*)entity, 0.f,  0.f, -1.f);
    if (App::key_hit[GLFW_KEY_LEFT])  App::translate_entity((Entity*)entity, -1.f, 0.f,  0.f);
    if (App::key_hit[GLFW_KEY_RIGHT]) App::translate_entity((Entity*)entity, 1.f,  0.f,  0.f);
    if (App::key_hit[GLFW_KEY_Q])     App::translate_entity((Entity*)entity, 0.f,  1.f,  0.f);
    if (App::key_hit[GLFW_KEY_A])     App::translate_entity((Entity*)entity, 0.f, -1.f,  0.f);

    float cx = std::min(std::max(App::entity_x((Entity*)entity), 1.f), (float)grid.tiles_x());
    float cy = std::min(std::max(App::entity_y((Entity*)entity), 1.f), (float)grid.tiles_y());
    float cz = std::min(std::max(App::entity_z((Entity*)entity), 1.f), (float)grid.tiles_z());
    App::set_entity_position((Entity*)entity, cx, cy, cz);
}
