this.mod_command_explode_skull_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.command_explode_skull";
		this.m.Name = "Explode";
		this.m.Description = "Force a selected \'Screaming Skull\' to explode immediately.";
		this.m.Icon = "skills/active_221.png";
		this.m.IconDisabled = "skills/active_221_sw.png";
		this.m.Overlay = "active_221";
		this.m.SoundOnUse = [];
		this.m.SoundVolume = 0.75;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsVisibleTileNeeded = true;
		this.m.IsRangeLimitsEnforced = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 5;
		this.m.MinRange = 0;
		this.m.MaxRange = 99;
		this.m.MaxLevelDifference = 4;
	}

	function getTooltip()
	{
		return this.getDefaultUtilityTooltip();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local _target = _targetTile.getEntity();

		if (!_target.getFlags().has("creator"))
		{
			return false;
		}

		if (_target.getFlags().get("creator") != this.getContainer().getActor().getID())
		{
			return false;
		}

		if (_target.getType() != this.Const.EntityType.FlyingSkull) 
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();

		if (!target.isHiddenToPlayer())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " explodes into shrapnel of bone!");
		}

		this.Time.scheduleEvent(this.TimeUnit.Real, 300, function ( _e )
		{
			_e.kill();
		}, target);
		return true;
	}

	function onTargetSelected( _targetTile ) {}
	function getHitFactors( _targetTile ) {return []}

});

