#include "app.h"
#include <algorithm>
#include <cstring>

namespace App
{

    IrrlichtDevice *device = nullptr;
    IVideoDriver *driver = nullptr;
    ISceneManager *smgr = nullptr;
    IGUIEnvironment *guienv = nullptr;
    std::string resource_root;

    float delta_time = 0.0f;
    float point_x = 0.0f;
    float point_y = 0.0f;
    int mouse_wheel = 0;
    bool key_down[KEY_KEY_CODES_COUNT] = {};
    bool key_hit[KEY_KEY_CODES_COUNT] = {};

    static bool key_was_down[KEY_KEY_CODES_COUNT] = {};
    static u32 last_time = 0;

    // ---------------------------------------------------------------------------
    class EventReceiver : public IEventReceiver
    {
    public:
        bool OnEvent(const SEvent &event) override
        {
            if (event.EventType == EET_KEY_INPUT_EVENT)
            {
                EKEY_CODE code = event.KeyInput.Key;
                if (event.KeyInput.PressedDown)
                {
                    if (!key_was_down[code])
                        key_hit[code] = true;
                    key_down[code] = true;
                    key_was_down[code] = true;
                }
                else
                {
                    key_down[code] = false;
                    key_was_down[code] = false;
                }
            }
            else if (event.EventType == EET_MOUSE_INPUT_EVENT)
            {
                if (event.MouseInput.Event == EMIE_MOUSE_WHEEL)
                    mouse_wheel += (int)event.MouseInput.Wheel;
            }
            return false;
        }
    };

    static EventReceiver g_receiver;

    // ---------------------------------------------------------------------------
    bool init(int width, int height, int bits, int flags)
    {
        SIrrlichtCreationParameters params;
        params.WindowSize = dimension2du(width, height);
        params.Bits = (u8)bits;
        params.Vsync = (flags & SCREEN_VSYNC) != 0;
        params.Fullscreen = (flags & SCREEN_FULLSCREEN) != 0;
        params.DriverType = EDT_OPENGL;
        params.EventReceiver = &g_receiver;
        params.LoggingLevel = ELL_NONE;

        device = createDeviceEx(params);
        if (!device)
            return false;

        device->setResizable((flags & SCREEN_RESIZABLE) != 0);

        driver = device->getVideoDriver();
        smgr = device->getSceneManager();
        guienv = device->getGUIEnvironment();

        // Match ColdSteel's OpenScreenEx defaults
        driver->setTextureCreationFlag(ETCF_ALWAYS_32_BIT, true);
        smgr->setAmbientLight(SColorf(1.f, 1.f, 1.f, 1.f));

        last_time = device->getTimer()->getTime();

        driver->beginScene(true, true, SColor(255, 0, 0, 80));
        return true;
    }

    void set_resource_root(const std::string &root)
    {
        resource_root = root;
        if (!resource_root.empty() && resource_root.back() != '/')
            resource_root.push_back('/');
    }

    std::string resource_path(const std::string &relative)
    {
        if (resource_root.empty())
            return relative;
        return resource_root + relative;
    }

    // ---------------------------------------------------------------------------
    bool run()
    {
        std::memset(key_hit, 0, sizeof(key_hit));
        mouse_wheel = 0;

        u32 now = device->getTimer()->getTime();
        delta_time = (float)(now - last_time) / 1000.0f;
        last_time = now;

        return device->run() && driver != nullptr;
    }

    // ---------------------------------------------------------------------------
    void draw_world(ICameraSceneNode *cam)
    {
        cam->updateAbsolutePosition();
        vector3df dest(0.f, 0.f, 100.f);
        cam->getAbsoluteTransformation().transformVect(dest);
        cam->setTarget(dest);
        smgr->setActiveCamera(cam);
        smgr->drawAll();
    }

    // ---------------------------------------------------------------------------
    void refresh_screen()
    {
        driver->endScene();
        driver->beginScene(true, true, SColor(255, 0, 0, 80));
    }

    // ---------------------------------------------------------------------------
    void draw_text(const std::string &text, int x, int y, u32 color)
    {
        if (!guienv)
            return;
        IGUIFont *font = guienv->getBuiltInFont();
        if (!font)
            return;
        core::stringw ws(text.c_str());
        font->draw(ws.c_str(), recti(x, y, x + 2000, y + 50), SColor(color), false, false, nullptr);
    }

