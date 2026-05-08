import grid_mesh.GridMesh;

class CreateGridMesh {
	public static function create(grid:Grid):IMesh {
		return new GridMesh(grid).createMesh();
	}
}
