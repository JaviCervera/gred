#include "flag.h"

ITexture *Flag::active_texture = nullptr;
ITexture *Flag::inactive_texture = nullptr;

Flag::Flag(int id_, float x, float y, float z) : id(id_)
{
    entity = App::smgr->addBillboardSceneNode();
    App::fix_material(entity->getMaterial(0));
    entity->getMaterial(0).MaterialType = EMT_TRANSPARENT_ALPHA_CHANNEL;
    entity->setSize(dimension2df(1.0f, 1.0f));
    active = false;
    position(x, y, z);
    set_active(true);
}

void Flag::destroy()
{
    entity->remove();
}

void Flag::position(float x, float y, float z)
{
    App::set_entity_position(entity, x, y, z);
}

float Flag::x() const { return App::entity_x(entity); }
float Flag::y() const { return App::entity_y(entity); }
float Flag::z() const { return App::entity_z(entity); }

void Flag::set_active(bool a)
{
    if (active_texture == nullptr)
        active_texture = App::driver->getTexture("icons/flag_red.png");
    if (inactive_texture == nullptr)
        inactive_texture = App::driver->getTexture("icons/flag_orange.png");

    if (a != active)
    {
        active = a;
        entity->getMaterial(0).setTexture(0, active ? active_texture : inactive_texture);
    }
}
