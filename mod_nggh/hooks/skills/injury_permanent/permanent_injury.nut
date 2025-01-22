::Nggh_MagicConcept.HooksMod.hook("scripts/skills/injury_permanent/permanent_injury", function (q)
{
	q.onAdded = @(__original) function()
	{
		if (!getContainer().getActor().getFlags().has("human"))
			return;

		__original();
	}
	
	q.showInjury = @(__original) function()
	{
		if (!getContainer().getActor().getFlags().has("human"))
			return;

		__original();
	}
	
	q.onCombatFinished = @(__original) function()
	{
		if (!getContainer().getActor().getFlags().has("human"))
			return;

		__original();
	}
});