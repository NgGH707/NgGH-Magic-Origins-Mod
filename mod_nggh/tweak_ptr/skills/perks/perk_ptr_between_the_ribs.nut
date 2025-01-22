::Nggh_MagicConcept.HooksMod.hook("scripts/skills/perks/perk_ptr_between_the_ribs", function ( q )
{
	q.onAdded <- function()
	{
		::Nggh_MagicConcept.HooksHelper.autoEnableForBeasts(this);
	}
});
