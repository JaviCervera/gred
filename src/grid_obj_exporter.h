#pragma once
#include <irrlicht.h>
#include <string>

class GridOBJExporter {
public:
    explicit GridOBJExporter(irr::IrrlichtDevice* device);
    bool export_mesh(irr::scene::IMesh* mesh, const std::string& path);

private:
    irr::IrrlichtDevice* device;
};
