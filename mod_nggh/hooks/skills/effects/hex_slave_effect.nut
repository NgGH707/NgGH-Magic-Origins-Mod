::mods_hookExactClass("skills/effects/hex_slave_effect", function(obj) 
{
	obj.applyDamage = function(_damage , _caster)
	{
		if (this.m.SoundOnUse.len() != 0)
		{
			::Sound.play(::MSU.Array.rand(this.m.SoundOnUse), ::Const.Sound.Volume.RacialEffect * 1.25, this.getContainer().getActor().getPos());
		}

		if (_caster == null || _caster.isNull())
		{
			_caster = this.getContainer().getActor();
		}

		if (typeof _caster == "instance")
		{
			_caster = _caster.get();
		}

		if (("getMaster" in _caster) && _caster.getMaster() != null && !_caster.getMaster().isNull() && _caster.getMaster().isAlive() && !_caster.getMaster().isDying())
		{
			_caster = _caster.getMaster();
		}

		local hitInfo = clone ::Const.Tactical.HitInfo;
		hitInfo.DamageRegular = _damage;
		hitInfo.DamageDirect = 1.0;
		hitInfo.BodyPart = ::Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		this.getContainer().getActor().onDamageReceived(_caster, this, hitInfo);
	}
});