::Nggh_MagicConcept.HooksMod.hook("scripts/skills/perks/perk_ptr_deadly_precision", function ( q )
{
	q.onAdded <- function()
	{
		::Nggh_MagicConcept.HooksHelper.autoEnableForBeasts(this);
	}
});
