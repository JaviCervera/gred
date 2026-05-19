#include "grid.h"
#include "grid_mesh_creator.h"

Grid::Grid(int tx, int ty, int tz, const std::string& tp)
    : tex_path(tp)
{
    reset(tx, ty, tz);
}

Grid::~Grid() {
    if (model) model->remove();
}

const std::string& Grid::get_texture_path() const { return tex_path; }

void Grid::reset(int tx, int ty, int tz) {
    if (model) { model->remove(); model = nullptr; }
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
    if (model) { model->remove(); model = nullptr; }
    auto* mesh = GridMeshCreator::create(this);
    model = App::smgr->addMeshSceneNode(mesh);
    mesh->drop();
    apply_filtering();
    apply_wireframe();
}

IMesh* Grid::get_mesh() const {
    return model ? model->getMesh() : nullptr;
}

void Grid::toggle_filtering() {
    filtering = !filtering;
    apply_filtering();
}

bool Grid::filtering_enabled() const { return filtering; }

void Grid::apply_filtering() {
    if (!model) return;
    int mode = filtering ? FILTER_ANISOTROPIC : FILTER_DISABLED;
    for (u32 i = 0; i < model->getMaterialCount(); ++i)
        App::set_material_filter_mode(model->getMaterial(i), mode);
}

void Grid::toggle_wireframe() {
    if (model) {
        wireframe = !wireframe;
        apply_wireframe();
    }
}

bool Grid::wireframe_enabled() const { return wireframe; }

void Grid::apply_wireframe() {
    if (!model) return;
    int mode = wireframe ? RENDER_WIREFRAME : RENDER_FILLED;
    for (u32 i = 0; i < model->getMaterialCount(); ++i)
        App::set_material_render_mode(model->getMaterial(i), mode);
}
