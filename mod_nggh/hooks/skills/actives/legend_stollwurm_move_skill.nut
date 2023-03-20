::mods_hookExactClass("skills/actives/legend_stollwurm_move_skill", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Digging your way through the underground to reach you destination.";
		this.m.Icon = "skills/active_149.png";
		this.m.IconDisabled = "skills/active_149_sw.png";
		this.m.Overlay = "active_149";
	};
	obj.onAdded <- function()
	{
		this.m.IsVisibleTileNeeded = this.getContainer().getActor().isPlayerControlled();
	};
});