# Moopy Monday
## Compiling notes:

It's recommended to run this command to compile the game, adding `-debug` if needed.

```sh
lime test [platform] -final -Dbuildcrash
```
You need to install the git version of FlashCache to compile the game, to do this run:

```
haxelib git FlashCache https://github.com/sayofthelor/FlashCache
```

You also need to run these:

```
haxelib git tentools https://github.com/TentaRJ/tentools.git
haxelib git systools https://github.com/haya3218/systools
haxelib run lime rebuild systools [platform]
```

You'll need to make a file called `GJKeys.hx` in the `source` folder with this in it:

```
final id:Int = 0;
final key:String = ""
```

Note that GameJolt integration won't work. This is so people don't grab the keys and post fake scores or screw with the save files.