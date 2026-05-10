#pragma once
#include <irrlicht.h>
#include <string>

using namespace irr;
using namespace irr::core;
using namespace irr::scene;
using namespace irr::video;
using namespace irr::gui;
using namespace irr::io;

// Color constants (ARGB)
constexpr u32 COLOR_WHITE = 0xFFFFFFFFu;
constexpr u32 COLOR_BLACK = 0xFF000000u;
constexpr u32 COLOR_RED = 0xFFFF0000u;
constexpr u32 COLOR_GREEN = 0xFF00FF00u;
constexpr u32 COLOR_BLUE = 0xFF0000FFu;
constexpr u32 COLOR_YELLOW = 0xFFFFFF00u;
constexpr u32 COLOR_ORANGE = 0xFFFFA500u;
constexpr u32 COLOR_LIGHTGRAY = 0xFFBFBFBFu;
constexpr u32 COLOR_DARKGRAY = 0xFF404040u;
constexpr u32 COLOR_GRAY = 0xFF808080u;

// Material types
constexpr int MATERIAL_SOLID = 0;
constexpr int MATERIAL_SOLID_ALPHA = 1;
constexpr int MATERIAL_LIGHTMAP = 2;
constexpr int MATERIAL_LIGHTMAP_ADD = 3;
constexpr int MATERIAL_LIGHTMAP_MUL = 4;
constexpr int MATERIAL_LIGHTMAP_MUL4 = 5;
constexpr int MATERIAL_ALPHA = 6;
constexpr int MATERIAL_VERTEXALPHA = 7;
constexpr int MATERIAL_ALPHATEST = 8;
constexpr int MATERIAL_SPHERE = 9;
constexpr int MATERIAL_REFLECT = 10;
constexpr int MATERIAL_ONETEX = 11;

// Material flags
constexpr int FLAG_LIGHTING = 1;
constexpr int FLAG_FOG = 2;
constexpr int FLAG_ZREAD = 4;
constexpr int FLAG_ZWRITE = 8;
constexpr int FLAG_BACKFACECULLING = 16;
constexpr int FLAG_NORMALIZE = 32;
constexpr int FLAG_VERTEXCOLORS = 64;
constexpr int FLAG_CLAMP = 128;

// Filter modes
constexpr int FILTER_DISABLED = 0;
constexpr int FILTER_BILINEAR = 1;
constexpr int FILTER_TRILINEAR = 2;
constexpr int FILTER_ANISOTROPIC = 3;

// Render modes
constexpr int RENDER_FILLED = 0;
constexpr int RENDER_WIREFRAME = 1;
constexpr int RENDER_POINTCLOUD = 2;

// Light types
constexpr int LIGHT_DIRECTIONAL = 0;
constexpr int LIGHT_POINT = 1;
constexpr int LIGHT_SPOT = 2;

// Screen flags
constexpr int SCREEN_FULLSCREEN = 1;
constexpr int SCREEN_RESIZABLE = 2;
constexpr int SCREEN_VSYNC = 4;

namespace App
{
    extern IrrlichtDevice *device;
    extern IVideoDriver *driver;
    extern ISceneManager *smgr;
    extern IGUIEnvironment *guienv;
    extern std::string resource_root;

    extern float delta_time;
    extern float point_x;
    extern float point_y;
    extern int mouse_wheel;
    extern bool key_down[KEY_KEY_CODES_COUNT];
    extern bool key_hit[KEY_KEY_CODES_COUNT];

    bool init(int width, int height, int bits, int flags);
    void set_resource_root(const std::string &root);
    std::string resource_path(const std::string &relative);
    bool run();
    void draw_world(ICameraSceneNode *cam);
    void refresh_screen();

    void draw_text(const std::string &text, int x, int y, u32 color);
    int text_width(const std::string &text);
    int text_height(const std::string &text);
    void draw_rect(int x, int y, int w, int h, u32 color);
    void draw_texture_ex(ITexture *tex, int x, int y, int w, int h, u32 color);
    void world_to_screen(ICameraSceneNode *cam, float x, float y, float z);
    void set_ambient(u32 color);

    u32 fade_color(u32 color, int new_alpha);
    void set_material_type(SMaterial &mat, int type);
    void set_material_flag(SMaterial &mat, int flag, bool enable);
    void set_material_filter_mode(SMaterial &mat, int mode);
    void set_material_render_mode(SMaterial &mat, int mode);
    void fix_material(SMaterial &mat);
    void update_mesh(IMesh *mesh);

    void set_entity_position(ISceneNode *node, float x, float y, float z);
    void set_entity_rotation(ISceneNode *node, float pitch, float yaw, float roll);
    void move_entity(ISceneNode *node, float x, float y, float z);
    void translate_entity(ISceneNode *node, float x, float y, float z);
    void turn_entity(ISceneNode *node, float pitch, float yaw, float roll);
    ISceneNode *entity_child(ISceneNode *node, int index); // 1-based
    float entity_x(ISceneNode *node);
    float entity_y(ISceneNode *node);
    float entity_z(ISceneNode *node);
}
