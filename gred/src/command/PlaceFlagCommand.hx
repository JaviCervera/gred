package command;

import FlagManager;

class PlaceFlagCommand implements ICommand {
	var id:Int;
	var x:Float;
	var y:Float;
	var z:Float;
	var mgr:FlagManager;

	public function new(id:Int, x:Float, y:Float, z:Float, mgr:FlagManager) {
		this.id = id;
		this.x = x;
		this.y = y;
		this.z = z;
		this.mgr = mgr;
	}

	public function execute():Null<ICommand> {
		var undoCmd:Null<ICommand> = null;
		if (mgr.findIndex(id) == null) {
			undoCmd = new RemoveFlagCommand(id, mgr);
		} else {
			var flag = mgr.find(id);
			if (flag == null) return null;
			if (flag.x() == x && flag.y() == y && flag.z() == z) return null;
			undoCmd = new PlaceFlagCommand(id, flag.x(), flag.y(), flag.z(), mgr);
		}
		mgr.place(id, x, y, z);
		return undoCmd;
	}

	public static function placeFlag(id:Int, x:Float, y:Float, z:Float, flagMgr:FlagManager):Null<ICommand> {
		return new PlaceFlagCommand(id, x, y, z, flagMgr).execute();
	}
}
