#include "grid.h"
#include "grid_mesh_creator.h"

Grid::Grid(int tx, int ty, int tz, const std::string& tp)
    : tex_path(tp)
{
    reset(tx, ty, tz);
}

Grid::~Grid() {
    if (model) FreeModel(model);
}

const std::string& Grid::get_texture_path() const { return tex_path; }

void Grid::reset(int tx, int ty, int tz) {
    if (model) { FreeModel(model); model = nullptr; }
    tiles.clear();
    tiles.resize(tx);
    for (int x = 0; x < tx; ++x) {
        tiles[x].resize(ty);
        for (int y = 0; y < ty; ++y)
            tiles[x][y].resize(tz, std::nullopt);
    }
}

int Grid::tiles_x() const { return (int)tiles.size(); }
int Grid::tiles_y() const { return tiles_x() == 0 ? 0 : (int)tiles[0].size(); }
int Grid::tiles_z() const { return tiles_y() == 0 ? 0 : (int)tiles[0][0].size(); }

bool Grid::has_tile(int x, int y, int z) const {
    if (x < 1 || x > tiles_x()) return false;
    if (y < 1 || y > tiles_y()) return false;
    if (z < 1 || z > tiles_z()) return false;
    return tiles[x-1][y-1][z-1].has_value();
}

void Grid::set_tile(int x, int y, int z, int kind,
                    const std::string& ceil, const std::string& wall, const std::string& floor,
                    bool do_update) {
    if (get_tile_type(x, y, z) != kind
     || ceiling_texture_name(x, y, z) != ceil
     || wall_texture_name(x, y, z)    != wall
     || floor_texture_name(x, y, z)   != floor)
    {
        tiles[x-1][y-1][z-1] = TileData{kind, ceil, wall, floor};
        if (do_update) update_model();
    }
}

void Grid::remove_tile(int x, int y, int z, bool do_update) {
    if (has_tile(x, y, z)) {
        tiles[x-1][y-1][z-1] = std::nullopt;
        if (do_update) update_model();
    }
}

int Grid::get_tile_type(int x, int y, int z) const {
    if (!has_tile(x, y, z)) return EMPTY;
    return tiles[x-1][y-1][z-1]->kind;
}

std::string Grid::ceiling_texture_name(int x, int y, int z) const {
    if (!has_tile(x, y, z)) return "";
    return tiles[x-1][y-1][z-1]->ceiling;
}

std::string Grid::wall_texture_name(int x, int y, int z) const {
    if (!has_tile(x, y, z)) return "";
    return tiles[x-1][y-1][z-1]->wall;
}

std::string Grid::floor_texture_name(int x, int y, int z) const {
    if (!has_tile(x, y, z)) return "";
    return tiles[x-1][y-1][z-1]->floor;
}

void Grid::update_model() {
    if (model) { FreeModel(model); model = nullptr; }
    Mesh* mesh = GridMeshCreator::create(this);
    model = CreateModel(mesh, nullptr);
    FreeMesh(mesh);
    apply_lighting();
}

void Grid::toggle_filtering() {
    filtering = !filtering;
    update_model();
}

bool Grid::filtering_enabled() const { return filtering; }

void Grid::toggle_wireframe() {
    wireframe = !wireframe;
    // No visual wireframe in Vortex — kept as no-op
}

bool Grid::wireframe_enabled() const { return wireframe; }

void Grid::set_lighting(bool enabled) {
    lighting = enabled;
    apply_lighting();
}

bool Grid::lighting_enabled() const { return lighting; }

void Grid::apply_lighting() {
    if (!model) return;
    u32_t n = GetNumEntityMaterials((Entity*)model);
    for (u32_t i = 0; i < n; ++i)
        SetMaterialLightingEnabled(GetEntityMaterial((Entity*)model, i), lighting ? TRUE : FALSE);
}
