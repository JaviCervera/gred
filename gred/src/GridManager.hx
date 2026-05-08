import command.SetTileCommand;
import command.RemoveTileCommand;
import command.PlaceFlagCommand;
import command.RemoveFlagCommand;

class GridManager {
	public var grid:Grid;
	public var cursor:Cursor;
	public var ceilingTexRetriever:TextureViewer;
	public var wallTexRetriever:TextureViewer;
	public var floorTexRetriever:TextureViewer;
	public var flagMgr:FlagManager;
	public var undoMgr:UndoManager;
	public var editing:Bool;
	public var mode:Int;
	public var currentFlag:Int;
	public var filename:Null<String>;
	var lights:Null<ISceneNode>;

	public function new(grid:Grid, cursor:Cursor, ceilingTexRetriever:TextureViewer, wallTexRetriever:TextureViewer, floorTexRetriever:TextureViewer, flagMgr:FlagManager, undoMgr:UndoManager) {
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
		if (Cs.keyHit(Cs.KEY_ENTER)) editing = !editing;
		if (Cs.keyHit(Cs.KEY_F)) grid.toggleFiltering();
		if (Cs.keyHit(Cs.KEY_L)) toggleLighting();
		if (Cs.keyHit(Cs.KEY_R)) grid.toggleWireframe();
		if (Cs.keyHit(Cs.KEY_U)) currentFlag = Cs.int(Cs.max(1, currentFlag - 1));
		if (Cs.keyHit(Cs.KEY_I)) currentFlag = Cs.int(Cs.min(100, currentFlag + 1));
		if (Cs.keyHit(Cs.KEY_P)) placeFlag();
		if (Cs.keyHit(Cs.KEY_O)) deleteFlag();
		if (editing) {
			if (Cs.keyHit(Cs.KEY_F1)) reset();
			if (Cs.keyHit(Cs.KEY_F2)) {
				var selected = Dialogs.requestFile("Grid filename", "*.grd", false, filename);
				if (selected != "") {
					LoadGrid.load(grid, flagMgr, selected);
					filename = selected;
					undoMgr.reset();
				}
			}
			if (Cs.keyHit(Cs.KEY_F3)) {
				if (filename == null) {
					var selected = Dialogs.requestFile("Grid filename", "*.grd", true, filename);
					if (selected != "") filename = selected;
				}
				if (filename != null) SaveGrid.save(grid, flagMgr, filename);
			}
			if (Cs.keyHit(Cs.KEY_F4)) {
				mode++;
				if (mode > Grid.STAIRS_LEFT) mode = Grid.TILE;
			}
			if (Cs.keyDown(Cs.KEY_SPACE)) {
				undoMgr.addUndo(SetTileCommand.setTile(
					grid,
					Cs.int(Cs.entityX(cursor.entity)),
					Cs.int(Cs.entityY(cursor.entity)),
					Cs.int(Cs.entityZ(cursor.entity)),
					mode,
					ceilingTexRetriever.textureName(),
					wallTexRetriever.textureName(),
					floorTexRetriever.textureName()));
			}
			if (Cs.keyDown(Cs.KEY_DELETE)) {
				undoMgr.addUndo(RemoveTileCommand.removeTile(
					grid,
					Cs.int(Cs.entityX(cursor.entity)),
					Cs.int(Cs.entityY(cursor.entity)),
					Cs.int(Cs.entityZ(cursor.entity))));
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
		undoMgr.addUndo(PlaceFlagCommand.placeFlag(
			currentFlag,
			Cs.entityX(cursor.entity),
			Cs.entityY(cursor.entity),
			Cs.entityZ(cursor.entity),
			flagMgr));
	}

	public function deleteFlag():Void {
		undoMgr.addUndo(RemoveFlagCommand.removeFlag(currentFlag, flagMgr));
	}
}
