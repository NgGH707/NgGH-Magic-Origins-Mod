::mods_hookExactClass("entity/tactical/enemies/legend_redback_spider", function(obj) 
{
	local onInit = obj.onInit;
	obj.onInit = function()
	{
		onInit();
		local chance = 25;

		if (!::Tactical.State.isScenarioMode() && ::World.getTime().Days >= 135)
			chance = ::Math.min(100, chance + ::Math.max(10, ::World.getTime().Days - 135));

		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggH_Spider_Web], chance - 25);

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
			chance = 100;

		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggH_Spider_Bite, ::Const.Perks.PerkDefs.NggH_Spider_Venom], chance);
	}

	obj.makeMiniboss <- function()
	{
		if (!this.actor.makeMiniboss())
			return false;

		this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_spider_bite"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_spider_web"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_fearsome"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_dodge"));
		return true;
	}
});