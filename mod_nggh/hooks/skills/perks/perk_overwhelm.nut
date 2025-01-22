::Nggh_MagicConcept.HooksMod.hook("scripts/skills/perks/perk_overwhelm", function(q) 
{
	q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_targetEntity != null && _targetEntity.isAlive() && !_targetEntity.isDying() && _targetEntity.getCurrentProperties().IsImmuneToOverwhelm)
			return;

		__original(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);
	}

	q.onTargetMissed = @(__original) function( _skill, _targetEntity )
	{
		if (_targetEntity != null && _targetEntity.isAlive() && !_targetEntity.isDying() && _targetEntity.getCurrentProperties().IsImmuneToOverwhelm)
			return;

		__original(_skill, _targetEntity);
	};
});