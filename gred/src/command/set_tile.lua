SetTileCommand = class()

function SetTileCommand:Create(grid, x, y, z, type, ceiling_tex_name, wall_tex_name, floor_tex_name)
  self = SetTileCommand:New()
  self.grid = grid
  self.x = x
  self.y = y
  self.z = z
  self.type = type
  self.ceiling_tex_name = ceiling_tex_name
  self.wall_tex_name = wall_tex_name
  self.floor_tex_name = floor_tex_name
  return self
end

function SetTileCommand:execute()
  local undo_cmd = nil
  if self.grid:hasTile(self.x, self.y, self.z) then
    if self.grid:type(self.x, self.y, self.z) ~= self.type
      or self.grid:ceilingTextureName(self.x, self.y, self.z) ~= self.ceiling_tex_name
      or self.grid:wallTextureName(self.x, self.y, self.z) ~= self.wall_tex_name
      or self.grid:floorTextureName(self.x, self.y, self.z) ~= self.floor_tex_name then
      undo_cmd = SetTileCommand:Create(
        self.grid,
        self.x,
        self.y,
        self.z,
        self.grid:type(self.x, self.y, self.z),
        self.grid:ceilingTextureName(self.x, self.y, self.z),
        self.grid:wallTextureName(self.x, self.y, self.z),
        self.grid:floorTextureName(self.x, self.y, self.z))
    end
  else
    undo_cmd = RemoveTileCommand:Create(self.grid, self.x, self.y, self.z)
  end
  self.grid:setTile(self.x, self.y, self.z, self.type, self.ceiling_tex_name, self.wall_tex_name, self.floor_tex_name)
  return undo_cmd
end

function SetTile(grid, x, y, z, type, ceiling_tex_name, wall_tex_name, floor_tex_name)
  return SetTileCommand:Create(grid, x, y, z, type, ceiling_tex_name, wall_tex_name, floor_tex_name):execute()
end
