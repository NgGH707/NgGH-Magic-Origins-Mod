this.perk_lindwurm_acid <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lindwurm_acid";
		this.m.Name = this.Const.Strings.PerkName.LindwurmAcid;
		this.m.Description = this.Const.Strings.PerkDescription.LindwurmAcid;
		this.m.Icon = "ui/perks/perk_lindwurm_acid.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.m.Container.hasSkill("actives.lindwurm_acid"))
		{
			this.m.Container.add(this.new("scripts/skills/actives/spit_acid_skill"));
		}
	}

	function onRemoved()
	{
		this.m.Container.removeByID("actives.lindwurm_acid");
	}

});

