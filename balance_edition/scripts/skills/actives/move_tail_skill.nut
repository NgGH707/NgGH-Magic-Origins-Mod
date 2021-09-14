this.move_tail_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.move_tail";
		this.m.Name = "Move Tail";
		this.m.Description = "Move the tail closer to the body";
		this.m.Icon = "skills/active_109.png";
		this.m.IconDisabled = "skills/active_109_sw.png";
		this.m.Overlay = "active_109";
		this.m.SoundOnUse = [
			"sounds/enemies/lindwurm_idle_01.wav",
			"sounds/enemies/lindwurm_idle_02.wav",
			"sounds/enemies/lindwurm_idle_03.wav",
			"sounds/enemies/lindwurm_idle_04.wav",
			"sounds/enemies/lindwurm_idle_05.wav",
			"sounds/enemies/lindwurm_idle_06.wav",
			"sounds/enemies/lindwurm_idle_07.wav",
			"sounds/enemies/lindwurm_idle_08.wav",
			"sounds/enemies/lindwurm_idle_09.wav",
			"sounds/enemies/lindwurm_idle_10.wav",
			"sounds/enemies/lindwurm_idle_11.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 99;
		this.m.MaxLevelDifference = 4;
	}
	
	function getTooltip()
	{
		return this.getDefaultUtilityTooltip();
	}
	
	function onAdded()
	{	
		if (!this.getContainer().getActor().isPlayerControlled())
		{
			return;
		}
		
		this.m.ActionPointCost = 5;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!_targetTile.IsEmpty)
		{
			return false;
		}

		local body = this.getContainer().getActor().getBody();

		if (body == null || body.isNull() || !body.isAlive() || _targetTile.getDistanceTo(body.getTile()) > 1)
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local tag = {
			Skill = this,
			User = _user,
			TargetTile = _targetTile,
			OnDone = this.onTeleportDone,
			OnTeleportStart = this.onTeleportStart,
			NoAnimations = false
		};

		if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " moves its tail");
		}

		if (_user.getTile().IsVisibleForPlayer)
		{
			this.onTeleportStart(tag);
		}
		else if (_targetTile.IsVisibleForPlayer)
		{
			this.onTeleportStart(tag);
		}
		else
		{
			tag.NoAnimations = true;
			this.onTeleportStart(tag);
		}

		return true;
	}

	function onTeleportStart( _tag )
	{
		this.Tactical.getNavigator().teleport(_tag.User, _tag.TargetTile, _tag.OnDone, _tag, false, 3.0);
	}

	function onTeleportDone( _entity, _tag )
	{
		if (this.Const.Tactical.TerrainMovementSound[_entity.getTile().Subtype].len() != 0)
		{
			local sound = this.Const.Tactical.TerrainMovementSound[_entity.getTile().Subtype][this.Math.rand(0, this.Const.Tactical.TerrainMovementSound[_entity.getTile().Subtype].len() - 1)];
			this.Sound.play("sounds/" + sound.File, sound.Volume * this.Const.Sound.Volume.TacticalMovement * this.Math.rand(90, 100) * 0.01, _entity.getPos(), sound.Pitch * this.Math.rand(95, 105) * 0.01);
		}
	}

});

