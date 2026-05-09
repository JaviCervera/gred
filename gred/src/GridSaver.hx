class GridSaver {
	public static function save(grid:Grid, flagMgr:FlagManager, filename:String):Void {
		final texs = gridTextures(grid);
		final memblock = Cs.createMemblock(gridMemblockSize(grid, flagMgr, texs));
		final writer = new MemblockWriter(memblock);
		writeHeader(grid, writer);
		writeTextures(texs, writer);
		writeTiles(grid, texs, writer);
		writeFlags(flagMgr, writer);
		Cs.saveMemblock(memblock, filename);
		Cs.freeMemblock(memblock);
	}

	private static function gridTextures(grid:Grid):Array<String> {
		final texs:Array<String> = [];
		for (x in 1...(grid.tilesX() + 1)) {
			for (y in 1...(grid.tilesY() + 1)) {
				for (z in 1...(grid.tilesZ() + 1)) {
					final ceilTex = grid.ceilingTextureName(x, y, z);
					final wallTex = grid.wallTextureName(x, y, z);
					final floorTex = grid.floorTextureName(x, y, z);
					if (texs.indexOf(ceilTex) == -1)
						texs.push(ceilTex);
					if (texs.indexOf(wallTex) == -1)
						texs.push(wallTex);
					if (texs.indexOf(floorTex) == -1)
						texs.push(floorTex);
				}
			}
		}
		return texs;
	}

	private static function gridMemblockSize(grid:Grid, flagMgr:FlagManager, texs:Array<String>):Int {
		return headerSize() + texturesSize(texs) + tilesSize(grid) + flagsSize(flagMgr);
	}

	private static function headerSize():Int {
		return 4; // Version, Width, Height, Depth
	}

	private static function texturesSize(texs:Array<String>):Int {
		var size = 1; // Num textures
		for (tex in texs)
			size += 4 + Cs.len(tex);
		return size;
	}

	private static function tilesSize(grid:Grid):Int {
		return 4 + numTilesSet(grid) * 7;
	}

	private static function numTilesSet(grid:Grid):Int {
		var count = 0;
		for (x in 1...(grid.tilesX() + 1)) {
			for (y in 1...(grid.tilesY() + 1)) {
				for (z in 1...(grid.tilesZ() + 1)) {
					if (grid.hasTile(x, y, z))
						count++;
				}
			}
		}
		return count;
	}

	private static function flagsSize(flagMgr:FlagManager):Int {
		return 1 + flagMgr.size() * 4;
	}

	private static function writeHeader(grid:Grid, writer:MemblockWriter):Void {
		writer.writeByte(1);
		writer.writeByte(grid.tilesX());
		writer.writeByte(grid.tilesY());
		writer.writeByte(grid.tilesZ());
	}

	private static function writeTextures(texs:Array<String>, writer:MemblockWriter):Void {
		writer.writeByte(texs.length);
		for (tex in texs)
			writer.writeString(tex);
	}

	private static function writeTiles(grid:Grid, texs:Array<String>, writer:MemblockWriter):Void {
		writer.writeInt(numTilesSet(grid));
		for (x in 1...(grid.tilesX() + 1)) {
			for (y in 1...(grid.tilesY() + 1)) {
				for (z in 1...(grid.tilesZ() + 1)) {
					writeTile(grid, x, y, z, texs, writer);
				}
			}
		}
	}

	private static function writeTile(grid:Grid, x:Int, y:Int, z:Int, texs:Array<String>, writer:MemblockWriter):Void {
		if (grid.hasTile(x, y, z)) {
			writer.writeByte(x);
			writer.writeByte(y);
			writer.writeByte(z);
			writer.writeByte(grid.getTileType(x, y, z));
			writer.writeByte(texs.indexOf(grid.ceilingTextureName(x, y, z)) + 1);
			writer.writeByte(texs.indexOf(grid.wallTextureName(x, y, z)) + 1);
			writer.writeByte(texs.indexOf(grid.floorTextureName(x, y, z)) + 1);
		}
	}

	private static function writeFlags(flagMgr:FlagManager, writer:MemblockWriter):Void {
		writer.writeByte(flagMgr.size());
		for (i in 1...(flagMgr.size() + 1)) {
			writeFlag(flagMgr.at(i), writer);
		}
	}

	private static function writeFlag(flag:Null<Flag>, writer:MemblockWriter):Void {
		if (flag == null)
			return;
		writer.writeByte(flag.id);
		writer.writeByte(Cs.int(flag.x()));
		writer.writeByte(Cs.int(flag.y()));
		writer.writeByte(Cs.int(flag.z()));
	}
}
