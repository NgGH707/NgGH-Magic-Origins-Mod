this.perk_grow_shield <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.grow_shield";
		this.m.Name = this.Const.Strings.PerkName.SchratShield;
		this.m.Description = this.Const.Strings.PerkDescription.SchratShield;
		this.m.Icon = "ui/perks/perk_grow_shield.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInHammers = true;
	}

});

