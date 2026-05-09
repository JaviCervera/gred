package command;

import FlagManager;

class PlaceFlagCommand implements ICommand {
	final id:Int;
	final x:Float;
	final y:Float;
	final z:Float;
	final mgr:FlagManager;

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
			final flag = mgr.find(id);
			if (flag == null)
				return null;
			if (flag.x() == x && flag.y() == y && flag.z() == z)
				return null;
			undoCmd = new PlaceFlagCommand(id, flag.x(), flag.y(), flag.z(), mgr);
		}
		mgr.place(id, x, y, z);
		return undoCmd;
	}
}
