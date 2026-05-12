#include "texture_viewer.h"
#include <algorithm>

TextureViewer::TextureViewer(const std::vector<std::string>& names_, int selected_,
                             const std::string& path_, int pk, int nk)
    : names(names_), path(path_), prev_key(pk), next_key(nk)
{
    selected = std::min(std::max(selected_, 1), (int)names.size());
    reload_texture();
}

void TextureViewer::update() {
    if (App::key_hit[prev_key]) prev_texture();
    if (App::key_hit[next_key]) next_texture();
}

void TextureViewer::draw(int x, int y, int w, int h) const {
    if (tex) App::draw_texture_ex(tex, x, y, w, h, COLOR_WHITE);
}

Texture* TextureViewer::texture() const { return tex; }

const std::string& TextureViewer::texture_name() const {
    static std::string empty;
    if (names.empty()) return empty;
    return names[selected - 1];
}

void TextureViewer::next_texture() {
    ++selected;
    if (selected > (int)names.size()) selected = 1;
    reload_texture();
}

void TextureViewer::prev_texture() {
    --selected;
    if (selected < 1) selected = (int)names.size();
    reload_texture();
}

void TextureViewer::reload_texture() {
    if (names.empty()) { tex = nullptr; return; }
    std::string full = path + names[selected - 1];
    tex = CacheTexture(full.c_str(), FILTER_LINEAR);
}
