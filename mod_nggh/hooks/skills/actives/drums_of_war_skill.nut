::mods_hookExactClass("skills/actives/drums_of_war_skill", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Inspire your men with rhythm of war.";
		this.m.Icon = "skills/active_163.png";
		this.m.IconDisabled = "skills/active_163_sw.png";
	};
	obj.getTooltip <- function()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "Lowers the fatigue of every brother by [color=" + ::Const.UI.Color.NegativeValue + "]-10[/color] instantly."
			}
		]);
		return ret;
	}
});