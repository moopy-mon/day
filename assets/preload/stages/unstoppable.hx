import("Math"); 
var bg:FlxSprite;
var shader;

function createPost() {
    bg = new FlxSprite(-800, -200).loadGraphic(Paths.image("moopy/unstoppable/bg"));
    shader = new GlitchEffect(2, 5, 0.1);
    bg.shader = shader.shader;
    bg.scale.scale(4);
    addBehindGF(bg);
}

var elapsedtime:Float = 0;

function update(elapsed:Float) {
    elapsedtime += elapsed;
    game.dad.y += Math.cos(elapsedtime);
}