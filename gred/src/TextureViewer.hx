class TextureViewer {
	private final names:Array<String>;
	private final path:String;
	private final prevKey:Int;
	private final nextKey:Int;
	private var selected:Int;
	private var tex:Null<ITexture>;

	public function new(textureNames:Array<String>, selected:Int, path:String, prevKey:Int, nextKey:Int) {
		names = textureNames;
		this.selected = Cs.int(Cs.clamp(selected, 1, names.length));
		this.path = path;
		tex = null;
		this.prevKey = prevKey;
		this.nextKey = nextKey;
		reloadTexture();
	}

	public function update():Void {
		if (Cs.keyHit(prevKey))
			prevTexture();
		if (Cs.keyHit(nextKey))
			nextTexture();
	}

	public function draw(x:Int, y:Int, width:Int, height:Int):Void {
		if (tex != null)
			Cs.drawTextureEx(tex, x, y, width, height, Cs.COLOR_WHITE);
	}

	public function texture():Null<ITexture> {
		return tex;
	}

	public function textureName():String {
		return names[selected - 1];
	}

	private function nextTexture():Void {
		selected++;
		if (selected > names.length)
			selected = 1;
		reloadTexture();
	}

	private function prevTexture():Void {
		selected--;
		if (selected < 1)
			selected = names.length;
		reloadTexture();
	}

	private function reloadTexture():Void {
		tex = Cs.loadTexture(path + names[selected - 1]);
	}
}
