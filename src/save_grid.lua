function SaveGrid(grid, filename)
  local texs = _GridTextures(grid)
  local memblock = CreateMemblock(_GridMemblockSize(grid, texs))
  local writer = MemblockWriter:Create(memblock)
  _WriteGridHeader(grid, writer)
  _WriteGridTextures(texs, writer)
  _WriteGridTiles(grid, texs, writer)
  SaveMemblock(memblock, filename)
  FreeMemblock(memblock)
end

function _GridMemblockSize(grid, texs)
  return _GridHeaderSize(grid) + _GridTexturesSize(texs) + _GridTilesSize(grid)
end

function _GridHeaderSize(grid)
  return 4 -- Version, Width, Height, Depth
end

function _GridTexturesSize(texs)
  local size = 1 -- Num textures
  for _, tex in ipairs(texs) do
    size = size + 4 + Len(tex)
  end
  return size
end

function _GridTilesSize(grid)
  return 4 + _GridNumTilesSet(grid) * 7
end

function _GridNumTilesSet(grid)
  local count = 0
  for x = 1, grid:tilesX() do
    for y = 1, grid:tilesY() do
      for z = 1, grid:tilesZ() do
        if grid:hasTile(x, y, z) then count = count + 1 end
      end
    end
  end
  return count
end

function _GridTextures(grid)
  local texs = {}
  for x = 1, grid:tilesX() do
    for y = 1, grid:tilesY() do
      for z = 1, grid:tilesZ() do
        local ceiling_tex = grid:ceilingTextureName(x, y, z)
        local wall_tex = grid:wallTextureName(x, y, z)
        local floor_tex = grid:floorTextureName(x, y, z)
        if ListIndex(texs, ceiling_tex) == nil then texs[#texs + 1] = ceiling_tex end
        if ListIndex(texs, wall_tex) == nil then texs[#texs + 1] = wall_tex end
        if ListIndex(texs, floor_tex) == nil then texs[#texs + 1] = floor_tex end
      end
    end
  end
  return texs
end

function _WriteGridHeader(grid, writer)
  writer:writeByte(1)
  writer:writeByte(grid:tilesX())
  writer:writeByte(grid:tilesY())
  writer:writeByte(grid:tilesZ())
end

function _WriteGridTextures(texs, writer)
  writer:writeByte(#texs)
  for _, tex in ipairs(texs) do
    writer:writeString(tex)
  end
end

function _WriteGridTiles(grid, texs, writer)
  writer:writeInt(_GridNumTilesSet(grid))
  for x = 1, grid:tilesX() do
    for y = 1, grid:tilesY() do
      for z = 1, grid:tilesZ() do
        _WriteGridTile(grid, x, y, z, texs, writer)
      end
    end
  end
end

function _WriteGridTile(grid, x, y, z, texs, writer)
  if grid:hasTile(x, y, z) then
    writer:writeByte(x)
    writer:writeByte(y)
    writer:writeByte(z)
    writer:writeByte(grid:type(x, y, z))
    writer:writeByte(ListIndex(texs, grid:ceilingTextureName(x, y, z)))
    writer:writeByte(ListIndex(texs, grid:wallTextureName(x, y, z)))
    writer:writeByte(ListIndex(texs, grid:floorTextureName(x, y, z)))
  end
end
