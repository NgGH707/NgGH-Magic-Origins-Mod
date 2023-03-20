this.perk_nggh_luft_patting_mastery <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.patting";
		this.m.Name = ::Const.Strings.PerkName.NggHLuftPattingSpec;
		this.m.Description = ::Const.Strings.PerkDescription.NggHLuftPattingSpec;
		this.m.Icon = "ui/perks/perk_patting.png";
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

