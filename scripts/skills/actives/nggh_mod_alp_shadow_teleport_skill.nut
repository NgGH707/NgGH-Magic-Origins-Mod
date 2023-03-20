this.nggh_mod_alp_shadow_teleport_skill <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.alp_shadow_teleport";
		this.m.Name = "Shadow Blink";
		this.m.Description = "Moves between shadows.";
		this.m.Icon = "skills/active_160.png";
		this.m.IconDisabled = "skills/active_160.png";
		this.m.Overlay = "active_160";
		this.m.SoundOnUse = [
			"sounds/enemies/ghost_death_01.wav",
			"sounds/enemies/ghost_death_02.wav"
		];
		this.m.SoundOnHit = [];
		this.m.IsSerialized = false;
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted + 3;
		this.m.IsActive = true;
		this.m.IsHidden = false;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 0;
		this.m.MinRange = 1;
		this.m.MaxRange = 99;
		this.m.MaxLevelDifference = 4;
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
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can only be used when your AP bar is full"
			}
		];
		
		return ret;
	}
	
	function isUsable()
	{
		local actor = this.getContainer().getActor();
		return this.skill.isUsable() && actor.getActionPoints() == actor.getActionPointsMax();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (!_targetTile.IsEmpty)
		{
			return false;
		}

		if (_targetTile.Properties.Effect == null || _targetTile.Properties.Effect.Type != "shadows")
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
			OnFadeIn = this.onFadeIn,
			OnFadeDone = this.onFadeDone,
			OnTeleportStart = this.onTeleportStart,
			IgnoreColors = false
		};

		if (_user.getTile().IsVisibleForPlayer)
		{
			local specialEffect = _user.getSprite("body").getBrush().Name;

			if (_user.isPlayerControlled())
			{
				specialEffect = "mc_" + specialEffect;
			}

			local effect = {
				Delay = 0,
				Quantity = 12,
				LifeTimeQuantity = 12,
				SpawnRate = 100,
				Brushes = [
					specialEffect
				],
				Stages = [
					{
						LifeTimeMin = 0.7,
						LifeTimeMax = 0.7,
						ColorMin = ::createColor("ffffff5f"),
						ColorMax = ::createColor("ffffff5f"),
						ScaleMin = 1.0,
						ScaleMax = 1.0,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = ::createVec(-1.0, -1.0),
						DirectionMax = ::createVec(1.0, 1.0),
						SpawnOffsetMin = ::createVec(-10, -10),
						SpawnOffsetMax = ::createVec(10, 10),
						ForceMin = ::createVec(0, 0),
						ForceMax = ::createVec(0, 0)
					},
					{
						LifeTimeMin = 0.7,
						LifeTimeMax = 0.7,
						ColorMin = ::createColor("ffffff2f"),
						ColorMax = ::createColor("ffffff2f"),
						ScaleMin = 0.9,
						ScaleMax = 0.9,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = ::createVec(-1.0, -1.0),
						DirectionMax = ::createVec(1.0, 1.0),
						ForceMin = ::createVec(0, 0),
						ForceMax = ::createVec(0, 0)
					},
					{
						LifeTimeMin = 0.1,
						LifeTimeMax = 0.1,
						ColorMin = ::createColor("ffffff00"),
						ColorMax = ::createColor("ffffff00"),
						ScaleMin = 0.9,
						ScaleMax = 0.9,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = ::createVec(-1.0, -1.0),
						DirectionMax = ::createVec(1.0, 1.0),
						ForceMin = ::createVec(0, 0),
						ForceMax = ::createVec(0, 0)
					}
				]
			};
			::Tactical.spawnParticleEffect(false, effect.Brushes, _user.getTile(), effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, ::createVec(0, 40));
			_user.storeSpriteColors();
			_user.fadeTo(::createColor("ffffff00"), 0);
			this.onTeleportStart(tag);
		}
		else if (_targetTile.IsVisibleForPlayer)
		{
			_user.storeSpriteColors();
			_user.fadeTo(::createColor("ffffff00"), 0);
			this.onTeleportStart(tag);
		}
		else
		{
			tag.IgnoreColors = true;
			this.onTeleportStart(tag);
		}

		return true;
	}

	function onTeleportStart( _tag )
	{
		::Tactical.getNavigator().teleport(_tag.User, _tag.TargetTile, _tag.OnDone, _tag, false, 0.0);
	}

	function onTeleportDone( _entity, _tag )
	{
		if (!_entity.isHiddenToPlayer())
		{
			local specialEffect = _entity.getSprite("body").getBrush().Name;

			if (_entity.isPlayerControlled())
			{
				specialEffect = "mc_" + specialEffect;
			}

			local effect1 = {
				Delay = 0,
				Quantity = 4,
				LifeTimeQuantity = 4,
				SpawnRate = 100,
				Brushes = [
					specialEffect
				],
				Stages = [
					{
						LifeTimeMin = 0.4,
						LifeTimeMax = 0.4,
						ColorMin = ::createColor("ffffff5f"),
						ColorMax = ::createColor("ffffff5f"),
						ScaleMin = 1.0,
						ScaleMax = 1.0,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = ::createVec(0.0, -1.0),
						DirectionMax = ::createVec(0.0, -1.0),
						SpawnOffsetMin = ::createVec(-10, 40),
						SpawnOffsetMax = ::createVec(10, 50),
						ForceMin = ::createVec(0, 0),
						ForceMax = ::createVec(0, 0)
					},
					{
						LifeTimeMin = 0.4,
						LifeTimeMax = 0.4,
						ColorMin = ::createColor("ffffff2f"),
						ColorMax = ::createColor("ffffff2f"),
						ScaleMin = 1.0,
						ScaleMax = 1.0,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = ::createVec(0.0, -1.0),
						DirectionMax = ::createVec(0.0, -1.0),
						ForceMin = ::createVec(0, 0),
						ForceMax = ::createVec(0, 0)
					},
					{
						LifeTimeMin = 0.1,
						LifeTimeMax = 0.1,
						ColorMin = ::createColor("ffffff00"),
						ColorMax = ::createColor("ffffff00"),
						ScaleMin = 1.0,
						ScaleMax = 1.0,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = ::createVec(0.0, -1.0),
						DirectionMax = ::createVec(0.0, -1.0),
						ForceMin = ::createVec(0, 0),
						ForceMax = ::createVec(0, 0)
					}
				]
			};
			local effect2 = {
				Delay = 0,
				Quantity = 4,
				LifeTimeQuantity = 4,
				SpawnRate = 100,
				Brushes = [
					specialEffect
				],
				Stages = [
					{
						LifeTimeMin = 0.4,
						LifeTimeMax = 0.4,
						ColorMin = ::createColor("ffffff5f"),
						ColorMax = ::createColor("ffffff5f"),
						ScaleMin = 1.0,
						ScaleMax = 1.0,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = ::createVec(1.0, 0.0),
						DirectionMax = ::createVec(1.0, 0.0),
						SpawnOffsetMin = ::createVec(-40, -10),
						SpawnOffsetMax = ::createVec(-50, 10),
						ForceMin = ::createVec(0, 0),
						ForceMax = ::createVec(0, 0)
					},
					{
						LifeTimeMin = 0.4,
						LifeTimeMax = 0.4,
						ColorMin = ::createColor("ffffff2f"),
						ColorMax = ::createColor("ffffff2f"),
						ScaleMin = 1.0,
						ScaleMax = 1.0,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = ::createVec(1.0, 0.0),
						DirectionMax = ::createVec(1.0, 0.0),
						ForceMin = ::createVec(0, 0),
						ForceMax = ::createVec(0, 0)
					},
					{
						LifeTimeMin = 0.1,
						LifeTimeMax = 0.1,
						ColorMin = ::createColor("ffffff00"),
						ColorMax = ::createColor("ffffff00"),
						ScaleMin = 1.0,
						ScaleMax = 1.0,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = ::createVec(1.0, 0.0),
						DirectionMax = ::createVec(1.0, 0.0),
						ForceMin = ::createVec(0, 0),
						ForceMax = ::createVec(0, 0)
					}
				]
			};
			local effect3 = {
				Delay = 0,
				Quantity = 4,
				LifeTimeQuantity = 4,
				SpawnRate = 100,
				Brushes = [
					specialEffect
				],
				Stages = [
					{
						LifeTimeMin = 0.4,
						LifeTimeMax = 0.4,
						ColorMin = ::createColor("ffffff5f"),
						ColorMax = ::createColor("ffffff5f"),
						ScaleMin = 1.0,
						ScaleMax = 1.0,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = ::createVec(-1.0, 0.0),
						DirectionMax = ::createVec(-1.0, 0.0),
						SpawnOffsetMin = ::createVec(40, 10),
						SpawnOffsetMax = ::createVec(50, 10),
						ForceMin = ::createVec(0, 0),
						ForceMax = ::createVec(0, 0)
					},
					{
						LifeTimeMin = 0.4,
						LifeTimeMax = 0.4,
						ColorMin = ::createColor("ffffff2f"),
						ColorMax = ::createColor("ffffff2f"),
						ScaleMin = 1.0,
						ScaleMax = 1.0,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = ::createVec(-1.0, 0.0),
						DirectionMax = ::createVec(-1.0, 0.0),
						ForceMin = ::createVec(0, 0),
						ForceMax = ::createVec(0, 0)
					},
					{
						LifeTimeMin = 0.1,
						LifeTimeMax = 0.1,
						ColorMin = ::createColor("ffffff00"),
						ColorMax = ::createColor("ffffff00"),
						ScaleMin = 1.0,
						ScaleMax = 1.0,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = ::createVec(-1.0, 0.0),
						DirectionMax = ::createVec(-1.0, 0.0),
						ForceMin = ::createVec(0, 0),
						ForceMax = ::createVec(0, 0)
					}
				]
			};
			::Tactical.spawnParticleEffect(false, effect1.Brushes, _entity.getTile(), effect1.Delay, effect1.Quantity, effect1.LifeTimeQuantity, effect1.SpawnRate, effect1.Stages, ::createVec(0, 40));
			::Tactical.spawnParticleEffect(false, effect2.Brushes, _entity.getTile(), effect2.Delay, effect2.Quantity, effect2.LifeTimeQuantity, effect2.SpawnRate, effect2.Stages, ::createVec(0, 40));
			::Tactical.spawnParticleEffect(false, effect3.Brushes, _entity.getTile(), effect3.Delay, effect3.Quantity, effect3.LifeTimeQuantity, effect3.SpawnRate, effect3.Stages, ::createVec(0, 40));
			::Time.scheduleEvent(::TimeUnit.Virtual, 400, _tag.OnFadeIn, _tag);
		}
		else
		{
			_tag.OnFadeIn(_tag);
		}
	}

	function onFadeIn( _tag )
	{
		if (!_tag.IgnoreColors)
		{
			if (_tag.User.isHiddenToPlayer())
			{
				_tag.User.restoreSpriteColors();
			}
			else
			{
				_tag.User.fadeToStoredColors(300);
				::Time.scheduleEvent(::TimeUnit.Virtual, 300, _tag.OnFadeDone, _tag);
			}
		}
	}

	function onFadeDone( _tag )
	{
		_tag.User.restoreSpriteColors();
	}

});

