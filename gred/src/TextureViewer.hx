class TextureViewer {
	public var names:Array<String>;
	public var selected:Int;
	public var path:String;
	public var tex:Null<ITexture>;
	var prevKey:Int;
	var nextKey:Int;

	public function new(textureNames:Array<String>, selected:Int, path:String, prevKey:Int, nextKey:Int) {
		names = textureNames;
		this.selected = Cs.int(Cs.clamp(selected, 1, names.length));
		this.path = path;
		tex = null;
		this.prevKey = prevKey;
		this.nextKey = nextKey;
		_reloadTexture();
	}

	public function update():Void {
		if (Cs.keyHit(prevKey)) _prevTexture();
		if (Cs.keyHit(nextKey)) _nextTexture();
	}

	public function draw(x:Int, y:Int, width:Int, height:Int):Void {
		if (tex != null) Cs.drawTextureEx(tex, x, y, width, height, Cs.COLOR_WHITE);
	}

	public function texture():Null<ITexture> {
		return tex;
	}

	public function textureName():String {
		return names[selected - 1];
	}

	function _nextTexture():Void {
		selected++;
		if (selected > names.length) selected = 1;
		_reloadTexture();
	}

	function _prevTexture():Void {
		selected--;
		if (selected < 1) selected = names.length;
		_reloadTexture();
	}

	function _reloadTexture():Void {
		tex = Cs.loadTexture(path + names[selected - 1]);
	}
}
