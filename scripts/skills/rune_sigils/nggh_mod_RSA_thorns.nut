nggh_mod_RSA_thorns <- ::inherit("scripts/skills/skill", {
	m = {
		IsForceEnabled = false,
		Efficiency = 1.0,
		LastHitToBodyPart = ::Const.BodyPart.Body
	},
	function create()
	{
		::Legends.Effects.onCreate(this, ::Legends.Effect.NgGHRsaThorns);
		m.Description = "Rune Sigil: Thorns";
		m.Icon = "ui/rune_sigils/legend_rune_sigil.png";
		m.Type = ::Const.SkillType.Special | ::Const.SkillType.StatusEffect;
		m.Order = ::Const.SkillOrder.VeryLast;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = true;
	}

	function onUpdate( _properties )
	{
		if (!m.IsForceEnabled && ::MSU.isNull(getItem()))
			return;

		_properties.DamageReceivedArmorMult *= 1.25;
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		m.LastHitToBodyPart = _hitInfo.BodyPart;
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (_attacker == null || _damageArmor <= 0)
			return;

		if (m.LastHitToBodyPart != ::Const.BodyPart.Body)
			return;

		if (!m.IsForceEnabled && ::MSU.isNull(getItem()))
			return;

		if (!_attacker.isAlive() || _attacker.isDying())
			return;

		if (_attacker.getID() == this.getContainer().getActor().getID() || _attacker.getTile().getDistanceTo(this.getContainer().getActor().getTile()) > 2)
			return;

		if (_attacker.getCurrentProperties().IsImmuneToDamageReflection)
			return;

		local mult = ::Math.rand(35, 65) * 0.01 * m.Efficiency;
		local hitInfo = clone ::Const.Tactical.HitInfo;
		hitInfo.DamageRegular = _damageArmor * mult;
		hitInfo.DamageArmor = hitInfo.DamageRegular;
		hitInfo.DamageFatigue = 0;
		hitInfo.DamageDirect = ::Math.rand(25, 55) * 0.01 * m.Efficiency;
		hitInfo.BodyPart = ::Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(this.getContainer().getActor()) + "\'s [b]rune sigil of Thorns[/b] returns its favor back to " + ::Const.UI.getColorizedEntityName(_attacker));
		_attacker.onDamageReceived(this.getContainer().getActor(), this, hitInfo);
	}

});

