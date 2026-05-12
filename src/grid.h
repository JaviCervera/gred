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
    static const int EMPTY           = 0;
    static const int TILE            = 1;
    static const int STAIRS_FORWARD  = 2;
    static const int STAIRS_RIGHT    = 3;
    static const int STAIRS_BACKWARDS = 4;
    static const int STAIRS_LEFT     = 5;

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
    void set_lighting(bool enabled);
    bool lighting_enabled() const;

private:
    std::string tex_path;
    std::vector<std::vector<std::vector<std::optional<TileData>>>> tiles;
    Model* model   = nullptr;
    bool filtering = true;
    bool wireframe = false;
    bool lighting  = false;

    void apply_lighting();
};
