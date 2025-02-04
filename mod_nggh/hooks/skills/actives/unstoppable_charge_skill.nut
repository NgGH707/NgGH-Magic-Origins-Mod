::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/unstoppable_charge_skill", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Charge forward with unbeleivable speed and ram at enemy formation. Can cause knock back or stun. Can not be used in melee.";
		m.Icon = "skills/active_110.png";
		m.IconDisabled = "skills/active_110_sw.png";
	}

	q.getTooltip = @() function()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + getMaxRange() + "[/color] tiles"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "May inflict [color=" + ::Const.UI.Color.PositiveValue + "]Stun[/color] or cause [color=" + ::Const.UI.Color.PositiveValue + "]Knock Back[/color] to nearby foes"
			}
		]);
		
		if (::Tactical.isActive() && getContainer().getActor().isEngagedInMelee())
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can not be used because this character is engaged in melee[/color]"
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

	q.onCombatFinished = function() 
	{
		m.IsSpent = false;
	}
	
});