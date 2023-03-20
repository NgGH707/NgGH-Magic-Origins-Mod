::mods_hookExactClass("skills/perks/perk_ptr_light_weapon", function ( obj )
{
	obj.onAdded <- function()
	{
		::Nggh_MagicConcept.HooksHelper.autoEnableForBeasts(this);
	};
});
