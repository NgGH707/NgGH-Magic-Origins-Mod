::mods_hookExactClass("skills/effects/sleeping_effect", function(obj)
{
	obj.m.PreventWakeUp <- false;
	obj.m.AppliedMoraleCheck <- false;

	obj.onRemoved = function()
	{
		local actor = this.getContainer().getActor();

		if (actor.hasSprite("status_stunned"))
		{
			actor.getSprite("status_stunned").Visible = false;
		}

		actor.getFlags().set("Sleeping", false);
		
		if (actor.getFlags().has("human"))
		{
			if (actor.hasSprite("closed_eyes"))
			{
				actor.getSprite("closed_eyes").Visible = false;
			}
			
			if ("setEyesClosed" in actor.get())
			{
				actor.setEyesClosed(false);
			}
		}

		actor.setDirty(true);
		
		if (this.m.AppliedMoraleCheck && actor.isAlive() && !actor.isDying())
		{
			actor.checkMorale(-1, -10, ::Const.MoraleCheckType.MentalAttack);
		}
	};
	obj.onUpdate = function( _properties )
	{
		local actor = this.getContainer().getActor();
		_properties.IsStunned = true;
		_properties.Initiative -= 100;

		if (actor.hasSprite("status_stunned"))
		{
			actor.getSprite("status_stunned").setBrush(actor.isAlliedWithPlayer() ? "bust_sleep" : "bust_sleep_mirrored");
			actor.getSprite("status_stunned").Visible = true;
			
			if (actor.getFlags().has("human"))
			{
				if (actor.hasSprite("closed_eyes"))
				{
					actor.getSprite("closed_eyes").Visible = true;
				}
				
				if ("setEyesClosed" in actor.get())
				{
					actor.setEyesClosed(true);
				}
			}

			actor.setDirty(true);
		}
	};
	obj.onBeforeDamageReceived <- function( _attacker, _skill, _hitInfo, _properties )
	{
		if (_attacker != null && _skill != null && _skill.getID() == "actives.nightmare")
		{
			local specialized = _attacker.getSkills().hasSkill("perk.after_wake");
			this.m.PreventWakeUp = specialized && ::Math.rand(1, 100) <= 33;
			this.m.AppliedMoraleCheck = specialized && !this.m.PreventWakeUp;
		}
	};
	obj.onDamageReceived = function( _attacker, _damageHitpoints, _damageArmor )
	{
		if (_damageHitpoints > 0 && !this.m.PreventWakeUp)
		{
			this.removeSelf();
		}

		this.m.PreventWakeUp = false;
	}
});