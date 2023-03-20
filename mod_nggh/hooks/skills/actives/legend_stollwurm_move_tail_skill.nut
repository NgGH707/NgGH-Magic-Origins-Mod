::mods_hookExactClass("skills/actives/legend_stollwurm_move_tail_skill", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.ID = "actives.move_tail";
		this.m.Name = "Burrow Tail";
		this.m.Description = "Digging your way through the underground to reach you destination.";
		this.m.Icon = "skills/active_149.png";
		this.m.IconDisabled = "skills/active_149_sw.png";
		this.m.Overlay = "active_149";
	};
	obj.onAdded <- function()
	{	
		if (!::Nggh_MagicConcept.IsOPMode && this.getContainer().getActor().isPlayerControlled())
		{
			this.m.ActionPointCost = 5;
		}
	};
	obj.getTooltip <- function()
	{
		return this.getDefaultUtilityTooltip();
	};
});