    int text_width(const std::string &text)
    {
        if (!guienv)
            return 0;
        IGUIFont *font = guienv->getBuiltInFont();
        if (!font)
            return 0;
        core::stringw ws(text.c_str());
        return (int)font->getDimension(ws.c_str()).Width;
    }

    int text_height(const std::string &text)
    {
        if (!guienv)
            return 0;
        IGUIFont *font = guienv->getBuiltInFont();
        if (!font)
            return 0;
        core::stringw ws(text.c_str());
        return (int)font->getDimension(ws.c_str()).Height;
    }

    void draw_rect(int x, int y, int w, int h, u32 color)
    {
        driver->draw2DRectangle(SColor(color), recti(x, y, x + w, y + h));
    }

    void draw_texture_ex(ITexture *tex, int x, int y, int w, int h, u32 color)
    {
        if (!tex)
            return;
        SColor colors[4];
        for (int i = 0; i < 4; ++i)
            colors[i] = SColor(color);
        dimension2du sz = tex->getOriginalSize();
        driver->draw2DImage(tex, recti(x, y, x + w, y + h),
                            recti(0, 0, (int)sz.Width, (int)sz.Height),
                            nullptr, colors, true);
    }

    void world_to_screen(ICameraSceneNode *cam, float x, float y, float z)
    {
        position2di p = smgr->getSceneCollisionManager()
                            ->getScreenCoordinatesFrom3DPosition(vector3df(x, y, z), cam);
        point_x = (float)p.X;
        point_y = (float)p.Y;
    }

    // ---------------------------------------------------------------------------
    void set_ambient(u32 color)
    {
        SColor sc(color);
        smgr->setAmbientLight(SColorf(
            sc.getRed() / 255.f,
            sc.getGreen() / 255.f,
            sc.getBlue() / 255.f,
            sc.getAlpha() / 255.f));
    }

    // ---------------------------------------------------------------------------
    u32 fade_color(u32 color, int new_alpha)
    {
        u32 a = (u32)std::max(0, std::min(255, new_alpha));
        return (a << 24) | (color & 0x00FFFFFFu);
    }

    // ---------------------------------------------------------------------------
    void set_material_type(SMaterial &mat, int type)
    {
        switch (type)
        {
        case MATERIAL_SOLID:
            mat.MaterialType = EMT_SOLID;
            break;
        case MATERIAL_SOLID_ALPHA:
            mat.MaterialType = EMT_TRANSPARENT_ADD_COLOR;
            break;
        case MATERIAL_LIGHTMAP:
            mat.MaterialType = EMT_LIGHTMAP;
            break;
        case MATERIAL_LIGHTMAP_ADD:
            mat.MaterialType = EMT_LIGHTMAP_ADD;
            break;
        case MATERIAL_LIGHTMAP_MUL:
            mat.MaterialType = EMT_LIGHTMAP_M2;
            break;
        case MATERIAL_LIGHTMAP_MUL4:
            mat.MaterialType = EMT_LIGHTMAP_M4;
            break;
        case MATERIAL_ALPHA:
            mat.MaterialType = EMT_TRANSPARENT_ALPHA_CHANNEL;
            break;
        case MATERIAL_VERTEXALPHA:
            mat.MaterialType = EMT_TRANSPARENT_VERTEX_ALPHA;
            break;
        case MATERIAL_ALPHATEST:
            mat.MaterialType = EMT_TRANSPARENT_ALPHA_CHANNEL_REF;
            break;
        case MATERIAL_SPHERE:
            mat.MaterialType = EMT_SPHERE_MAP;
            break;
        case MATERIAL_REFLECT:
            mat.MaterialType = EMT_REFLECTION_2_LAYER;
            break;
        case MATERIAL_ONETEX:
            mat.MaterialType = EMT_DETAIL_MAP;
            break;
        default:
            break;
        }
    }

