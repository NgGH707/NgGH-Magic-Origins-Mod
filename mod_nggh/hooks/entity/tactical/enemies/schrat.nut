::Nggh_MagicConcept.HooksMod.hook("scripts/entity/tactical/enemies/schrat", function(q) 
{
	q.onInit = @(__original) function()
	{
		__original();
		local chance = 25;

		if (!::Tactical.State.isScenarioMode() && ::World.getTime().Days >= 150)
			chance = ::Math.min(100, chance + ::Math.max(10, ::World.getTime().Days - 150));

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
			chance = 100;

		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggHSchratShield, ::Const.Perks.PerkDefs.NggHSchratUproot, ::Const.Perks.PerkDefs.NggHSchratUprootAoE], chance);
	}

	if (!q.contains("makeMiniboss")) {
		q.makeMiniboss <- function()
		{
			if (!actor.makeMiniboss())
				return false;

			getSkills().add(::new("scripts/skills/perks/perk_nggh_schrat_grow_shield"));
			getSkills().add(::new("scripts/skills/perks/perk_nggh_schrat_uproot_aoe"));
			return true;
		}
	}
	else {
		q.makeMiniboss = function()
		{
			if (!actor.makeMiniboss())
				return false;

			getSkills().add(::new("scripts/skills/perks/perk_nggh_schrat_grow_shield"));
			getSkills().add(::new("scripts/skills/perks/perk_nggh_schrat_uproot_aoe"));
			return true;
		}
	}
	
});