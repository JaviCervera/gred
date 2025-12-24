Camera = class()

Camera.MOVE_SPEED = 2
Camera.TURN_SPEED = 90

function Camera:Create(cursor)
  self = self:New()
  self.cam = Camera3D()
  self.cam.up.x = 0
  self.cam.up.y = 0
  self.cam.up.z = -1
  self.cam.fovy = 60
  self.cam.projection = CAMERA_PERSPECTIVE
  self.cursor = cursor
  self.distance = 6
  self.was_editing = true
  return self
end

function Camera:update(editing)
  if editing then
    self.distance = math.max(2, (self.distance - GetMouseWheelMove()))
    self.cam.position.x = self.cursor.position.x
    self.cam.position.y = self.cursor.position.y + self.distance
    self.cam.position.z = self.cursor.position.z
    self.cam.target.x = self.cursor.position.x
    self.cam.target.y = self.cursor.position.y
    self.cam.target.z = self.cursor.position.z
    self.was_editing = true
  else
    if self.was_editing then
      self.cam.position.x = self.cursor.position.x
      self.cam.position.y = self.cursor.position.y
      self.cam.position.z = self.cursor.position.z
      self.cam.target.x = self.cursor.position.x
      self.cam.target.y = self.cursor.position.y
      self.cam.target.z = self.cursor.position.z - 1
    end
    local movement = Vector3()
    local rotation = Vector3()
    if IsKeyDown(KEY_UP) then movement.x = movement.x - self.MOVE_SPEED * GetFrameTime() end
    if IsKeyDown(KEY_DOWN) then movement.x = movement.x + self.MOVE_SPEED * GetFrameTime() end
    if IsKeyDown(KEY_LEFT) then rotation.y = movement.y + self.TURN_SPEED * GetFrameTime() end
    if IsKeyDown(KEY_RIGHT) then rotation.y = movement.y - self.TURN_SPEED * GetFrameTime() end
    if IsKeyDown(KEY_Q) then movement.y = movement.y + self.MOVE_SPEED * GetFrameTime() end
    if IsKeyDown(KEY_A) then movement.y = movement.y - self.MOVE_SPEED * GetFrameTime() end
    UpdateCameraPro(self.cam, movement, rotation, 1)
    self.was_editing = false
  end
end
