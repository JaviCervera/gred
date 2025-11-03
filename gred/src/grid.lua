Grid = class()

Grid.EMPTY = 0
Grid.TILE = 1
Grid.STAIRS_FORWARD = 2
Grid.STAIRS_RIGHT = 3
Grid.STAIRS_BACKWARDS = 4
Grid.STAIRS_LEFT = 5

function Grid:Create(tiles_x, tiles_y, tiles_z, ceiling_tex_retriever, wall_tex_retriever, floor_tex_retriever, tex_path)
  self = self:New()
  self.model = nil
  self:reset(tiles_x, tiles_y, tiles_z)
  self.ceiling_tex_retriever = ceiling_tex_retriever
  self.wall_tex_retriever = wall_tex_retriever
  self.floor_tex_retriever = floor_tex_retriever
  self.tex_path = tex_path
  self.filtering = true
  self.wireframe = false
  return self
end

function Grid:reset(tiles_x, tiles_y, tiles_z)
  self.tiles = {}
  for x = 1, tiles_x do
    self.tiles[x] = {}
    for y = 1, tiles_y do
      self.tiles[x][y] = {}
      for z = 1, tiles_z do
        self.tiles[x][y][z] = false
      end
    end
  end
  if self.model ~= nil then FreeEntity(self.model) end
  self.model = nil
end

function Grid:tilesX()
  return #self.tiles
end

function Grid:tilesY()
  if self:tilesX() == 0 then return 0 end
  return #self.tiles[1]
end

function Grid:tilesZ()
  if self:tilesY() == 0 then return 0 end
  return #self.tiles[1][1]
end

function Grid:hasTile(x, y, z)
  if x < 1 or x > self:tilesX() then return false end
  if y < 1 or y > self:tilesY() then return false end
  if z < 1 or z > self:tilesZ() then return false end
  return self.tiles[x][y][z] ~= false
end

function Grid:setTile(x, y, z, type, ceiling_tex_name, wall_tex_name, floor_tex_name, update_model)
  if update_model == nil then update_model = true end
  if self:type(x, y, z) ~= type
    or self:ceilingTextureName(x, y, z) ~= ceiling_tex_name
    or self:wallTextureName(x, y, z) ~= wall_tex_name
    or self:floorTextureName(x, y, z) ~= floor_tex_name then
    self.tiles[x][y][z] = {
      type = type,
      ceiling = ceiling_tex_name,
      wall = wall_tex_name,
      floor = floor_tex_name
    }
    if update_model then self:_updateModel() end
  end
end

function Grid:removeTile(x, y, z, update_model)
  if update_model == nil then update_model = true end
  if self:hasTile(x, y, z) then
    self.tiles[x][y][z] = false
    if update_model then self:_updateModel() end
  end
end

function Grid:type(x, y, z)
  if not self:hasTile(x, y, z) then return Grid.EMPTY end
  return self.tiles[x][y][z].type
end

function Grid:ceilingTextureName(x, y, z)
  if not self:hasTile(x, y, z) then return "" end
  return self.tiles[x][y][z].ceiling
end

function Grid:wallTextureName(x, y, z)
  if not self:hasTile(x, y, z) then return "" end
  return self.tiles[x][y][z].wall
end

function Grid:floorTextureName(x, y, z)
  if not self:hasTile(x, y, z) then return "" end
  return self.tiles[x][y][z].floor
end

function Grid:_updateModel()
  if self.model ~= nil then FreeEntity(self.model) end
  local mesh = CreateGridMesh(self)
  self.model = CreateModel(mesh)
  self:_applyFiltering()
  self:_applyWireframe()
  --[[
  local inversed = CreateModel(mesh)
  SetEntityParent(inversed, self.model)
  local mat = EntityMaterial(inversed, 1)
  SetMaterialType(mat, MATERIAL_ALPHA)
  SetMaterialCullingEnabled(mat, false)
  SetMaterialVertexColorsEnabled(mat, false)
  SetMaterialDiffuse(mat, FadeColor(COLOR_WHITE, 128))
  ]]--
  FreeMesh(mesh)
end

function Grid:toggleFiltering()
  self.filtering = not self.filtering
  self:_applyFiltering()
end

function Grid:filteringEnabled()
  return self.filtering
end

function Grid:_applyFiltering()
  local mode = FILTER_DISABLED
  if self.filtering then mode = FILTER_ANISOTROPIC end
  for i = 1, EntityNumMaterials(self.model) do
    SetMaterialFilterMode(EntityMaterial(self.model, i), mode)
  end
end

function Grid:toggleWireframe()
  if self.model then
    self.wireframe = not self.wireframe
    self:_applyWireframe()
  end
end

function Grid:wireframeEnabled()
  return self.wireframe
end

function Grid:_applyWireframe()
  local mode = RENDER_FILLED
  if self.wireframe then mode = RENDER_WIREFRAME end
  for i = 1, EntityNumMaterials(self.model) do
    SetMaterialRenderMode(EntityMaterial(self.model, i), mode)
  end
end
