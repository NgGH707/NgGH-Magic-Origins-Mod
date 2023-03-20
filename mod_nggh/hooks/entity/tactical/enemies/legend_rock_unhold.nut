::mods_hookExactClass("entity/tactical/enemies/legend_rock_unhold", function (obj) 
{
	obj.makeMiniboss <- function()
	{
		if (!this.actor.makeMiniboss())
		{
			return false;
		}

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

		this.m.Skills.add(::new("scripts/skills/perks/perk_colossus"));
		return true;
	}
});