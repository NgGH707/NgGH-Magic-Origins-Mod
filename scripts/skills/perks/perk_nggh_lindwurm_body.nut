this.perk_nggh_lindwurm_body <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lindwurm_body";
		this.m.Name = ::Const.Strings.PerkName.NggHLindwurmBody;
		this.m.Description = ::Const.Strings.PerkDescription.NggHLindwurmBody;
		this.m.Icon = "ui/perks/perk_lindwurm_body.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
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

