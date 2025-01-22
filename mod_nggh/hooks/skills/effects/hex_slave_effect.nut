::Nggh_MagicConcept.HooksMod.hook("scripts/skills/effects/hex_slave_effect", function(q) 
{
	q.applyDamage = @() function(_damage , _caster)
	{
		if (m.SoundOnUse.len() != 0)
			::Sound.play(::MSU.Array.rand(m.SoundOnUse), ::Const.Sound.Volume.RacialEffect * 1.25, getContainer().getActor().getPos());

		if (::MSU.isNull(_caster))
			_caster = getContainer().getActor();

		if (::MSU.isIn("getMaster", _caster, true) && !::MSU.isNull(_caster.getMaster()) && _caster.getMaster().isAlive() && !_caster.getMaster().isDying())
			_caster = _caster.getMaster();

		local hitInfo = clone ::Const.Tactical.HitInfo;
		hitInfo.DamageRegular = _damage;
		hitInfo.DamageDirect = 1.0;
		hitInfo.BodyPart = ::Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		getContainer().getActor().onDamageReceived(_caster, this, hitInfo);
	}
	
});