Cursor = class()
Cursor.COLOR_ORANGE = Color()
Cursor.COLOR_ORANGE.r = 255
Cursor.COLOR_ORANGE.g = 161
Cursor.COLOR_ORANGE.b = 0
Cursor.COLOR_ORANGE.a = 255
Cursor.COLOR_WHITE = Color()
Cursor.COLOR_WHITE.r = 255
Cursor.COLOR_WHITE.g = 255
Cursor.COLOR_WHITE.b = 255
Cursor.COLOR_WHITE.a = 255

function Cursor:Create(grid)
  self = self:New()
  self.position = Vector3()
  self.grid = grid
  self.alpha = 0.5
  self.alpha_dir = 1
  self:reset()
  return self
end

function Cursor:reset()
  self.position.x = self.grid:tilesX() / 2
  self.position.y = self.grid:tilesY() / 2
  self.position.z = self.grid:tilesZ() / 2
end

function Cursor:update(editing)
  if editing then
    -- Update alpha
    self.alpha = self.alpha + self.alpha_dir * 0.5 * GetFrameTime()
    if self.alpha <= 0.25 or self.alpha >= 0.75 then
      self.alpha = Clamp(self.alpha, 0.25, 0.75)
      self.alpha_dir = self.alpha_dir * -1
    end

    -- Update position
    if IsKeyPressed(KEY_UP) then self.position.z = Clamp(self.position.z - 1, 1, self.grid:tilesZ()) end
    if IsKeyPressed(KEY_DOWN) then self.position.z = Clamp(self.position.z + 1, 1, self.grid:tilesZ()) end
    if IsKeyPressed(KEY_LEFT) then self.position.x = Clamp(self.position.x - 1, 1, self.grid:tilesX()) end
    if IsKeyPressed(KEY_RIGHT) then self.position.x = Clamp(self.position.x + 1, 1, self.grid:tilesX()) end
    if IsKeyPressed(KEY_Q) then self.position.y = Clamp(self.position.y - 1, 1, self.grid:tilesY()) end
    if IsKeyPressed(KEY_A) then self.position.y = Clamp(self.position.y - 1, 1, self.grid:tilesY()) end
  end
end

function Cursor:draw()
  DrawCube(self.position, 1, 1, 1, ColorLerp(Cursor.COLOR_ORANGE, Cursor.COLOR_WHITE, self.alpha))
end
