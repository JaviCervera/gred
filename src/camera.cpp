#include "camera.h"
#include <algorithm>

Camera::Camera(Cursor& cur)
    : cursor(cur), distance(6.f), was_editing(true)
{
    entity = App::smgr->addCameraSceneNode(nullptr,
                                           vector3df(0.f, 0.f, 0.f),
                                           vector3df(0.f, 0.f, 1.f));
    entity->setNearValue(0.1f);
    entity->setFarValue(100.f);
    // Prime the rotation so that move_entity on frame 1 already uses the correct pitch
    entity->setRotation(vector3df(89.9f, 0.f, 0.f));
}

void Camera::update(bool editing) {
    if (editing) {
        float cx = App::entity_x(cursor.entity);
        float cy = App::entity_y(cursor.entity);
        float cz = App::entity_z(cursor.entity);
        App::set_entity_position(entity, cx, cy, cz);
        // Do NOT reset rotation here — move_entity must use the existing (89.9,0,0) pitch
        // so that (0,0,-dist) in local space maps to ~(0,+dist,0) in world space, placing
        // the camera above the cursor rather than behind it in Z.
        distance = std::max(2.f, distance - (float)App::mouse_wheel);
        App::move_entity(entity, 0.f, 0.f, -distance);
        entity->setRotation(vector3df(89.9f, 0.f, 0.f));
        was_editing = true;
    } else {
        if (was_editing) {
            App::set_entity_position(entity,
                App::entity_x(cursor.entity),
                App::entity_y(cursor.entity),
                App::entity_z(cursor.entity));
            entity->setRotation(vector3df(0.f, 0.f, 0.f));
        }
        if (App::key_down[KEY_UP])
            App::move_entity(entity, 0.f, 0.f, MOVE_SPEED * App::delta_time);
        if (App::key_down[KEY_DOWN])
            App::move_entity(entity, 0.f, 0.f, -MOVE_SPEED * App::delta_time);
        if (App::key_down[KEY_LEFT])
            App::turn_entity(entity, 0.f, -TURN_SPEED * App::delta_time, 0.f);
        if (App::key_down[KEY_RIGHT])
            App::turn_entity(entity, 0.f,  TURN_SPEED * App::delta_time, 0.f);
        if (App::key_down[KEY_KEY_Q])
            App::translate_entity(entity, 0.f,  MOVE_SPEED * App::delta_time, 0.f);
        if (App::key_down[KEY_KEY_A])
            App::translate_entity(entity, 0.f, -MOVE_SPEED * App::delta_time, 0.f);
        was_editing = false;
    }
}
