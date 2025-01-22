::Nggh_MagicConcept.HooksMod.hook("scripts/skills/traits/fat_trait", function ( q )
{
	q.onAdded = @(__original) function()
	{
		if (!getContainer().getActor().getFlags().has("human"))
			return;
		
		__original();
	}
});