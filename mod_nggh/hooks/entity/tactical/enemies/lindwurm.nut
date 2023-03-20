::mods_hookExactClass("entity/tactical/enemies/lindwurm", function(obj) 
{
	local onInit = obj.onInit;
	obj.onInit = function()
	{
		onInit();
		local chance = 25;

		if (!::Tactical.State.isScenarioMode() && ::World.getTime().Days >= 170)
		{
			chance = ::Math.min(100, chance + ::Math.max(10, ::World.getTime().Days - 170));
		}

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
		{
			chance = 75;
		}

		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggHLindwurmAcid, ::Const.Perks.PerkDefs.NggHLindwurmBody], chance);
	}

	obj.makeMiniboss <- function()
	{
		if (!this.actor.makeMiniboss())
		{
			return false;
		}

		this.m.BaseProperties.ActionPoints = 8;
		this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_lindwurm_body"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_lindwurm_acid"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_bloody_harvest"));

		if (this.m.Tail != null && !this.m.Tail.isNull())
		{
			this.m.Tail.makeMiniboss();
			this.m.Tail.m.Skills.add(::new("scripts/skills/perks/perk_nggh_lindwurm_body"));
			this.m.Tail.m.Skills.add(::new("scripts/skills/perks/perk_bloody_harvest"));
		}

		return true;
	}
});