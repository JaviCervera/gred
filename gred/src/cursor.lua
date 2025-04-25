Cursor = class()

function Cursor:Create(grid)
  self = self:New()
  local mesh = CreateCubeMesh()
  self.entity = CreateModel(mesh)
  self.grid = grid
  self.alpha = 0.5
  self.alpha_dir = 1
  FreeMesh(mesh)
  local mat = EntityMaterial(self.entity, 1)
  SetMaterialType(mat, MATERIAL_ALPHA)
  SetMaterialFlag(mat, FLAG_LIGHTING, false)
  SetMaterialFlag(mat, FLAG_VERTEXCOLORS, true)
  self:reset()
  return self
end

function Cursor:reset()
  SetEntityPosition(self.entity, self.grid:tilesX() / 2, self.grid:tilesY() / 2, self.grid:tilesZ() / 2)
end

function Cursor:update(editing)
  if editing and not EntityVisible(self.entity) then SetEntityVisible(self.entity, true) end
  if not editing and EntityVisible(self.entity) then SetEntityVisible(self.entity, false) end
  if editing then
    -- Update alpha
    self.alpha = self.alpha + self.alpha_dir * 0.5 * DeltaTime()
    if self.alpha <= 0.25 or self.alpha >= 0.75 then
      self.alpha = Clamp(self.alpha, 0.25, 0.75)
      self.alpha_dir = self.alpha_dir * -1
    end
    SetMeshColor(ModelMesh(self.entity), FadeColor(COLOR_ORANGE, self.alpha * 255))
    UpdateMesh(ModelMesh(self.entity))

    -- Update position
    if KeyHit(KEY_UP) then TranslateEntity(self.entity, 0, 0, 1) end
    if KeyHit(KEY_DOWN) then TranslateEntity(self.entity, 0, 0, -1) end
    if KeyHit(KEY_LEFT) then TranslateEntity(self.entity, -1, 0, 0) end
    if KeyHit(KEY_RIGHT) then TranslateEntity(self.entity, 1, 0, 0) end
    if KeyHit(KEY_Q) then TranslateEntity(self.entity, 0, 1, 0) end
    if KeyHit(KEY_A) then TranslateEntity(self.entity, 0, -1, 0) end
    SetEntityPosition(
      self.entity,
      Clamp(EntityX(self.entity), 1, self.grid:tilesX()),
      Clamp(EntityY(self.entity), 1, self.grid:tilesY()),
      Clamp(EntityZ(self.entity), 1, self.grid:tilesZ()))
  end
end
