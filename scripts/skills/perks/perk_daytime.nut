this.perk_daytime <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.daytime";
		this.m.Name = this.Const.Strings.PerkName.Daytime;
		this.m.Description = this.Const.Strings.PerkDescription.Daytime;
		this.m.Icon = "skills/status_effect_daytime.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += 10;
	}

});

