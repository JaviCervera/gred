#include "flag.h"

Texture* Flag::active_texture   = nullptr;
Texture* Flag::inactive_texture = nullptr;

Flag::Flag(int id_, float x, float y, float z) : id(id_) {
    if (!active_texture)
        active_texture   = CacheTexture(App::resource_path("icons/flag_red.png").c_str(),   FILTER_NONE);
    if (!inactive_texture)
        inactive_texture = CacheTexture(App::resource_path("icons/flag_orange.png").c_str(), FILTER_NONE);

    entity = CreateSprite(inactive_texture, 1, 1, SPRITE_SPHERICAL, nullptr);
    SetSpriteSize(entity, 1.f, 1.f);
    Material* mat = GetEntityMaterial((Entity*)entity, 0);
    SetMaterialBlendMode(mat, BLEND_ALPHA);
    SetMaterialLightingEnabled(mat, FALSE);
    active = false;
    position(x, y, z);
    set_active(true);
}

void Flag::destroy() {
    FreeEntity((Entity*)entity);
}

void Flag::position(float x, float y, float z) {
    App::set_entity_position((Entity*)entity, x, y, z);
}

float Flag::x() const { return App::entity_x((Entity*)entity); }
float Flag::y() const { return App::entity_y((Entity*)entity); }
float Flag::z() const { return App::entity_z((Entity*)entity); }

void Flag::set_active(bool a) {
    if (a != active) {
        active = a;
        Texture* tex = active ? active_texture : inactive_texture;
        SetMaterialColorTexture(GetEntityMaterial((Entity*)entity, 0), tex);
    }
}
