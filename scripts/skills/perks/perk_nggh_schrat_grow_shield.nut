this.perk_nggh_schrat_grow_shield <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.grow_shield";
		this.m.Name = ::Const.Strings.PerkName.NggHSchratShield;
		this.m.Description = ::Const.Strings.PerkDescription.NggHSchratShield;
		this.m.Icon = "ui/perks/perk_grow_shield.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInHammers = true;
	}

});

