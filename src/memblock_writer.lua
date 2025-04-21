MemblockWriter = class()

function MemblockWriter:Create(memblock)
  local self = self:New()
  self.memblock = memblock
  self.offset = 0
  return self
end

function MemblockWriter:writeByte(v)
  PokeByte(self.memblock, self.offset, v)
  self.offset = self.offset + 1
end

function MemblockWriter:writeShort(v)
  PokeShort(self.memblock, self.offset, v)
  self.offset = self.offset + 2
end

function MemblockWriter:writeInt(v)
  PokeInt(self.memblock, self.offset, v)
  self.offset = self.offset + 4
end

function MemblockWriter:writeFloat(v)
  PokeFloat(self.memblock, self.offset, v)
  self.offset = self.offset + 4
end

function MemblockWriter:writeString(v)
  PokeString(self.memblock, self.offset, v)
  self.offset = self.offset + 4 + Len(v)
end
