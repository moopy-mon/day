function onCreate()
	setProperty("skipCountdown", true);
end

local allowCountdown = false

function onStartCountdown()
	if not allowCountdown and isStoryMode and not seenCutscene then
		startVideo("serene");
		allowCountdown = true;
		return Function_Stop;
	end
	return Function_Cooldown;
end