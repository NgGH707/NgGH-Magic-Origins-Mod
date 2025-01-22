if (::Is_PTR_Exist)
	return;

::Nggh_MagicConcept.HooksMod.hook("scripts/skills/perks/perk_legend_lithe", function(o) {
	local getBonus = o.getBonus;
	o.getBonus = function()
	{
		if (::MSU.isKindOf(getContainer().getActor(), "nggh_mod_player_beast"))
			return m.BonusMax - 5;
		
		return getBonus();
	}
})