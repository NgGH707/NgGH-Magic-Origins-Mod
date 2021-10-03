this.legend_RSA_thorns <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "special.legend_RSA_thorns";
		this.m.Name = "Rune Sigil: Thorns";
		this.m.Description = "Rune Sigil: Thorns";
		this.m.Icon = "ui/rune_sigils/legend_rune_sigil.png";
		this.m.Type = this.Const.SkillType.Special | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}

	function onUpdate( _properties )
	{
		if (this.getItem() == null)
		{
			return;
		}

		_properties.DamageReceivedArmorMult *= 1.25;
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (this.getItem() == null || _attacker == null)
		{
			return;
		}

		if (!_attacker.isAlive() || _attacker.isDying())
		{
			return;
		}

		if (_attacker.getID() == this.getContainer().getActor().getID() || _attacker.getTile().getDistanceTo(this.getContainer().getActor().getTile()) > 2)
		{
			return;
		}

		if (_attacker.getCurrentProperties().IsImmuneToDamageReflection)
		{
			return;
		}

		if (_damageArmor > 0)
		{
			local mult = this.Math.rand(35, 65) * 0.01;
			local hitInfo = clone this.Const.Tactical.HitInfo;
			hitInfo.DamageRegular = _damageArmor * mult;
			hitInfo.DamageArmor = hitInfo.DamageRegular;
			hitInfo.DamageFatigue = 0;
			hitInfo.DamageDirect = this.Math.rand(25, 55) * 0.01;
			hitInfo.BodyPart = this.Const.BodyPart.Body;
			hitInfo.BodyDamageMult = 1.0;
			hitInfo.FatalityChanceMult = 0.0;
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + "\'s [b]rune sigil of Thorns[/b] returns its favor back to " + this.Const.UI.getColorizedEntityName(_attacker));
			_attacker.onDamageReceived(this.getContainer().getActor(), this, hitInfo);
		}
	}

});

