PlaceFlagCommand = class()

function PlaceFlagCommand:Create(id, x, y, z, flag_mgr)
  self = PlaceFlagCommand:New()
  self.id = id
  self.x = x
  self.y = y
  self.z = z
  self.mgr = flag_mgr
  return self
end

function PlaceFlagCommand:execute()
  local undo_cmd = nil
  if self.mgr:findIndex(self.id) == nil then
    undo_cmd = RemoveFlagCommand:Create(self.id, self.mgr)
  else
    local flag = self.mgr:find(self.id)
    if flag:x() == self.x and flag:y() == self.y and flag:z() == self.z then return nil end
    undo_cmd = PlaceFlagCommand:Create(self.id, flag:x(), flag:y(), flag:z(), self.mgr)
  end
  self.mgr:place(self.id, self.x, self.y, self.z)
  return undo_cmd
end

function PlaceFlag(id, x, y, z, flag_mgr)
  return PlaceFlagCommand:Create(id, x, y, z, flag_mgr):execute()
end
