package grid_mesh;

import Grid;

class GridMesh {
	var surfs:Map<String, GridSurface>;
	var grid:Grid;

	public function new(grid:Grid) {
		this.grid = grid;
		surfs = new Map();
		for (x in 1...(grid.tilesX() + 1)) {
			for (y in 1...(grid.tilesY() + 1)) {
				for (z in 1...(grid.tilesZ() + 1)) {
					_addGridMeshTile(x, y, z);
				}
			}
		}
	}

	function _addGridMeshTile(x:Int, y:Int, z:Int):Void {
		if (!grid.hasTile(x, y, z)) return;
		var t = grid.getTileType(x, y, z);
		if (t == Grid.TILE) _addBlock(x, y, z);
		if (t == Grid.STAIRS_FORWARD) _addStairs(x, y, z, 0);
		if (t == Grid.STAIRS_RIGHT) _addStairs(x, y, z, 90);
		if (t == Grid.STAIRS_BACKWARDS) _addStairs(x, y, z, 180);
		if (t == Grid.STAIRS_LEFT) _addStairs(x, y, z, 270);
	}

	function _addBlock(x:Int, y:Int, z:Int, floor:Bool = true, front:Bool = true, right:Bool = true, back:Bool = true, left:Bool = true):Void {
		var surf = _findSurface(grid.floorTextureName(x, y, z));

		// Floor
		if (floor && !grid.hasTile(x, y - 1, z)) {
			var sx = x - 0.5; var sy = y - 0.5; var sz = z - 0.5;
			var a = surf.addVertex(new GridVertex(sx, sy, sz, 0, 1, 0, Cs.COLOR_WHITE, 0, 1));
			var b = surf.addVertex(new GridVertex(sx + 1, sy, sz, 0, 1, 0, Cs.COLOR_WHITE, 1, 1));
			var c = surf.addVertex(new GridVertex(sx + 1, sy, sz + 1, 0, 1, 0, Cs.COLOR_WHITE, 1, 0));
			var d = surf.addVertex(new GridVertex(sx, sy, sz + 1, 0, 1, 0, Cs.COLOR_WHITE, 0, 0));
			surf.addIndex(a); surf.addIndex(c); surf.addIndex(b);
			surf.addIndex(a); surf.addIndex(d); surf.addIndex(c);
		}

		surf = _findSurface(grid.ceilingTextureName(x, y, z));

		// Ceiling
		if (!grid.hasTile(x, y + 1, z)) {
			var sx = x - 0.5; var sy = y + 0.5; var sz = z - 0.5;
			var a = surf.addVertex(new GridVertex(sx, sy, sz, 0, -1, 0, Cs.COLOR_WHITE, 0, 1));
			var b = surf.addVertex(new GridVertex(sx + 1, sy, sz, 0, -1, 0, Cs.COLOR_WHITE, 1, 1));
			var c = surf.addVertex(new GridVertex(sx + 1, sy, sz + 1, 0, -1, 0, Cs.COLOR_WHITE, 1, 0));
			var d = surf.addVertex(new GridVertex(sx, sy, sz + 1, 0, -1, 0, Cs.COLOR_WHITE, 0, 0));
			surf.addIndex(a); surf.addIndex(b); surf.addIndex(c);
			surf.addIndex(a); surf.addIndex(c); surf.addIndex(d);
		}

		surf = _findSurface(grid.wallTextureName(x, y, z));

		// Left wall
		if (left && !grid.hasTile(x - 1, y, z)) {
			var sx = x - 0.5; var sy = y - 0.5; var sz = z - 0.5;
			var a = surf.addVertex(new GridVertex(sx, sy, sz, 1, 0, 0, Cs.COLOR_WHITE, 0, 1));
			var b = surf.addVertex(new GridVertex(sx, sy, sz + 1, 1, 0, 0, Cs.COLOR_WHITE, 1, 1));
			var c = surf.addVertex(new GridVertex(sx, sy + 1, sz + 1, 1, 0, 0, Cs.COLOR_WHITE, 1, 0));
			var d = surf.addVertex(new GridVertex(sx, sy + 1, sz, 1, 0, 0, Cs.COLOR_WHITE, 0, 0));
			surf.addIndex(a); surf.addIndex(c); surf.addIndex(b);
			surf.addIndex(a); surf.addIndex(d); surf.addIndex(c);
		}

		// Right wall
		if (right && !grid.hasTile(x + 1, y, z)) {
			var sx = x + 0.5; var sy = y - 0.5; var sz = z - 0.5;
			var a = surf.addVertex(new GridVertex(sx, sy, sz, -1, 0, 0, Cs.COLOR_WHITE, 0, 1));
			var b = surf.addVertex(new GridVertex(sx, sy, sz + 1, -1, 0, 0, Cs.COLOR_WHITE, 1, 1));
			var c = surf.addVertex(new GridVertex(sx, sy + 1, sz + 1, -1, 0, 0, Cs.COLOR_WHITE, 1, 0));
			var d = surf.addVertex(new GridVertex(sx, sy + 1, sz, -1, 0, 0, Cs.COLOR_WHITE, 0, 0));
			surf.addIndex(b); surf.addIndex(c); surf.addIndex(a);
			surf.addIndex(a); surf.addIndex(c); surf.addIndex(d);
		}

		// Front wall
		if (front && !grid.hasTile(x, y, z + 1)) {
			var sx = x - 0.5; var sy = y - 0.5; var sz = z + 0.5;
			var a = surf.addVertex(new GridVertex(sx, sy, sz, 0, 0, -1, Cs.COLOR_WHITE, 0, 1));
			var b = surf.addVertex(new GridVertex(sx + 1, sy, sz, 0, 0, -1, Cs.COLOR_WHITE, 1, 1));
			var c = surf.addVertex(new GridVertex(sx + 1, sy + 1, sz, 0, 0, -1, Cs.COLOR_WHITE, 1, 0));
			var d = surf.addVertex(new GridVertex(sx, sy + 1, sz, 0, 0, -1, Cs.COLOR_WHITE, 0, 0));
			surf.addIndex(a); surf.addIndex(d); surf.addIndex(c);
			surf.addIndex(a); surf.addIndex(c); surf.addIndex(b);
		}

		// Back wall
		if (back && !grid.hasTile(x, y, z - 1)) {
			var sx = x - 0.5; var sy = y - 0.5; var sz = z - 0.5;
			var a = surf.addVertex(new GridVertex(sx, sy, sz, 0, 0, 1, Cs.COLOR_WHITE, 0, 1));
			var b = surf.addVertex(new GridVertex(sx + 1, sy, sz, 0, 0, 1, Cs.COLOR_WHITE, 1, 1));
			var c = surf.addVertex(new GridVertex(sx + 1, sy + 1, sz, 0, 0, 1, Cs.COLOR_WHITE, 1, 0));
			var d = surf.addVertex(new GridVertex(sx, sy + 1, sz, 0, 0, 1, Cs.COLOR_WHITE, 0, 0));
			surf.addIndex(a); surf.addIndex(b); surf.addIndex(d);
			surf.addIndex(b); surf.addIndex(c); surf.addIndex(d);
		}
	}

