class ReadTextures {
	public static function read(path:String):Array<String> {
		var textures:Array<String> = [];
		var contents = Cs.dirContents(path);
		for (i in 1...(Cs.splitCount(contents, "\n") + 1)) {
			var tex = Cs.splitIndex(contents, "\n", i);
			var ext = Cs.lower(Cs.extractExt(tex));
			if (Cs.left(tex, 1) != "." && (ext == "jpg" || ext == "png")) {
				textures.push(tex);
			}
		}
		return textures;
	}
}
