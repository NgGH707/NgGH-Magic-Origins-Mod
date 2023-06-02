::mods_hookExactClass("entity/tactical/enemies/serpent", function(obj) 
{
	local onInit = obj.onInit;
	obj.onInit = function()
	{
		onInit();
		local chance = 15;

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
		{
			chance = 115;
		}

		if (!::Tactical.State.isScenarioMode() && ::World.getTime().Days >= 100)
		{
			chance = ::Math.min(100, chance + ::Math.max(5, ::World.getTime().Days - 100));
		}

		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggHSerpentBite, ::Const.Perks.PerkDefs.NggHSerpentVenom], chance - 15);
		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggHSerpentDrag, ::Const.Perks.PerkDefs.NggHSerpentGiant], chance);
	}

	obj.makeMiniboss <- function()
	{
		if (!this.actor.makeMiniboss())
		{
			return false;
		}

		local b = this.m.BaseProperties;
		b.ActionPoints += 1;
		b.Hitpoints += 25;
		b.MeleeSkill += 20;
		b.MeleeDefense += 15;
		b.RangedDefense += 15;
		this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_serpent_bite"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_serpent_drag"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_serpent_giant"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_nimble"));
		this.setHitpointsPct(1.0);
		return true;
	}
});