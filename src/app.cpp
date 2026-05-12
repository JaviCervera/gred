#include "app.h"
#include <cstring>

namespace App
{

std::string resource_root;

float delta_time = 0.0f;
float point_x    = 0.0f;
float point_y    = 0.0f;
int   mouse_wheel = 0;
bool  key_down[GLFW_KEY_LAST + 1] = {};
bool  key_hit[GLFW_KEY_LAST + 1]  = {};

static GLFWwindow* s_window     = nullptr;
static Font*       s_font       = nullptr;
static Camera*     s_cam        = nullptr;
static double      s_last_time  = 0.0;
static int         s_scroll_accum = 0;

static bool s_key_was_down[GLFW_KEY_LAST + 1] = {};

// ---------------------------------------------------------------------------
static void scroll_callback(GLFWwindow*, double /*xoffset*/, double yoffset)
{
    s_scroll_accum += (int)yoffset;
}

// ---------------------------------------------------------------------------
bool init(int width, int height, int flags)
{
    if (!glfwInit())
        return false;

    glfwWindowHint(GLFW_SAMPLES, 4);
    glfwWindowHint(GLFW_RESIZABLE, (flags & SCREEN_RESIZABLE) ? GLFW_TRUE : GLFW_FALSE);

    GLFWmonitor* monitor = (flags & SCREEN_FULLSCREEN) ? glfwGetPrimaryMonitor() : nullptr;
    s_window = glfwCreateWindow(width, height, "gred", monitor, nullptr);
    if (!s_window)
    {
        glfwTerminate();
        return false;
    }

    glfwMakeContextCurrent(s_window);
    if (flags & SCREEN_VSYNC)
        glfwSwapInterval(1);

    InitVortex(reinterpret_cast<ProcLoader>(glfwGetProcAddress), 4);
    SetFramebufferSize(width, height);

    glfwSetScrollCallback(s_window, scroll_callback);

    s_cam = CreateCamera((u32_t)width, (u32_t)height, nullptr);
    SetCameraBackgroundColor(s_cam, 0xFF000050u);

    // Load a default font for UI text
    s_font = LoadFont("C:\\Windows\\Fonts\\courbd.ttf", 16);
    if (!s_font)
        s_font = LoadFont("/System/Library/Fonts/Supplemental/Courier New Bold.ttf", 16);
    if (!s_font)
        s_font = LoadFont("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 16);

    s_last_time = glfwGetTime();

    // Default world state: ambient = white, no sun (effectively unlit look)
    SetAmbientLightColor(COLOR_WHITE);
    SetSunColor(COLOR_BLACK);

    return true;
}

// ---------------------------------------------------------------------------
void set_resource_root(const std::string& root)
{
    resource_root = root;
    if (!resource_root.empty() && resource_root.back() != '/')
        resource_root.push_back('/');
}

std::string resource_path(const std::string& relative)
{
    if (resource_root.empty())
        return relative;
    return resource_root + relative;
}

// ---------------------------------------------------------------------------
bool run()
{
    if (!s_window || glfwWindowShouldClose(s_window))
        return false;

    glfwPollEvents();

    // Update delta time
    double now = glfwGetTime();
    delta_time = (float)(now - s_last_time);
    s_last_time = now;
    SetDeltaTime(delta_time);

    // Update key state
    for (int k = 0; k <= GLFW_KEY_LAST; ++k)
    {
        bool pressed = (glfwGetKey(s_window, k) == GLFW_PRESS);
        key_hit[k]  = pressed && !s_key_was_down[k];
        key_down[k] = pressed;
        s_key_was_down[k] = pressed;
    }

    // Consume accumulated scroll
    mouse_wheel = s_scroll_accum;
    s_scroll_accum = 0;

    return true;
}

// ---------------------------------------------------------------------------
void draw_world(Camera* cam)
{
    int w = screen_width();
    int h = screen_height();
    SetCameraViewport(cam, 0, 0, (u32_t)w, (u32_t)h);
    if (h > 0)
        SetCameraAspectRatio(cam, (float)w / (float)h);
    UpdateWorld();
    DrawWorld((u32_t)w, (u32_t)h);
    Setup2D(0, 0, w, h);
}

// ---------------------------------------------------------------------------
void refresh_screen()
{
    if (s_window)
        glfwSwapBuffers(s_window);
}

// ---------------------------------------------------------------------------
int screen_width()
{
    int w = 0, h = 0;
    if (s_window)
        glfwGetFramebufferSize(s_window, &w, &h);
    return w;
}

int screen_height()
{
    int w = 0, h = 0;
    if (s_window)
        glfwGetFramebufferSize(s_window, &w, &h);
    return h;
}

// ---------------------------------------------------------------------------
void draw_text(const std::string& text, int x, int y, u32_t color)
{
    if (!s_font) return;
    SetColor((i32_t)color);
    DrawText(s_font, (float)x, (float)y, text.c_str());
}

int text_width(const std::string& text)
{
    if (!s_font) return 0;
    return (int)TextWidth(s_font, text.c_str());
}

int text_height(const std::string& text)
{
    if (!s_font) return 0;
    return (int)TextHeight(s_font, text.c_str());
}

void draw_rect(int x, int y, int w, int h, u32_t color)
{
    SetColor((i32_t)color);
    DrawRect((float)x, (float)y, (float)w, (float)h);
}

void draw_texture_ex(Texture* tex, int x, int y, int w, int h, u32_t color)
{
    if (!tex) return;
    SetColor((i32_t)color);
    DrawTexture(tex, (float)x, (float)y, (float)w, (float)h);
}

void world_to_screen(Camera* cam, float x, float y, float z)
{
    CameraProject(cam, x, y, z);
    point_x = (float)GetCameraProjectedX(cam);
    point_y = (float)GetCameraProjectedY(cam);
}

// ---------------------------------------------------------------------------
void set_entity_position(Entity* e, float x, float y, float z)
{
    SetEntityPosition(e, x, y, z);
}

void set_entity_rotation(Entity* e, float pitch, float yaw, float roll)
{
    SetEntityRotation(e, pitch, yaw, roll);
}

void move_entity(Entity* e, float x, float y, float z)
{
    MoveEntity(e, x, y, z, FALSE);
}

void translate_entity(Entity* e, float x, float y, float z)
{
    SetEntityPosition(e, GetEntityX(e) + x, GetEntityY(e) + y, GetEntityZ(e) + z);
}

void turn_entity(Entity* e, float pitch, float yaw, float roll)
{
    TurnEntity(e, pitch, yaw, roll);
}

float entity_x(Entity* e) { return GetEntityX(e); }
float entity_y(Entity* e) { return GetEntityY(e); }
float entity_z(Entity* e) { return GetEntityZ(e); }

} // namespace App
