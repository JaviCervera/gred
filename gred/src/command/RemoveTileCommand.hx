package command;

import Grid;

class RemoveTileCommand implements ICommand {
	final grid:Grid;
	final x:Int;
	final y:Int;
	final z:Int;

	public function new(grid:Grid, x:Int, y:Int, z:Int) {
		this.grid = grid;
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public function execute():Null<ICommand> {
		if (grid.hasTile(x, y, z)) {
			final undoCmd:ICommand = new SetTileCommand(grid, x, y, z, grid.getTileType(x, y, z), grid.ceilingTextureName(x, y, z),
				grid.wallTextureName(x, y, z), grid.floorTextureName(x, y, z));
			grid.removeTile(x, y, z);
			return undoCmd;
		}
		return null;
	}
}
