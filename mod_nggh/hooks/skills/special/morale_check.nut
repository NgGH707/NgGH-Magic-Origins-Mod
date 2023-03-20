::mods_hookExactClass("skills/special/morale_check", function(obj)
{
	obj.onAdded <- function()
	{
		local AI = this.getContainer().getActor().getAIAgent();

		if (AI != null && AI.getID() != ::Const.AI.Agent.ID.Player)
		{
			AI.addBehavior(::new("scripts/ai/tactical/behaviors/ai_wake_up_ally"));
		}
	}
});