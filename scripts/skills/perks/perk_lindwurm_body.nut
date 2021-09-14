this.perk_lindwurm_body <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lindwurm_body";
		this.m.Name = this.Const.Strings.PerkName.LindwurmBody;
		this.m.Description = this.Const.Strings.PerkDescription.LindwurmBody;
		this.m.Icon = "ui/perks/perk_lindwurm_body.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInAxes = true;
		_properties.DamageTotalMult *= 1.1;
	}

});

