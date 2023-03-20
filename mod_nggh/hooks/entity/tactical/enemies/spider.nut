::mods_hookExactClass("entity/tactical/enemies/spider", function(obj) 
{
	local onInit = obj.onInit;
	obj.onInit = function()
	{
		onInit();
		local chance = 15;

		if (!::Tactical.State.isScenarioMode() && ::World.getTime().Days >= 150)
		{
			chance = ::Math.min(100, chance + ::Math.max(10, ::World.getTime().Days - 150));
		}

		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggHSpiderWeb], chance - 25);

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
		{
			chance = 110;
		}

		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggHSpiderBite, ::Const.Perks.PerkDefs.NggHSpiderVenom], chance);
	}

	obj.makeMiniboss <- function()
	{
		if (!this.actor.makeMiniboss())
		{
			return false;
		}

		local b = this.m.BaseProperties;
		b.Hitpoints += 50;
		b.MeleeSkill += 15;
		b.MeleeDefense += 15;
		b.RangedDefense += 15;
		this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_spider_venom"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_spider_bite"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_dodge"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_nimble"));
		this.setHitpointsPct(1.0);
		return true;
	}
});