::mods_hookExactClass("entity/tactical/enemies/spider", function(obj) 
{
	local onInit = obj.onInit;
	obj.onInit = function()
	{
		onInit();
		local chance = 15;

		if (!::Tactical.State.isScenarioMode() && ::World.getTime().Days >= 150)
			chance = ::Math.min(100, chance + ::Math.max(10, ::World.getTime().Days - 150));

		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggH_Spider_Web, ::Const.Perks.PerkDefs.NggH_Spider_ToughCarapace], chance - 25);

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
			chance = 110;

		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggH_Spider_Bite, ::Const.Perks.PerkDefs.NggH_Spider_Venom], chance);
	}

	obj.makeMiniboss <- function()
	{
		if (!this.actor.makeMiniboss())
			return false;

		local b = this.m.BaseProperties;
		b.ActionPoints += 1;
		b.Hitpoints += 40;
		b.MeleeSkill += 10;
		b.MeleeDefense += 10;
		b.RangedDefense += 10;
		this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_spider_tough_carapace"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_spider_venom"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_spider_bite"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_dodge"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_nimble"));

		if (!::Tactical.State.isScenarioMode())
		{
			if (::World.getTime().Days >= 75)
				this.m.Skills.add(::new("scripts/skills/perks/perk_push_the_advantage"));

			if (::World.getTime().Days >= 150)
				this.m.Skills.add(::new("scripts/skills/perks/perk_legend_ubernimble"));
		}

		this.setHitpointsPct(1.0);
		return true;
	}
});