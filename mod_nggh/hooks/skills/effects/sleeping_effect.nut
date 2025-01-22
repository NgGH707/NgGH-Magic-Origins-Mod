::Nggh_MagicConcept.HooksMod.hook("scripts/skills/effects/sleeping_effect", function(q)
{
	q.m.PreventWakeUp <- false;
	q.m.AppliedMoraleCheck <- false;

	q.onRemoved = @(__original) function()
	{
		local actor = getContainer().getActor();
		if (actor.getFlags().has("human"))
			__original();
		else {
			if (actor.hasSprite("status_stunned"))
				actor.getSprite("status_stunned").Visible = false;
			
			if (actor.hasSprite("closed_eyes"))
				actor.getSprite("closed_eyes").Visible = false;
				
			if (::MSU.isIn("setEyesClosed", actor, true))
				actor.setEyesClosed(false);

			actor.getFlags().set("Sleeping", false);
			actor.setDirty(true);
		}
		
		if (m.AppliedMoraleCheck && actor.isAlive() && !actor.isDying())
			actor.checkMorale(-1, -10, ::Const.MoraleCheckType.MentalAttack);
	}

	q.onBeforeDamageReceived = @(__original) function( _attacker, _skill, _hitInfo, _properties )
	{
		if (_attacker != null && _skill != null && _skill.getID() == "actives.nightmare") {
			local specialized = _attacker.getSkills().hasSkill("perk.after_wake");
			m.PreventWakeUp = specialized && ::Math.rand(1, 100) <= 33;
			m.AppliedMoraleCheck = specialized && !m.PreventWakeUp;
		}

		__original(_attacker, _skill, _hitInfo, _properties);
	}

	q.onDamageReceived = function( _attacker, _damageHitpoints, _damageArmor )
	{
		if (_damageHitpoints > 0 && !m.PreventWakeUp)
			removeSelf();

		m.PreventWakeUp = false;

		__original(_attacker, _damageHitpoints, _damageArmor);
	}
});