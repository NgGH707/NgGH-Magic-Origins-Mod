this.fake_champion_racial <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "racial.champion";
		this.m.Name = "Champion";
		this.m.Description = "";
		this.m.Icon = "skills/status_effect_108.png";
		this.m.IconMini = "status_effect_108_mini";
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.First;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.DamageTotalMult *= 1.15;
	}

});

