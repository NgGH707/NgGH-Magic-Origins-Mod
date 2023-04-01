::mods_hookExactClass("skills/traits/seductive_trait", function ( obj )
{
	obj.m.Bonus <- 5;
	obj.getBonus <- function()
	{
		return this.m.Bonus;
	};
	local ws_getTooltip = obj.getTooltip;
	obj.getTooltip = function()
	{
		local ret = ws_getTooltip();

		if (this.getContainer().hasSkill("spells.charm"))
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/health.png",
				text = "Has a [color=" + ::Const.UI.Color.PositiveValue + "]+" + this.m.Bonus + "%[/color] to successfully charm a target"
			});
		}

		return ret;
	};
});