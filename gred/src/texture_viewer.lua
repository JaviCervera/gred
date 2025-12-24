TextureViewer = class()

function TextureViewer:Create(texture_names, selected, path, prev_key, next_key)
  self = TextureViewer:New()
  self.names = texture_names
  self.selected = Clamp(math.floor(selected), 1, #texture_names)
  self.path = path
  self.tex = nil
  self.prev_key = prev_key
  self.next_key = next_key
  self:_reloadTexture()
  return self
end

function TextureViewer:update()
  if IsKeyPressed(self.prev_key) then self:_prevTexture() end
  if IsKeyPressed(self.next_key) then self:_nextTexture() end
end

function TextureViewer:draw(x, y, width, height)
  if self.tex ~= nil then
    local src = Rectangle()
    src.x = 0
    src.y = 0
    src.width = self.tex.width
    src.height = self.tex.height
    local dst = Rectangle()
    dst.x = x
    dst.y = y
    dst.width = width
    dst.height = height
    DrawTexturePro(self.tex, src, dst, Vector2(), 0, GetColor(0xFFFFFFFF))
  end
end

function TextureViewer:texture()
  return self.tex
end

function TextureViewer:textureName()
  return self.names[self.selected]
end

function TextureViewer:_nextTexture()
  self.selected = self.selected + 1
  if self.selected > #self.names then self.selected = 1 end
  self:_reloadTexture()
end

function TextureViewer:_prevTexture()
  self.selected = self.selected - 1
  if self.selected < 1 then self.selected = #self.names end
  self:_reloadTexture()
end

function TextureViewer:_reloadTexture()
  self.tex = LoadTexture(self.path .. self.names[self.selected])
end
