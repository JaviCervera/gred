#include "grid_obj_exporter.h"
#include <irrlicht.h>

using namespace irr;
using namespace irr::scene;
using namespace irr::io;

GridOBJExporter::GridOBJExporter(IrrlichtDevice* dev)
    : device(dev)
{
}

bool GridOBJExporter::export_mesh(IMesh* mesh, const std::string& path)
{
    if (!mesh || !device)
        return false;

    IMeshWriter* writer = device->getSceneManager()->createMeshWriter(EMWT_OBJ);
    if (!writer)
        return false;

    IWriteFile* file = device->getFileSystem()->createAndWriteFile(path.c_str());
    if (!file)
    {
        writer->drop();
        return false;
    }

    bool ok = writer->writeMesh(file, mesh);
    file->drop();
    writer->drop();
    return ok;
}
