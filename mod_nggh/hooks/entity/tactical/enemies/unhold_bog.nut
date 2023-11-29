::mods_hookExactClass("entity/tactical/enemies/unhold_bog", function(obj) {
	local assignRandomEquipment = obj.assignRandomEquipment;
	obj.assignRandomEquipment = function()
	{
		this.unhold.assignRandomEquipment();
		assignRandomEquipment();
	}
});