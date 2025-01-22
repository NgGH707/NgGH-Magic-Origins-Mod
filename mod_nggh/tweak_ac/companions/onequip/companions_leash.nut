::Nggh_MagicConcept.HooksMod.hook("scripts/companions/onequip/companions_leash", function(q) 
{
	q.onUse = @(__original) function(_user, _targetTile)
	{
		local ret = __original(_user, _targetTile);
		
		if (_user.getFlags().has("can_mount"))
			_user.getMount().onLeashMount();

		return ret;
	}
});
