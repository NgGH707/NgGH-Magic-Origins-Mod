::mods_hookExactClass("skills/perks/perk_overwhelm", function(obj) 
{
	local ws_onTargetHit = obj.onTargetHit;
	obj.onTargetHit = function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_targetEntity != null && _targetEntity.isAlive() && !_targetEntity.isDying() && _targetEntity.getCurrentProperties().IsImmuneToOverwhelm)
		{
			return;
		}

		ws_onTargetHit(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);
	};

	local ws_onTargetMissed = obj.onTargetMissed;
	obj.onTargetMissed = function( _skill, _targetEntity )
	{
		if (_targetEntity != null && _targetEntity.isAlive() && !_targetEntity.isDying() && _targetEntity.getCurrentProperties().IsImmuneToOverwhelm)
		{
			return;
		}

		ws_onTargetMissed(_skill, _targetEntity);
	};
});