::mods_hookExactClass("entity/tactical/enemies/legend_rock_unhold", function (obj) 
{
	/*
	local assignRandomEquipment = obj.assignRandomEquipment;
	obj.assignRandomEquipment = function()
	{
		this.getItems().equip(::new("scripts/items/weapons/nggh_mod_picked_up_rock"));
		assignRandomEquipment();
	}
	*/

	obj.makeMiniboss <- function()
	{
		if (!this.actor.makeMiniboss())
			return false;

	    this.m.Items.equip(::new("scripts/items/legend_armor/barbarians/nggh_mod_unhold_armor_heavy"));
		this.m.Items.equip(::new("scripts/items/legend_helmets/barbarians/nggh_mod_unhold_helmet_heavy"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_vengeance"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_colossus"));
		return true;
	}
});
