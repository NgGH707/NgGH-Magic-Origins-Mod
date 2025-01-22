::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/line_breaker", function ( q )
{
	q.create = @(__original) function()
	{
		__original();
		m.Description = "Using brute force to knock a target to the side so you can advance forward. Can be used on allies.";
		m.Icon = "skills/active_53.png";
		m.IconDisabled = "skills/active_53_sw.png";
		m.IsAttack = false;
	}

	q.onAdded <- function()
	{
		local AI = getContainer().getActor().getAIAgent();

		if (AI.getID() != ::Const.AI.Agent.ID.Player)
			AI.addBehavior(::new("scripts/ai/tactical/behaviors/ai_line_breaker"));
	}

	q.getTooltip <- function()
	{
		local ret = getDefaultUtilityTooltip();
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Knock a target to the side then move forward"
		});

		return ret;
	}
});