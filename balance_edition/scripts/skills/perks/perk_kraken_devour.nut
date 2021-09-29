this.perk_kraken_devour <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.kraken_devour";
		this.m.Name = this.Const.Strings.PerkName.KrakenDevour;
		this.m.Description = this.Const.Strings.PerkDescription.KrakenDevour;
		this.m.Icon = "ui/perks/perk_kraken_devour.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInGreatSwords = true;
	}

});

