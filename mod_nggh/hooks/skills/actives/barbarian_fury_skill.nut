::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/barbarian_fury_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Switch places with another character directly adjacent, provided neither the target is stunned or rooted, nor the character using the skill is. Rotate the battle line to keep fresh troops in front!";
		m.Icon = "skills/active_175.png";
		m.IconDisabled = "skills/active_175_sw.png";
	}

	q.onAdded <- function()
	{
		if (::MSU.isKindOf(getContainer().getActor(), "player"))
			setBaseValue("FatigueCost", 10);
	}

	q.getTooltip <- function()
	{
		local ret = getDefaultUtilityTooltip();

		if (getContainer().getActor().getCurrentProperties().IsRooted)
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can not be used while rooted[/color]"
			});
		
		if (m.IsSpent)
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can only be used once per turn[/color]"
			});

		return ret;
	}

	q.getCursorForTile <- function( _tile )
	{
		return ::Const.UI.Cursor.Rotation;
	}
});