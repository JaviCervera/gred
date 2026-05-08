package command;

import Grid;

class SetTileCommand implements ICommand {
	var grid:Grid;
	var x:Int;
	var y:Int;
	var z:Int;
	var kind:Int;
	var ceilingTexName:String;
	var wallTexName:String;
	var floorTexName:String;

	public function new(grid:Grid, x:Int, y:Int, z:Int, kind:Int, ceilingTexName:String, wallTexName:String, floorTexName:String) {
		this.grid = grid;
		this.x = x;
		this.y = y;
		this.z = z;
		this.kind = kind;
		this.ceilingTexName = ceilingTexName;
		this.wallTexName = wallTexName;
		this.floorTexName = floorTexName;
	}

	public function execute():Null<ICommand> {
		var undoCmd:Null<ICommand> = null;
		if (grid.hasTile(x, y, z)) {
			if (grid.getTileType(x, y, z) != kind
				|| grid.ceilingTextureName(x, y, z) != ceilingTexName
				|| grid.wallTextureName(x, y, z) != wallTexName
				|| grid.floorTextureName(x, y, z) != floorTexName) {
				undoCmd = new SetTileCommand(grid, x, y, z,
					grid.getTileType(x, y, z),
					grid.ceilingTextureName(x, y, z),
					grid.wallTextureName(x, y, z),
					grid.floorTextureName(x, y, z));
			}
		} else {
			undoCmd = new RemoveTileCommand(grid, x, y, z);
		}
		grid.setTile(x, y, z, kind, ceilingTexName, wallTexName, floorTexName);
		return undoCmd;
	}

	public static function setTile(grid:Grid, x:Int, y:Int, z:Int, kind:Int, ceilingTexName:String, wallTexName:String, floorTexName:String):Null<ICommand> {
		return new SetTileCommand(grid, x, y, z, kind, ceilingTexName, wallTexName, floorTexName).execute();
	}
}