    void set_material_flag(SMaterial &mat, int flag, bool enable)
    {
        switch (flag)
        {
        case FLAG_LIGHTING:
            mat.setFlag(EMF_LIGHTING, enable);
            break;
        case FLAG_FOG:
            mat.setFlag(EMF_FOG_ENABLE, enable);
            break;
        case FLAG_ZREAD:
            mat.setFlag(EMF_ZBUFFER, enable);
            break;
        case FLAG_ZWRITE:
            mat.setFlag(EMF_ZWRITE_ENABLE, enable);
            break;
        case FLAG_BACKFACECULLING:
            mat.setFlag(EMF_BACK_FACE_CULLING, enable);
            break;
        case FLAG_NORMALIZE:
            mat.setFlag(EMF_NORMALIZE_NORMALS, enable);
            break;
        case FLAG_VERTEXCOLORS:
            mat.ColorMaterial = enable ? ECM_DIFFUSE_AND_AMBIENT : ECM_NONE;
            break;
        case FLAG_CLAMP:
            mat.setFlag(EMF_TEXTURE_WRAP, enable);
            break;
        default:
            break;
        }
    }

    void set_material_filter_mode(SMaterial &mat, int mode)
    {
        // Mirror ColdSteel's SetMaterialFilterMode: higher modes include lower ones
        mat.setFlag(EMF_ANISOTROPIC_FILTER, mode == FILTER_ANISOTROPIC);
        mat.setFlag(EMF_TRILINEAR_FILTER, mode >= FILTER_TRILINEAR);
        mat.setFlag(EMF_BILINEAR_FILTER, mode >= FILTER_BILINEAR);
        mat.setFlag(EMF_USE_MIP_MAPS, mode >= FILTER_BILINEAR);
    }

    void set_material_render_mode(SMaterial &mat, int mode)
    {
        switch (mode)
        {
        case RENDER_FILLED:
            mat.setFlag(EMF_WIREFRAME, false);
            mat.setFlag(EMF_POINTCLOUD, false);
            break;
        case RENDER_WIREFRAME:
            mat.setFlag(EMF_WIREFRAME, true);
            mat.setFlag(EMF_POINTCLOUD, false);
            break;
        case RENDER_POINTCLOUD:
            mat.setFlag(EMF_WIREFRAME, false);
            mat.setFlag(EMF_POINTCLOUD, true);
            break;
        default:
            break;
        }
    }

    void fix_material(SMaterial &mat)
    {
        mat.ColorMaterial = ECM_DIFFUSE_AND_AMBIENT;
        mat.SpecularColor = SColor(255, 0, 0, 0);
    }

    // ---------------------------------------------------------------------------
    void update_mesh(IMesh *mesh)
    {
        for (u32 i = 0; i < mesh->getMeshBufferCount(); ++i)
            mesh->getMeshBuffer(i)->recalculateBoundingBox();
        static_cast<SMesh *>(mesh)->recalculateBoundingBox();
        mesh->setDirty();
    }

    // ---------------------------------------------------------------------------
    void set_entity_position(ISceneNode *node, float x, float y, float z)
    {
        node->setPosition(vector3df(x, y, z));
        node->updateAbsolutePosition();
    }

    void set_entity_rotation(ISceneNode *node, float pitch, float yaw, float roll)
    {
        node->setRotation(vector3df(pitch, yaw, roll));
        node->updateAbsolutePosition();
    }

    void move_entity(ISceneNode *node, float x, float y, float z)
    {
        vector3df dest(x, y, z);
        node->getRelativeTransformation().transformVect(dest);
        node->setPosition(dest);
        node->updateAbsolutePosition();
    }

    void translate_entity(ISceneNode *node, float x, float y, float z)
    {
        node->setPosition(node->getPosition() + vector3df(x, y, z));
        node->updateAbsolutePosition();
    }

    void turn_entity(ISceneNode *node, float pitch, float yaw, float roll)
    {
        node->setRotation(node->getRotation() + vector3df(pitch, yaw, roll));
    }

    ISceneNode *entity_child(ISceneNode *node, int index)
    {
        const core::list<ISceneNode *> &children = node->getChildren();
        auto it = children.begin();
        for (int i = 1; i < index; ++i)
            ++it;
        return *it;
    }

    float entity_x(ISceneNode *node) { return node->getAbsolutePosition().X; }
    float entity_y(ISceneNode *node) { return node->getAbsolutePosition().Y; }
    float entity_z(ISceneNode *node) { return node->getAbsolutePosition().Z; }

} // namespace App
