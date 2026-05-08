class Flag {
	static var _activeTexture:Null<ITexture> = null;
	static var _inactiveTexture:Null<ITexture> = null;

	public var id:Int;
	public var entity:IBillboardSceneNode;
	public var active:Bool;

	public function new(id:Int, x:Float, y:Float, z:Float) {
		this.id = id;
		entity = Cs.createSprite(null, Cs.MATERIAL_ALPHA);
		active = false;
		position(x, y, z);
		setActive(true);
	}

	public function destroy():Void {
		Cs.freeEntity(entity);
	}

	public function position(x:Float, y:Float, z:Float):Void {
		Cs.setEntityPosition(entity, x, y, z);
	}

	public function x():Float {
		return Cs.entityX(entity);
	}

	public function y():Float {
		return Cs.entityY(entity);
	}

	public function z():Float {
		return Cs.entityZ(entity);
	}

	public function setActive(active:Bool):Void {
		if (_activeTexture == null) _activeTexture = Cs.loadTexture("icons/flag_red.png");
		if (_inactiveTexture == null) _inactiveTexture = Cs.loadTexture("icons/flag_orange.png");
		if (active != this.active) {
			this.active = active;
			if (active) {
				Cs.setMaterialTexture(Cs.entityMaterial(entity, 1), 1, _activeTexture);
			} else {
				Cs.setMaterialTexture(Cs.entityMaterial(entity, 1), 1, _inactiveTexture);
			}
		}
	}
}
