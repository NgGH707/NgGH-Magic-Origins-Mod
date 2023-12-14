if (::Is_PTR_Exist)
	return;

::mods_hookExactClass("skills/perks/perk_legend_lithe", function(o) {
	local getBonus = o.getBonus;
	o.getBonus = function()
	{
		if (::MSU.isKindOf(this.getContainer().getActor(), "nggh_mod_player_beast"))
			return this.m.BonusMax - 5;
		
		return getBonus();
	}
})