package grid_mesh;

class CreateStairsMesh {
	public static function create(x:Float, y:Float, z:Float, yaw:Float):IMesh {
		var surf = new GridSurface();
		_addStepWall(0, 0, 0, surf);
		_addStepWall(0, 0.2, 0.25, surf);
		_addStepWall(0, 0.4, 0.50, surf);
		_addStepWall(0, 0.6, 0.75, surf);
		_addStepWall(0, 0.8, 1, surf);
		_addStepFloor(0, 0.2, 0, surf);
		_addStepFloor(0, 0.4, 0.25, surf);
		_addStepFloor(0, 0.6, 0.50, surf);
		_addStepFloor(0, 0.8, 0.75, surf);
		var mesh = Cs.createMesh();
		surf.addToMesh(mesh);
		if (yaw != 0) Cs.rotateMesh(mesh, 0, yaw, 0);
		Cs.translateMesh(mesh, x, y, z);
		Cs.updateMesh(mesh);
		return mesh;
	}

	static function _addStepWall(x:Float, y:Float, z:Float, surf:GridSurface):Void {
		var sx = x - 0.5;
		var sy = y - 0.5;
		var sz = z - 0.5;
		var a = surf.addVertex(new GridVertex(sx, sy, sz, 0, 0, -1, Cs.COLOR_WHITE, 0, 0.2));
		var b = surf.addVertex(new GridVertex(sx + 1, sy, sz, 0, 0, -1, Cs.COLOR_WHITE, 1, 0.2));
		var c = surf.addVertex(new GridVertex(sx + 1, sy + 0.2, sz, 0, 0, -1, Cs.COLOR_WHITE, 1, 0));
		var d = surf.addVertex(new GridVertex(sx, sy + 0.2, sz, 0, 0, -1, Cs.COLOR_WHITE, 0, 0));
		surf.addIndex(a); surf.addIndex(d); surf.addIndex(c);
		surf.addIndex(a); surf.addIndex(c); surf.addIndex(b);
	}

	static function _addStepFloor(x:Float, y:Float, z:Float, surf:GridSurface):Void {
		var sx = x - 0.5;
		var sy = y - 0.5;
		var sz = z - 0.5;
		var a = surf.addVertex(new GridVertex(sx, sy, sz, 0, 1, 0, Cs.COLOR_WHITE, 0, 0.25));
		var b = surf.addVertex(new GridVertex(sx + 1, sy, sz, 0, 1, 0, Cs.COLOR_WHITE, 1, 0.25));
		var c = surf.addVertex(new GridVertex(sx + 1, sy, sz + 0.25, 0, 1, 0, Cs.COLOR_WHITE, 1, 0));
		var d = surf.addVertex(new GridVertex(sx, sy, sz + 0.25, 0, 1, 0, Cs.COLOR_WHITE, 0, 0));
		surf.addIndex(a); surf.addIndex(c); surf.addIndex(b);
		surf.addIndex(a); surf.addIndex(d); surf.addIndex(c);
	}
}
