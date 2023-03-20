::mods_hookExactClass("skills/actives/move_tail_skill", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Move the tail closer to the body";
		this.m.Icon = "skills/active_109.png";
		this.m.IconDisabled = "skills/active_109_sw.png";
	};
	obj.onAdded <- function()
	{	
		if (this.getContainer().getActor().isPlayerControlled())
		{
			this.m.ActionPointCost = 5;
		}
	};
	obj.getTooltip <- function()
	{
		return this.getDefaultUtilityTooltip();
	};
});