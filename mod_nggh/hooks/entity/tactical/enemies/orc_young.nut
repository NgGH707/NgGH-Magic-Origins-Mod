::mods_hookExactClass("entity/tactical/enemies/orc_young", function (obj) 
{
	local ws_assignRandomEquipment = obj.assignRandomEquipment
    obj.assignRandomEquipment = function()
	{
		ws_assignRandomEquipment()
		this.m.Items.unequip(this.m.Items.getItemAtSlot(::Const.ItemSlot.Body));

		local roll = ::MSU.Array.rand([
			"orc_young_light",
			"orc_young_medium",
			"orc_young_heavy"
		]);

		if (::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
		{
			this.m.Items.equip(::new("scripts/items/armor/greenskins/" + roll + "_armor"));
		}
		else
		{
			this.m.Items.equip(::new("scripts/items/legend_armor/greenskins/nggh_mod_" + roll + "_armor"));
		}
	}
});