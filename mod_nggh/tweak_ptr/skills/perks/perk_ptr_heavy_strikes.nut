::mods_hookExactClass("skills/perks/perk_ptr_heavy_strikes", function ( obj )
{
	obj.onAdded <- function()
	{
		::Nggh_MagicConcept.HooksHelper.autoEnableForBeasts(this);
	};
});
