::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/legend_intensely_charm_skill", function ( q )
{
	q.isViableTarget = @(__original) function( _user, _target )
	{
		if (!__original(_user, _target))
			return false;

		/*
		if (_target.getCurrentProperties().IsImmuneToMagic)
		{
			return false;
		}
		*/
		
		if (_target.getType() == ::Const.EntityType.Hexe || _target.getType() == ::Const.EntityType.LegendHexeLeader)
			return false;

		if (_target.getFlags().has("Hexe") || _target.isNonCombatant())
			return false;

		local simp = _target.getSkills().getSkillByID("effects.simp");

	    if (simp != null && simp.getSimpLevel() == 0 && simp.isMutiny())
			return false;

		foreach (id in [
			"effects.charmed_captive",
			"effects.legend_intensely_charmed",
		]) 
		{
		    if (_target.getSkills().hasSkill(id))
		    	return false;
		}

		return true;
	}

	q.onDelayedEffect = @(__original) function( _tag )
	{
		if (isViableTarget(_tag.User, _tag.TargetTile.getEntity()))
			return __original(_tag);

		::Time.scheduleEvent(::TimeUnit.Virtual, ::Tactical.spawnProjectileEffect("effect_heart_01", _tag.User.getTile(), _tag.TargetTile, 0.33, 2.0, false, false), function ( _t ) {
			if (_t.TargetTile.IsVisibleForPlayer && !_t.User.isHiddenToPlayer())
				::Tactical.EventLog.log(format("%s doesn\'t seem to be unaffected by the charm", ::Const.UI.getColorizedEntityName(_t.TargetTile.getEntity())));
		}, _tag);
	}
	
});