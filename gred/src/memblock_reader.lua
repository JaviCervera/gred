MemblockReader = class()

function MemblockReader:Create(memblock)
  local self = self:New()
  self.memblock = memblock
  self.offset = 0
  return self
end

function MemblockReader:readByte()
  local val = PeekByte(self.memblock, self.offset)
  self.offset = self.offset + 1
  return val
end

function MemblockReader:readShort()
  local val = PeekShort(self.memblock, self.offset)
  self.offset = self.offset + 2
  return val
end

function MemblockReader:readInt()
  local val = PeekInt(self.memblock, self.offset)
  self.offset = self.offset + 4
  return val
end

function MemblockReader:readFloat()
  local val = PeekFloat(self.memblock, self.offset)
  self.offset = self.offset + 4
  return val
end

function MemblockReader:readString()
  local val = PeekString(self.memblock, self.offset)
  self.offset = self.offset + 4 + Len(val)
  return val
end
