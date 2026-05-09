package command;

import FlagManager;

class RemoveFlagCommand implements ICommand {
	final id:Int;
	final mgr:FlagManager;

	public function new(id:Int, mgr:FlagManager) {
		this.id = id;
		this.mgr = mgr;
	}

	public function execute():Null<ICommand> {
		final flag = mgr.find(id);
		if (flag == null)
			return null;
		final undoCmd = new PlaceFlagCommand(id, flag.x(), flag.y(), flag.z(), mgr);
		mgr.remove(id);
		return undoCmd;
	}
}
