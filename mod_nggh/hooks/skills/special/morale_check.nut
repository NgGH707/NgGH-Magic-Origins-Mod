::Nggh_MagicConcept.HooksMod.hook("scripts/skills/special/morale_check", function(q)
{
	q.onAdded <- function()
	{
		local AI = getContainer().getActor().getAIAgent();

		if (AI != null && AI.getID() != ::Const.AI.Agent.ID.Player)
			AI.addBehavior(::new("scripts/ai/tactical/behaviors/ai_wake_up_ally"));
	}
});