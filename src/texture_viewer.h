#pragma once
#include "app.h"
#include <string>
#include <vector>

class TextureViewer {
public:
    TextureViewer(const std::vector<std::string>& names, int selected,
                  const std::string& path, EKEY_CODE prev_key, EKEY_CODE next_key);
    void update();
    void draw(int x, int y, int w, int h) const;
    ITexture*          texture() const;
    const std::string& texture_name() const;

private:
    std::vector<std::string> names;
    std::string path;
    EKEY_CODE   prev_key, next_key;
    int         selected;
    ITexture*   tex = nullptr;

    void reload_texture();
    void next_texture();
    void prev_texture();
};
