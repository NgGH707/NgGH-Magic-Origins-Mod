this.perk_nggh_serpent_bite <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.serpent_bite";
		this.m.Name = ::Const.Strings.PerkName.NggHSerpentBite;
		this.m.Description = ::Const.Strings.PerkDescription.NggHSerpentBite;
		this.m.Icon = "ui/perks/perk_serpent_bite.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInPolearms = true;
	}

});

