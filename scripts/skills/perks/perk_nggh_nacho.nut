this.perk_nggh_nacho <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.nacho";
		this.m.Name = ::Const.Strings.PerkName.NggHNacho;
		this.m.Description = ::Const.Strings.PerkDescription.NggHNacho;
		this.m.Icon = "ui/perks/perk_nacho.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.StaminaMult *= 1.1;
		_properties.IsSpecializedInShields = true;
	}

});

