class MemblockReader {
	private final memblock:Memblock;
	private var offset:Int;

	public function new(memblock:Memblock) {
		this.memblock = memblock;
		offset = 0;
	}

	public function readByte():Int {
		final val = Cs.peekByte(memblock, offset);
		offset += 1;
		return val;
	}

	public function readShort():Int {
		final val = Cs.peekShort(memblock, offset);
		offset += 2;
		return val;
	}

	public function readInt():Int {
		final val = Cs.peekInt(memblock, offset);
		offset += 4;
		return val;
	}

	public function readFloat():Float {
		final val = Cs.peekFloat(memblock, offset);
		offset += 4;
		return val;
	}

	public function readString():String {
		final val = Cs.peekString(memblock, offset);
		offset += 4 + Cs.len(val);
		return val;
	}
}