	function _addStairs(x:Int, y:Int, z:Int, yaw:Float):Void {
		_addBlock(x, y, z, false, yaw != 0, yaw != 90, yaw != 180, yaw != 270);
		var stairsMesh = CreateStairsMesh.create(x, y, z, yaw);
		var stairsSurf = Cs.meshSurface(stairsMesh, 1);
		var surf = _findSurface(grid.floorTextureName(x, y, z));
		var numVerts = surf.numVertices();
		for (v in 1...(Cs.numVertices(stairsSurf) + 1)) {
			surf.addVertex(new GridVertex(
				Cs.vertexX(stairsSurf, v), Cs.vertexY(stairsSurf, v), Cs.vertexZ(stairsSurf, v),
				Cs.vertexNX(stairsSurf, v), Cs.vertexNY(stairsSurf, v), Cs.vertexNZ(stairsSurf, v),
				Cs.vertexColor(stairsSurf, v),
				Cs.vertexU(stairsSurf, v, 1), Cs.vertexV(stairsSurf, v, 1)));
		}
		for (i in 1...(Cs.numIndices(stairsSurf) + 1)) {
			surf.addIndex(numVerts + Cs.surfaceIndex(stairsSurf, i));
		}
		Cs.freeMesh(stairsMesh);
	}

	function _findSurface(texName:String):GridSurface {
		if (surfs.exists(texName)) return surfs.get(texName);
		surfs.set(texName, new GridSurface(grid.texPath + texName));
		return surfs.get(texName);
	}

	public function createMesh():IMesh {
		var mesh = Cs.createMesh();
		for (s in surfs) {
			s.addToMesh(mesh);
		}
		Cs.updateMesh(mesh);
		return mesh;
	}
}
