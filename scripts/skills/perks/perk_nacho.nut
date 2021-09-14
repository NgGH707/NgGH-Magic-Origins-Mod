this.perk_nacho <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.nacho";
		this.m.Name = this.Const.Strings.PerkName.Nacho;
		this.m.Description = this.Const.Strings.PerkDescription.Nacho;
		this.m.Icon = "ui/perks/perk_nacho.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.StaminaMult *= 1.05;
		_properties.IsSpecializedInShields = true;
	}

});

