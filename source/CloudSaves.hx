package;

import tentools.api.FlxGameJolt;
import flixel.FlxG;
import openfl.net.SharedObject;
import sys.io.File;
import sys.FileSystem;
using StringTools;

class CloudSaves {
    public static function sendScores():Void {
        FlxG.save.flush();
        @:privateAccess var path:String = SharedObject.__getPath(FlxG.save._sharedObject.__localPath, FlxG.save._sharedObject.__name);
        FlxG.save.close();
        var save:String = File.getContent(path);
        FlxGameJolt.setData("saveData", save);
        trace("Sent save data to GameJolt");
    }
    public static function getScores():Void {
        FlxG.save.flush();
        @:privateAccess var path:String = SharedObject.__getPath(FlxG.save._sharedObject.__localPath, FlxG.save._sharedObject.__name);
        #if windows 
        path = path.replace("/", "\\"); 
        path = path.replace("\\", "/");
        path = path.replace("//", "/");
        #end
        trace(path);
        FlxG.save.close();
        var save:String;
        trace("getting...");
        FlxGameJolt.fetchData("saveData", true, (map:Map<String, String>) -> {
            save = map.get('data');
            save = save.replace(" ", "%20");
            handleData(path, save);
        });
    }
    static function handleData(path:String, save:String) {
        FileSystem.deleteFile(path);
        File.saveContent(path, "");
        var x = File.write(path, false);
        x.writeString(save);
        x.close();
        trace("Got save data from GameJolt");
        Sys.exit(0);
    }
}