::mods_hookExactClass("entity/tactical/enemies/alp", function(obj) 
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Flags.set("auto_teleport", true);
	}

	local onInit = obj.onInit;
	obj.onInit = function()
	{
		onInit();
		local chance = 15;

		if (!::Tactical.State.isScenarioMode() && ::World.getTime().Days >= 120)
		{
			chance = ::Math.min(100, chance + ::Math.max(1, ::World.getTime().Days - 120));
		}

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
		{
			chance = 110;
		}

		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggHAlpSleepSpec, ::Const.Perks.PerkDefs.NggHAlpNightmareSpec], chance - 10);
		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggHAlpAfterimage], chance - 5);
		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggHAlpAfterWake], chance);
	}

	obj.makeMiniboss <- function()
	{
		if (!this.actor.makeMiniboss())
		{
			return false;
		}

		local b = this.m.BaseProperties;
		b.MeleeDefense += 15;
		b.RangedDefense += 15;
		b.DamageReceivedRegularMult *= 0.85;
		this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_alp_nightmare_mastery"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_alp_sleep_mastery"));
		this.getAIAgent().addBehavior(::new("scripts/ai/tactical/behaviors/ai_darkflight"));
		return true;
	}
});