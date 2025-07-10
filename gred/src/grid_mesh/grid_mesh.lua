GridMesh = class()

function GridMesh:Create(grid)
  self = GridMesh:New()
  self.surfs = {}
  self.grid = grid
  for x = 1, grid:tilesX() do
    for y = 1, grid:tilesY() do
      for z = 1, grid:tilesZ() do
        self:_addGridMeshTile(x, y, z)
      end
    end
  end
  return self
end

function GridMesh:_addGridMeshTile(x, y, z)
  if not self.grid:hasTile(x, y, z) then return end
  if self.grid:type(x, y, z) == Grid.TILE then self:_addBlock(x, y, z) end
  if self.grid:type(x, y, z) == Grid.STAIRS_FORWARD then self:_addStairs(x, y, z, 0) end
  if self.grid:type(x, y, z) == Grid.STAIRS_RIGHT then self:_addStairs(x, y, z, 90) end
  if self.grid:type(x, y, z) == Grid.STAIRS_BACKWARDS then self:_addStairs(x, y, z, 180) end
  if self.grid:type(x, y, z) == Grid.STAIRS_LEFT then self:_addStairs(x, y, z, 270) end
end

function GridMesh:_addBlock(x, y, z, floor, front, right, back, left)
  if floor == nil then floor = true end
  if front == nil then front = true end
  if right == nil then right = true end
  if back == nil then back = true end
  if left == nil then left = true end

  local surf = self:_findSurface(self.grid:floorTextureName(x, y, z))

  -- Floor
  if floor and not self.grid:hasTile(x, y - 1, z) then
    local start_x = x - 0.5
    local start_y = y - 0.5
    local start_z = z - 0.5
    local a = surf:addVertex(GridVertex:Create(start_x, start_y, start_z, 0, 1, 0, COLOR_WHITE, 0, 1))
    local b = surf:addVertex(GridVertex:Create(start_x + 1, start_y, start_z, 0, 1, 0, COLOR_WHITE, 1, 1))
    local c = surf:addVertex(GridVertex:Create(start_x + 1, start_y, start_z + 1, 0, 1, 0, COLOR_WHITE, 1, 0))
    local d = surf:addVertex(GridVertex:Create(start_x, start_y, start_z + 1, 0, 1, 0, COLOR_WHITE, 0, 0))
    surf:addIndex(a)
    surf:addIndex(c)
    surf:addIndex(b)
    surf:addIndex(a)
    surf:addIndex(d)
    surf:addIndex(c)
  end

  surf = self:_findSurface(self.grid:ceilingTextureName(x, y, z))

  -- Ceiling
  if not self.grid:hasTile(x, y + 1, z) then
    local start_x = x - 0.5
    local start_y = y + 0.5
    local start_z = z - 0.5
    local a = surf:addVertex(GridVertex:Create(start_x, start_y, start_z, 0, -1, 0, COLOR_WHITE, 0, 1))
    local b = surf:addVertex(GridVertex:Create(start_x + 1, start_y, start_z, 0, -1, 0, COLOR_WHITE, 1, 1))
    local c = surf:addVertex(GridVertex:Create(start_x + 1, start_y, start_z + 1, 0, -1, 0, COLOR_WHITE, 1, 0))
    local d = surf:addVertex(GridVertex:Create(start_x, start_y, start_z + 1, 0, -1, 0, COLOR_WHITE, 0, 0))
    surf:addIndex(a)
    surf:addIndex(b)
    surf:addIndex(c)
    surf:addIndex(a)
    surf:addIndex(c)
    surf:addIndex(d)
  end

  surf = self:_findSurface(self.grid:wallTextureName(x, y, z))

  -- Left wall
  if left and not self.grid:hasTile(x - 1, y, z) then
    local start_x = x - 0.5
    local start_y = y - 0.5
    local start_z = z - 0.5
    local a = surf:addVertex(GridVertex:Create(start_x, start_y, start_z, 1, 0, 0, COLOR_WHITE, 0, 1))
    local b = surf:addVertex(GridVertex:Create(start_x, start_y, start_z + 1, 1, 0, 0, COLOR_WHITE, 1, 1))
    local c = surf:addVertex(GridVertex:Create(start_x, start_y + 1, start_z + 1, 1, 0, 0, COLOR_WHITE, 1, 0))
    local d = surf:addVertex(GridVertex:Create(start_x, start_y + 1, start_z, 1, 0, 0, COLOR_WHITE, 0, 0))
    surf:addIndex(a)
    surf:addIndex(c)
    surf:addIndex(b)
    surf:addIndex(a)
    surf:addIndex(d)
    surf:addIndex(c)
  end

  -- Right wall
  if right and not self.grid:hasTile(x + 1, y, z) then
    local start_x = x + 0.5
    local start_y = y - 0.5
    local start_z = z - 0.5
    local a = surf:addVertex(GridVertex:Create(start_x, start_y, start_z, -1, 0, 0, COLOR_WHITE, 0, 1))
    local b = surf:addVertex(GridVertex:Create(start_x, start_y, start_z + 1, -1, 0, 0, COLOR_WHITE, 1, 1))
    local c = surf:addVertex(GridVertex:Create(start_x, start_y + 1, start_z + 1, -1, 0, 0, COLOR_WHITE, 1, 0))
    local d = surf:addVertex(GridVertex:Create(start_x, start_y + 1, start_z, -1, 0, 0, COLOR_WHITE, 0, 0))
    surf:addIndex(b)
    surf:addIndex(c)
    surf:addIndex(a)
    surf:addIndex(a)
    surf:addIndex(c)
    surf:addIndex(d)
  end

  -- Front wall
  if front and not self.grid:hasTile(x, y, z + 1) then
    local start_x = x - 0.5
    local start_y = y - 0.5
    local start_z = z + 0.5
    local a = surf:addVertex(GridVertex:Create(start_x, start_y, start_z, 0, 0, -1, COLOR_WHITE, 0, 1))
    local b = surf:addVertex(GridVertex:Create(start_x + 1, start_y, start_z, 0, 0, -1, COLOR_WHITE, 1, 1))
    local c = surf:addVertex(GridVertex:Create(start_x + 1, start_y + 1, start_z, 0, 0, -1, COLOR_WHITE, 1, 0))
    local d = surf:addVertex(GridVertex:Create(start_x, start_y + 1, start_z, 0, 0, -1, COLOR_WHITE, 0, 0))
    surf:addIndex(a)
    surf:addIndex(d)
    surf:addIndex(c)
    surf:addIndex(a)
    surf:addIndex(c)
    surf:addIndex(b)
  end

  -- Back wall
  if back and not self.grid:hasTile(x, y, z - 1) then
    local start_x = x - 0.5
    local start_y = y - 0.5
    local start_z = z - 0.5
    local a = surf:addVertex(GridVertex:Create(start_x, start_y, start_z, 0, 0, 1, COLOR_WHITE, 0, 1))
    local b = surf:addVertex(GridVertex:Create(start_x + 1, start_y, start_z, 0, 0, 1, COLOR_WHITE, 1, 1))
    local c = surf:addVertex(GridVertex:Create(start_x + 1, start_y + 1, start_z, 0, 0, 1, COLOR_WHITE, 1, 0))
    local d = surf:addVertex(GridVertex:Create(start_x, start_y + 1, start_z, 0, 0, 1, COLOR_WHITE, 0, 0))
    surf:addIndex(a)
    surf:addIndex(b)
    surf:addIndex(d)
    surf:addIndex(b)
    surf:addIndex(c)
    surf:addIndex(d)
  end
