::mods_hookExactClass("skills/perks/perk_ptr_from_all_sides", function ( obj )
{
	obj.onAdded <- function()
	{
		::Nggh_MagicConcept.HooksHelper.autoEnableForBeasts(this);
	};
});
