#include "camera.h"
#include <algorithm>

CameraController::CameraController(Cursor& cur)
    : cursor(cur), distance(6.f), was_editing(true)
    , last_w(App::screen_width()), last_h(App::screen_height())
{
    entity = CreateCamera((u32_t)last_w, (u32_t)last_h, nullptr);
    SetCameraNearDistance(entity, 0.1f);
    SetCameraFarDistance(entity, 100.f);
    SetCameraBackgroundColor(entity, 0xFF000050u);
    if (last_h > 0)
        SetCameraAspectRatio(entity, (float)last_w / (float)last_h);
    // Prime rotation so move_entity uses the correct pitch on frame 1
    SetEntityRotation((Entity*)entity, 89.9f, 0.f, 0.f);
}

void CameraController::update(bool editing) {
    int w = App::screen_width();
    int h = App::screen_height();
    if ((w != last_w || h != last_h) && h > 0) {
        SetCameraAspectRatio(entity, (float)w / (float)h);
        last_w = w;
        last_h = h;
    }

    if (editing) {
        float cx = App::entity_x((Entity*)cursor.entity);
        float cy = App::entity_y((Entity*)cursor.entity);
        float cz = App::entity_z((Entity*)cursor.entity);
        App::set_entity_position((Entity*)entity, cx, cy, cz);
        distance = std::max(2.f, distance - (float)App::mouse_wheel);
        App::move_entity((Entity*)entity, 0.f, 0.f, -distance);
        SetEntityRotation((Entity*)entity, 89.9f, 0.f, 0.f);
        was_editing = true;
    } else {
        if (was_editing) {
            App::set_entity_position((Entity*)entity,
                App::entity_x((Entity*)cursor.entity),
                App::entity_y((Entity*)cursor.entity),
                App::entity_z((Entity*)cursor.entity));
            SetEntityRotation((Entity*)entity, 0.f, 0.f, 0.f);
        }
        if (App::key_down[GLFW_KEY_UP])
            App::move_entity((Entity*)entity, 0.f, 0.f, MOVE_SPEED * App::delta_time);
        if (App::key_down[GLFW_KEY_DOWN])
            App::move_entity((Entity*)entity, 0.f, 0.f, -MOVE_SPEED * App::delta_time);
        if (App::key_down[GLFW_KEY_LEFT])
            App::turn_entity((Entity*)entity, 0.f, -TURN_SPEED * App::delta_time, 0.f);
        if (App::key_down[GLFW_KEY_RIGHT])
            App::turn_entity((Entity*)entity, 0.f,  TURN_SPEED * App::delta_time, 0.f);
        if (App::key_down[GLFW_KEY_Q])
            App::translate_entity((Entity*)entity, 0.f,  MOVE_SPEED * App::delta_time, 0.f);
        if (App::key_down[GLFW_KEY_A])
            App::translate_entity((Entity*)entity, 0.f, -MOVE_SPEED * App::delta_time, 0.f);
        was_editing = false;
    }
}
