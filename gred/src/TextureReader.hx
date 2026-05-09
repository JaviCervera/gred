class TextureReader {
	public static function read(path:String):Array<String> {
		final textures:Array<String> = [];
		final contents = Cs.dirContents(path);
		for (i in 1...(Cs.splitCount(contents, "\n") + 1)) {
			final tex = Cs.splitIndex(contents, "\n", i);
			final ext = Cs.lower(Cs.extractExt(tex));
			if (Cs.left(tex, 1) != "." && (ext == "jpg" || ext == "png")) {
				textures.push(tex);
			}
		}
		return textures;
	}
}
