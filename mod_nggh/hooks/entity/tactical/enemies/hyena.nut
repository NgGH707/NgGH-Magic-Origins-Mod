::Nggh_MagicConcept.HooksMod.hook("scripts/entity/tactical/enemies/hyena", function(q) 
{
	q.onInit = @(__original) function()
	{
		__original();
		local chance = 25;

		if (!::Tactical.State.isScenarioMode() && ::World.getTime().Days >= 50)
			chance = ::Math.min(100, chance + ::Math.max(10, ::World.getTime().Days - 50));

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
			chance = 100;

		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggHHyenaBite, ::Const.Perks.PerkDefs.NggHWolfEnrage], chance - 35);
		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggHWolfThickHide], chance - 20);
	}

	q.makeMiniboss <- function()
	{
		if (!actor.makeMiniboss())
			return false;

		local b = m.BaseProperties;
		b.ActionPoints += 2;
		b.MeleeSkill += 10;
		b.MeleeDefense += 10;
		b.Bravery += 25;
		getSkills().add(::new("scripts/skills/perks/perk_nggh_hyena_bite"));
		getSkills().add(::new("scripts/skills/perks/perk_nggh_wolf_thick_hide"));
		getSkills().add(::new("scripts/skills/perks/perk_nggh_wolf_enrage"));
		//getSkills().add(::new("scripts/skills/perks/perk_fearsome"));
		getSkills().add(::new("scripts/skills/actives/line_breaker"));

		if (!::Tactical.State.isScenarioMode()) {
			if (::World.getTime().Days >= 75)
				getSkills().add(::new("scripts/skills/perks/perk_overwhelm"));

			if (::World.getTime().Days >= 100)
				getSkills().add(::new("scripts/skills/perks/perk_nimble"));
		}

		return true;
	}
});