#pragma once
#include "app.h"
#include "cursor.h"

class CameraController {
public:
    Camera* entity;

    CameraController(Cursor& cursor);
    void update(bool editing);

private:
    static constexpr float MOVE_SPEED = 2.0f;
    static constexpr float TURN_SPEED = 90.0f;

    Cursor& cursor;
    float   distance;
    bool    was_editing;
    int     last_w;
    int     last_h;
};
