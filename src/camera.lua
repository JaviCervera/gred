Camera = class()

Camera.MOVE_SPEED = 2
Camera.TURN_SPEED = 90

function Camera:Create(cursor)
  self = self:New()
  self.entity = CreateCamera()
  self.cursor = cursor
  self.distance = 6
  self.was_editing = true
  SetCameraRange(self.entity, 0.1, 100)
  return self
end

function Camera:update(editing)
  if editing then
    SetEntityPosition(
      self.entity,
      EntityX(self.cursor.entity),
      EntityY(self.cursor.entity),
      EntityZ(self.cursor.entity))
    MoveEntity(self.entity, 0, 0, -Max(2, (self.distance + CursorWheel())))
    SetEntityRotation(self.entity, 89.9, 0, 0)
    self.was_editing = true
  else
    if self.was_editing then
      SetEntityPosition(
        self.entity,
        EntityX(self.cursor.entity),
        EntityY(self.cursor.entity),
        EntityZ(self.cursor.entity))
      SetEntityRotation(self.entity, 0, 0, 0)
    end
    if KeyDown(KEY_UP) then MoveEntity(self.entity, 0, 0, self.MOVE_SPEED * DeltaTime()) end
    if KeyDown(KEY_DOWN) then MoveEntity(self.entity, 0, 0, -self.MOVE_SPEED * DeltaTime()) end
    if KeyDown(KEY_LEFT) then TurnEntity(self.entity, 0, -self.TURN_SPEED * DeltaTime(), 0) end
    if KeyDown(KEY_RIGHT) then TurnEntity(self.entity, 0, self.TURN_SPEED * DeltaTime(), 0) end
    if KeyDown(KEY_Q) then TranslateEntity(self.entity, 0, self.MOVE_SPEED * DeltaTime(), 0) end
    if KeyDown(KEY_A) then TranslateEntity(self.entity, 0, -self.MOVE_SPEED * DeltaTime(), 0) end
    self.was_editing = false
  end
end
