#pragma once
#include "app.h"
#include "cursor.h"

class Camera {
public:
    ICameraSceneNode* entity;

    Camera(Cursor& cursor);
    void update(bool editing);

private:
    static constexpr float MOVE_SPEED = 2.0f;
    static constexpr float TURN_SPEED = 90.0f;

    Cursor& cursor;
    float   distance;
    bool    was_editing;
    dimension2du last_screen_size;
};
