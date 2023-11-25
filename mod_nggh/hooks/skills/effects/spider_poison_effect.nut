::mods_hookExactClass("skills/effects/spider_poison_effect", function(obj) 
{
	obj.m.ActorID <- null;
	obj.m.IsSuperPoison <- false;
	
	obj.onUpdate <- function( _properties )
	{
		if (!this.m.IsSuperPoison)
			return;

		_properties.IsWeakenByPoison = true;
		_properties.FatigueEffectMult *= 1.05;
	};
	obj.setActorID <- function( _id )
	{
   		this.m.ActorID = _id;
   	};
   	obj.applyDamage = function()
	{
		if (this.m.LastRoundApplied != ::Time.getRound())
		{
			this.m.LastRoundApplied = ::Time.getRound();
			this.spawnIcon("status_effect_54", this.getContainer().getActor().getTile());

			if (this.m.SoundOnUse.len() != 0)
				::Sound.play(::MSU.Array.rand(this.m.SoundOnUse), ::Const.Sound.Volume.RacialEffect * 1.0, this.getContainer().getActor().getPos());

			local attacker = this.getContainer().getActor();
			local hitInfo = clone ::Const.Tactical.HitInfo;
			hitInfo.DamageRegular = this.getDamage();
			hitInfo.DamageDirect = 1.0;
			hitInfo.BodyPart = ::Const.BodyPart.Body;
			hitInfo.BodyDamageMult = 1.0;
			hitInfo.FatalityChanceMult = 0.0;

			if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
				hitInfo.DamageRegular *= 1.25;

			if (this.m.ActorID != null)
			{
				local e = ::Tactical.getEntityByID(this.m.ActorID);

				if (e != null && e.isPlacedOnMap() && e.isAlive() && !e.isDying())
					attacker = e;
			}

			this.getContainer().getActor().onDamageReceived(attacker, this, hitInfo);
		}
	};
});