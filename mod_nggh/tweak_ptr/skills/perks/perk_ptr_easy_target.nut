::Nggh_MagicConcept.HooksMod.hook("scripts/skills/perks/perk_ptr_whack_a_smack", function ( q )
{
	q.onAdded <- function()
	{
		::Nggh_MagicConcept.HooksHelper.autoEnableForBeasts(this);
	}
});
