TextureViewer = class()

function TextureViewer:Create(texture_names, selected, path, prev_key, next_key)
  self = TextureViewer:New()
  self.names = texture_names
  self.selected = Clamp(Int(selected), 1, #texture_names)
  self.path = path
  self.tex = nil
  self.prev_key = prev_key
  self.next_key = next_key
  self:_reloadTexture()
  return self
end

function TextureViewer:update()
  if KeyHit(self.prev_key) then self:_prevTexture() end
  if KeyHit(self.next_key) then self:_nextTexture() end
end

function TextureViewer:draw(x, y, width, height)
  if self.tex ~= nil then
    DrawTextureEx(self.tex, x, y, width, height, COLOR_WHITE)
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
