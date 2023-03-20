::mods_hookExactClass("skills/actives/raise_undead", function(obj)
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Raise a corpse back to life as an undead, faithfully follows your bidding.";
		this.m.IconDisabled = "skills/active_26_sw.png";
	};
	obj.getTooltip <- function()
	{
		return this.getDefaultUtilityTooltip();
	};
});