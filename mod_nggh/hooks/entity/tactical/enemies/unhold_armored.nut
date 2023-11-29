::mods_hookExactClass("entity/tactical/enemies/unhold_armored", function (obj) 
{
	obj.assignRandomEquipment = function()
	{
		this.unhold.assignRandomEquipment();
		this.m.Items.equip(::new("scripts/items/legend_armor/barbarians/nggh_mod_unhold_armor_light"));
		this.m.Items.equip(::new("scripts/items/legend_helmets/barbarians/nggh_mod_unhold_helmet_light"));
	}
});