end

function GridMesh:_addStairs(x, y, z, yaw)
  self:_addBlock(x, y, z, false, yaw ~= 0, yaw ~= 90, yaw ~= 180, yaw ~= 270)
  local stairs_mesh = CreateStairsMesh(x, y, z, yaw)
  local stairs_surf = MeshSurface(stairs_mesh, 1)
  local surf = self:_findSurface(self.grid:floorTextureName(x, y, z))
  local num_vertices = surf:numVertices()
  for v = 1, NumVertices(stairs_surf) do
    surf:addVertex(GridVertex:Create(
      VertexX(stairs_surf, v),
      VertexY(stairs_surf, v),
      VertexZ(stairs_surf, v),
      VertexNX(stairs_surf, v),
      VertexNY(stairs_surf, v),
      VertexNZ(stairs_surf, v),
      VertexColor(stairs_surf, v),
      VertexU(stairs_surf, v, 1),
      VertexV(stairs_surf, v, 1)))
  end
  for i = 1, NumIndices(stairs_surf) do
    surf:addIndex(num_vertices + SurfaceIndex(stairs_surf, i))
  end
  FreeMesh(stairs_mesh)
end

function GridMesh:_findSurface(tex_name)
  for key, val in pairs(self.surfs) do
    if key == tex_name then return val end
  end
  self.surfs[tex_name] = GridSurface:Create(self.grid.tex_path .. tex_name)
  return self.surfs[tex_name]
end

function GridMesh:createMesh()
  local mesh = CreateMesh()
  for _, s in pairs(self.surfs) do
    s:addToMesh(mesh)
  end
  UpdateMesh(mesh)
  return mesh
end
