this.perk_patting <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.patting";
		this.m.Name = this.Const.Strings.PerkName.PattingSpec;
		this.m.Description = this.Const.Strings.PerkDescription.PattingSpec;
		this.m.Icon = "ui/perks/perk_patting.png";
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

