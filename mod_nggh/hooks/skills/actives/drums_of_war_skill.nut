::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/drums_of_war_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Inspire your men with rhythm of war.";
		m.Icon = "skills/active_163.png";
		m.IconDisabled = "skills/active_163_sw.png";
	}

	q.getTooltip <- function()
	{
		local ret = getDefaultUtilityTooltip();
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "Lowers the fatigue of every brother by [color=" + ::Const.UI.Color.NegativeValue + "]-10[/color] instantly."
		});
		return ret;
	}
});