::mods_hookExactClass("skills/perks/perk_sundering_strikes", function(o) {
	local create = o.create;
	o.create = function()
	{
		create();
		this.m.Order = ::Const.SkillOrder.Last;
	}
})