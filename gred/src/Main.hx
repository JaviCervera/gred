class Main {
	static function main():Void {
		untyped __lua__('load("dialogs")');

		final TEX_PATH = "../textures/";

		Cs.openScreen(1024, 768, Cs.desktopDepth(), Cs.SCREEN_RESIZABLE + Cs.SCREEN_VSYNC);

		var font = Cs.loadFont("FSEX300.ttf", 16);

		var textureNames = ReadTextures.read(TEX_PATH);
		var ceilingTexViewer = new TextureViewer(textureNames, 1, TEX_PATH, Cs.KEY_W, Cs.KEY_E);
		var wallTexViewer = new TextureViewer(textureNames, 2, TEX_PATH, Cs.KEY_S, Cs.KEY_D);
		var floorTexViewer = new TextureViewer(textureNames, 3, TEX_PATH, Cs.KEY_X, Cs.KEY_C);

		var grid = new Grid(64, 16, 64, TEX_PATH);
		var cursor = new Cursor(grid);
		var flagMgr = new FlagManager();
		var undoMgr = new UndoManager();
		var gridMgr = new GridManager(grid, cursor, ceilingTexViewer, wallTexViewer, floorTexViewer, flagMgr, undoMgr);
		var cam = new Camera(cursor);

		while (!Cs.screenShouldClose()) {
			undoMgr.update();
			cursor.update(gridMgr.editing);
			cam.update(gridMgr.editing);
			gridMgr.update();
			if (gridMgr.editing) {
				ceilingTexViewer.update();
				wallTexViewer.update();
				floorTexViewer.update();
			}
			flagMgr.update(gridMgr.currentFlag);

			Cs.drawWorld();
			flagMgr.drawFlagNumbers(font, cam.entity);
			if (gridMgr.editing) {
				ceilingTexViewer.draw(Cs.screenWidth() - 144, 16, 128, 128);
				wallTexViewer.draw(Cs.screenWidth() - 144, 160, 128, 128);
				floorTexViewer.draw(Cs.screenWidth() - 144, 304, 128, 128);
				Cs.drawText(font,
					"[F1] New -- [F2] Load -- [F3] Save -- [F4] Mode: " + editModeName(gridMgr.mode) + " -- [ENTER] Preview",
					8, 8, Cs.COLOR_WHITE);
				Cs.drawText(font,
					"[F] " + enableDisableText(grid.filteringEnabled()) + " texture filtering -- " +
					"[L] " + enableDisableText(gridMgr.lightingEnabled()) + " lighting -- " +
					"[R] " + enableDisableText(grid.wireframeEnabled()) + " wireframe",
					8, 24, Cs.COLOR_WHITE);
				Cs.drawText(font,
					"[U/I] Select flag number (current: " + gridMgr.currentFlag + ") -- " +
					"[P] Place flag -- " +
					"[O] Delete flag",
					8, 40, Cs.COLOR_WHITE);
				Cs.drawText(font,
					"Cursor Position " + Cs.int(Cs.entityX(cursor.entity)) + "x" + Cs.int(Cs.entityY(cursor.entity)) + "x" + Cs.int(Cs.entityZ(cursor.entity)),
					8, Cs.screenHeight() - 24, Cs.COLOR_WHITE);
			}
			Cs.refreshScreen();
		}
	}

	static function editModeName(modeId:Int):String {
		var names = ["Tile", "Stairs Forward", "Stairs Right", "Stairs Backwards", "Stairs Left"];
		if (modeId < 1 || modeId > names.length) return "";
		return names[modeId - 1];
	}

	static function enableDisableText(state:Bool):String {
		return state ? "Disable" : "Enable";
	}
}
