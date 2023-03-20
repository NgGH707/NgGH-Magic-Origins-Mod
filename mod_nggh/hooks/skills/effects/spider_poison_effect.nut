::mods_hookExactClass("skills/effects/spider_poison_effect", function(obj) 
{
	obj.m.ActorID <- null;
	obj.m.Count <- 1;
	
	obj.getName <- function()
	{
		if (this.m.Count <= 1)
		{
			return this.m.Name;
		}
		else
		{
			return this.m.Name + " (x" + this.m.Count + ")";
		}
	}
	obj.setActorID <- function( _id )
	{
   		this.m.ActorID = _id;
   	};
   	obj.getDamage = function()
	{
		return this.m.Damage + 5 * (this.m.Count - 1);
	}
   	obj.applyDamage = function()
	{
		if (this.m.LastRoundApplied != ::Time.getRound())
		{
			this.m.LastRoundApplied = ::Time.getRound();
			this.spawnIcon("status_effect_54", this.getContainer().getActor().getTile());

			if (this.m.SoundOnUse.len() != 0)
			{
				::Sound.play(::MSU.Array.rand(this.m.SoundOnUse), ::Const.Sound.Volume.RacialEffect * 1.0, this.getContainer().getActor().getPos());
			}

			local hitInfo = clone ::Const.Tactical.HitInfo;
			hitInfo.DamageRegular = this.getDamage();

			if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
			{
				hitInfo.DamageRegular = 1.5 * this.m.Damage;
			}

			local attacker = this.getContainer().getActor();
			hitInfo.DamageDirect = 1.0;
			hitInfo.BodyPart = ::Const.BodyPart.Body;
			hitInfo.BodyDamageMult = 1.0;
			hitInfo.FatalityChanceMult = 0.0;

			if (this.m.ActorID != null)
			{
				local e = ::Tactical.getEntityByID(this.m.ActorID);

				if (e != null && e.isPlacedOnMap() && e.isAlive() && !e.isDying())
				{
					attacker = e;
				}
			}

			this.getContainer().getActor().onDamageReceived(attacker, this, hitInfo);
		}
	};
});