this.perk_nggh_kraken_devour <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.kraken_devour";
		this.m.Name = ::Const.Strings.PerkName.NggHKrakenDevour;
		this.m.Description = ::Const.Strings.PerkDescription.NggHKrakenDevour;
		this.m.Icon = "ui/perks/perk_kraken_devour.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInGreatSwords = true;
	}

});

