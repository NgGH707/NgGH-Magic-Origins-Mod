if (::Is_PTR_Exist)
	return;

::Nggh_MagicConcept.HooksMod.hook("scripts/skills/perks/perk_legend_lithe", function(q) {
	q.getBonus = @(__original) function()
	{
		if (::MSU.isKindOf(getContainer().getActor(), "nggh_mod_player_beast"))
			return m.BonusMax - 5;
		
		return __original();
	}
})