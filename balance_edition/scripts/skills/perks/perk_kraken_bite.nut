this.perk_kraken_bite <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.kraken_bite";
		this.m.Name = this.Const.Strings.PerkName.KrakenBite;
		this.m.Description = this.Const.Strings.PerkDescription.KrakenBite;
		this.m.Icon = "ui/perks/perk_kraken_bite.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInCleavers = true;
	}

});

