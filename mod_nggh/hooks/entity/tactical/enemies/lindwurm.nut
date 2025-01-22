::Nggh_MagicConcept.HooksMod.hook("scripts/entity/tactical/enemies/lindwurm", function(q) 
{
	q.onInit = @(__original) function()
	{
		__original();
		local chance = 25;

		if (!::Tactical.State.isScenarioMode() && ::World.getTime().Days >= 170)
			chance = ::Math.min(100, chance + ::Math.max(10, ::World.getTime().Days - 170));

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
			chance = 75;

		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggHLindwurmAcid, ::Const.Perks.PerkDefs.NggHLindwurmBody], chance);
	}

	q.makeMiniboss <- function()
	{
		if (!actor.makeMiniboss())
			return false;

		m.BaseProperties.ActionPoints = 8;
		getSkills().add(::new("scripts/skills/perks/perk_nggh_lindwurm_body"));
		getSkills().add(::new("scripts/skills/perks/perk_nggh_lindwurm_acid"));
		getSkills().add(::new("scripts/skills/perks/perk_legend_bloody_harvest"));

		if (!::MSU.isNull(m.Tail)) {
			m.Tail.makeMiniboss();
			m.Tail.getSkills().add(::new("scripts/skills/perks/perk_nggh_lindwurm_body"));
			m.Tail.getSkills().add(::new("scripts/skills/perks/perk_legend_bloody_harvest"));
		}

		if (!::Tactical.State.isScenarioMode() && ::World.getTime().Days >= 150)
			getSkills().add(::new("scripts/skills/perks/perk_colossus"));

		return true;
	}
});