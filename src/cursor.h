#pragma once
#include "app.h"
#include "grid.h"

class Cursor {
public:
    IMeshSceneNode* entity;

    Cursor(Grid& grid);
    void reset();
    void update(bool editing);

private:
    Grid&  grid;
    IMesh* mesh;
    float  alpha;
    float  alpha_dir;
};
