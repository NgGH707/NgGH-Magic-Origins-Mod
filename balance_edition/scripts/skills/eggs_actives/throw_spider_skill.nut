this.throw_spider_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.throw_spider";
		this.m.Name = "Spider Mortal";
		this.m.Description = "Throw spider, of course.";
		this.m.Icon = "skills/active_193.png";
		this.m.IconDisabled = "skills/active_193_sw.png";
		this.m.Overlay = "active_193";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/giant_spider_idle_04.wav",
			"sounds/enemies/dlc2/giant_spider_idle_05.wav",
			"sounds/enemies/dlc2/giant_spider_idle_06.wav",
			"sounds/enemies/dlc2/giant_spider_idle_07.wav",
			"sounds/enemies/dlc2/giant_spider_idle_08.wav",
			"sounds/enemies/dlc2/giant_spider_idle_09.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/dlc2/giant_spider_hurt_01.wav",
			"sounds/enemies/dlc2/giant_spider_hurt_02.wav",
			"sounds/enemies/dlc2/giant_spider_hurt_03.wav",
			"sounds/enemies/dlc2/giant_spider_hurt_04.wav",
			"sounds/enemies/dlc2/giant_spider_hurt_05.wav"
		];
		this.m.SoundOnHitDelay = 0;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.Delay = 300;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsDoingForwardMove = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.25;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 2;
		this.m.MaxRange = 5;
		this.m.MaxLevelDifference = 3;
		this.m.ProjectileTimeScale = 1.33;
		this.m.IsProjectileRotated = true;
		this.m.ChanceSmash = 10;
	}
	
	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles on even ground, more if throwing downhill"
			}
		]);

		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Shoots a Webknecht"
		});

		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not be used because this character is engaged in melee[/color]"
			});
		}

		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.DamageRegularMin += 15;
		_properties.DamageRegularMax += 25;
		_properties.DamageArmorMult *= 0.5;
	}

	function isUsable()
	{
		return !this.Tactical.isActive() || this.skill.isUsable() && !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
	}
	
	function onVerifyTarget( _userTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_userTile, _targetTile))
		{
			return false;
		}

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else if (_targetTile.getNextTile(i).IsEmpty)
			{
				return true;
			}
		}

		return false;
	}

	function onUse( _user, _targetTile )
	{
		local targetEntity = _targetTile.getEntity();
		local info = {
			Skill = this,
			User = _user,
			TargetEntity = targetEntity,
			TargetTile = _targetTile,
		}
		
		if (this.m.IsShowingProjectile && _user.getTile().getDistanceTo(targetEntity.getTile()) >= this.Const.Combat.SpawnProjectileMinDist)
		{
			local flip = !this.m.IsProjectileRotated && targetEntity.getPos().X > _user.getPos().X;
			local time = this.Tactical.spawnProjectileEffect("projectile_spider", _user.getTile(), targetEntity.getTile(), 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, time, this.onImpact, info);
		}
		
		return true;
	}
	
	function onImpact( _info )
	{
		local self = _info.Skill;
		local _user = _info.User;
		local _targetEntity = _info.TargetEntity;
		local _targetTile = _info.TargetTile;
		local availableTiles = [];
		local tile;
		self.attackEntity(_user, _targetEntity);
		
		for( local i = 0; i < 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else if (_targetTile.getNextTile(i).IsEmpty)
			{
				availableTiles.push(_targetTile.getNextTile(i));
			}
		}
		
		if (availableTiles.len() != 0)
		{
			tile = availableTiles[this.Math.rand(0, availableTiles.len() - 1)];
		}
		
		return self.onSpawnSpider(tile);
	}
	
	function onSpawnSpider( _tile )
	{
		if (_tile == null || !_tile.IsEmpty)
		{
			return false;
		}
		
		local spawn = this.Tactical.spawnEntity("scripts/entity/tactical/minions/spider_minion", _tile.Coords);
		spawn.setSize(this.Math.rand(60, 70) * 0.01);
		spawn.setFaction(this.getContainer().getActor().getFaction());
		spawn.setMaster(this.getContainer().getActor());
		spawn.m.XP = spawn.m.XP / 2;
		local allies = this.Tactical.Entities.getInstancesOfFaction(this.getContainer().getActor().getFaction());

		foreach( a in allies )
		{
			if (a.getType() == this.Const.EntityType.Hexe)
			{
				spawn.getSkills().add(this.new("scripts/skills/effects/fake_charmed_effect"));
				break;
			}
		}
		
		this.makeSpiderAct(spawn);
		this.getContainer().update();
		return true;
	}
	
	function makeSpiderAct( _spawn )
	{
		this.Tactical.TurnSequenceBar.removeEntity(_spawn);
		_spawn.m.IsActingImmediately = true;
		_spawn.m.IsTurnDone = false;
		this.Tactical.TurnSequenceBar.insertEntity(_spawn);
	}
	
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.RangedSkill += 90;
		}
	}

});

