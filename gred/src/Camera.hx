class Camera {
	private static inline final MOVE_SPEED = 2.0;
	private static inline final TURN_SPEED = 90.0;

	public final entity:ICameraSceneNode;

	private final cursor:Cursor;
	private var distance:Float;
	private var wasEditing:Bool;

	public function new(cursor:Cursor) {
		entity = Cs.createCamera();
		this.cursor = cursor;
		distance = 6;
		wasEditing = true;
		Cs.setCameraRange(entity, 0.1, 100);
	}

	public function update(editing:Bool):Void {
		if (editing) {
			Cs.setEntityPosition(entity, Cs.entityX(cursor.entity), Cs.entityY(cursor.entity), Cs.entityZ(cursor.entity));
			Cs.moveEntity(entity, 0, 0, -Cs.max(2, (distance - Cs.cursorZ())));
			Cs.setEntityRotation(entity, 89.9, 0, 0);
			wasEditing = true;
		} else {
			if (wasEditing) {
				Cs.setEntityPosition(entity, Cs.entityX(cursor.entity), Cs.entityY(cursor.entity), Cs.entityZ(cursor.entity));
				Cs.setEntityRotation(entity, 0, 0, 0);
			}
			if (Cs.keyDown(Cs.KEY_UP))
				Cs.moveEntity(entity, 0, 0, MOVE_SPEED * Cs.deltaTime());
			if (Cs.keyDown(Cs.KEY_DOWN))
				Cs.moveEntity(entity, 0, 0, -MOVE_SPEED * Cs.deltaTime());
			if (Cs.keyDown(Cs.KEY_LEFT))
				Cs.turnEntity(entity, 0, -TURN_SPEED * Cs.deltaTime(), 0);
			if (Cs.keyDown(Cs.KEY_RIGHT))
				Cs.turnEntity(entity, 0, TURN_SPEED * Cs.deltaTime(), 0);
			if (Cs.keyDown(Cs.KEY_Q))
				Cs.translateEntity(entity, 0, MOVE_SPEED * Cs.deltaTime(), 0);
			if (Cs.keyDown(Cs.KEY_A))
				Cs.translateEntity(entity, 0, -MOVE_SPEED * Cs.deltaTime(), 0);
			wasEditing = false;
		}
	}
}
