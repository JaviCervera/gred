Flag = class()
Flag._ActiveTexture = nil
Flag._InactiveTexture = nil

function Flag:Create(id, x, y, z)
  self = Flag:New()
  self.id = id
  self.entity = CreateSprite(nil, MATERIAL_ALPHA)
  self.active = false
  self:position(x, y, z)
  self:setActive(true)
  return self
end

function Flag:destroy()
  FreeEntity(self.entity)
end

function Flag:position(x, y, z)
  SetEntityPosition(self.entity, x, y, z)
end

function Flag:x()
  return EntityX(self.entity)
end

function Flag:y()
  return EntityY(self.entity)
end

function Flag:z()
  return EntityZ(self.entity)
end

function Flag:setActive(active)
  if self._ActiveTexture == nil then self._ActiveTexture = LoadTexture("icons/flag_red.png") end
  if self._InactiveTexture == nil then self._InactiveTexture = LoadTexture("icons/flag_orange.png") end
  if active ~= self.active then
    self.active = active
    if active then
      SetMaterialTexture(EntityMaterial(self.entity, 1), 1, self._ActiveTexture)
    else
      SetMaterialTexture(EntityMaterial(self.entity, 1), 1, self._InactiveTexture)
    end
  end
end
