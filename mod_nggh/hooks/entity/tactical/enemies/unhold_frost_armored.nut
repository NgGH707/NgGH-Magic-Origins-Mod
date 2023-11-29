::mods_hookExactClass("entity/tactical/enemies/unhold_frost_armored", function (obj) 
{
	obj.assignRandomEquipment = function()
	{
		this.unhold_frost.assignRandomEquipment();
	    this.m.Items.equip(::new("scripts/items/legend_armor/barbarians/nggh_mod_unhold_armor_heavy"));
		this.m.Items.equip(::new("scripts/items/legend_helmets/barbarians/nggh_mod_unhold_helmet_heavy"));
	}
});