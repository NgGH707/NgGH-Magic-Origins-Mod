::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/charge", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Throw yourself at the enemies and slam at them with your hugemungus body.";
		m.Icon = "skills/active_52.png";
		m.IconDisabled = "skills/active_52_sw.png";
	}

	q.onAdded <- function()
	{
		local AI = getContainer().getActor().getAIAgent();

		if (AI.getID() == ::Const.AI.Agent.ID.Player)
			setBaseValue("FatigueCost", 30);
		else {
			AI.addBehavior(::new("scripts/ai/tactical/behaviors/ai_charge"));
			AI.m.Properties.EngageRangeMin = 1;
			AI.m.Properties.EngageRangeMax = 2;
			AI.m.Properties.EngageRangeIdeal = 2;
		}
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + getMaxRange() + "[/color] tiles"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has a [color=" + ::Const.UI.Color.PositiveValue + "]100%[/color] chance to stun"
			}
		])

		if (m.IsSpent)
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can only be used once per turn[/color]"
			});

		return ret;
	}
	
});