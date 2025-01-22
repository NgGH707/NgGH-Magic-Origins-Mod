::Nggh_MagicConcept.HooksMod.hook("scripts/ai/tactical/agents/ghost_agent", function ( q )
{
	q.onAddBehaviors = @(__original) function()
	{
		__original();
		addBehavior(::new("scripts/ai/tactical/behaviors/ai_ghost_possess"));
		addBehavior(::new("scripts/ai/tactical/behaviors/ai_defend_rotation"));
	}
});