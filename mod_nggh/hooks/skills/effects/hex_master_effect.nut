::Nggh_MagicConcept.HooksMod.hook("scripts/skills/effects/hex_master_effect", function(q) 
{
	q.onDamageReceived = @() function(_attacker,_damageHitpoints,_damageArmor) {
		if (::MSU.isNull(m.Slave) || !m.Slave.isAlive()) {
			removeSelf();
			return;
		}

		if (_damageHitpoints > 0)
			m.Slave.applyDamage(_damageHitpoints, getContainer().getActor());

		if (::MSU.isNull(m.Slave) || !m.Slave.isAlive()) {
			removeSelf();
	}

});