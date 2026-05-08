package grid_mesh;

class GridVertex {
	public var x:Float;
	public var y:Float;
	public var z:Float;
	public var nx:Float;
	public var ny:Float;
	public var nz:Float;
	public var color:Int;
	public var u:Float;
	public var v:Float;

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
