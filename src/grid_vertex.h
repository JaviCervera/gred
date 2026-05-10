#pragma once

struct GridVertex {
    float x, y, z;
    float nx, ny, nz;
    int   color;
    float u, v;

    GridVertex(float x, float y, float z,
               float nx, float ny, float nz,
               int color, float u, float v)
        : x(x), y(y), z(z)
        , nx(nx), ny(ny), nz(nz)
        , color(color), u(u), v(v)
    {}
};
