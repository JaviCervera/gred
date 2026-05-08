package grid_mesh;

class GridSurface {
	public var texName:Null<String>;
	public var verts:Array<GridVertex>;
	public var idxs:Array<Int>;

	public function new(?texName:String) {
		this.texName = texName;
		verts = [];
		idxs = [];
	}

	public function addVertex(vertex:GridVertex):Int {
		verts.push(vertex);
		return verts.length - 1;
	}

	public function numVertices():Int {
		return verts.length;
	}

	public function vertex(i:Int):GridVertex {
		return verts[i];
	}

	public function addIndex(idx:Int):Void {
		idxs.push(idx);
	}

	public function numIndices():Int {
		return idxs.length;
	}

	public function index(i:Int):Int {
		return idxs[i];
	}

	public function addToMesh(mesh:IMesh):IMeshBuffer {
		var vertices = _verticesMemblock();
		var indices = _indicesMemblock();
		var surf = Cs.addSurface(mesh, vertices, numVertices(), indices, numIndices(), Cs.SURFACE_STANDARD);
		var mat = Cs.surfaceMaterial(surf);
		if (texName != null) Cs.setMaterialTexture(mat, 1, Cs.loadTexture(texName));
		Cs.freeMemblock(vertices);
		Cs.freeMemblock(indices);
		return surf;
	}

	function _verticesMemblock():Memblock {
		var vertexSize = 36;
		var memblock = Cs.createMemblock(vertexSize * numVertices());
		for (i in 0...verts.length) {
			var v = verts[i];
			Cs.pokeFloat(memblock, i * vertexSize, v.x);
			Cs.pokeFloat(memblock, i * vertexSize + 4, v.y);
			Cs.pokeFloat(memblock, i * vertexSize + 8, v.z);
			Cs.pokeFloat(memblock, i * vertexSize + 12, v.nx);
			Cs.pokeFloat(memblock, i * vertexSize + 16, v.ny);
			Cs.pokeFloat(memblock, i * vertexSize + 20, v.nz);
			Cs.pokeInt(memblock, i * vertexSize + 24, v.color);
			Cs.pokeFloat(memblock, i * vertexSize + 28, v.u);
			Cs.pokeFloat(memblock, i * vertexSize + 32, v.v);
		}
		return memblock;
	}

	function _indicesMemblock():Memblock {
		var indexSize = 2;
		var memblock = Cs.createMemblock(indexSize * numIndices());
		for (i in 0...idxs.length) {
			Cs.pokeShort(memblock, i * indexSize, idxs[i]);
		}
		return memblock;
	}
}
