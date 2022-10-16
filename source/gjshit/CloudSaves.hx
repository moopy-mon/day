package gjshit;

import tentools.api.FlxGameJolt;
import flixel.FlxG;

using StringTools;

class CloudSaves { // note to any people maybe using this, it is not a state, don't try and switch to it
    public static function sendScores():Void {
        var tempShit:StringBuf;
        for (i in Highscore.songScores.keys()) {
            tempShit.add(i);
            tempShit.add("--");
            tempShit.add(Std.string(Highscore.songScores.get(i)));
            tempShit.add("\n");
        }
        var otherTemp:String = tempShit.toString();
        FlxGameJolt.setData("songScores", otherTemp);

        tempShit = new StringBuf();
        for (i in Highscore.weekScores.keys()) {
            tempShit.add(i);
            tempShit.add("--");
            tempShit.add(Std.string(Highscore.weekScores.get(i)));
            tempShit.add("\n");
        }
        otherTemp = tempShit.toString();
        FlxGameJolt.setData("weekScores", otherTemp);

        tempShit = new StringBuf();
        for (i in Highscore.songRating.keys()) {
            tempShit.add(i);
            tempShit.add("--");
            tempShit.add(Std.string(Highscore.songRating.get(i)));
            tempShit.add("\n");
        }
        otherTemp = tempShit.toString();
        FlxGameJolt.setData("songRating", otherTemp);
    }
    public static function getScores():Void {
        var tempShitAgain:Array<String>;
        FlxGameJolt.fetchData("songScores", function(map) {
            tempShitAgain = map.data.split("\n");
        });
        var otherTempAgain:Map<String, Int> = [];
        for (i in tempShitAgain) {
            var tempShitAgainAgain:Array<String> = i.split("--");
            otherTempAgain.set(tempShitAgainAgain[0], Std.parseInt(tempShitAgainAgain[1]));
        }
        Highscore.songScores = otherTempAgain;
        FlxG.save.data.songScores = Highscore.songScores;

        FlxGameJolt.fetchData("weekScores", function(map) {
            tempShitAgain = map.data.split("\n");
        });
        otherTempAgain = [];
        for (i in tempShitAgain) {
            var tempShitAgainAgain:Array<String> = i.split("--");
            otherTempAgain.set(tempShitAgainAgain[0], Std.parseInt(tempShitAgainAgain[1]));
        }
        Highscore.weekScores = otherTempAgain;
        FlxG.save.data.weekScores = Highscore.weekScores;

        FlxGameJolt.fetchData("songRating", function(map) {
            tempShitAgain = map.data.split("\n");
        });
        var stupid:Map<String, Float> = [];
        for (i in tempShitAgain) {
            var tempShitAgainAgain:Array<String> = i.split("--");
            stupid.set(tempShitAgainAgain[0], Std.parseFloat(tempShitAgainAgain[1]));
        }
        Highscore.songRating = stupid;
        FlxG.save.data.songRating = Highscore.songRating;

        FlxG.save.flush();
    }
}