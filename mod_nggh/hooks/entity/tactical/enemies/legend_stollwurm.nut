::Nggh_MagicConcept.HooksMod.hook("scripts/entity/tactical/enemies/legend_stollwurm", function(q) 
{
	q.onInit = @(__original) function()
	{
		__original();
		local chance = 10;

		if (!::Tactical.State.isScenarioMode() && ::World.getTime().Days >= 200)
			chance = ::Math.min(100, chance + ::Math.max(10, ::World.getTime().Days - 200));

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
			chance = 100;

		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggHLindwurmAcid], chance);
		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggHLindwurmBody], chance + 15);
	}

	q.makeMiniboss <- function()
	{
		if (!actor.makeMiniboss())
			return false;

		getSkills().add(::new("scripts/skills/perks/perk_nggh_lindwurm_acid"));
		getSkills().add(::new("scripts/skills/perks/perk_nggh_lindwurm_body"));
		getSkills().add(::new("scripts/skills/perks/perk_colossus"));
		getSkills().add(::new("scripts/skills/perks/perk_legend_rebound"));

		if (!::MSU.isNull(m.Tail)) {
			m.Tail.makeMiniboss();
			m.Tail.getSkills().add(::new("scripts/skills/perks/perk_nggh_lindwurm_body"));
			m.Tail.getSkills().add(::new("scripts/skills/perks/perk_colossus"));
			m.Tail.getSkills().add(::new("scripts/skills/perks/perk_legend_rebound"));
		}

		return true;
	}
});