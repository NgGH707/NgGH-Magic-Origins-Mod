this.perk_kraken_tentacle <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.kraken_tentacle";
		this.m.Name = this.Const.Strings.PerkName.KrakenTentacle;
		this.m.Description = this.Const.Strings.PerkDescription.KrakenTentacle;
		this.m.Icon = "ui/perks/perk_kraken_tentacle.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsImmuneToBleeding = true;
		_properties.DamageRegularReduction += 10;
		_properties.DamageArmorReduction += 10
	}

});

