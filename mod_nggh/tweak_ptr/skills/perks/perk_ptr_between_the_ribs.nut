::mods_hookExactClass("skills/perks/perk_ptr_between_the_ribs", function ( obj )
{
	obj.onAdded <- function()
	{
		::Nggh_MagicConcept.HooksHelper.autoEnableForBeasts(this);
	};
});
