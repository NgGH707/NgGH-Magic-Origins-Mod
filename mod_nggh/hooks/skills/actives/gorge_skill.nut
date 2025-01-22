::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/gorge_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "A powerful attack that can be used at a distance.";
		m.Icon = "skills/active_107.png";
		m.IconDisabled = "skills/active_107_sw.png";
	}

	q.getTooltip <- function()
	{
		local ret = getDefaultTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + getMaxRange() + "[/color] tiles"
		});
		return ret;
	}

	q.onAfterUpdate <- function( _properties )
	{
		m.FatigueCostMult = _properties.IsSpecializedInAxes ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	}
});