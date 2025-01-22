::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/throw_holy_water", function(q) 
{
	q.m.AttackerID <- null;

	q.create = @(__original) function()
	{
		__original();
		m.IsAttack = false;
	}

	q.onAdded <- function()
	{
		m.AttackerID = getContainer().getActor().getID();
	}

	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		if (!__original(_originTile, _targetTile))
			return false;

		local target = _targetTile.getEntity();

		if (target.isAlliedWith(getContainer().getActor()) && !target.getSkills().hasSkill("effects.ghost_possessed"))
			return false;

		return true;
	}

	q.applyEffect = @(__original) function( _target )
	{
		local possess = _target.getSkills().getSkillByID("effects.ghost_possessed");

		if (possess != null) {
			possess.m.AttackerID = m.AttackerID;
			possess.setExorcised(true);
			possess.removeSelf();
			_target.getSkills().update();
		}

		__original(_target);
	}
	
});