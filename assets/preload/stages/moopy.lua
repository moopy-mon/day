function onCreate()
	makeLuaSprite("bg", "moopy/week1bg", -500, -100);
	makeLuaSprite("fg", "moopy/week1fg", -500, -100);
	setScrollFactor("bg", 0.8, 1);
	initLuaShader('titleScreen', 'shadertoy');
	setSpriteShader('bg', 'titleScreen');
	addLuaSprite("bg");
	addLuaSprite("fg");
	close(true);
end