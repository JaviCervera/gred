UndoManager = class()

function UndoManager:Create()
  self = self:New()
  self._undo = {}
  self._redo = {}
  return self
end

function UndoManager:addUndo(command)
  if command ~= nil then
    self._undo[#self._undo + 1] = command
    self._redo = {}
  end
end

function UndoManager:canUndo()
  return #self._undo > 0
end

function UndoManager:canRedo()
  return #self._redo > 0
end

function UndoManager:undo()
  if self:canUndo() then
    self._redo[#self._redo + 1] = self._undo[#self._undo]:execute()
    self._undo[#self._undo] = nil
  end
end

function UndoManager:redo()
  if self:canRedo() then
    self._undo[#self._undo + 1] = self._redo[#self._redo]:execute()
    self._redo[#self._redo] = nil
  end
end

function UndoManager:update()
  if IsKeyDown(KEY_LEFT_CONTROL) or IsKeyDown(KEY_RIGHT_CONTROL) then
    if IsKeyPressed(KEY_Z) then self:undo() end
    if IsKeyPressed(KEY_Y) then self:redo() end
  end
end

function UndoManager:reset()
  self._undo = {}
  self._redo = {}
end
