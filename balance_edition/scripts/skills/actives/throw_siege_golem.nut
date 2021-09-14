this.throw_siege_golem <- this.inherit("scripts/skills/mc_magic_skill", {
	m = {
		Script = "scripts/entity/tactical/minions/special/siege_golem"
	},
	
	function create()
	{
		this.mc_magic_skill.create();
		this.m.ID = "actives.throw_siege_golem";
		this.m.Name = "Throw It";
		this.m.Description = "Throw the stone and trigger it to acitvate. It is wrecking time!";
		this.m.Icon = "skills/active_193.png";
		this.m.IconDisabled = "skills/active_193_sw.png";
		this.m.Overlay = "active_193";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc6/sand_golem_assemble_01.wav",
			"sounds/enemies/dlc6/sand_golem_assemble_02.wav",
			"sounds/enemies/dlc6/sand_golem_assemble_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.Delay = 0;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = true;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = true;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
		this.m.MaxLevelDifference = 3;
		this.m.ProjectileType = this.Const.ProjectileType.Rock;
		this.m.ProjectileTimeScale = 1.33;
		this.m.IsProjectileRotated = true;
	}
	
	function getCursorForTile( _tile )
	{
		return this.Const.UI.Cursor.Hand;
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.MaxRange + "[/color] tiles"
			}
		];
		
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Will create a [color=" + this.Const.UI.Color.DamageValue + "]Siege Golem[/color] at targeted tile"
		});
		
		return ret;
	}
	
	function onUpdate( _properties )
	{	
	}
	
	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInThrowing ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}
	
	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (_originTile.Level + 1 < _targetTile.Level)
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{	
		local flip = !this.m.IsProjectileRotated && targetEntity.getPos().X > _user.getPos().X;
		local time = this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), _targetTile, 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
		
		if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
		{
			this.Time.scheduleEvent(this.TimeUnit.Virtual, time, this.onSpawn, {
				User = _user,
				Skill = this,
				TargetTile = _targetTile
			});
		}
		else
		{
			this.onSpawn({
				User = _user,
				Skill = this,
				TargetTile = _targetTile
			});
		}
		_user.getItems().unequip(_user.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
		
		return true;
	}
	
	function onSpawn( _tag )
	{
		local _targetTile = _tag.TargetTile;
		local _user = _tag.User;
		local _skill = _tag.Skill;
		this.Tactical.CameraDirector.addMoveToTileEvent(0, _targetTile);
		this.Tactical.CameraDirector.addDelay(0.2);
		local spawn = this.Tactical.spawnEntity(_skill.m.Script, _targetTile.Coords.X, _targetTile.Coords.Y);
		spawn.setFaction(2);
		spawn.grow();
		spawn.resetStats();
		_skill.actitvateGolem(spawn, _user);
	}
	
	function actitvateGolem( _golem , _user)
	{
		local effect = _golem.getSkills().getSkillByID("racial.siege_golem");
		
		if (effect != null)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_golem) + " is active now");
			effect.setMaster(_user, true);
			effect.onActivateGolem();
		}
	}
	
});