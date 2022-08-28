package options;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;

using StringTools;

class CachingSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Caching Settings';
		rpcTitle = 'Caching Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Cache Audio',
			'If checked, audio will be cached at startup for faster loading.\nWarning: uses a fair bit of memory',
			'cacheAudio',
			'bool',
			false);
		addOption(option);	

		var option:Option = new Option('Cache Graphics',
			'If checked, graphics will be cached at startup for faster loading.\nWarning: uses a LOT of memory',
			'cacheImages',
			'bool',
			false);
		addOption(option);

		super();
	}
}