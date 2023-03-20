::mods_hookExactClass("items/trade/uncut_gems_item", function(obj) 
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.ItemType = this.m.ItemType | ::Const.Items.ItemType.Crafting;
	}

});