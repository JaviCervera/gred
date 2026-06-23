class Main {
	static function main():Void {
		final TEX_PATH = "../textures/";

		Dialogs.init();

		Cs.openScreen(1024, 768, Cs.desktopDepth(), Cs.SCREEN_RESIZABLE | Cs.SCREEN_VSYNC);

		final textureNames = TextureReader.read(TEX_PATH);
		final ceilingTexViewer = new TextureViewer(textureNames, 1, TEX_PATH, Cs.KEY_W, Cs.KEY_E);
		final wallTexViewer = new TextureViewer(textureNames, 2, TEX_PATH, Cs.KEY_S, Cs.KEY_D);
		final floorTexViewer = new TextureViewer(textureNames, 3, TEX_PATH, Cs.KEY_X, Cs.KEY_C);

		final grid = new Grid(64, 16, 64, TEX_PATH);
		final cursor = new Cursor(grid);
		final flagMgr = new FlagManager();
		final undoMgr = new UndoManager();
		final gridMgr = new GridManager(grid, cursor, ceilingTexViewer, wallTexViewer, floorTexViewer, flagMgr, undoMgr);
		final cam = new Cam(cursor);

		while (!Cs.screenShouldClose()) {
			undoMgr.update();
			cursor.update(gridMgr.isEditing());
			cam.update(gridMgr.isEditing());
			gridMgr.update();
			if (gridMgr.isEditing()) {
				ceilingTexViewer.update();
				wallTexViewer.update();
				floorTexViewer.update();
			}
			flagMgr.update(gridMgr.getCurrentFlag());

			Cs.drawWorld();
			flagMgr.drawFlagNumbers(null, cam.entity);
			if (gridMgr.isEditing()) {
				ceilingTexViewer.draw(Cs.screenWidth() - 144, 16, 128, 128);
				wallTexViewer.draw(Cs.screenWidth() - 144, 160, 128, 128);
				floorTexViewer.draw(Cs.screenWidth() - 144, 304, 128, 128);
				Cs.drawText(null, "[F1] New -- [F2] Load -- [F3] Save -- [F4] Mode: " + gridMgr.getModeName() + " -- [F5] Export OBJ -- [ENTER] Preview", 8, 8, Cs.COLOR_WHITE);
				Cs.drawText(null,
					"[F] "
					+ enableDisableText(grid.filteringEnabled())
					+ " texture filtering -- "
					+ "[L] "
					+ enableDisableText(gridMgr.lightingEnabled())
					+ " lighting -- "
					+ "[R] "
					+ enableDisableText(grid.wireframeEnabled())
					+ " wireframe",
					8, 24, Cs.COLOR_WHITE);
			Cs.drawText(null, "[U/I] Select flag number (current: "
				+ gridMgr.getCurrentFlag()
				+ ") -- "
				+ "[P] Place flag -- "
				+ "[O] Delete flag", 8,
				40, Cs.COLOR_WHITE);
				Cs.drawText(null, "[J/K] Select tile height (current: "
					+ cursor.tileHeight()
					+ ")", 8, 56, Cs.COLOR_WHITE);
				Cs.drawText(null,
					"Cursor Position "
					+ Cs.int(Cs.entityX(cursor.entity))
					+ "x"
					+ Cs.int(Cs.entityY(cursor.entity))
					+ "x"
					+ Cs.int(Cs.entityZ(cursor.entity)),
					8, Cs.screenHeight()
					- 24, Cs.COLOR_WHITE);
			}
			Cs.refreshScreen();
		}
	}

	static function enableDisableText(state:Bool):String {
		return state ? "Disable" : "Enable";
	}
}
