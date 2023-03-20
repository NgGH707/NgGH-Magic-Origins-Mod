this.perk_nggh_wolf_bite <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.wolf_bite";
		this.m.Name = ::Const.Strings.PerkName.NggHWolfBite;
		this.m.Description = ::Const.Strings.PerkDescription.NggHWolfBite;
		this.m.Icon = "ui/perks/perk_wolf_bite.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInSwords = true;
	}

});

