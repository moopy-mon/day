package lore;

import flashcache.ImageCache;
import flixel.FlxState;
import flixel.FlxG;
import flixel.addons.display.FlxPieDial;
import flixel.text.FlxText;
import sys.FileSystem;
import flixel.addons.util.FlxAsyncLoop;

using StringTools;

/*
    Loader.hx
    Moves things that only need to init once into here, rather than TitleState
    Also where caching happens if you have that enabled
*/

class Loader extends FlxState {
    var completelyCached:Bool = false;
    var loadText:FlxText;
    public static var imgCache:ImageCache = new ImageCache("assets/images");
    public static var sharedImgCache:ImageCache = new ImageCache("assets/shared/images");
    var pie:FlxPieDial; 
    var audioLoop:FlxAsyncLoop;
    var imageLoop:FlxAsyncLoop;
    var sharedImageLoop:FlxAsyncLoop;
    override public function create():Void {
        super.create();
        PlayerSettings.init();
		FlxG.save.bind('funkin', 'ninjamuffin99');
		ClientPrefs.loadPrefs();
        lore.Colorblind.updateFilter();
        #if LUA_ALLOWED
		Paths.pushGlobalMods();
		#end
		// Just to load a mod on start up if ya got one. For mods that change the menu music and bg
		WeekData.loadTheFirstEnabledMod();
        if (!ClientPrefs.cacheAudio && !ClientPrefs.cacheImages) {
            completelyCached = true;
            return; // juuuuuuust to be safe
        }
        add(loadText = new FlxText(4, 4, FlxG.width - 8, "Preloading..."));
        loadText.setFormat(Paths.font("vcr.ttf"), 32, 0xffffffff, "center");
        loadText.screenCenter();
        loadText.y -= (44 + loadText.height);
        initCache();
    }

    static final sharedCacheList:Array<String> = [
        "",
        "moopy/",
        "moopy/erect/",
        "moopy/strike/",
        "characters/"
    ];

    static final preloadCacheList:Array<String> = [
        "icons/",
        ""
    ];

    var imgsToCache:Array<String> = [];
    var sharedImgsToCache:Array<String> = [];
    var audioToCache:Array<String> = [];
    var totalCache:Int = 0;
    var cacheProgress:Int = 0;
    var eachCache:Int = 0;

    private function initCache():Void {
        if (ClientPrefs.cacheAudio) {
            for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/songs"))) {
                if (!FileSystem.isDirectory("assets/songs/" + i)) continue;
                audioToCache.push(i);
                totalCache++;
            }
        }
        if (ClientPrefs.cacheImages) {
            for (i in sharedCacheList) {
                searchFolderForCache(i, sharedImgsToCache);
            }
            for (i in preloadCacheList) {
                searchPreloadFolderForCache(i, imgsToCache);
            }
        }
        generatePieDial();
        if (ClientPrefs.cacheAudio) {
            audioLoop = new FlxAsyncLoop(audioToCache.length, cacheAudio, 1);
            add(audioLoop);
            audioLoop.start();
        } else if (ClientPrefs.cacheImages) {
            imageLoop = new FlxAsyncLoop(imgsToCache.length, cacheImages, 1);
            add(imageLoop);
            imageLoop.start();
        }
    }

    function cacheAudio():Void {
        Paths.inst(audioToCache[eachCache]);
        Paths.voices(audioToCache[eachCache]);
        Paths.voices2(audioToCache[eachCache]);
        trace("Cached audio: " + audioToCache[eachCache]);
        eachCache++;
        cacheProgress++;
        pie.amount = cacheProgress / totalCache;
        loadText.text = "Preloading: " + cacheProgress + "/" + totalCache;
        if (eachCache == audioToCache.length) {
            eachCache = 0;
            audioLoop.destroy();
            audioLoop = null;
            if (ClientPrefs.cacheImages) {
                imageLoop = new FlxAsyncLoop(imgsToCache.length, cacheImages, 1);
                add(imageLoop);
                imageLoop.start();
            } else {
                completelyCached = true;
            }
        }
    }

    function cacheImages():Void {
        imgCache.cacheGraphic(imgsToCache[eachCache], true);
        eachCache++;
        cacheProgress++;
        loadText.text = "Preloading: " + cacheProgress + "/" + totalCache;
        pie.amount = cacheProgress / totalCache;
        if (eachCache == imgsToCache.length) {
            eachCache = 0;
            imageLoop.destroy();
            imageLoop = null;
            sharedImageLoop = new FlxAsyncLoop(sharedImgsToCache.length, cacheSharedImages, 1);
            add(sharedImageLoop);
            sharedImageLoop.start();
        }
    }

    function cacheSharedImages():Void {
        sharedImgCache.cacheGraphic(sharedImgsToCache[eachCache], true);
        eachCache++;
        cacheProgress++;
        pie.amount = cacheProgress / totalCache;
        loadText.text = "Preloading: " + cacheProgress + "/" + totalCache;
        if (eachCache == sharedImgsToCache.length) {
            eachCache = 0;
            sharedImageLoop.destroy();
            sharedImageLoop = null;
            completelyCached = true;
        }
    }

    function generatePieDial():Void {
        add(pie = new FlxPieDial(0, loadText.height + 84, 40, 0xFF007F00, totalCache, CIRCLE, true, 20));
        pie.screenCenter();
    }

    function searchFolderForCache(key:String, ar:Array<String>):Void {
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/" + key))) {
			if (!i.endsWith(".png")) continue;
            totalCache++;
			ar.push(key + i.replace(".png", ""));
		}
	}

    function searchPreloadFolderForCache(key:String, ar:Array<String>):Void {
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/images/" + key))) {
			if (!i.endsWith(".png")) continue;
            totalCache++;
			ar.push(key + i.replace(".png", ""));
		}
	}

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        if (completelyCached) {
            completelyCached = false; // prevent it from running 49023095832908423 times
            FlxG.switchState(new TitleState());
        }
    }
}