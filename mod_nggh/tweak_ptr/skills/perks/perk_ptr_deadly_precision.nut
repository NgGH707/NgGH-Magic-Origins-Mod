::mods_hookExactClass("skills/perks/perk_ptr_deadly_precision", function ( obj )
{
	obj.onAdded <- function()
	{
		::Nggh_MagicConcept.HooksHelper.autoEnableForBeasts(this);
	};
});
