function onCreatePost()
    makeLuaSprite('bg', 'moopy/strike/bg', 0, 0);
    setScrollFactor('bg', 0.8, 1);
    makeLuaSprite('fg', 'moopy/strike/fg', 0, 0);
    makeLuaSprite('crystals', 'moopy/strike/crystals', 0, 0);
    runHaxeCode('game.modchartSprites["bg"].antialiasing = false;');
    runHaxeCode('game.modchartSprites["fg"].antialiasing = false;');
    runHaxeCode('game.modchartSprites["crystals"].antialiasing = false;');
    addLuaSprite('bg');
    addLuaSprite('fg');
    addLuaSprite('crystals');
    close(true);
end