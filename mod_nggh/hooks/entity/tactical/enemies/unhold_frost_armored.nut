::mods_hookExactClass("entity/tactical/enemies/unhold_frost_armored", function (obj) 
{
	obj.assignRandomEquipment = function()
	{
		if (::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
		{
			this.m.Items.equip(::new("scripts/items/armor/barbarians/unhold_armor_heavy"));
			this.m.Items.equip(::new("scripts/items/helmets/barbarians/unhold_helmet_heavy"));
		}
		else 
		{
		    this.m.Items.equip(::new("scripts/items/legend_armor/barbarians/nggh_mod_unhold_armor_heavy"));
			this.m.Items.equip(::new("scripts/items/legend_helmets/barbarians/nggh_mod_unhold_helmet_heavy"));
		}
	}
});