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
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_hitInfo.DamageRegular != 0)
		{
			_hitInfo.DamageRegular = this.Math.maxf(0.0, _hitInfo.DamageRegular - 10);
		}

		if (_hitInfo.DamageArmor != 0)
		{
			_hitInfo.DamageArmor = this.Math.maxf(0.0, _hitInfo.DamageArmor - 10);
		}

		if (_hitInfo.DamageMinimum != 0)
		{
			_hitInfo.DamageMinimum = this.Math.maxf(0.0, _hitInfo.DamageMinimum - 10);
		}
	}

});

