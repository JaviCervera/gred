#pragma once
#include "app.h"
#include "grid.h"

class Cursor {
public:
    Model* entity;

    Cursor(Grid& grid);
    ~Cursor();
    void reset();
    void update(bool editing);

private:
    Grid&  grid;
    float  alpha;
    float  alpha_dir;
};
