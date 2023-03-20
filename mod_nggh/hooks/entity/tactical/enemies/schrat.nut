::mods_hookExactClass("entity/tactical/enemies/schrat", function(obj) 
{
	local onInit = obj.onInit;
	obj.onInit = function()
	{
		onInit();
		local chance = 25;

		if (!::Tactical.State.isScenarioMode() && ::World.getTime().Days >= 150)
		{
			chance = ::Math.min(100, chance + ::Math.max(10, ::World.getTime().Days - 150));
		}

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
		{
			chance = 100;
		}

		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggHSchratShield, ::Const.Perks.PerkDefs.NggHSchratUproot, ::Const.Perks.PerkDefs.NggHSchratUprootAoE], chance);
	}

	if (!("makeMiniboss" in obj))
	{
		obj.makeMiniboss <- function()
		{
			if (!this.actor.makeMiniboss())
			{
				return false;
			}

			this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_schrat_grow_shield"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_schrat_uproot_aoe"));
			return true;
		}
	}
	else
	{
		obj.makeMiniboss = function()
		{
			if (!this.actor.makeMiniboss())
			{
				return false;
			}

			this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_schrat_grow_shield"));
			this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_schrat_uproot_aoe"));
			return true;
		}
	}
	
});