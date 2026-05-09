package grid_mesh;

class StairMeshCreator {
	public static function create(x:Float, y:Float, z:Float, yaw:Float):IMesh {
		final surf = new GridSurface();
		addStepWall(0, 0, 0, surf);
		addStepWall(0, 0.2, 0.25, surf);
		addStepWall(0, 0.4, 0.50, surf);
		addStepWall(0, 0.6, 0.75, surf);
		addStepWall(0, 0.8, 1, surf);
		addStepFloor(0, 0.2, 0, surf);
		addStepFloor(0, 0.4, 0.25, surf);
		addStepFloor(0, 0.6, 0.50, surf);
		addStepFloor(0, 0.8, 0.75, surf);
		final mesh = Cs.createMesh();
		surf.addToMesh(mesh);
		if (yaw != 0)
			Cs.rotateMesh(mesh, 0, yaw, 0);
		Cs.translateMesh(mesh, x, y, z);
		Cs.updateMesh(mesh);
		return mesh;
	}

	private static function addStepWall(x:Float, y:Float, z:Float, surf:GridSurface):Void {
		final sx = x - 0.5;
		final sy = y - 0.5;
		final sz = z - 0.5;
		final a = surf.addVertex(new GridVertex(sx, sy, sz, 0, 0, -1, Cs.COLOR_WHITE, 0, 0.2));
		final b = surf.addVertex(new GridVertex(sx + 1, sy, sz, 0, 0, -1, Cs.COLOR_WHITE, 1, 0.2));
		final c = surf.addVertex(new GridVertex(sx + 1, sy + 0.2, sz, 0, 0, -1, Cs.COLOR_WHITE, 1, 0));
		final d = surf.addVertex(new GridVertex(sx, sy + 0.2, sz, 0, 0, -1, Cs.COLOR_WHITE, 0, 0));
		surf.addIndex(a);
		surf.addIndex(d);
		surf.addIndex(c);
		surf.addIndex(a);
		surf.addIndex(c);
		surf.addIndex(b);
	}

	private static function addStepFloor(x:Float, y:Float, z:Float, surf:GridSurface):Void {
		final sx = x - 0.5;
		final sy = y - 0.5;
		final sz = z - 0.5;
		final a = surf.addVertex(new GridVertex(sx, sy, sz, 0, 1, 0, Cs.COLOR_WHITE, 0, 0.25));
		final b = surf.addVertex(new GridVertex(sx + 1, sy, sz, 0, 1, 0, Cs.COLOR_WHITE, 1, 0.25));
		final c = surf.addVertex(new GridVertex(sx + 1, sy, sz + 0.25, 0, 1, 0, Cs.COLOR_WHITE, 1, 0));
		final d = surf.addVertex(new GridVertex(sx, sy, sz + 0.25, 0, 1, 0, Cs.COLOR_WHITE, 0, 0));
		surf.addIndex(a);
		surf.addIndex(c);
		surf.addIndex(b);
		surf.addIndex(a);
		surf.addIndex(d);
		surf.addIndex(c);
	}
}
