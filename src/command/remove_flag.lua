RemoveFlagCommand = class()

function RemoveFlagCommand:Create(id, flag_mgr)
  self = RemoveFlagCommand:New()
  self.id = id
  self.mgr = flag_mgr
  return self
end

function RemoveFlagCommand:execute()
  local flag = self.mgr:find(self.id)
  if flag == nil then return nil end
  local undo_cmd = PlaceFlagCommand:Create(self.id, flag:x(), flag:y(), flag:z(), self.mgr)
  self.mgr:remove(self.id)
  return undo_cmd
end

function RemoveFlag(id, flag_mgr)
  return RemoveFlagCommand:Create(id, flag_mgr):execute()
end
