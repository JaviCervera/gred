package grid_mesh;

class GridSurface {
	public final texName:String;
	public final verts:Array<GridVertex>;
	public final idxs:Array<Int>;

	public function new(texName:String = "") {
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
		final vertices = verticesMemblock();
		final indices = indicesMemblock();
		final surf = Cs.addSurface(mesh, vertices, numVertices(), indices, numIndices(), Cs.SURFACE_STANDARD);
		final mat = Cs.surfaceMaterial(surf);
		if (texName != "")
			Cs.setMaterialTexture(mat, 1, Cs.loadTexture(texName));
		Cs.freeMemblock(vertices);
		Cs.freeMemblock(indices);
		return surf;
	}

	private function verticesMemblock():Memblock {
		final vertexSize = 36;
		final memblock = Cs.createMemblock(vertexSize * numVertices());
		for (i in 0...verts.length) {
			final v = verts[i];
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

	private function indicesMemblock():Memblock {
		final indexSize = 2;
		final memblock = Cs.createMemblock(indexSize * numIndices());
		for (i in 0...idxs.length) {
			Cs.pokeShort(memblock, i * indexSize, idxs[i]);
		}
		return memblock;
	}
}
