package command;

import Grid;

class RemoveTileCommand implements ICommand {
	var grid:Grid;
	var x:Int;
	var y:Int;
	var z:Int;

	public function new(grid:Grid, x:Int, y:Int, z:Int) {
		this.grid = grid;
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public function execute():Null<ICommand> {
		if (grid.hasTile(x, y, z)) {
			var undoCmd:ICommand = new SetTileCommand(grid, x, y, z,
				grid.getTileType(x, y, z),
				grid.ceilingTextureName(x, y, z),
				grid.wallTextureName(x, y, z),
				grid.floorTextureName(x, y, z));
			grid.removeTile(x, y, z);
			return undoCmd;
		}
		return null;
	}

	public static function removeTile(grid:Grid, x:Int, y:Int, z:Int):Null<ICommand> {
		return new RemoveTileCommand(grid, x, y, z).execute();
	}
}
