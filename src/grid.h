#pragma once
#include "app.h"
#include <string>
#include <vector>
#include <optional>

struct TileData {
    int kind;
    std::string ceiling;
    std::string wall;
    std::string floor;
};

class Grid {
public:
    static constexpr int EMPTY           = 0;
    static constexpr int TILE            = 1;
    static constexpr int STAIRS_FORWARD  = 2;
    static constexpr int STAIRS_RIGHT    = 3;
    static constexpr int STAIRS_BACKWARDS = 4;
    static constexpr int STAIRS_LEFT     = 5;

    Grid(int tx, int ty, int tz, const std::string& tex_path);
    ~Grid();

    const std::string& get_texture_path() const;
    void reset(int tx, int ty, int tz);
    int  tiles_x() const;
    int  tiles_y() const;
    int  tiles_z() const;
    bool has_tile(int x, int y, int z) const;
    void set_tile(int x, int y, int z, int kind,
                  const std::string& ceil, const std::string& wall, const std::string& floor,
                  bool update_model = true);
    void remove_tile(int x, int y, int z, bool update_model = true);
    int  get_tile_type(int x, int y, int z) const;
    std::string ceiling_texture_name(int x, int y, int z) const;
    std::string wall_texture_name(int x, int y, int z) const;
    std::string floor_texture_name(int x, int y, int z) const;
    void update_model();
    void toggle_filtering();
    bool filtering_enabled() const;
    void toggle_wireframe();
    bool wireframe_enabled() const;

private:
    std::string tex_path;
    std::vector<std::vector<std::vector<std::optional<TileData>>>> tiles;
    IMeshSceneNode* model  = nullptr;
    bool filtering         = true;
    bool wireframe         = false;

    void apply_filtering();
    void apply_wireframe();
};
