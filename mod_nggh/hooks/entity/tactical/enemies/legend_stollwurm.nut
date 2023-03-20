::mods_hookExactClass("entity/tactical/enemies/legend_stollwurm", function(obj) 
{
	local onInit = obj.onInit;
	obj.onInit = function()
	{
		onInit();
		local chance = 10;

		if (!::Tactical.State.isScenarioMode() && ::World.getTime().Days >= 200)
		{
			chance = ::Math.min(100, chance + ::Math.max(10, ::World.getTime().Days - 200));
		}

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
		{
			chance = 100;
		}

		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggHLindwurmAcid], chance);
		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggHLindwurmBody], chance + 15);
	}

	obj.makeMiniboss <- function()
	{
		if (!this.actor.makeMiniboss())
		{
			return false;
		}

		this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_lindwurm_acid"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_lindwurm_body"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_colossus"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_rebound"));

		if (this.m.Tail != null && !this.m.Tail.isNull())
		{
			this.m.Tail.makeMiniboss();
			this.m.Tail.m.Skills.add(::new("scripts/skills/perks/perk_nggh_lindwurm_body"));
			this.m.Tail.m.Skills.add(::new("scripts/skills/perks/perk_colossus"));
			this.m.Tail.m.Skills.add(::new("scripts/skills/perks/perk_rebound"));
		}

		return true;
	}
});