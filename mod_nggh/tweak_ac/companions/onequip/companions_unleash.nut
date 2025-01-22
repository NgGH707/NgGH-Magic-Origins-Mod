::Nggh_MagicConcept.HooksMod.hook("scripts/companions/onequip/companions_unleash", function(q) 
{
	q.onUse = @(__original) function(_user, _targetTile)
	{
		local ret = __original(_user, _targetTile);

		if (_user.isMounted())
			_user.getMount().onDismountPet();

		return ret;
	}
});

