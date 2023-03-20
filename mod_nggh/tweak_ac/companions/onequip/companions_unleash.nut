::mods_hookExactClass("companions/onequip/companions_unleash", function(obj) 
{
	local ws_onUse = obj.onUse;
	obj.onUse = function(_user, _targetTile)
	{
		local ret = ws_onUse(_user, _targetTile);

		if (_user.isMounted())
		{
			_user.getMount().onDismountPet();
		}

		return ret;
	}
});

