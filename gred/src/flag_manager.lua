FlagManager = class()

function FlagManager:Create()
  self = FlagManager:New()
  self.lst = {}
  self.current_active = nil
  return self
end

function FlagManager:update(active_flag)
  if active_flag ~= self.current_active then
    if self.current_active ~= nil then
      local flag = self:find(self.current_active)
      if flag ~= nil then flag:setActive(false) end
      self.current_active = nil
    end
    if active_flag ~= nil then
      local flag = self:find(active_flag)
      if flag ~= nil then
        flag:setActive(true)
        self.current_active = active_flag
      end
    end
  end
end

function FlagManager:drawFlagNumbers(font, cam)
  for _, flag in ipairs(self.lst) do
    WorldToScreen(cam, EntityX(flag.entity), EntityY(flag.entity), EntityZ(flag.entity))
    local width = TextWidth(font, flag.id)
    local height = TextHeight(font, flag.id)
    DrawRect(PointX(), PointY(), width, height, COLOR_BLACK)
    DrawText(font, flag.id, PointX(), PointY(), COLOR_YELLOW)
  end
end

function FlagManager:clear()
  for _, flag in ipairs(self.lst) do
    flag:destroy()
  end
  self.lst = {}
  self.current_active = nil
end

function FlagManager:place(flag_id, x, y, z)
  local index = self:findIndex(flag_id)
  if index == nil then
    self.lst[#self.lst + 1] = Flag:Create(flag_id, x, y, z)
    table.sort(self.lst, function(a, b) return a.id <= b.id end)
  else
    self.lst[index]:position(x, y, z)
  end
end

function FlagManager:remove(flag_id)
  local index = self:findIndex(flag_id)
  if index == nil then return nil end
  self.lst[index]:destroy()
  table.remove(self.lst, index)
end

function FlagManager:find(flag_id)
  local index = self:findIndex(flag_id)
  if index ~= nil then return self.lst[index] else return nil end
end

function FlagManager:findIndex(flag_id)
  for i, flag in ipairs(self.lst) do
    if flag.id == flag_id then return i end
  end
  return nil
end

function FlagManager:size()
  return #self.lst
end

function FlagManager:at(index)
  if index < 0 or index > self:size() then return nil end
  return self.lst[index]
end
