::Nggh_MagicConcept.HooksMod.hook("scripts/skills/traits/legend_gift_of_people_trait", function (q)
{
	q.m.Bonus <- 5;

	q.getBonus <- function()
	{
		return m.Bonus;
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		if (getContainer().hasSkill("spells.charm"))
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/health.png",
				text = "Has a [color=" + ::Const.UI.Color.PositiveValue + "]+" + m.Bonus + "%[/color] chance to successfully charm a target"
			});

		return ret;
	}
});