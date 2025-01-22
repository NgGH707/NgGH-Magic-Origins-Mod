::Nggh_MagicConcept.HooksMod.hook("scripts/skills/injury/injury", function (q)
{
	q.showInjury = @(__original) function()
	{
		if (!getContainer().getActor().getFlags().has("human"))
			return;

		__original();
	};
});