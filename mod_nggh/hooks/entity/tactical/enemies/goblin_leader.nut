::mods_hookExactClass("entity/tactical/enemies/goblin_leader", function (obj) 
{
    local ws_assignRandomEquipment = obj.assignRandomEquipment
    obj.assignRandomEquipment = function()
	{
		ws_assignRandomEquipment()
		this.m.Items.unequip(this.m.Items.getItemAtSlot(::Const.ItemSlot.Body));
		this.m.Items.unequip(this.m.Items.getItemAtSlot(::Const.ItemSlot.Head))

		if (::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
		{
			this.m.Items.equip(::new("scripts/items/armor/greenskins/goblin_leader_armor"));
			this.m.Items.equip(::new("scripts/items/helmets/greenskins/goblin_leader_helmet"));
		}
		else
		{
			this.m.Items.equip(::new("scripts/items/legend_armor/greenskins/nggh_mod_goblin_leader_armor"));
			this.m.Items.equip(::new("scripts/items/legend_helmets/greenskins/nggh_mod_goblin_leader_helmet"));
		}
	}
});