function CreateGridMesh(grid)
  local surfs = {}
  local mesh = CreateMesh()
  for x = 1, grid:tilesX() do
    for y = 1, grid:tilesY() do
      for z = 1, grid:tilesZ() do
        _AddGridMeshTile(grid, x, y, z, surfs, mesh)
      end
    end
  end
  UpdateMesh(mesh)
  return mesh
end

function _AddGridMeshTile(grid, x, y, z, surfs, mesh)
  if not grid:hasTile(x, y, z) then return end
  if grid:type(x, y, z) == Grid.TILE then _AddGridMeshBlock(grid, x, y, z, surfs, mesh) end
  if grid:type(x, y, z) == Grid.STAIRS_FORWARD then _AddGridMeshStairs(grid, x, y, z, surfs, mesh, 0) end
  if grid:type(x, y, z) == Grid.STAIRS_RIGHT then _AddGridMeshStairs(grid, x, y, z, surfs, mesh, 90) end
  if grid:type(x, y, z) == Grid.STAIRS_BACKWARDS then _AddGridMeshStairs(grid, x, y, z, surfs, mesh, 180) end
  if grid:type(x, y, z) == Grid.STAIRS_LEFT then _AddGridMeshStairs(grid, x, y, z, surfs, mesh, 270) end
end

