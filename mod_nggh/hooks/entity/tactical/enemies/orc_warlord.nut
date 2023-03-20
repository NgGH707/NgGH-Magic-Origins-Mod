::mods_hookExactClass("entity/tactical/enemies/orc_warlord", function (obj) 
{
	local ws_assignRandomEquipment = obj.assignRandomEquipment
    obj.assignRandomEquipment = function()
	{
		ws_assignRandomEquipment()
		this.m.Items.unequip(this.m.Items.getItemAtSlot(::Const.ItemSlot.Body));

		if (::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
		{
			this.m.Items.equip(::new("scripts/items/armor/greenskins/orc_warlord_armor"));
		}
		else
		{
			this.m.Items.equip(::new("scripts/items/legend_armor/greenskins/nggh_mod_orc_warlord_armor"));
		}
	}
});