package grid_mesh;

class GridVertex {
	public final x:Float;
	public final y:Float;
	public final z:Float;
	public final nx:Float;
	public final ny:Float;
	public final nz:Float;
	public final color:Int;
	public final u:Float;
	public final v:Float;

	public function new(x:Float, y:Float, z:Float, nx:Float, ny:Float, nz:Float, color:Int, u:Float, v:Float) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.nx = nx;
		this.ny = ny;
		this.nz = nz;
		this.color = color;
		this.u = u;
		this.v = v;
	}
}
