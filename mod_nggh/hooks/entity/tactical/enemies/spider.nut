::Nggh_MagicConcept.HooksMod.hook("scripts/entity/tactical/enemies/spider", function(q) 
{
	q.onInit = @(__original) function()
	{
		__original();
		local chance = 15;

		if (!::Tactical.State.isScenarioMode() && ::World.getTime().Days >= 150)
			chance = ::Math.min(100, chance + ::Math.max(10, ::World.getTime().Days - 150));

		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggH_Spider_Web, ::Const.Perks.PerkDefs.NggH_Spider_ToughCarapace], chance - 25);

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
			chance = 110;

		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggH_Spider_Bite, ::Const.Perks.PerkDefs.NggH_Spider_Venom], chance);
	}

	q.makeMiniboss <- function()
	{
		if (!actor.makeMiniboss())
			return false;

		local b = m.BaseProperties;
		b.ActionPoints += 1;
		b.Hitpoints += 40;
		b.MeleeSkill += 10;
		b.MeleeDefense += 10;
		b.RangedDefense += 10;
		getSkills().add(::new("scripts/skills/perks/perk_nggh_spider_tough_carapace"));
		getSkills().add(::new("scripts/skills/perks/perk_nggh_spider_venom"));
		getSkills().add(::new("scripts/skills/perks/perk_nggh_spider_bite"));
		getSkills().add(::new("scripts/skills/perks/perk_dodge"));
		getSkills().add(::new("scripts/skills/perks/perk_nimble"));

		if (!::Tactical.State.isScenarioMode()) {
			if (::World.getTime().Days >= 75)
				getSkills().add(::new("scripts/skills/perks/perk_legend_push_the_advantage"));

			if (::World.getTime().Days >= 150)
				getSkills().add(::new("scripts/skills/perks/perk_legend_ubernimble"));
		}

		setHitpointsPct(1.0);
		return true;
	}
	
});