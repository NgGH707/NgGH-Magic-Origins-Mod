this.perk_nggh_lindwurm_acid <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lindwurm_acid";
		this.m.Name = ::Const.Strings.PerkName.NggHLindwurmAcid;
		this.m.Description = ::Const.Strings.PerkDescription.NggHLindwurmAcid;
		this.m.Icon = "ui/perks/perk_lindwurm_acid.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.getContainer().hasSkill("actives.spit_acid"))
		{
			this.getContainer().add(::new("scripts/skills/actives/nggh_mod_spit_acid_skill"));
		}
	}

	function onRemoved()
	{
		this.getContainer().removeByID("actives.spit_acid");
	}

});

