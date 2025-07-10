GridVertex = class()

function GridVertex:Create(x, y, z, nx, ny, nz, color, u, v)
  self = GridVertex:New()
  self.x = x
  self.y = y
  self.z = z
  self.nx = nx
  self.ny = ny
  self.nz = nz
  self.color = color
  self.u = u
  self.v = v
  return self
end
