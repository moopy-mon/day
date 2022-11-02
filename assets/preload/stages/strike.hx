var bg:FlxSprite;
var fg:FlxSprite;
var crystals:FlxSprite;

function createPost():Void {
    bg = new FlxSprite().loadGraphic(Paths.image("moopy/strike/bg"));
    addBehindGF(bg);
    fg = new FlxSprite().loadGraphic(Paths.image("moopy/strike/fg"));
    addBehindGF(fg);
    crystals = new FlxSprite().loadGraphic(Paths.image("moopy/strike/crystals"));
    addBehindGF(crystals);
    bg.antialiasing = false;
    fg.antialiasing = false;
    crystals.antialiasing = false;
}