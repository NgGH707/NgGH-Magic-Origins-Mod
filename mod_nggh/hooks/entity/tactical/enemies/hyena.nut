::mods_hookExactClass("entity/tactical/enemies/hyena", function(obj) 
{
	local onInit = obj.onInit;
	obj.onInit = function()
	{
		onInit();
		local chance = 25;

		if (!::Tactical.State.isScenarioMode() && ::World.getTime().Days >= 100)
		{
			chance = ::Math.min(100, chance + ::Math.max(10, ::World.getTime().Days - 100));
		}

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
		{
			chance = 100;
		}

		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggHHyenaBite, ::Const.Perks.PerkDefs.NggHWolfThickHide, ::Const.Perks.PerkDefs.NggHWolfEnrage], chance);
	}

	obj.makeMiniboss <- function()
	{
		if (!this.actor.makeMiniboss())
		{
			return false;
		}

		local b = this.m.BaseProperties;
		b.MeleeSkill += 15;
		b.MeleeDefense += 10;
		b.Bravery += 25;
		this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_wolf_enrage"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_hyena_bite"));
		this.m.Skills.add(::new("scripts/skills/actives/line_breaker"));
		return true;
	}
});