GridEditor = class()

function GridEditor:Create(grid, cursor, ceiling_tex_retriever, wall_tex_retriever, floor_tex_retriever, undo_mgr)
  self = self:New()
  self.filename = nil
  self.grid = grid
  self.cursor = cursor
  self.ceiling_tex_retriever = ceiling_tex_retriever
  self.wall_tex_retriever = wall_tex_retriever
  self.floor_tex_retriever = floor_tex_retriever
  self.undo_mgr = undo_mgr
  self.editing = true
  self.mode = Grid.TILE
  self.lights = nil
  return self
end

function GridEditor:update()
  if KeyHit(KEY_ENTER) then self.editing = not self.editing end
  if KeyHit(KEY_F) then self.grid:toggleFiltering() end
  if KeyHit(KEY_L) then self:toggleLighting() end
  if KeyHit(KEY_R) then self.grid:toggleWireframe() end
  if self.editing then
    if KeyHit(KEY_F2) then
      local selected = RequestFile("Grid filename", "*.grd", false, self.filename)
      if selected ~= "" then
        LoadGrid(self.grid, selected)
        self.filename = selected
      end
    end
    if KeyHit(KEY_F3) then
      if not self.filename then
        local selected = RequestFile("Grid filename", "*.grd", true, self.filename)
        if selected ~= "" then self.filename = selected end
      end
      if self.filename then SaveGrid(self.grid, self.filename) end
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

function GridEditor:toggleLighting()
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

function GridEditor:lightingEnabled()
  return self.lights ~= nil
end
