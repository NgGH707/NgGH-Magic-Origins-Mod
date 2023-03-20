::mods_hookExactClass("companions/onequip/companions_leash", function(obj) 
{
	local ws_onUse = obj.onUse;
	obj.onUse = function(_user, _targetTile)
	{
		local ret = ws_onUse(_user, _targetTile);
		
		if (_user.getFlags().has("can_mount"))
		{
			_user.getMount().onLeashMount();
		}

		return ret;
	}
});
