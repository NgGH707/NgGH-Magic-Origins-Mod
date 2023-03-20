this.perk_nggh_misc_daytime <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.daytime";
		this.m.Name = ::Const.Strings.PerkName.NggHMiscDaytime;
		this.m.Description = ::Const.Strings.PerkDescription.NggHMiscDaytime;
		this.m.Icon = "skills/status_effect_daytime.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += 10;
	}

});

