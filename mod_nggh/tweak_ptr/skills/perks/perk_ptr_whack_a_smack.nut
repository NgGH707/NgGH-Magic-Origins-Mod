::mods_hookExactClass("skills/perks/perk_ptr_whack_a_smack", function ( obj )
{
	obj.onAdded <- function()
	{
		::Nggh_MagicConcept.HooksHelper.autoEnableForBeasts(this);
	};
});
