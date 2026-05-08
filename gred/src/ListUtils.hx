class ListUtils {
	public static function indexOf<T>(lst:Array<T>, val:T):Null<Int> {
		for (i in 0...lst.length) {
			if (lst[i] == val) return i + 1;
		}
		return null;
	}
}
