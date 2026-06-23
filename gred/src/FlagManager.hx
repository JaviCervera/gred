class FlagManager {
	private var lst:Array<Flag>;
	private var currentActive:Null<Int>;

	public function new() {
		lst = [];
		currentActive = null;
	}

	public function update(activeFlag:Null<Int>):Void {
		if (activeFlag != currentActive) {
			if (currentActive != null) {
				var flag = find(currentActive);
				if (flag != null)
					flag.setActive(false);
				currentActive = null;
			}
			if (activeFlag != null) {
				var flag = find(activeFlag);
				if (flag != null) {
					flag.setActive(true);
					currentActive = activeFlag;
				}
			}
		}
	}

	public function drawFlagNumbers(font:Font, cam:Camera):Void {
		for (flag in lst) {
			Cs.worldToScreen(cam, Cs.entityX(flag.entity), Cs.entityY(flag.entity), Cs.entityZ(flag.entity));
			var label = Std.string(flag.id);
			var width = Cs.textWidth(font, label);
			var height = Cs.textHeight(font, label);
			Cs.drawRect(Cs.int(Cs.pointX()), Cs.int(Cs.pointY()), width, height, Cs.COLOR_BLACK);
			Cs.drawText(font, label, Cs.int(Cs.pointX()), Cs.int(Cs.pointY()), Cs.COLOR_YELLOW);
		}
	}

	public function clear():Void {
		for (flag in lst)
			flag.destroy();
		lst = [];
		currentActive = null;
	}

	public function place(flagId:Int, x:Float, y:Float, z:Float):Void {
		var index = findIndex(flagId);
		if (index == null) {
			lst.push(new Flag(flagId, x, y, z));
			lst.sort((a, b) -> a.id - b.id);
		} else {
			lst[index].position(x, y, z);
		}
	}

	public function remove(flagId:Int):Void {
		var index = findIndex(flagId);
		if (index == null)
			return;
		lst[index].destroy();
		lst.splice(index, 1);
	}

	public function find(flagId:Int):Null<Flag> {
		var index = findIndex(flagId);
		return index != null ? lst[index] : null;
	}

	public function findIndex(flagId:Int):Null<Int> {
		for (i in 0...lst.length) {
			if (lst[i].id == flagId)
				return i;
		}
		return null;
	}

	public function size():Int {
		return lst.length;
	}

	public function at(index:Int):Null<Flag> {
		if (index <= 0 || index > size())
			return null;
		return lst[index - 1];
	}
}
