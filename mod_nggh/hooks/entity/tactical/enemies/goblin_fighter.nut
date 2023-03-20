::mods_hookExactClass("entity/tactical/enemies/goblin_fighter", function (obj) 
{
	local ws_assignRandomEquipment = obj.assignRandomEquipment;
    obj.assignRandomEquipment = function()
	{
		ws_assignRandomEquipment()
		this.m.Items.unequip(this.m.Items.getItemAtSlot(::Const.ItemSlot.Body));
		this.m.Items.unequip(this.m.Items.getItemAtSlot(::Const.ItemSlot.Head));

		local armors = ["goblin_light","goblin_medium","goblin_heavy"];
		local helmets = ["goblin_light","goblin_light","goblin_light","goblin_heavy"];

		if (::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
		{
			this.m.Items.equip(::new("scripts/items/armor/greenskins/" + ::MSU.Array.rand(armors) + "_armor"));
			this.m.Items.equip(::new("scripts/items/helmets/greenskins/" + ::MSU.Array.rand(helmets) + "_helmet"));
		}
		else
		{
			this.m.Items.equip(::new("scripts/items/legend_armor/greenskins/nggh_mod_" + ::MSU.Array.rand(armors) + "_armor"));
			this.m.Items.equip(::new("scripts/items/legend_helmets/greenskins/nggh_mod_" + ::MSU.Array.rand(helmets) + "_helmet"));
		}
	}
});