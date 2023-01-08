var bg:FlxSprite;
var fg:FlxSprite;
var sus:FlxSprite;
var stx:Int = 200;
var sty:Int = FlxG.random.int(1000, 1200);

function createPost():Void {
    bg = new FlxSprite(-1000, -100).loadGraphic(Paths.image("moopy/erect/bg"));
    fg = new FlxSprite(-900, -100).loadGraphic(Paths.image("moopy/erect/fg"));
    bg.scrollFactor.set(0.8, 1);
    sus = new FlxSprite(stx, sty);
    sus.frames = Paths.getSparrowAtlas("moopy/erect/red");
    sus.animation.addByPrefix("idle", "idle instance 1", 24, true);
    sus.animation.play("idle");
    addBehindGF(bg);
    addBehindGF(sus);
    addBehindGF(fg);
}

function beatHit():Void {
    if (game.curBeat % 64 == 0) {
        var r:Int = FlxG.random.int(5, 10);
        FlxTween.tween(sus, {x: FlxG.random.int(3000, 4000), y: 1500}, r, {ease: FlxEase.cubeOut, onComplete: function(t) {
            sus.x = stx;
            sus.y = FlxG.random.int(1000, 1200);
        }});
    }
}