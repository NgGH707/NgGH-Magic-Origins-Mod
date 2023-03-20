::mods_hookExactClass("skills/actives/unleash_wardog", function(obj) 
{
	local ws_onUse = obj.onUse;
	obj.onUse = function(_user, _targetTile)
	{
		local ret = ws_onUse(_user, _targetTile);

		if (ret && _user.isMounted())
		{
			_user.getMount().onDismountPet();
		}

		return ret;
	}
});