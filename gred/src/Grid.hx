typedef TileData = {kind:Int, ceiling:String, wall:String, floor:String}

class Grid {
	public static inline final EMPTY = 0;
	public static inline final TILE = 1;
	public static inline final STAIRS_FORWARD = 2;
	public static inline final STAIRS_RIGHT = 3;
	public static inline final STAIRS_BACKWARDS = 4;
	public static inline final STAIRS_LEFT = 5;

	private final texPath:String;
	private var tiles:Array<Array<Array<Null<TileData>>>>;
	private var model:Null<IMeshSceneNode>;
	private var filtering:Bool;
	private var wireframe:Bool;

	public function new(tilesX:Int, tilesY:Int, tilesZ:Int, texPath:String) {
		this.texPath = texPath;
		tiles = [];
		model = null;
		filtering = true;
		wireframe = false;
		reset(tilesX, tilesY, tilesZ);
	}

	public function getTexturePath():String {
		return texPath;
	}

	public function reset(tilesX:Int, tilesY:Int, tilesZ:Int):Void {
		if (model != null) {
			Cs.freeEntity(model);
			model = null;
		}
		tiles = [];
		for (x in 0...tilesX) {
			tiles.push([]);
			for (y in 0...tilesY) {
				tiles[x].push([]);
				for (z in 0...tilesZ) {
					tiles[x][y].push(null);
				}
			}
		}
	}

	public function tilesX():Int {
		return tiles.length;
	}

	public function tilesY():Int {
		if (tilesX() == 0)
			return 0;
		return tiles[0].length;
	}

	public function tilesZ():Int {
		if (tilesY() == 0)
			return 0;
		return tiles[0][0].length;
	}

	public function hasTile(x:Int, y:Int, z:Int):Bool {
		if (x < 1 || x > tilesX())
			return false;
		if (y < 1 || y > tilesY())
			return false;
		if (z < 1 || z > tilesZ())
			return false;
		return tiles[x - 1][y - 1][z - 1] != null;
	}

	public function setTile(x:Int, y:Int, z:Int, kind:Int, ceilingTexName:String, wallTexName:String, floorTexName:String, updateModel:Bool = true):Void {
		if (getTileType(x, y, z) != kind
			|| ceilingTextureName(x, y, z) != ceilingTexName
			|| wallTextureName(x, y, z) != wallTexName
			|| floorTextureName(x, y, z) != floorTexName) {
			tiles[x - 1][y - 1][z - 1] = {
				kind: kind,
				ceiling: ceilingTexName,
				wall: wallTexName,
				floor: floorTexName
			};
			if (updateModel)
				_updateModel();
		}
	}

	public function removeTile(x:Int, y:Int, z:Int, updateModel:Bool = true):Void {
		if (hasTile(x, y, z)) {
			tiles[x - 1][y - 1][z - 1] = null;
			if (updateModel)
				_updateModel();
		}
	}

	public function getTileType(x:Int, y:Int, z:Int):Int {
		if (!hasTile(x, y, z))
			return EMPTY;
		return tiles[x - 1][y - 1][z - 1].kind;
	}

	public function ceilingTextureName(x:Int, y:Int, z:Int):String {
		if (!hasTile(x, y, z))
			return "";
		return tiles[x - 1][y - 1][z - 1].ceiling;
	}

	public function wallTextureName(x:Int, y:Int, z:Int):String {
		if (!hasTile(x, y, z))
			return "";
		return tiles[x - 1][y - 1][z - 1].wall;
	}

	public function floorTextureName(x:Int, y:Int, z:Int):String {
		if (!hasTile(x, y, z))
			return "";
		return tiles[x - 1][y - 1][z - 1].floor;
	}

	public function _updateModel():Void {
		if (model != null)
			Cs.freeEntity(model);
		final mesh = grid_mesh.GridMeshCreator.create(this);
		model = Cs.createModel(mesh);
		_applyFiltering();
		_applyWireframe();
		Cs.freeMesh(mesh);
	}

	public function toggleFiltering():Void {
		filtering = !filtering;
		_applyFiltering();
	}

	public function filteringEnabled():Bool {
		return filtering;
	}

	public function _applyFiltering():Void {
		if (model == null)
			return;
		final mode = filtering ? Cs.FILTER_ANISOTROPIC : Cs.FILTER_DISABLED;
		for (i in 1...(Cs.entityNumMaterials(model) + 1)) {
			Cs.setMaterialFilterMode(Cs.entityMaterial(model, i), mode);
		}
	}

	public function toggleWireframe():Void {
		if (model != null) {
			wireframe = !wireframe;
			_applyWireframe();
		}
	}

	public function wireframeEnabled():Bool {
		return wireframe;
	}

	public function _applyWireframe():Void {
		if (model == null)
			return;
		final mode = wireframe ? Cs.RENDER_WIREFRAME : Cs.RENDER_FILLED;
		for (i in 1...(Cs.entityNumMaterials(model) + 1)) {
			Cs.setMaterialRenderMode(Cs.entityMaterial(model, i), mode);
		}
	}
}
