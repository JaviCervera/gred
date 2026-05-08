class LoadGrid {
	public static function load(grid:Grid, flagMgr:FlagManager, filename:String):Void {
		var memblock = Cs.loadMemblock(filename);
		var reader = new MemblockReader(memblock);
		var version = reader.readByte();
		var tilesX = reader.readByte();
		var tilesY = reader.readByte();
		var tilesZ = reader.readByte();
		grid.reset(tilesX, tilesY, tilesZ);
		var texs = _loadTextureNames(reader);
		var numTiles = reader.readInt();
		for (i in 0...numTiles) {
			_loadTile(grid, texs, reader);
		}
		grid._updateModel();
		flagMgr.clear();
		var numFlags = reader.readByte();
		for (i in 0...numFlags) {
			_loadFlag(flagMgr, reader);
		}
		Cs.freeMemblock(memblock);
	}

	static function _loadTextureNames(reader:MemblockReader):Array<String> {
		var texs:Array<String> = [];
		var count = reader.readByte();
		for (i in 0...count) {
			texs.push(reader.readString());
		}
		return texs;
	}

	static function _loadTile(grid:Grid, texs:Array<String>, reader:MemblockReader):Void {
		var x = reader.readByte();
		var y = reader.readByte();
		var z = reader.readByte();
		var kind = reader.readByte();
		var ceilingTex = texs[reader.readByte() - 1];
		var wallTex = texs[reader.readByte() - 1];
		var floorTex = texs[reader.readByte() - 1];
		grid.setTile(x, y, z, kind, ceilingTex, wallTex, floorTex, false);
	}

	static function _loadFlag(flagMgr:FlagManager, reader:MemblockReader):Void {
		var id = reader.readByte();
		var x = reader.readByte();
		var y = reader.readByte();
		var z = reader.readByte();
		flagMgr.place(id, x, y, z);
	}
}
