this.perk_nggh_kraken_tentacle <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.kraken_tentacle";
		this.m.Name = ::Const.Strings.PerkName.NggHKrakenTentacle;
		this.m.Description = ::Const.Strings.PerkDescription.NggHKrakenTentacle;
		this.m.Icon = "ui/perks/perk_kraken_tentacle.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsImmuneToBleeding = true;
		_properties.DamageRegularReduction += 15;
		_properties.DamageArmorReduction += 15;
	}

});

