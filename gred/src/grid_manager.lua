GridManager = class()

function GridManager:Create(grid, cursor, ceiling_tex_retriever, wall_tex_retriever, floor_tex_retriever, flag_mgr, undo_mgr)
  self = self:New()
  self.grid = grid
  self.cursor = cursor
  self.ceiling_tex_retriever = ceiling_tex_retriever
  self.wall_tex_retriever = wall_tex_retriever
  self.floor_tex_retriever = floor_tex_retriever
  self.flag_mgr = flag_mgr
  self.undo_mgr = undo_mgr
  self.lights = nil
  self:reset()
  return self
end

function GridManager:reset()
  self.filename = nil
  self.editing = true
  self.mode = Grid.TILE
  self.current_flag = 1
  self.grid:reset(self.grid:tilesX(), self.grid:tilesY(), self.grid:tilesZ())
  self.cursor:reset()
end

function GridManager:update()
  if KeyHit(KEY_ENTER) then self.editing = not self.editing end
  if KeyHit(KEY_F) then self.grid:toggleFiltering() end
  if KeyHit(KEY_L) then self:toggleLighting() end
  if KeyHit(KEY_R) then self.grid:toggleWireframe() end
  if KeyHit(KEY_U) then self.current_flag = Max(1, self.current_flag - 1) end
  if KeyHit(KEY_I) then self.current_flag = Min(100, self.current_flag + 1) end
  if KeyHit(KEY_P) then self:placeFlag() end
  if KeyHit(KEY_O) then self:deleteFlag() end
  if self.editing then
    if KeyHit(KEY_F1) then self:reset() end
    if KeyHit(KEY_F2) then
      local selected = RequestFile("Grid filename", "*.grd", false, self.filename)
      if selected ~= "" then
        LoadGrid(self.grid, self.flag_mgr, selected)
        self.filename = selected
        self.undo_mgr:reset()
      end
    end
    if KeyHit(KEY_F3) then
      if not self.filename then
        local selected = RequestFile("Grid filename", "*.grd", true, self.filename)
        if selected ~= "" then self.filename = selected end
      end
      if self.filename then SaveGrid(self.grid, self.flag_mgr, self.filename) end
    end
    if KeyHit(KEY_F4) then
      self.mode = self.mode + 1
      if self.mode > Grid.STAIRS_LEFT then self.mode = Grid.TILE end
    end
    if KeyDown(KEY_SPACE) then
      self.undo_mgr:addUndo(
        SetTile(
          self.grid,
          EntityX(self.cursor.entity),
          EntityY(self.cursor.entity),
          EntityZ(self.cursor.entity),
          self.mode,
          self.ceiling_tex_retriever:textureName(),
          self.wall_tex_retriever:textureName(),
          self.floor_tex_retriever:textureName()))
    end
    if KeyDown(KEY_DELETE) then
      self.undo_mgr:addUndo(
        RemoveTile(
          self.grid,
          EntityX(self.cursor.entity),
          EntityY(self.cursor.entity),
          EntityZ(self.cursor.entity)))
    end
  end
end

function GridManager:toggleLighting()
  if not self:lightingEnabled() then
    self.lights = CreateEntity()
    SetEntityParent(CreateLight(LIGHT_DIRECTIONAL), self.lights)
    SetEntityParent(CreateLight(LIGHT_DIRECTIONAL), self.lights)
    SetEntityParent(CreateLight(LIGHT_DIRECTIONAL), self.lights)
    SetEntityRotation(EntityChild(self.lights, 2), 0, 180, 0)
    SetEntityRotation(EntityChild(self.lights, 3), 90, 0, 0)
    SetAmbient(COLOR_LIGHTGRAY)
  else
    FreeEntity(self.lights)
    SetAmbient(COLOR_WHITE)
    self.lights = nil
  end
end

function GridManager:lightingEnabled()
  return self.lights ~= nil
end

function GridManager:placeFlag()
  self.undo_mgr:addUndo(PlaceFlag(
    self.current_flag,
    EntityX(self.cursor.entity),
    EntityY(self.cursor.entity),
    EntityZ(self.cursor.entity),
    self.flag_mgr))
end

function GridManager:deleteFlag()
  self.undo_mgr:addUndo(RemoveFlag(self.current_flag, self.flag_mgr))
end
