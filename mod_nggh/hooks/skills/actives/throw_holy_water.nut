::mods_hookExactClass("skills/actives/throw_holy_water", function(obj) 
{
	obj.m.AttackerID <- null;

	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.IsAttack = false;
	};
	obj.onAdded <- function()
	{
		this.m.AttackerID = this.getContainer().getActor().getID();
	};
	local ws_onVerifyTarget = obj.onVerifyTarget;
	obj.onVerifyTarget = function( _originTile, _targetTile )
	{
		if (!ws_onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local target = _targetTile.getEntity();

		if (target.isAlliedWith(this.getContainer().getActor()) && !target.getSkills().hasSkill("effects.ghost_possessed"))
		{
			return false;
		}

		return true;
	};
	local ws_applyEffect = obj.applyEffect;
	obj.applyEffect = function( _target )
	{
		local possess = _target.getSkills().getSkillByID("effects.ghost_possessed");

		if (possess != null)
		{
			possess.m.AttackerID = this.m.AttackerID;
			possess.setExorcised(true);
			possess.removeSelf();
			_target.getSkills().update();
		}

		ws_applyEffect(_target);
	};
});