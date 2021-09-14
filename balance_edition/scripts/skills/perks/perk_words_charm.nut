this.perk_words_charm <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.words_charm";
		this.m.Name = this.Const.Strings.PerkName.CharmWord;
		this.m.Description = this.Const.Strings.PerkDescription.CharmWord;
		this.m.Icon = "ui/perks/perk_words_charm.png";
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

