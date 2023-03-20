::mods_hookExactClass("skills/perks/perk_ptr_pointy_end", function ( obj )
{
	obj.onAdded <- function()
	{
		::Nggh_MagicConcept.HooksHelper.autoEnableForBeasts(this);
	};
});
