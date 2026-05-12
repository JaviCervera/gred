#pragma once
#include <vortex.h>
#include <GLFW/glfw3.h>
#include <string>

// Screen flags
constexpr int SCREEN_FULLSCREEN = 1;
constexpr int SCREEN_RESIZABLE  = 2;
constexpr int SCREEN_VSYNC      = 4;

namespace App
{
    extern std::string resource_root;

    extern float delta_time;
    extern float point_x;
    extern float point_y;
    extern int   mouse_wheel;
    extern bool  key_down[GLFW_KEY_LAST + 1];
    extern bool  key_hit[GLFW_KEY_LAST + 1];

    bool        init(int width, int height, int flags);
    void        set_resource_root(const std::string& root);
    std::string resource_path(const std::string& relative);
    bool        run();
    void        draw_world(Camera* cam);
    void        refresh_screen();
    int         screen_width();
    int         screen_height();

    void draw_text(const std::string& text, int x, int y, u32_t color);
    int  text_width(const std::string& text);
    int  text_height(const std::string& text);
    void draw_rect(int x, int y, int w, int h, u32_t color);
    void draw_texture_ex(Texture* tex, int x, int y, int w, int h, u32_t color);
    void world_to_screen(Camera* cam, float x, float y, float z);

    void  set_entity_position(Entity* e, float x, float y, float z);
    void  set_entity_rotation(Entity* e, float pitch, float yaw, float roll);
    void  move_entity(Entity* e, float x, float y, float z);
    void  translate_entity(Entity* e, float x, float y, float z);
    void  turn_entity(Entity* e, float pitch, float yaw, float roll);
    float entity_x(Entity* e);
    float entity_y(Entity* e);
    float entity_z(Entity* e);
}
