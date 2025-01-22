::Nggh_MagicConcept.HooksMod.hook("scripts/skills/perks/perk_ptr_light_weapon", function ( q )
{
	q.onAdded <- function()
	{
		::Nggh_MagicConcept.HooksHelper.autoEnableForBeasts(this);
	}
});
