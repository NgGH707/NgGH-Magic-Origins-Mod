::Nggh_MagicConcept.HooksMod.hook("scripts/skills/perks/perk_ptr_pointy_end", function ( q )
{
	q.onAdded <- function() {
		::Nggh_MagicConcept.HooksHelper.autoEnableForBeasts(this);
	}
});
