::mods_hookExactClass("entity/tactical/enemies/unhold_frost", function(obj) {
	obj.makeMiniboss <- function()
	{
		if (!this.actor.makeMiniboss())
			return false;

		this.m.BaseProperties.RangedSkill += 15;
		//this.m.Items.equip(::new("scripts/items/weapons/nggh_mod_picked_up_rock"));
	    //this.m.Items.equip(::new("scripts/items/legend_armor/barbarians/nggh_mod_unhold_armor_heavy"));
		//this.m.Items.equip(::new("scripts/items/legend_helmets/barbarians/nggh_mod_unhold_helmet_heavy"));
		//this.m.Skills.add(::new("scripts/skills/perks/perk_mastery_throwing"));
		//this.m.Skills.add(::new("scripts/skills/perks/perk_vengeance"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_colossus"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_underdog"));
		return true;
	}
});