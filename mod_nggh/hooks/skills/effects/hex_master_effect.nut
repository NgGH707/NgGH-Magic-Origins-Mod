::mods_hookExactClass("skills/effects/hex_master_effect", function(obj) 
{
	obj.onDamageReceived = function(_attacker,_damageHitpoints,_damageArmor)
	{
		if (this.m.Slave == null || this.m.Slave.isNull() || !this.m.Slave.isAlive())
		{
			this.removeSelf();
			return;
		}

		if (_damageHitpoints > 0)
		{
			this.m.Slave.applyDamage(_damageHitpoints, this.getContainer().getActor());
		}

		if (this.m.Slave == null || this.m.Slave.isNull() || !this.m.Slave.isAlive())
		{
			this.removeSelf();
		}
	}
});