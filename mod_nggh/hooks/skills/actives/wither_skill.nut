::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/wither_skill", function(q) 
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Wither a target for three turns, reducing their damage, fatigue and initiative by [color=" + ::Const.UI.Color.NegativeValue + "]-30%[/color]. The effect is weaken by 10% each turn";
		m.IconDisabled = "skills/active_217_sw.png";
	}

	q.getTooltip <- function()
	{
		local ret = getDefaultUtilityTooltip();
		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" +  ::Const.UI.Color.PositiveValue + "]" + getMaxRange() + "[/color] tiles"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Only affects living beings"
			},
		]);
		return ret;
	}

	q.onVerifyTarget <- function( _originTile, _targetTile )
	{
		return skill.onVerifyTarget(_originTile, _targetTile) && !_targetTile.getEntity().getFlags().has("undead");
	}
	
});