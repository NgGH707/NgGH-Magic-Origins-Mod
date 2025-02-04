::Nggh_MagicConcept.HooksMod.hook("scripts/entity/tactical/enemies/unhold_frost_armored", function (q) 
{
	q.assignRandomEquipment = @() function()
	{
		unhold_frost.assignRandomEquipment();
	    getItems().equip(::new("scripts/items/legend_armor/barbarians/nggh_mod_unhold_armor_heavy"));
		getItems().equip(::new("scripts/items/legend_helmets/barbarians/nggh_mod_unhold_helmet_heavy"));
	}

});