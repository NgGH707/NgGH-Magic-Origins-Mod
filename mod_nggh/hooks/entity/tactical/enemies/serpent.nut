::Nggh_MagicConcept.HooksMod.hook("scripts/entity/tactical/enemies/serpent", function(q) 
{
	q.onInit = @(__original) function()
	{
		__original();
		local chance = 15;

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
			chance = 115;

		if (!::Tactical.State.isScenarioMode() && ::World.getTime().Days >= 50)
			chance = ::Math.min(100, chance + ::Math.max(5, ::World.getTime().Days - 50));

		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggHSerpentBite, ::Const.Perks.PerkDefs.NggHSerpentVenom], chance - 25);
		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggHSerpentDrag, ::Const.Perks.PerkDefs.NggHSerpentGiant], chance - 35);
	}

	q.makeMiniboss <- function()
	{
		if (!actor.makeMiniboss())
			return false;

		local b = m.BaseProperties;
		b.ActionPoints += 1;
		b.Hitpoints += 25;
		b.MeleeSkill += 10;
		b.MeleeDefense += 5;
		b.RangedDefense += 15;
		getSkills().add(::new("scripts/skills/perks/perk_nggh_serpent_bite"));
		getSkills().add(::new("scripts/skills/perks/perk_nggh_serpent_drag"));
		getSkills().add(::new("scripts/skills/perks/perk_nggh_serpent_giant"));
		getSkills().add(::new("scripts/skills/perks/perk_nimble"));

		if (!::Tactical.State.isScenarioMode()) {
			if (::World.getTime().Days >= 100)
				getSkills().add(::new("scripts/skills/perks/perk_fearsome"));

			if (::World.getTime().Days >= 200)
				getSkills().add(::new("scripts/skills/perks/perk_legend_ubernimble"));
		}

		setHitpointsPct(1.0);
		return true;
	}
});