package;

import shadertoy.FlxShaderToyRuntimeShader;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.input.keyboard.FlxKey;
import sys.io.File;

class NewMenu extends MusicBeatState {
    var debugKeys:Array<FlxKey>;
    var menuSpriteGroup:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
    var menuSpriteSelectedGroup:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
    var options:Array<String> = ["story mode", "extras", "options"];
    var optionYs:Array<Float> = [18, 263, 524];
    var selected:Int = 0;
    var s:Dynamic;
    override public function create() {
        var moopbg:FlxSprite = new FlxSprite().makeGraphic(1280, 720, 0xFF000000);
        s = new FlxShaderToyRuntimeShader(File.getContent(Paths.shaderFragment("titleScreen")), 1280, 720);
        moopbg.shader = s;
        moopbg.screenCenter();
        var moopfg:FlxSprite = new FlxSprite(0, -360).loadGraphic(Paths.image("moopy/week1fg"), "shared");
        add(moopbg);
        add(moopfg);

        debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

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
        if (s != null && s is FlxShaderToyRuntimeShader) {
            s.update(elapsed, null);
        }
        super.update(elapsed);
        if (controls.UI_UP_P || controls.UI_DOWN_P) changeSelection(controls.UI_UP_P);
        if (controls.BACK) {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.switchState(new TitleState());
        }
        if (controls.ACCEPT) go();
        #if cpp
        #if debug
        if (FlxG.keys.anyJustPressed(debugKeys))
        {
            MusicBeatState.switchState(new editors.MasterEditorMenu());
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
        else if (selected == 1) MusicBeatState.switchState(new ExtrasState());
        else if (selected == 2) MusicBeatState.switchState(new options.OptionsState());
    }
}