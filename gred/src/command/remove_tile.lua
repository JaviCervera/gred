RemoveTileCommand = class()

function RemoveTileCommand:Create(grid, x, y, z)
  self = RemoveTileCommand:New()
  self.grid = grid
  self.x = x
  self.y = y
  self.z = z
  return self
end

function RemoveTileCommand:execute()
  if self.grid:hasTile(self.x, self.y, self.z) then
    local undo_cmd = SetTileCommand:Create(
      self.grid,
      self.x,
      self.y,
      self.z,
      self.grid:type(self.x, self.y, self.z),
      self.grid:ceilingTextureName(self.x, self.y, self.z),
      self.grid:wallTextureName(self.x, self.y, self.z),
      self.grid:floorTextureName(self.x, self.y, self.z))
    self.grid:removeTile(self.x, self.y, self.z)
    return undo_cmd
  end
end

function RemoveTile(grid, x, y, z)
  return RemoveTileCommand:Create(grid, x, y, z):execute()
end
