class SaveGrid {
	public static function save(grid:Grid, flagMgr:FlagManager, filename:String):Void {
		var texs = _gridTextures(grid);
		var memblock = Cs.createMemblock(_gridMemblockSize(grid, flagMgr, texs));
		var writer = new MemblockWriter(memblock);
		_writeHeader(grid, writer);
		_writeTextures(texs, writer);
		_writeTiles(grid, texs, writer);
		_writeFlags(flagMgr, writer);
		Cs.saveMemblock(memblock, filename);
		Cs.freeMemblock(memblock);
	}

	static function _gridTextures(grid:Grid):Array<String> {
		var texs:Array<String> = [];
		for (x in 1...(grid.tilesX() + 1)) {
			for (y in 1...(grid.tilesY() + 1)) {
				for (z in 1...(grid.tilesZ() + 1)) {
					var ceilTex = grid.ceilingTextureName(x, y, z);
					var wallTex = grid.wallTextureName(x, y, z);
					var floorTex = grid.floorTextureName(x, y, z);
					if (ListUtils.indexOf(texs, ceilTex) == null) texs.push(ceilTex);
					if (ListUtils.indexOf(texs, wallTex) == null) texs.push(wallTex);
					if (ListUtils.indexOf(texs, floorTex) == null) texs.push(floorTex);
				}
			}
		}
		return texs;
	}

	static function _gridMemblockSize(grid:Grid, flagMgr:FlagManager, texs:Array<String>):Int {
		return _headerSize() + _texturesSize(texs) + _tilesSize(grid) + _flagsSize(flagMgr);
	}

	static function _headerSize():Int {
		return 4; // Version, Width, Height, Depth
	}

	static function _texturesSize(texs:Array<String>):Int {
		var size = 1; // Num textures
		for (tex in texs) size += 4 + Cs.len(tex);
		return size;
	}

	static function _tilesSize(grid:Grid):Int {
		return 4 + _numTilesSet(grid) * 7;
	}

	static function _numTilesSet(grid:Grid):Int {
		var count = 0;
		for (x in 1...(grid.tilesX() + 1)) {
			for (y in 1...(grid.tilesY() + 1)) {
				for (z in 1...(grid.tilesZ() + 1)) {
					if (grid.hasTile(x, y, z)) count++;
				}
			}
		}
		return count;
	}

	static function _flagsSize(flagMgr:FlagManager):Int {
		return 1 + flagMgr.size() * 4;
	}

	static function _writeHeader(grid:Grid, writer:MemblockWriter):Void {
		writer.writeByte(1);
		writer.writeByte(grid.tilesX());
		writer.writeByte(grid.tilesY());
		writer.writeByte(grid.tilesZ());
	}

	static function _writeTextures(texs:Array<String>, writer:MemblockWriter):Void {
		writer.writeByte(texs.length);
		for (tex in texs) writer.writeString(tex);
	}

	static function _writeTiles(grid:Grid, texs:Array<String>, writer:MemblockWriter):Void {
		writer.writeInt(_numTilesSet(grid));
		for (x in 1...(grid.tilesX() + 1)) {
			for (y in 1...(grid.tilesY() + 1)) {
				for (z in 1...(grid.tilesZ() + 1)) {
					_writeTile(grid, x, y, z, texs, writer);
				}
			}
		}
	}

	static function _writeTile(grid:Grid, x:Int, y:Int, z:Int, texs:Array<String>, writer:MemblockWriter):Void {
		if (grid.hasTile(x, y, z)) {
			writer.writeByte(x);
			writer.writeByte(y);
			writer.writeByte(z);
			writer.writeByte(grid.getTileType(x, y, z));
			writer.writeByte(ListUtils.indexOf(texs, grid.ceilingTextureName(x, y, z)));
			writer.writeByte(ListUtils.indexOf(texs, grid.wallTextureName(x, y, z)));
			writer.writeByte(ListUtils.indexOf(texs, grid.floorTextureName(x, y, z)));
		}
	}

	static function _writeFlags(flagMgr:FlagManager, writer:MemblockWriter):Void {
		writer.writeByte(flagMgr.size());
		for (i in 1...(flagMgr.size() + 1)) {
			_writeFlag(flagMgr.at(i), writer);
		}
	}

	static function _writeFlag(flag:Null<Flag>, writer:MemblockWriter):Void {
		if (flag == null) return;
		writer.writeByte(flag.id);
		writer.writeByte(Cs.int(flag.x()));
		writer.writeByte(Cs.int(flag.y()));
		writer.writeByte(Cs.int(flag.z()));
	}
}
