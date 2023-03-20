::mods_hookExactClass("skills/perks/perk_ptr_through_the_gaps", function ( obj )
{
	obj.onAdded <- function()
	{
		::Nggh_MagicConcept.HooksHelper.autoEnableForBeasts(this);
	};
});
