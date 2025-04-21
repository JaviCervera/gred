function LoadGrid(grid, filename)
  local memblock = LoadMemblock(filename)
  local reader = MemblockReader:Create(memblock)
  local version = reader:readByte()
  local tiles_x = reader:readByte()
  local tiles_y = reader:readByte()
  local tiles_z = reader:readByte()
  grid:reset(tiles_x, tiles_y, tiles_z)
  texs = _LoadGridTextureNames(reader)
  local num_tiles = reader:readInt()
  for i = 1, num_tiles do
    _LoadGridTile(grid, texs, reader)
  end
  grid:_updateModel()
  FreeMemblock(memblock)
end

function _LoadGridTextureNames(reader)
  local texs = {}
  local count = reader:readByte()
  for i = 1, count do
    texs[#texs + 1] = reader:readString()
  end
  return texs
end

function _LoadGridTile(grid, texs, reader)
  local x = reader:readByte()
  local y = reader:readByte()
  local z = reader:readByte()
  local type = reader:readByte()
  local ceiling_tex = texs[reader:readByte()]
  local wall_tex = texs[reader:readByte()]
  local floor_tex = texs[reader:readByte()]
  grid:setTile(x, y, z, type, ceiling_tex, wall_tex, floor_tex, false)
end
