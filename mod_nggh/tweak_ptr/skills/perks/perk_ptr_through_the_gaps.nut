::Nggh_MagicConcept.HooksMod.hook("scripts/skills/perks/perk_ptr_through_the_gaps", function ( q )
{
	q.onAdded <- function() {
		::Nggh_MagicConcept.HooksHelper.autoEnableForBeasts(this);
	}
});
