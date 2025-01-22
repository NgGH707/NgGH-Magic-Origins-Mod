::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/legend_unleash_warbear_skill", function(q) 
{
	q.onUse = @(__original) function(_user, _targetTile)
	{
		local ret = __original(_user, _targetTile);

		if (ret && _user.isMounted())
			_user.getMount().onDismountPet();

		return ret;
	}
});