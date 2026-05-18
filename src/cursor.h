#pragma once
#include "app.h"
#include "grid.h"

class Cursor
{
public:
    IMeshSceneNode *entity;

    Cursor(Grid &grid);
    void reset();
    void update(bool editing);

    uint8_t tile_height() const;

private:
    Grid &grid;
    IMesh *mesh;
    float alpha;
    float alpha_dir;
    uint8_t tile_height_;

    void tile_height(uint8_t height);
};
