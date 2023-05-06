::mods_hookExactClass("skills/actives/legend_bear_claws", function(obj) 
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.ActionPointCost = 4;
	};
	
});