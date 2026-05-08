import command.ICommand;

class UndoManager {
	var _undo:Array<ICommand>;
	var _redo:Array<ICommand>;

	public function new() {
		_undo = [];
		_redo = [];
	}

	public function addUndo(command:Null<ICommand>):Void {
		if (command != null) {
			_undo.push(command);
			_redo = [];
		}
	}

	public function canUndo():Bool {
		return _undo.length > 0;
	}

	public function canRedo():Bool {
		return _redo.length > 0;
	}

	public function undo():Void {
		if (canUndo()) {
			var result = _undo[_undo.length - 1].execute();
			_undo.pop();
			if (result != null) _redo.push(result);
		}
	}

	public function redo():Void {
		if (canRedo()) {
			var result = _redo[_redo.length - 1].execute();
			_redo.pop();
			if (result != null) _undo.push(result);
		}
	}

	public function update():Void {
		if (Cs.keyDown(Cs.KEY_LCONTROL) || Cs.keyDown(Cs.KEY_RCONTROL)) {
			if (Cs.keyHit(Cs.KEY_Z)) undo();
			if (Cs.keyHit(Cs.KEY_Y)) redo();
		}
	}

	public function reset():Void {
		_undo = [];
		_redo = [];
	}
}
