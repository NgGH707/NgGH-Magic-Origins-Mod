::Nggh_MagicConcept.HooksMod.hook("scripts/skills/perks/perk_ptr_from_all_sides", function ( q )
{
	q.onAdded <- function()
	{
		::Nggh_MagicConcept.HooksHelper.autoEnableForBeasts(this);
	}
});