function _AddGridMeshBlock(grid, x, y, z, surfs, mesh, floor, front, right, back, left)
  if floor == nil then floor = true end
  if front == nil then front = true end
  if right == nil then right = true end
  if back == nil then back = true end
  if left == nil then left = true end

  local surf = _SurfaceForTexName(grid:floorTextureName(x, y, z), surfs, mesh, grid.tex_path)

  -- Floor
  if floor and not grid:hasTile(x, y - 1, z) then
    local start_x = x - 0.5
    local start_y = y - 0.5
    local start_z = z - 0.5
    local a = AddVertex(surf, start_x, start_y, start_z, 0, 1, 0, COLOR_WHITE, 0, 1)
    local b = AddVertex(surf, start_x + 1, start_y, start_z, 0, 1, 0, COLOR_WHITE, 1, 1)
    local c = AddVertex(surf, start_x + 1, start_y, start_z + 1, 0, 1, 0, COLOR_WHITE, 1, 0)
    local d = AddVertex(surf, start_x, start_y, start_z + 1, 0, 1, 0, COLOR_WHITE, 0, 0)
    AddIndex(surf, a)
    AddIndex(surf, c)
    AddIndex(surf, b)
    AddIndex(surf, a)
    AddIndex(surf, d)
    AddIndex(surf, c)
  end

  surf = _SurfaceForTexName(grid:ceilingTextureName(x, y, z), surfs, mesh, grid.tex_path)

  -- Ceiling
  if not grid:hasTile(x, y + 1, z) then
    local start_x = x - 0.5
    local start_y = y + 0.5
    local start_z = z - 0.5
    local a = AddVertex(surf, start_x, start_y, start_z, 0, -1, 0, COLOR_WHITE, 0, 1)
    local b = AddVertex(surf, start_x + 1, start_y, start_z, 0, -1, 0, COLOR_WHITE, 1, 1)
    local c = AddVertex(surf, start_x + 1, start_y, start_z + 1, 0, -1, 0, COLOR_WHITE, 1, 0)
    local d = AddVertex(surf, start_x, start_y, start_z + 1, 0, -1, 0, COLOR_WHITE, 0, 0)
    AddIndex(surf, a)
    AddIndex(surf, b)
    AddIndex(surf, c)
    AddIndex(surf, a)
    AddIndex(surf, c)
    AddIndex(surf, d)
  end

  surf = _SurfaceForTexName(grid:wallTextureName(x, y, z), surfs, mesh, grid.tex_path)

  -- Left wall
  if left and not grid:hasTile(x - 1, y, z) then
    local start_x = x - 0.5
    local start_y = y - 0.5
    local start_z = z - 0.5
    local a = AddVertex(surf, start_x, start_y, start_z, 1, 0, 0, COLOR_WHITE, 0, 1)
    local b = AddVertex(surf, start_x, start_y, start_z + 1, 1, 0, 0, COLOR_WHITE, 1, 1)
    local c = AddVertex(surf, start_x, start_y + 1, start_z + 1, 1, 0, 0, COLOR_WHITE, 1, 0)
    local d = AddVertex(surf, start_x, start_y + 1, start_z, 1, 0, 0, COLOR_WHITE, 0, 0)
    AddIndex(surf, a)
    AddIndex(surf, c)
    AddIndex(surf, b)
    AddIndex(surf, a)
    AddIndex(surf, d)
    AddIndex(surf, c)
  end

  -- Right wall
  if right and not grid:hasTile(x + 1, y, z) then
    local start_x = x + 0.5
    local start_y = y - 0.5
    local start_z = z - 0.5
    local a = AddVertex(surf, start_x, start_y, start_z, -1, 0, 0, COLOR_WHITE, 0, 1)
    local b = AddVertex(surf, start_x, start_y, start_z + 1, -1, 0, 0, COLOR_WHITE, 1, 1)
    local c = AddVertex(surf, start_x, start_y + 1, start_z + 1, -1, 0, 0, COLOR_WHITE, 1, 0)
    local d = AddVertex(surf, start_x, start_y + 1, start_z, -1, 0, 0, COLOR_WHITE, 0, 0)
    AddIndex(surf, b)
    AddIndex(surf, c)
    AddIndex(surf, a)
    AddIndex(surf, a)
    AddIndex(surf, c)
    AddIndex(surf, d)
  end

  -- Front wall
  if front and not grid:hasTile(x, y, z + 1) then
    local start_x = x - 0.5
    local start_y = y - 0.5
    local start_z = z + 0.5
    local a = AddVertex(surf, start_x, start_y, start_z, 0, 0, -1, COLOR_WHITE, 0, 1)
    local b = AddVertex(surf, start_x + 1, start_y, start_z, 0, 0, -1, COLOR_WHITE, 1, 1)
    local c = AddVertex(surf, start_x + 1, start_y + 1, start_z, 0, 0, -1, COLOR_WHITE, 1, 0)
    local d = AddVertex(surf, start_x, start_y + 1, start_z, 0, 0, -1, COLOR_WHITE, 0, 0)
    AddIndex(surf, a)
    AddIndex(surf, d)
    AddIndex(surf, c)
    AddIndex(surf, a)
    AddIndex(surf, c)
    AddIndex(surf, b)
  end

  -- Back wall
  if back and not grid:hasTile(x, y, z - 1) then
    local start_x = x - 0.5
    local start_y = y - 0.5
    local start_z = z - 0.5
    local a = AddVertex(surf, start_x, start_y, start_z, 0, 0, 1, COLOR_WHITE, 0, 1)
    local b = AddVertex(surf, start_x + 1, start_y, start_z, 0, 0, 1, COLOR_WHITE, 1, 1)
    local c = AddVertex(surf, start_x + 1, start_y + 1, start_z, 0, 0, 1, COLOR_WHITE, 1, 0)
    local d = AddVertex(surf, start_x, start_y + 1, start_z, 0, 0, 1, COLOR_WHITE, 0, 0)
    AddIndex(surf, a)
    AddIndex(surf, b)
    AddIndex(surf, d)
    AddIndex(surf, b)
    AddIndex(surf, c)
    AddIndex(surf, d)
  end
end

