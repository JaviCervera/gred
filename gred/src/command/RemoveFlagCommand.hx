package command;

import FlagManager;

class RemoveFlagCommand implements ICommand {
	var id:Int;
	var mgr:FlagManager;

	public function new(id:Int, mgr:FlagManager) {
		this.id = id;
		this.mgr = mgr;
	}

	public function execute():Null<ICommand> {
		var flag = mgr.find(id);
		if (flag == null) return null;
		var undoCmd:ICommand = new PlaceFlagCommand(id, flag.x(), flag.y(), flag.z(), mgr);
		mgr.remove(id);
		return undoCmd;
	}

	public static function removeFlag(id:Int, flagMgr:FlagManager):Null<ICommand> {
		return new RemoveFlagCommand(id, flagMgr).execute();
	}
}
