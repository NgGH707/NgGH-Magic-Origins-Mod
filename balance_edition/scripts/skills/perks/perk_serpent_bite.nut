this.perk_serpent_bite <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.serpent_bite";
		this.m.Name = this.Const.Strings.PerkName.SerpentBite;
		this.m.Description = this.Const.Strings.PerkDescription.SerpentBite;
		this.m.Icon = "ui/perks/perk_serpent_bite.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInPolearms = true;
	}

});

