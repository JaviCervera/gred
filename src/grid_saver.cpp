#include "grid_saver.h"
#include <algorithm>

// ---------------------------------------------------------------------------
class BinaryWriter {
    std::vector<uint8_t> data;
public:
    void write_byte(uint8_t v) { data.push_back(v); }
    void write_int(int v) {
        data.push_back((uint8_t)(v & 0xFF));
        data.push_back((uint8_t)((v >> 8) & 0xFF));
        data.push_back((uint8_t)((v >> 16) & 0xFF));
        data.push_back((uint8_t)((v >> 24) & 0xFF));
    }
    void write_string(const std::string& s) {
        write_int((int)s.size());
        for (char c : s) write_byte((uint8_t)c);
    }
    bool save(const std::string& filename) {
        auto* file = App::device->getFileSystem()->createAndWriteFile(filename.c_str());
        if (!file) return false;
        if (!data.empty())
            file->write(data.data(), (u32)data.size());
        file->drop();
        return true;
    }
};

// ---------------------------------------------------------------------------
static std::vector<std::string> grid_textures(Grid& grid) {
    std::vector<std::string> texs;
    auto add = [&](const std::string& t) {
        if (std::find(texs.begin(), texs.end(), t) == texs.end())
            texs.push_back(t);
    };
    for (int x = 1; x <= grid.tiles_x(); ++x)
        for (int y = 1; y <= grid.tiles_y(); ++y)
            for (int z = 1; z <= grid.tiles_z(); ++z) {
                add(grid.ceiling_texture_name(x, y, z));
                add(grid.wall_texture_name(x, y, z));
                add(grid.floor_texture_name(x, y, z));
            }
    return texs;
}

static int num_tiles_set(Grid& grid) {
    int count = 0;
    for (int x = 1; x <= grid.tiles_x(); ++x)
        for (int y = 1; y <= grid.tiles_y(); ++y)
            for (int z = 1; z <= grid.tiles_z(); ++z)
                if (grid.has_tile(x, y, z)) ++count;
    return count;
}

static void write_tile(Grid& grid, int x, int y, int z,
                       const std::vector<std::string>& texs, BinaryWriter& w) {
    if (!grid.has_tile(x, y, z)) return;
    auto idx = [&](const std::string& t) -> uint8_t {
        auto it = std::find(texs.begin(), texs.end(), t);
        return (uint8_t)(std::distance(texs.begin(), it) + 1);
    };
    w.write_byte((uint8_t)x);
    w.write_byte((uint8_t)y);
    w.write_byte((uint8_t)z);
    w.write_byte((uint8_t)grid.get_tile_type(x, y, z));
    w.write_byte(idx(grid.ceiling_texture_name(x, y, z)));
    w.write_byte(idx(grid.wall_texture_name(x, y, z)));
    w.write_byte(idx(grid.floor_texture_name(x, y, z)));
}

// ---------------------------------------------------------------------------
void GridSaver::save(Grid& grid, FlagManager& flag_mgr, const std::string& filename) {
    auto texs = grid_textures(grid);
    BinaryWriter w;

    // Header
    w.write_byte(1);                        // version
    w.write_byte((uint8_t)grid.tiles_x());
    w.write_byte((uint8_t)grid.tiles_y());
    w.write_byte((uint8_t)grid.tiles_z());

    // Textures
    w.write_byte((uint8_t)texs.size());
    for (const auto& t : texs)
        w.write_string(t);

    // Tiles
    w.write_int(num_tiles_set(grid));
    for (int x = 1; x <= grid.tiles_x(); ++x)
        for (int y = 1; y <= grid.tiles_y(); ++y)
            for (int z = 1; z <= grid.tiles_z(); ++z)
                write_tile(grid, x, y, z, texs, w);

    // Flags
    w.write_byte((uint8_t)flag_mgr.size());
    for (int i = 1; i <= flag_mgr.size(); ++i) {
        Flag* f = flag_mgr.at(i);
        if (!f) continue;
        w.write_byte((uint8_t)f->id);
        w.write_byte((uint8_t)(int)f->x());
        w.write_byte((uint8_t)(int)f->y());
        w.write_byte((uint8_t)(int)f->z());
    }

    w.save(filename);
}
