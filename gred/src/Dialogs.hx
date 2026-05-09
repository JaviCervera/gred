@:native('_G')
extern class Dialogs {
	public static inline function init():Void {
		System.load('dialogs');
	}

	@:native('Confirm')
	public static function confirm(title:String, text:String, serious:Bool):Bool;

	@:native('Notify')
	public static function notify(title:String, text:String, serious:Bool):Void;

	@:native('Proceed')
	public static function proceed(title:String, text:String, serious:Bool):Int;

	@:native('RequestColor')
	public static function requestColor(title:String, color:Int):Int;

	@:native('RequestDir')
	public static function requestDir(title:String, dir:String):String;

	@:native('RequestFile')
	public static function requestFile(title:String, filters:String, save:Bool, file:String):String;

	@:native('RequestInput')
	public static function requestInput(title:String, text:String, def:String, password:Bool):String;
}
