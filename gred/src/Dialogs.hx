@:native("_G") extern class Dialogs {
	@:native("RequestFile") public static function requestFile(title:String, filter:String, save:Bool, initial:Dynamic):String;
}
