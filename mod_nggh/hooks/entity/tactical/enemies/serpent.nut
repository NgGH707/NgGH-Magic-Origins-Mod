::mods_hookExactClass("entity/tactical/enemies/serpent", function(obj) 
{
	local onInit = obj.onInit;
	obj.onInit = function()
	{
		onInit();
		local chance = 15;

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
			chance = 115;

		if (!::Tactical.State.isScenarioMode() && ::World.getTime().Days >= 50)
			chance = ::Math.min(100, chance + ::Math.max(5, ::World.getTime().Days - 50));

		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggHSerpentBite, ::Const.Perks.PerkDefs.NggHSerpentVenom], chance - 25);
		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggHSerpentDrag, ::Const.Perks.PerkDefs.NggHSerpentGiant], chance - 35);
	}

	obj.makeMiniboss <- function()
	{
		if (!this.actor.makeMiniboss())
			return false;

		local b = this.m.BaseProperties;
		b.ActionPoints += 1;
		b.Hitpoints += 25;
		b.MeleeSkill += 10;
		b.MeleeDefense += 5;
		b.RangedDefense += 15;
		this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_serpent_bite"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_serpent_drag"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_serpent_giant"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_nimble"));

		if (!::Tactical.State.isScenarioMode())
		{
			if (::World.getTime().Days >= 100)
				this.m.Skills.add(::new("scripts/skills/perks/perk_fearsome"));

			if (::World.getTime().Days >= 200)
				this.m.Skills.add(::new("scripts/skills/perks/perk_legend_ubernimble"));
		}

		this.setHitpointsPct(1.0);
		return true;
	}
});