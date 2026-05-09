class MemblockWriter {
	private final memblock:Memblock;
	private var offset:Int;

	public function new(memblock:Memblock) {
		this.memblock = memblock;
		offset = 0;
	}

	public function writeByte(v:Int):Void {
		Cs.pokeByte(memblock, offset, v);
		offset += 1;
	}

	public function writeShort(v:Int):Void {
		Cs.pokeShort(memblock, offset, v);
		offset += 2;
	}

	public function writeInt(v:Int):Void {
		Cs.pokeInt(memblock, offset, v);
		offset += 4;
	}

	public function writeFloat(v:Float):Void {
		Cs.pokeFloat(memblock, offset, v);
		offset += 4;
	}

	public function writeString(v:String):Void {
		Cs.pokeString(memblock, offset, v);
		offset += 4 + Cs.len(v);
	}
}
