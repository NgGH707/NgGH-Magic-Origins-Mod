::Nggh_MagicConcept.HooksMod.hook("scripts/entity/tactical/enemies/legend_redback_spider", function(q) 
{
	q.onInit = @(__original) function()
	{
		__original();
		local chance = 25;

		if (!::Tactical.State.isScenarioMode() && ::World.getTime().Days >= 140)
			chance = ::Math.min(100, chance + ::Math.max(10, ::World.getTime().Days - 140));

		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggH_Spider_Web, ::Const.Perks.PerkDefs.NggH_Spider_ToughCarapace], chance - 25);

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
			chance = 100;

		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggH_Spider_Venom], chance - 10);
	}

	q.makeMiniboss <- function()
	{
		if (!actor.makeMiniboss())
			return false;

		m.BaseProperties.MeleeDefense += 5;
		getSkills().add(::new("scripts/skills/perks/perk_nggh_spider_tough_carapace"));
		getSkills().add(::new("scripts/skills/perks/perk_nggh_spider_web"));
		getSkills().add(::new("scripts/skills/perks/perk_legend_push_the_advantage"));
		getSkills().add(::new("scripts/skills/perks/perk_fearsome"));	

		if (!getSkills().hasSkill("perk.spider_bite")) {
			if (::Math.rand(1, 10) <= 5)
				getSkills().add(::new("scripts/skills/perks/perk_nggh_spider_bite"));
			else
				getSkills().add(::new("scripts/skills/perks/perk_dodge"));
		}

		return true;
	}
	
});