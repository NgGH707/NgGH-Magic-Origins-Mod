this.nggh_mod_lightning_storm_skill <- ::inherit("scripts/skills/skill", {
	m = {
		Cooldown = ::Math.rand(0, 1),
		AffectedTiles = [],
		HasCooldownAfterImpact = false
	},
	function create()
	{
		this.m.ID = "actives.lightning_storm";
		this.m.Name = "Lightning Strike";
		this.m.Description = "Call down the wrath of \'The Black Book\', turning your enemy into burnt meat while leaving your allies unharmed.";
		this.m.KilledString = "Electrocuted";
		this.m.Icon = "skills/active_216.png";
		this.m.IconDisabled = "skills/active_216_sw.png";
		this.m.Overlay = "active_216";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc6/cast_lightning_01.wav",
			"sounds/enemies/dlc6/cast_lightning_02.wav",
			"sounds/enemies/dlc6/cast_lightning_03.wav",
			"sounds/enemies/dlc6/cast_lightning_04.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/dlc6/lightning_impact_01.wav",
			"sounds/enemies/dlc6/lightning_impact_02.wav",
			"sounds/enemies/dlc6/lightning_impact_03.wav",
			"sounds/enemies/dlc6/lightning_impact_04.wav"
		];
		this.m.SoundOnHitDelay = 0;
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted + 1;
		this.m.Delay = 2500;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsWeaponSkill = false;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = false;
		this.m.IsVisibleTileNeeded = true;
		this.m.InjuriesOnBody = ::Const.Injury.BurningAndPiercingBody;
		this.m.InjuriesOnHead = ::Const.Injury.BurningAndPiercingHead;
		this.m.DirectDamageMult = 0.75;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 0;
		this.m.MinRange = 1;
		this.m.MaxRange = 12;
		this.m.MaxLevelDifference = 4;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();

		ret.extend([
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Call down lightning strikes in a straight line across the map"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "The line general direction is changed each time"
			},
		]);

		if (this.m.Cooldown > 0)
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can be used again after " + this.m.Cooldown + " turn(s)[/color]"
			});
		}

		return ret;
	}

	function setCooldownAfterImpact( _c )
	{
		this.m.HasCooldownAfterImpact = true;

		if (!_c)
		{
			this.m.Cooldown = 0;
		}
	}

	function isUsable()
	{
		return this.skill.isUsable() && this.m.Cooldown == 0;
	}

	function isWaitingOnImpact()
	{
		return this.m.AffectedTiles.len() != 0;
	}

	function getTiles()
	{
		return this.m.AffectedTiles;
	}

	function updateImpact()
	{
		if (this.getTiles().len() != 0)
		{
			::Sound.play(::MSU.Array.rand(this.m.SoundOnHit), 0.8);
			//::Time.scheduleEvent(::TimeUnit.Real, 600, this.onImpact.bindenv(this), this);
			::Tactical.CameraDirector.pushMoveToTileEvent(600, this.m.AffectedTiles[0], -1, this.onImpact.bindenv(this), this, 200, ::Const.Tactical.Settings.CameraNextEventDelay);
			::Tactical.CameraDirector.addDelay(0.2);
		}
	}

	function onTurnStart()
	{
		this.updateImpact();
		this.m.Cooldown = ::Math.max(0, this.m.Cooldown - 1);
	}

	function onCombatStarted()
	{
		this.m.Cooldown = ::Math.rand(0, 1);
		this.m.AffectedTiles = [];
	}

	function onCombatFinished()
	{
		this.m.Cooldown = 0;
		this.m.AffectedTiles = [];
	}

	function onUse( _user, _targetTile )
	{
		local data = this.getAffectedTiles(_targetTile);
		local find;
		this.m.Cooldown = 2;
		this.m.AffectedTiles = data.Tiles;
		::Tactical.Entities.getFlags().set("LightningStrikesStyle", data.Choose);

		foreach(i, tile in this.m.AffectedTiles )
		{
			tile.Properties.IsMarkedForImpact = true;
			tile.spawnDetail("mortar_target_02", ::Const.Tactical.DetailFlag.SpecialOverlay, false, true);

			if (tile.ID == _targetTile.ID)
			{
				find = i;
			}
		}

		if (find != null)
		{
			this.m.AffectedTiles.remove(find);
			this.m.AffectedTiles.insert(0, _targetTile);
		}		

		::Tactical.Entities.getFlags().increment("LightningStrikesActive");

		if (!_user.isHiddenToPlayer())
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " summons lightning");
		}

		return true;
	}

	function onDeath( _fatalityType )
	{
		foreach( tile in this.m.AffectedTiles )
		{
			tile.Properties.IsMarkedForImpact = false;
			tile.clear(::Const.Tactical.DetailFlag.SpecialOverlay);
		}

		this.m.AffectedTiles = [];
		::Tactical.Entities.getFlags().set("LightningStrikesActive", ::Math.max(0, ::Tactical.Entities.getFlags().getAsInt("LightningStrikesActive") - 1));
	}

	function onImpact( _tag )
	{
		::Tactical.EventLog.log("Lightning strikes the battlefield");
		::Tactical.getCamera().quake(::createVec(0, -1.0), 6.0, 0.16, 0.35);
		local actor = _tag.getContainer().getActor();

		foreach( i, t in _tag.m.AffectedTiles )
		{
			t.addVisibilityForFaction(::Const.Faction.Player);

			::Time.scheduleEvent(::TimeUnit.Real, i * 30, function ( _data )
			{
				local tile = _data.Tile;


				for( local i = 0; i < ::Const.Tactical.LightningParticles.len(); ++i )
				{
					::Tactical.spawnParticleEffect(true, ::Const.Tactical.LightningParticles[i].Brushes, tile, ::Const.Tactical.LightningParticles[i].Delay, ::Const.Tactical.LightningParticles[i].Quantity, ::Const.Tactical.LightningParticles[i].LifeTimeQuantity, ::Const.Tactical.LightningParticles[i].SpawnRate, ::Const.Tactical.LightningParticles[i].Stages);
				}

				tile.clear(::Const.Tactical.DetailFlag.SpecialOverlay);
				tile.Properties.IsMarkedForImpact = false;

				if ((tile.IsEmpty || tile.IsOccupiedByActor) && tile.Type != ::Const.Tactical.TerrainType.ShallowWater && tile.Type != ::Const.Tactical.TerrainType.DeepWater)
				{
					tile.clear(::Const.Tactical.DetailFlag.Scorchmark);
					tile.spawnDetail("impact_decal", ::Const.Tactical.DetailFlag.Scorchmark, false, true);
				}

				if (tile.IsOccupiedByActor && !_data.User.isAlliedWith(tile.getEntity()))
				{
					local target = tile.getEntity();
					local hitInfo = clone ::Const.Tactical.HitInfo;
					hitInfo.DamageRegular = ::Math.rand(25, 50);
					hitInfo.DamageArmor = hitInfo.DamageRegular * 1.0;
					hitInfo.DamageDirect = 0.75;
					hitInfo.BodyPart = 0;
					hitInfo.FatalityChanceMult = 0.0;
					hitInfo.Injuries = ::Const.Injury.BurningBody;
					target.onDamageReceived(_data.User, _data.Skill, hitInfo);
				}
			}, {
				Tile = t,
				Skill = _tag,
				User = actor
			});
		}

		_tag.m.AffectedTiles = [];

		if (_tag.m.HasCooldownAfterImpact)
		{
			_tag.m.Cooldown = 1;
		}

		::Tactical.Entities.getFlags().set("LightningStrikesActive", ::Math.max(0, ::Tactical.Entities.getFlags().getAsInt("LightningStrikesActive") - 1));
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin = 25;
			_properties.DamageRegularMax = 50;
			_properties.MeleeDamageMult = 1.0;
			_properties.RangedDamageMult = 1.0;
			_properties.DamageRegularMult = 1.0;
			_properties.DamageArmorMult = 1.0;
			_properties.DamageDirectAdd = 0.0;
			_properties.DamageDirectMult = 1.0;
			_properties.DamageTotalMult = 1.0;
			_properties.DamageAdditionalWithEachTile = 0.0;
		}
	}

	function onTargetSelected( _targetTile )
	{
		local tiles = this.getAffectedTiles(_targetTile).Tiles;

		foreach ( t in tiles )
		{
			if (!t.IsVisibleForPlayer)
			{
				continue;
			}

			::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, t, t.Pos.X, t.Pos.Y);
		}
	} 

	function getAffectedTiles( _targetTile )
	{
		local ret = {
			Tiles = [],
			Choose = 1
		};
		local size = ::Tactical.getMapSize();
		local last_attack_style = ::Tactical.Entities.getFlags().getAsInt("LightningStrikesStyle");

		if (last_attack_style > 0 && last_attack_style < 4)
		{
			ret.Choose = last_attack_style + 1;
		}
		
		switch (ret.Choose)
		{
		case 1:
			// vertical
			for( local y = 0; y < size.Y; y = ++y )
			{
				if (!::Tactical.isValidTileSquare(_targetTile.SquareCoords.X, y))
				{
					continue;
				}
				
				local tile = ::Tactical.getTileSquare(_targetTile.SquareCoords.X, y);

				if (!tile.IsEmpty && !tile.IsOccupiedByActor)
				{
				}
				else
				{
					ret.Tiles.push(tile);
				}
			}
			break;

		case 2:
			// horizonal
			for( local x = 0; x < size.X; x = ++x )
			{
				if (!::Tactical.isValidTileSquare(x, _targetTile.SquareCoords.Y))
				{
					continue;
				}

				local tile = ::Tactical.getTileSquare(x, _targetTile.SquareCoords.Y);

				if (!tile.IsEmpty && !tile.IsOccupiedByActor)
				{
				}
				else
				{
					ret.Tiles.push(tile);
				}
			}
			break;

		case 3:
			// diagonal up
			local NE_tile = _targetTile.hasNextTile(::Const.Direction.NE) ? _targetTile.getNextTile(::Const.Direction.NE) : null;
			local SW_tile = _targetTile.hasNextTile(::Const.Direction.SW) ? _targetTile.getNextTile(::Const.Direction.SW) : null;

			if (NE_tile != null)
			{
				local next = _targetTile.SquareCoords.Y != NE_tile.SquareCoords.Y;
				local y = NE_tile.SquareCoords.Y;

				for( local x = NE_tile.SquareCoords.X; x >= 0; x = --x )
				{
					if (!::Tactical.isValidTileSquare(x, y))
					{
						continue;
					}

					local tile = ::Tactical.getTileSquare(x, y);

					if (!tile.IsEmpty && !tile.IsOccupiedByActor)
					{
					}
					else
					{
						ret.Tiles.push(tile);
					}

					if (next)
					{
						--y;
					}

					next = !next;
				}
			}

			if (_targetTile.IsEmpty || _targetTile.IsOccupiedByActor)
			{
				ret.Tiles.insert(0, _targetTile);
			}

			if (SW_tile != null)
			{
				local next = _targetTile.SquareCoords.Y != SW_tile.SquareCoords.Y;
				local y = SW_tile.SquareCoords.Y;

				for( local x = SW_tile.SquareCoords.X; x < size.X; x = ++x )
				{
					if (!::Tactical.isValidTileSquare(x, y))
					{
						continue;
					}

					local tile = ::Tactical.getTileSquare(x, y);

					if (!tile.IsEmpty && !tile.IsOccupiedByActor)
					{
					}
					else
					{
						ret.Tiles.push(tile);
					}

					if (next)
					{
						++y;
					}

					next = !next;
				}
			}
			break;

		case 4:
			// diagonal down
			local NW_tile = _targetTile.hasNextTile(::Const.Direction.NW) ? _targetTile.getNextTile(::Const.Direction.NW) : null;
			local SE_tile = _targetTile.hasNextTile(::Const.Direction.SE) ? _targetTile.getNextTile(::Const.Direction.SE) : null;

			if (NW_tile != null)
			{
				local next = _targetTile.SquareCoords.Y != NW_tile.SquareCoords.Y;
				local y = NW_tile.SquareCoords.Y;

				for( local x = NW_tile.SquareCoords.X; x >= 0; x = --x )
				{
					if (!::Tactical.isValidTileSquare(x, y))
					{
						continue;
					}

					local tile = ::Tactical.getTileSquare(x, y);

					if (!tile.IsEmpty && !tile.IsOccupiedByActor)
					{
					}
					else
					{
						ret.Tiles.push(tile);
					}

					if (!next)
					{
						++y;
					}

					next = !next;
				}
			}

			if (_targetTile.IsEmpty || _targetTile.IsOccupiedByActor)
			{
				ret.Tiles.insert(0, _targetTile);
			}

			if (SE_tile != null)
			{
				local next = _targetTile.SquareCoords.Y != SE_tile.SquareCoords.Y;
				local y = SE_tile.SquareCoords.Y;

				for( local x = SE_tile.SquareCoords.X; x < size.X; x = ++x )
				{
					if (!::Tactical.isValidTileSquare(x, y))
					{
						continue;
					}

					local tile = ::Tactical.getTileSquare(x, y);

					if (!tile.IsEmpty && !tile.IsOccupiedByActor)
					{
					}
					else
					{
						ret.Tiles.push(tile);
					}

					if (!next)
					{
						--y;
					}

					next = !next;
				}
			}
			break;	
		}

		return ret;
	}

});

