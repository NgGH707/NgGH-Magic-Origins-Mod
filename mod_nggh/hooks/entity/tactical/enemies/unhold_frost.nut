::Nggh_MagicConcept.HooksMod.hook("scripts/entity/tactical/enemies/unhold_frost", function(q) {
	q.makeMiniboss <- function()
	{
		if (!actor.makeMiniboss())
			return false;

		m.BaseProperties.RangedSkill += 15;
		//this.m.Items.equip(::new("scripts/items/weapons/nggh_mod_picked_up_rock"));
	    //this.m.Items.equip(::new("scripts/items/legend_armor/barbarians/nggh_mod_unhold_armor_heavy"));
		//this.m.Items.equip(::new("scripts/items/legend_helmets/barbarians/nggh_mod_unhold_helmet_heavy"));
		//getSkills().add(::new("scripts/skills/perks/perk_mastery_throwing"));
		//getSkills().add(::new("scripts/skills/perks/perk_vengeance"));
		getSkills().add(::new("scripts/skills/perks/perk_colossus"));
		getSkills().add(::new("scripts/skills/perks/perk_underdog"));
		return true;
	}
});