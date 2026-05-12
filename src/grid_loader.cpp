#include "grid_loader.h"
#include <cstdio>
#include <cstring>

// ---------------------------------------------------------------------------
class BinaryReader {
    std::vector<uint8_t> data;
    size_t pos = 0;
public:
    bool load(const std::string& filename) {
        FILE* f = fopen(filename.c_str(), "rb");
        if (!f) return false;
        fseek(f, 0, SEEK_END);
        long sz = ftell(f);
        rewind(f);
        data.resize((size_t)sz);
        fread(data.data(), 1, (size_t)sz, f);
        fclose(f);
        return true;
    }
    uint8_t read_byte() { return data[pos++]; }
    int read_int() {
        int v = (int)data[pos]
              | ((int)data[pos+1] << 8)
              | ((int)data[pos+2] << 16)
              | ((int)data[pos+3] << 24);
        pos += 4;
        return v;
    }
    std::string read_string() {
        int n = read_int();
        std::string s(n, '\0');
        for (int i = 0; i < n; ++i) s[i] = (char)read_byte();
        return s;
    }
};

// ---------------------------------------------------------------------------
static std::vector<std::string> load_texture_names(BinaryReader& r) {
    std::vector<std::string> texs;
    int count = (int)r.read_byte();
    for (int i = 0; i < count; ++i)
        texs.push_back(r.read_string());
    return texs;
}

static void load_tile(Grid& grid, const std::vector<std::string>& texs, BinaryReader& r) {
    int x    = (int)r.read_byte();
    int y    = (int)r.read_byte();
    int z    = (int)r.read_byte();
    int kind = (int)r.read_byte();
    int ci   = (int)r.read_byte() - 1;
    int wi   = (int)r.read_byte() - 1;
    int fi   = (int)r.read_byte() - 1;
    std::string ceil  = (ci >= 0 && ci < (int)texs.size()) ? texs[ci] : "";
    std::string wall  = (wi >= 0 && wi < (int)texs.size()) ? texs[wi] : "";
    std::string floor = (fi >= 0 && fi < (int)texs.size()) ? texs[fi] : "";
    grid.set_tile(x, y, z, kind, ceil, wall, floor, false);
}

static void load_flag(FlagManager& flag_mgr, BinaryReader& r) {
    int id = (int)r.read_byte();
    float x = (float)r.read_byte();
    float y = (float)r.read_byte();
    float z = (float)r.read_byte();
    flag_mgr.place(id, x, y, z);
}

// ---------------------------------------------------------------------------
void GridLoader::load(Grid& grid, FlagManager& flag_mgr, const std::string& filename) {
    BinaryReader r;
    if (!r.load(filename)) return;

    r.read_byte(); // version, unused
    int tx = (int)r.read_byte();
    int ty = (int)r.read_byte();
    int tz = (int)r.read_byte();
    grid.reset(tx, ty, tz);

    auto texs = load_texture_names(r);

    int num_tiles = r.read_int();
    for (int i = 0; i < num_tiles; ++i)
        load_tile(grid, texs, r);
    grid.update_model();

    flag_mgr.clear();
    int num_flags = (int)r.read_byte();
    for (int i = 0; i < num_flags; ++i)
        load_flag(flag_mgr, r);
}
