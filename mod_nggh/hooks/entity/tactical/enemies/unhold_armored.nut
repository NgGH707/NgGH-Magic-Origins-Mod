::Nggh_MagicConcept.HooksMod.hook("scripts/entity/tactical/enemies/unhold_armored", function (q) 
{
	q.assignRandomEquipment = @() function()
	{
		unhold.assignRandomEquipment();
	    getItems().equip(::new("scripts/items/legend_armor/barbarians/nggh_mod_unhold_armor_light"));
		getItems().equip(::new("scripts/items/legend_helmets/barbarians/nggh_mod_unhold_helmet_light"));
	}
	
});