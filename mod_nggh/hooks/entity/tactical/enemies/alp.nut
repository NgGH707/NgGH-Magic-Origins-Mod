::Nggh_MagicConcept.HooksMod.hook("scripts/entity/tactical/enemies/alp", function(q) 
{
	q.create = @(__original) function()
	{
		__original();
		m.Flags.set("auto_teleport", true);
	}

	q.onInit = @(__original) function()
	{
		__original();
		local chance = 15;

		if (!::Tactical.State.isScenarioMode() && ::World.getTime().Days >= 120)
			chance = ::Math.min(100, chance + ::Math.max(1, ::World.getTime().Days - 120));

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
			chance = 110;

		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggHAlpSleepSpec, ::Const.Perks.PerkDefs.NggHAlpNightmareSpec], chance - 10);
		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggHAlpAfterimage], chance - 5);
		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggHAlpAfterWake], chance);
	}

	q.makeMiniboss <- function()
	{
		if (!actor.makeMiniboss())
			return false;

		local b = m.BaseProperties;
		b.MeleeDefense += 10;
		b.RangedDefense += 15;
		b.DamageReceivedRegularMult *= 0.85;
		m.Skills.add(::new("scripts/skills/perks/perk_nggh_alp_nightmare_mastery"));
		m.Skills.add(::new("scripts/skills/perks/perk_nggh_alp_sleep_mastery"));
		getAIAgent().addBehavior(::new("scripts/ai/tactical/behaviors/ai_darkflight"));

		if (!::Tactical.State.isScenarioMode()) {
			if (::World.getTime().Days >= 125)
				this.m.Skills.add(::new("scripts/skills/perks/perk_nimble"));

			if (::World.getTime().Days >= 250)
				this.m.Skills.add(::new("scripts/skills/perks/perk_fortified_mind"));
		}

		return true;
	}
});