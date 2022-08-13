local stx;
local sty;
function onCreatePost()
	runHaxeCode("trace('Working!');"); -- Init interp so it doesn't lag out later, just in case
	makeLuaSprite("bg", "moopy/erect/bg", -500, -100);
	makeLuaSprite("fg", "moopy/erect/fg", -1000, -100);
	setScrollFactor("bg", 0.8, 1);
	addLuaSprite("bg");
    -- close(true);
	stx = 200;
	sty = math.random(1000, 1200);
	makeAnimatedLuaSprite("sus", "moopy/erect/red", stx, sty);
	addAnimationByPrefix("sus", "spin", "idle instance 1", 24, true);
	addLuaSprite("sus");
	addLuaSprite("fg");
	playAnim("sus", "spin", true);
end

function onBeatHit()
	if curBeat % 64 == 0 then
		r = math.random(5, 10);
		doTweenX("susX", "sus", math.random(3000, 4000), r, "cubeOut");
		doTweenY("susY", "sus", 1500, r, "cubeOut");
	end
end

function onTweenCompleted(t)
	if t == "susX" then
		runHaxeCode("game.modchartSprites['sus'].x = 200;");
		runHaxeCode("game.modchartSprites['sus'].y = FlxG.random.int(1000, 1200);");
	end
end