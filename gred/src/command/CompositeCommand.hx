package command;

class CompositeCommand implements ICommand {
	private final commands:Array<ICommand>;

	public function new() {
		commands = [];
	}

	public function addCommand(command:Null<ICommand>):Void {
		if (command != null)
			commands.push(command);
	}

	public function execute():Null<ICommand> {
		final undoCmd = new CompositeCommand();
		for (cmd in commands)
			undoCmd.addCommand(cmd.execute());
		return (undoCmd.commands.length == 0) ? null : undoCmd;
	}
}
