class Cursor {
	public final entity:IMeshSceneNode;

	private final grid:Grid;
	private var alpha:Float;
	private var alphaDir:Float;

	public function new(grid:Grid) {
		this.grid = grid;
		alpha = 0.5;
		alphaDir = 1;
		var mesh = Cs.createCubeMesh();
		entity = Cs.createModel(mesh);
		Cs.freeMesh(mesh);
		var mat = Cs.entityMaterial(entity, 1);
		Cs.setMaterialType(mat, Cs.MATERIAL_ALPHA);
		Cs.setMaterialFlag(mat, Cs.FLAG_LIGHTING, false);
		Cs.setMaterialFlag(mat, Cs.FLAG_VERTEXCOLORS, true);
		reset();
	}

	public function reset():Void {
		Cs.setEntityPosition(entity, grid.tilesX() / 2, grid.tilesY() / 2, grid.tilesZ() / 2);
	}

	public function update(editing:Bool):Void {
		if (editing && !Cs.entityVisible(entity))
			Cs.setEntityVisible(entity, true);
		if (!editing && Cs.entityVisible(entity))
			Cs.setEntityVisible(entity, false);
		if (editing) {
			alpha += alphaDir * 0.5 * Cs.deltaTime();
			if (alpha <= 0.25 || alpha >= 0.75) {
				alpha = Cs.clamp(alpha, 0.25, 0.75);
				alphaDir = alphaDir * -1;
			}
			Cs.setMeshColor(Cs.modelMesh(entity), Cs.fadeColor(Cs.COLOR_ORANGE, Cs.int(alpha * 255)));
			Cs.updateMesh(Cs.modelMesh(entity));

			if (Cs.keyHit(Cs.KEY_UP))
				Cs.translateEntity(entity, 0, 0, 1);
			if (Cs.keyHit(Cs.KEY_DOWN))
				Cs.translateEntity(entity, 0, 0, -1);
			if (Cs.keyHit(Cs.KEY_LEFT))
				Cs.translateEntity(entity, -1, 0, 0);
			if (Cs.keyHit(Cs.KEY_RIGHT))
				Cs.translateEntity(entity, 1, 0, 0);
			if (Cs.keyHit(Cs.KEY_Q))
				Cs.translateEntity(entity, 0, 1, 0);
			if (Cs.keyHit(Cs.KEY_A))
				Cs.translateEntity(entity, 0, -1, 0);
			Cs.setEntityPosition(entity, Cs.clamp(Cs.entityX(entity), 1, grid.tilesX()), Cs.clamp(Cs.entityY(entity), 1, grid.tilesY()),
				Cs.clamp(Cs.entityZ(entity), 1, grid.tilesZ()));
		}
	}
}
