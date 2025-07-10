function CreateStairsMesh(x, y, z, yaw)
  local surf = GridSurface:Create()
  _AddStepWall(0, 0, 0, surf)
  _AddStepWall(0, 0.2, 0.25, surf)
  _AddStepWall(0, 0.4, 0.50, surf)
  _AddStepWall(0, 0.6, 0.75, surf)
  _AddStepWall(0, 0.8, 1, surf)
  _AddStepFloor(0, 0.2, 0, surf)
  _AddStepFloor(0, 0.4, 0.25, surf)
  _AddStepFloor(0, 0.6, 0.50, surf)
  _AddStepFloor(0, 0.8, 0.75, surf)
  local mesh = CreateMesh()
  surf:addToMesh(mesh)
  if yaw ~= 0 then RotateMesh(mesh, 0, yaw, 0) end
  TranslateMesh(mesh, x, y, z)
  UpdateMesh(mesh)
  return mesh
end

function _AddStepWall(x, y, z, surf)
  local start_x = x - 0.5
  local start_y = y - 0.5
  local start_z = z - 0.5
  local a = surf:addVertex(GridVertex:Create(start_x, start_y, start_z, 0, 0, -1, COLOR_WHITE, 0, 0.2))
  local b = surf:addVertex(GridVertex:Create(start_x + 1, start_y, start_z, 0, 0, -1, COLOR_WHITE, 1, 0.2))
  local c = surf:addVertex(GridVertex:Create(start_x + 1, start_y + 0.2, start_z, 0, 0, -1, COLOR_WHITE, 1, 0))
  local d = surf:addVertex(GridVertex:Create(start_x, start_y + 0.2, start_z, 0, 0, -1, COLOR_WHITE, 0, 0))
  surf:addIndex(a)
  surf:addIndex(d)
  surf:addIndex(c)
  surf:addIndex(a)
  surf:addIndex(c)
  surf:addIndex(b)
end

function _AddStepFloor(x, y, z, surf)
  local start_x = x - 0.5
  local start_y = y - 0.5
  local start_z = z - 0.5
  local a = surf:addVertex(GridVertex:Create(start_x, start_y, start_z, 0, 1, 0, COLOR_WHITE, 0, 0.25))
  local b = surf:addVertex(GridVertex:Create(start_x + 1, start_y, start_z, 0, 1, 0, COLOR_WHITE, 1, 0.25))
  local c = surf:addVertex(GridVertex:Create(start_x + 1, start_y, start_z + 0.25, 0, 1, 0, COLOR_WHITE, 1, 0))
  local d = surf:addVertex(GridVertex:Create(start_x, start_y, start_z + 0.25, 0, 1, 0, COLOR_WHITE, 0, 0))
  surf:addIndex(a)
  surf:addIndex(c)
  surf:addIndex(b)
  surf:addIndex(a)
  surf:addIndex(d)
  surf:addIndex(c)
end
