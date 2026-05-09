import command.SetTileCommand;
import command.RemoveTileCommand;
import command.PlaceFlagCommand;
import command.RemoveFlagCommand;

class GridManager {
	private final grid:Grid;
	private final cursor:Cursor;
	private final ceilingTexRetriever:TextureViewer;
	private final wallTexRetriever:TextureViewer;
	private final floorTexRetriever:TextureViewer;
	private final flagMgr:FlagManager;
	private final undoMgr:UndoManager;
	private var editing:Bool;
	private var mode:Int;
	private var currentFlag:Int;
	private var filename:Null<String>;
	private var lights:Null<ISceneNode>;

	public function new(grid:Grid, cursor:Cursor, ceilingTexRetriever:TextureViewer, wallTexRetriever:TextureViewer, floorTexRetriever:TextureViewer,
			flagMgr:FlagManager, undoMgr:UndoManager) {
		this.grid = grid;
		this.cursor = cursor;
		this.ceilingTexRetriever = ceilingTexRetriever;
		this.wallTexRetriever = wallTexRetriever;
		this.floorTexRetriever = floorTexRetriever;
		this.flagMgr = flagMgr;
		this.undoMgr = undoMgr;
		lights = null;
		reset();
	}

	public function reset():Void {
		filename = null;
		editing = true;
		mode = Grid.TILE;
		currentFlag = 1;
		grid.reset(grid.tilesX(), grid.tilesY(), grid.tilesZ());
		cursor.reset();
	}

	public function update():Void {
		if (Cs.keyHit(Cs.KEY_ENTER))
			editing = !editing;
		if (Cs.keyHit(Cs.KEY_F))
			grid.toggleFiltering();
		if (Cs.keyHit(Cs.KEY_L))
			toggleLighting();
		if (Cs.keyHit(Cs.KEY_R))
			grid.toggleWireframe();
		if (Cs.keyHit(Cs.KEY_U))
			currentFlag = Cs.int(Cs.max(1, currentFlag - 1));
		if (Cs.keyHit(Cs.KEY_I))
			currentFlag = Cs.int(Cs.min(100, currentFlag + 1));
		if (Cs.keyHit(Cs.KEY_P))
			placeFlag();
		if (Cs.keyHit(Cs.KEY_O))
			deleteFlag();
		if (editing) {
			if (Cs.keyHit(Cs.KEY_F1))
				reset();
			if (Cs.keyHit(Cs.KEY_F2)) {
				final selected = Dialogs.requestFile("Grid filename", "*.grd", false, filename);
				if (selected != "") {
					GridLoader.load(grid, flagMgr, selected);
					filename = selected;
					undoMgr.reset();
				}
			}
			if (Cs.keyHit(Cs.KEY_F3)) {
				if (filename == null) {
					final selected = Dialogs.requestFile("Grid filename", "*.grd", true, filename);
					if (selected != "")
						filename = selected;
				}
				if (filename != null)
					GridSaver.save(grid, flagMgr, filename);
			}
			if (Cs.keyHit(Cs.KEY_F4)) {
				mode++;
				if (mode > Grid.STAIRS_LEFT)
					mode = Grid.TILE;
			}
			if (Cs.keyDown(Cs.KEY_SPACE)) {
				undoMgr.addUndo(new SetTileCommand(grid, Cs.int(Cs.entityX(cursor.entity)), Cs.int(Cs.entityY(cursor.entity)),
					Cs.int(Cs.entityZ(cursor.entity)), mode, ceilingTexRetriever.textureName(), wallTexRetriever.textureName(),
					floorTexRetriever.textureName()).execute());
			}
			if (Cs.keyDown(Cs.KEY_DELETE)) {
				undoMgr.addUndo(new RemoveTileCommand(grid, Cs.int(Cs.entityX(cursor.entity)), Cs.int(Cs.entityY(cursor.entity)),
					Cs.int(Cs.entityZ(cursor.entity))).execute());
			}
		}
	}

	public function toggleLighting():Void {
		if (!lightingEnabled()) {
			lights = Cs.createEntity();
			Cs.setEntityParent(Cs.createLight(Cs.LIGHT_DIRECTIONAL), lights);
			Cs.setEntityParent(Cs.createLight(Cs.LIGHT_DIRECTIONAL), lights);
			Cs.setEntityParent(Cs.createLight(Cs.LIGHT_DIRECTIONAL), lights);
			Cs.setEntityRotation(Cs.entityChild(lights, 2), 0, 180, 0);
			Cs.setEntityRotation(Cs.entityChild(lights, 3), 90, 0, 0);
			Cs.setAmbient(Cs.COLOR_LIGHTGRAY);
		} else {
			Cs.freeEntity(lights);
			Cs.setAmbient(Cs.COLOR_WHITE);
			lights = null;
		}
	}

	public function lightingEnabled():Bool {
		return lights != null;
	}

	public function placeFlag():Void {
		undoMgr.addUndo(new PlaceFlagCommand(currentFlag, Cs.entityX(cursor.entity), Cs.entityY(cursor.entity), Cs.entityZ(cursor.entity), flagMgr).execute());
	}

	public function deleteFlag():Void {
		undoMgr.addUndo(new RemoveFlagCommand(currentFlag, flagMgr).execute());
	}

	public function getCurrentFlag():Int {
		return currentFlag;
	}

	public function isEditing():Bool {
		return editing;
	}

	public function getModeName():String {
		final names = ["Tile", "Stairs Forward", "Stairs Right", "Stairs Backwards", "Stairs Left"];
		if (mode < 1 || mode > names.length)
			return "";
		return names[mode - 1];
	}
}
