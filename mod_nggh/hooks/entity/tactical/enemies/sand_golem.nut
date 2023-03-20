::mods_hookExactClass("entity/tactical/enemies/sand_golem", function(obj) 
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Flags.add("sand_golem");
	}
});