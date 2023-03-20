this.perk_nggh_ghost_vanish <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.ghost_vanish";
		this.m.Name = ::Const.Strings.PerkName.NggHGhostVanish;
		this.m.Description = ::Const.Strings.PerkDescription.NggHGhostVanish;
		this.m.Icon = "ui/perks/perk_ghost_vanish.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		local actor = this.getContainer().getActor();

		if (_damageHitpoints >= actor.getHitpoints())
		{
			return;
		}

		local result = {
			TargetTile = actor.getTile(),
			Destinations = []
		};
		::Tactical.queryTilesInRange(actor.getTile(), 2, 6, false, [], this.onQueryTiles, result);

		if (result.Destinations.len() == 0)
		{
			return;
		}

		local allHostiles = ::Tactical.Entities.getInstancesHostileWithFaction(actor.getFaction());
		local dangerousTiles = [];
		local lessDangerousTiles = [];
		local valid = [];

		foreach ( tile in result.Destinations )
		{
			local isValid = true;

			if (tile.Type == this.Const.Tactical.TerrainType.Swamp || (tile.Properties.Effect != null && !tile.Properties.Effect.IsPositive))
			{
				dangerousTiles.push(tile);
				continue;
			}

			foreach ( a in allHostiles )
			{
				local d = a.getTile().getDistanceTo(tile);

				if (d <= 1)
				{
					dangerousTiles.push(tile);
					isValid = false;
					break;
				}
				else if (d <= 2)
				{
					lessDangerousTiles.push(tile)
					isValid = false;
					break;
				}
			}

			if (isValid)
			{
				valid.push(tile);
			}
		}

		local targetTile;

		if (valid.len() != 0)
		{
			targetTile = ::MSU.Array.rand(valid);
		}
		else if (lessDangerousTiles.len() != 0)
		{
			targetTile = ::MSU.Array.rand(lessDangerousTiles);
		}
		else if (dangerousTiles.len() != 0)
		{
			targetTile = ::MSU.Array.rand(dangerousTiles);
		}

		if (targetTile == null)
		{
			return;
		} 

		local tag = {
			User = actor,
			TargetTile = targetTile,
			OnDone = this.onTeleportDone,
			OnFadeIn = this.onFadeIn,
			OnFadeDone = this.onFadeDone,
			OnTeleportStart = this.onTeleportStart,
			IgnoreColors = false
		};

		if (actor.getTile().IsVisibleForPlayer)
		{
			local effect = {
				Delay = 0,
				Quantity = 12,
				LifeTimeQuantity = 12,
				SpawnRate = 100,
				Brushes = [
					actor.getSprite("body").getBrush().Name
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
			::Tactical.spawnParticleEffect(false, effect.Brushes, actor.getTile(), effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, ::createVec(0, 40));
			_user.storeSpriteColors();
			_user.fadeTo(::createColor("ffffff00"), 0);
			this.onTeleportStart(tag);
		}
		else if (targetTile.IsVisibleForPlayer)
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
	}

	function onQueryTiles( _tile, _tag )
	{
		if (!_tile.IsEmpty)
		{
			return;
		}

		_tag.Destinations.push(_tile);
	}

	function onTeleportStart( _tag )
	{
		::Tactical.getNavigator().teleport(_tag.User, _tag.TargetTile, _tag.OnDone, _tag, false, 0.0);
	}

	function onTeleportDone( _entity, _tag )
	{
		if (!_entity.isHiddenToPlayer())
		{
			local brush = _entity.getSprite("body").getBrush().Name;
			local effect1 = {
				Delay = 0,
				Quantity = 4,
				LifeTimeQuantity = 4,
				SpawnRate = 100,
				Brushes = [
					brush
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
					brush
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
					brush
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

