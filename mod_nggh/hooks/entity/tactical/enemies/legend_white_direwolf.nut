::Nggh_MagicConcept.HooksMod.hook("scripts/entity/tactical/enemies/legend_white_direwolf", function(q) 
{
	q.onInit = @(__original) function()
	{
		__original();
		local chance = 25;

		if (!::Tactical.State.isScenarioMode() && ::World.getTime().Days >= 100)
			chance = ::Math.min(100, chance + ::Math.max(10, ::World.getTime().Days - 100));

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
			chance = 100;

		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggHWolfBite, ::Const.Perks.PerkDefs.NggHWolfThickHide, ::Const.Perks.PerkDefs.NggHWolfEnrage], chance);
	}

	q.makeMiniboss <- function()
	{
		if (!actor.makeMiniboss())
			return false;

		getSkills().add(::new("scripts/skills/perks/perk_nggh_wolf_bite"));
		getSkills().add(::new("scripts/skills/perks/perk_nggh_wolf_thick_hide"));
		getSkills().add(::new("scripts/skills/perks/perk_nggh_wolf_enrage"));
		getSkills().add(::new("scripts/skills/actives/line_breaker"));
		return true;
	}
	
});