#pragma once
#include "app.h"

class Flag {
public:
    int                  id;
    IBillboardSceneNode* entity;

    Flag(int id, float x, float y, float z);
    ~Flag() = default;

    void destroy();
    void position(float x, float y, float z);
    float x() const;
    float y() const;
    float z() const;
    void set_active(bool active);

private:
    bool active = false;
    static ITexture* active_texture;
    static ITexture* inactive_texture;
};
