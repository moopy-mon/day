package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;

class NewMenu extends MusicBeatState {
    var menuSpriteGroup:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
    var menuSpriteSelectedGroup:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
    var options:Array<String> = ["story mode", "extras", "options"];
    var optionYs:Array<Float> = [18, 263, 524];
    var selected:Int = 0;
    override public function create() {
        var moopbg:FlxSprite = new FlxSprite().loadGraphic(FlxGraphic.fromBitmapData(BitmapData.fromFile("assets/shared/images/moopy/week1bg.png")));
        moopbg.screenCenter();
        var moopfg:FlxSprite = new FlxSprite(0, -360).loadGraphic(FlxGraphic.fromBitmapData(BitmapData.fromFile("assets/shared/images/moopy/week1fg.png")));
        add(moopbg);
        add(moopfg);

        for (i in 0...options.length) {
            var option:FlxSprite = new FlxSprite(-90, optionYs[i]);
            option.frames = Paths.getSparrowAtlas("moopy_menu_assets");
            var thing = i == 0 ? "story mode" : i == 1 ? "extras" : i == 2 ? "options" : "";
            option.animation.addByPrefix("idle", thing, 24, true);
            option.animation.play("idle");
            option.ID = i;
            menuSpriteGroup.add(option);
        }

        for (i in 0...options.length) {
            var option:FlxSprite = new FlxSprite(-90, optionYs[i]);
            option.frames = Paths.getSparrowAtlas("moopy_menu_assets_selected");
            var thing = i == 0 ? "story mode" : i == 1 ? "extras" : i == 2 ? "options" : "";
            option.animation.addByPrefix("idle", thing + " selected", 24, true);
            option.animation.play("idle");
            option.ID = i + 3;
            option.alpha = 0;
            menuSpriteSelectedGroup.add(option);
        }

        menuSpriteSelectedGroup.forEach((function(item:FlxSprite) {
            if (item.ID == 3) item.alpha = 1;
        }));

        add(menuSpriteGroup);
        add(menuSpriteSelectedGroup);

        super.create();
    }
    override public function update(elapsed:Float) {
        super.update(elapsed);
        if (controls.UI_UP_P || controls.UI_DOWN_P) changeSelection(controls.UI_UP_P);
        if (controls.BACK) {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.switchState(new TitleState());
        }
        if (controls.ACCEPT) go();
        #if cpp
        #if debug
        if (FlxG.keys.anyJustPressed(MainMenuState.debugKeys))
        {
            MusicBeatState.switchState(new MasterEditorMenu());
        }
        #end
        #end
    }
    function changeSelection(up:Bool) {
        FlxG.sound.play(Paths.sound('scrollMenu'));
        if (up) {
            selected--;
            if (selected < 0) selected = options.length - 1;
        } else {
            selected++;
            if (selected > options.length - 1) selected = 0;
        }
        menuSpriteSelectedGroup.forEach((function(item:FlxSprite) {
            if (item.ID == selected + 3) item.alpha = 1;
            else item.alpha = 0;
        }));
    }
    function go() {
        FlxG.sound.play(Paths.sound('confirmMenu'));
        FlxG.sound.music.stop();
        FlxTween.tween(menuSpriteGroup.members[0], {alpha:0}, 0.5);
        FlxTween.tween(menuSpriteGroup.members[1], {alpha:0}, 0.5);
        FlxTween.tween(menuSpriteGroup.members[2], {alpha:0}, 0.5, {onComplete:function(twn:FlxTween) {
            keepGoing();
        }});
    }
    function keepGoing() {
        if (selected == 0) MusicBeatState.switchState(new StoryMenuState());
        if (selected == 1) MusicBeatState.switchState(new FreeplayState());
        if (selected == 2) MusicBeatState.switchState(new options.OptionsState());
    }
}