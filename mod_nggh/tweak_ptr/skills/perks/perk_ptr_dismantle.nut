::mods_hookExactClass("skills/perks/perk_ptr_dismantle", function ( obj )
{
	obj.onAdded <- function()
	{
		::Nggh_MagicConcept.HooksHelper.autoEnableForBeasts(this);
	};
});