function _AddGridMeshStairs(grid, x, y, z, surfs, mesh, yaw)
  _AddGridMeshBlock(grid, x, y, z, surfs, mesh, false, yaw ~= 0, yaw ~= 90, yaw ~= 180, yaw ~= 270)

  local stairs_mesh = _CreateStairsMesh(x, y, z, yaw)
  local stairs_surf = MeshSurface(stairs_mesh, 1)
  local surf = _SurfaceForTexName(grid:floorTextureName(x, y, z), surfs, mesh, grid.tex_path)
  local num_vertices = NumVertices(surf)
  for v = 1, NumVertices(stairs_surf) do
    AddVertex(
      surf,
      VertexX(stairs_surf, v),
      VertexY(stairs_surf, v),
      VertexZ(stairs_surf, v),
      VertexNX(stairs_surf, v),
      VertexNY(stairs_surf, v),
      VertexNZ(stairs_surf, v),
      VertexColor(stairs_surf, v),
      VertexU(stairs_surf, v, 1),
      VertexV(stairs_surf, v, 1))
  end
  for i = 1, NumIndices(stairs_surf) do
    AddIndex(surf, num_vertices + SurfaceIndex(stairs_surf, i))
  end
  FreeMesh(stairs_mesh)
end

function _CreateStairsMesh(x, y, z, yaw)
  local mesh = CreateMesh()
  local surf = AddSurface(mesh)
  _AddStepWall(0, 0, 0, surf)
  _AddStepWall(0, 0.2, 0.25, surf)
  _AddStepWall(0, 0.4, 0.50, surf)
  _AddStepWall(0, 0.6, 0.75, surf)
  _AddStepWall(0, 0.8, 1, surf)
  _AddStepFloor(0, 0.2, 0, surf)
  _AddStepFloor(0, 0.4, 0.25, surf)
  _AddStepFloor(0, 0.6, 0.50, surf)
  _AddStepFloor(0, 0.8, 0.75, surf)
  if yaw ~= 0 then RotateMesh(mesh, 0, yaw, 0) end
  TranslateMesh(mesh, x, y, z)
  UpdateMesh(mesh)
  return mesh
end

function _AddStepWall(x, y, z, surf)
  local start_x = x - 0.5
  local start_y = y - 0.5
  local start_z = z - 0.5
  local a = AddVertex(surf, start_x, start_y, start_z, 0, 0, -1, COLOR_WHITE, 0, 0.2)
  local b = AddVertex(surf, start_x + 1, start_y, start_z, 0, 0, -1, COLOR_WHITE, 1, 0.2)
  local c = AddVertex(surf, start_x + 1, start_y + 0.2, start_z, 0, 0, -1, COLOR_WHITE, 1, 0)
  local d = AddVertex(surf, start_x, start_y + 0.2, start_z, 0, 0, -1, COLOR_WHITE, 0, 0)
  AddIndex(surf, a)
  AddIndex(surf, d)
  AddIndex(surf, c)
  AddIndex(surf, a)
  AddIndex(surf, c)
  AddIndex(surf, b)
end

function _AddStepFloor(x, y, z, surf)
  local start_x = x - 0.5
  local start_y = y - 0.5
  local start_z = z - 0.5
  local a = AddVertex(surf, start_x, start_y, start_z, 0, 1, 0, COLOR_WHITE, 0, 0.25)
  local b = AddVertex(surf, start_x + 1, start_y, start_z, 0, 1, 0, COLOR_WHITE, 1, 0.25)
  local c = AddVertex(surf, start_x + 1, start_y, start_z + 0.25, 0, 1, 0, COLOR_WHITE, 1, 0)
  local d = AddVertex(surf, start_x, start_y, start_z + 0.25, 0, 1, 0, COLOR_WHITE, 0, 0)
  AddIndex(surf, a)
  AddIndex(surf, c)
  AddIndex(surf, b)
  AddIndex(surf, a)
  AddIndex(surf, d)
  AddIndex(surf, c)
end

function _SurfaceForTexName(tex_name, surfs, mesh, tex_path)
  for key, val in pairs(surfs) do
    if key == tex_name then return val end
  end
  local surf = AddSurface(mesh)
  local mat = SurfaceMaterial(surf)
  SetMaterialTexture(mat, 1, LoadTexture(tex_path .. tex_name))
  surfs[tex_name] = surf
  return surf
end
