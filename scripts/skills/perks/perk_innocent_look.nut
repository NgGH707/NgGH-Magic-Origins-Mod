this.perk_innocent_look <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.words_charm";
		this.m.Name = this.Const.Strings.PerkName.InnocentLook;
		this.m.Description = this.Const.Strings.PerkDescription.InnocentLook;
		this.m.Icon = "ui/perks/perk_innocent_look.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
	
	function onUpdate( _properties )
	{
		_properties.BraveryMult *= 1.05;
		_properties.StaminaMult *= 1.05;
	}

});

