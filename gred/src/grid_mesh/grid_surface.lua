GridSurface = class()

function GridSurface:Create(tex_name)
  self = GridSurface:New()
  self.tex_name = tex_name
  self.verts = {}
  self.idxs = {}
  return self
end

function GridSurface:addVertex(vertex)
  self.verts[#self.verts + 1] = vertex
  return #self.verts - 1
end

function GridSurface:numVertices()
  return #self.verts
end

function GridSurface:vertex(i)
  return self.verts[i]
end

function GridSurface:addIndex(idx)
  self.idxs[#self.idxs + 1] = idx
end

function GridSurface:numIndices()
  return #self.idxs
end

function GridSurface:index(i)
  return self.idxs[i]
end

function GridSurface:addToMesh(mesh)
  local vertices = self:_verticesMemblock()
  local indices = self:_indicesMemblock()
  local surf = AddSurface(mesh, vertices, self:numVertices(), indices, self:numIndices(), SURFACE_STANDARD)
  local mat = SurfaceMaterial(surf)
  SetMaterialTexture(mat, 1, LoadTexture(self.tex_name))
  FreeMemblock(vertices)
  FreeMemblock(indices)
  return surf
end

function GridSurface:_verticesMemblock()
  local VERTEX_SIZE = 36
  local memblock = CreateMemblock(VERTEX_SIZE * self:numVertices())
  for i, v in ipairs(self.verts) do
    PokeFloat(memblock, (i-1)*VERTEX_SIZE, v.x)
    PokeFloat(memblock, (i-1)*VERTEX_SIZE + 4, v.y)
    PokeFloat(memblock, (i-1)*VERTEX_SIZE + 8, v.z)
    PokeFloat(memblock, (i-1)*VERTEX_SIZE + 12, v.nx)
    PokeFloat(memblock, (i-1)*VERTEX_SIZE + 16, v.ny)
    PokeFloat(memblock, (i-1)*VERTEX_SIZE + 20, v.nz)
    PokeInt(memblock, (i-1)*VERTEX_SIZE + 24, v.color)
    PokeFloat(memblock, (i-1)*VERTEX_SIZE + 28, v.u)
    PokeFloat(memblock, (i-1)*VERTEX_SIZE + 32, v.v)
  end
  return memblock
end

function GridSurface:_indicesMemblock()
  local INDEX_SIZE = 2
  local memblock = CreateMemblock(INDEX_SIZE * self:numIndices())
  for i, idx in ipairs(self.idxs) do
    PokeShort(memblock, (i-1)*INDEX_SIZE, idx)
  end
  return memblock
end
