class MemblockReader {
	var memblock:Memblock;
	var offset:Int;

	public function new(memblock:Memblock) {
		this.memblock = memblock;
		offset = 0;
	}

	public function readByte():Int {
		var val = Cs.peekByte(memblock, offset);
		offset += 1;
		return val;
	}

	public function readShort():Int {
		var val = Cs.peekShort(memblock, offset);
		offset += 2;
		return val;
	}

	public function readInt():Int {
		var val = Cs.peekInt(memblock, offset);
		offset += 4;
		return val;
	}

	public function readFloat():Float {
		var val = Cs.peekFloat(memblock, offset);
		offset += 4;
		return val;
	}

	public function readString():String {
		var val = Cs.peekString(memblock, offset);
		offset += 4 + Cs.len(val);
		return val;
	}
}
