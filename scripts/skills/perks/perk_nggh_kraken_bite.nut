this.perk_nggh_kraken_bite <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.kraken_bite";
		this.m.Name = ::Const.Strings.PerkName.NggHKrakenBite;
		this.m.Description = ::Const.Strings.PerkDescription.NggHKrakenBite;
		this.m.Icon = "ui/perks/perk_kraken_bite.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInCleavers = true;
	}

});

