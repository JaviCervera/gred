class GridLoader {
	public static function load(grid:Grid, flagMgr:FlagManager, filename:String):Void {
		final memblock = Cs.loadMemblock(filename);
		final reader = new MemblockReader(memblock);
		reader.readByte(); // Version, currently unused
		final tilesX = reader.readByte();
		final tilesY = reader.readByte();
		final tilesZ = reader.readByte();
		grid.reset(tilesX, tilesY, tilesZ);
		final texs = loadTextureNames(reader);
		final numTiles = reader.readInt();
		for (i in 0...numTiles) {
			loadTile(grid, texs, reader);
		}
		grid._updateModel();
		flagMgr.clear();
		final numFlags = reader.readByte();
		for (i in 0...numFlags) {
			loadFlag(flagMgr, reader);
		}
		Cs.freeMemblock(memblock);
	}

	private static function loadTextureNames(reader:MemblockReader):Array<String> {
		final texs:Array<String> = [];
		final count = reader.readByte();
		for (i in 0...count) {
			texs.push(reader.readString());
		}
		return texs;
	}

	private static function loadTile(grid:Grid, texs:Array<String>, reader:MemblockReader):Void {
		final x = reader.readByte();
		final y = reader.readByte();
		final z = reader.readByte();
		final kind = reader.readByte();
		final ceilingTex = texs[reader.readByte() - 1];
		final wallTex = texs[reader.readByte() - 1];
		final floorTex = texs[reader.readByte() - 1];
		grid.setTile(x, y, z, kind, ceilingTex, wallTex, floorTex, false);
	}

	private static function loadFlag(flagMgr:FlagManager, reader:MemblockReader):Void {
		final id = reader.readByte();
		final x = reader.readByte();
		final y = reader.readByte();
		final z = reader.readByte();
		flagMgr.place(id, x, y, z);
	}
}
