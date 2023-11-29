::mods_hookExactClass("entity/tactical/enemies/unhold", function(obj) {
	local assignRandomEquipment = obj.assignRandomEquipment;
	obj.assignRandomEquipment = function()
	{
		if (::Math.rand(1, 10) <= 3)
			this.getItems().equip(::new("scripts/items/weapons/nggh_mod_picked_up_rock"));

		assignRandomEquipment();
	}
});