this.mc_ELE_lightning <- this.inherit("scripts/skills/mc_magic_skill", {
	m = {
		SoundOnLightning = [
			"sounds/combat/dlc2/legendary_lightning_01.wav",
			"sounds/combat/dlc2/legendary_lightning_02.wav"
		],
		IsChained = false,
	},
	function create()
	{
		this.m.ID = "actives.mc_lightning";
		this.m.Name = "Lightning Strike";
		this.m.Description = "Call down a lightning strike to electrocute your target. Can be enhanced to summon more than one strike. Damage based on resolve, deal reduced damage if you don\'t have a magic staff.";
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
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.TemporaryInjury + 1;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsDoingForwardMove = true;
		this.m.IsShieldRelevant = false;
		this.m.IsIgnoreBlockTarget = true;
		this.m.IsTargetingActor = false;
		this.m.InjuriesOnBody = this.Const.Injury.BurningBody;
		this.m.InjuriesOnHead = this.Const.Injury.BurningHead;
		this.m.DirectDamageMult = 1.0;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 18;
		this.m.MaxRangeBonus = 9;
		this.m.MinRange = 1;
		this.m.MaxRange = 4;
	}

	function getDescription()
	{
		return this.skill.getDescription();
	}

	function onAfterUpdate( _properties )
	{
		this.mc_magic_skill.onAfterUpdate(_properties);
		this.m.MaxRange = _properties.IsSpecializedInMC_Magic ? 4 : 5;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles on even ground, more if casting downhill"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Completely ignores armor"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can and deal more damage if struck on a wet tile"
			},
		]);

		local e = this.getContainer().getSkillByID("special.mc_focus");

		if (e != null)
		{
			ret.extend([
				{
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Is enhanced by [color=" + this.Const.UI.Color.PositiveValue + "]Concentrate[/color] effect"
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "A lightning shower"
				}
			]);
		}

		return ret;
	}

	function onUse( _user, _targetTile )
	{
		local affectedTiles = [];
		local num = 1;
		affectedTiles.push(_targetTile);

		if (this.m.IsEnhanced)
		{
			for( local i = 0; i < 6; i = ++i )
			{
				if (!_targetTile.hasNextTile(i))
				{
				}
				else
				{
					affectedTiles.push(_targetTile.getNextTile(i));
				}
			}

			num = 8;
		}

		for( local i = 0 ; i < num ; i = i )
		{
			local random = affectedTiles[this.Math.rand(0, affectedTiles.len() - 1)];

			this.Time.scheduleEvent(this.TimeUnit.Real, 250 * i + 150, function ( _data )
			{
				local tile = _data.Tile;
				local excludedTile = [
					this.Const.Tactical.TerrainType.ShallowWater,
					this.Const.Tactical.TerrainType.DeepWater,
					this.Const.Tactical.TerrainType.Swamp
				];
				local isWetTile = excludedTile.find(tile.Type) != null;

				for( local i = 0; i < this.Const.Tactical.LightningParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(true, this.Const.Tactical.LightningParticles[i].Brushes, tile, this.Const.Tactical.LightningParticles[i].Delay, this.Const.Tactical.LightningParticles[i].Quantity, this.Const.Tactical.LightningParticles[i].LifeTimeQuantity, this.Const.Tactical.LightningParticles[i].SpawnRate, this.Const.Tactical.LightningParticles[i].Stages);
				}

				if ((tile.IsEmpty || tile.IsOccupiedByActor) && !isWetTile)
				{
					tile.clear(this.Const.Tactical.DetailFlag.Scorchmark);
					tile.spawnDetail("impact_decal", this.Const.Tactical.DetailFlag.Scorchmark, false, true);
				}

				_data.Skill.getContainer().setBusy(true);

				if (tile.IsOccupiedByActor && tile.getEntity().isAttackable() && tile.getEntity().isAlive())
				{
					_data.Skill.attackEntity(_data.User, tile.getEntity());
				}

				_data.Skill.reset(i + 1 >= num);
			},
			{
				Tile = random,
				Skill = this,
				User = _user
			});

			i = ++i;
		}

		return true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin += 15;
			_properties.DamageRegularMax += 40;
			_properties.DamageArmorMult *= 0.0;
			_properties.IsIgnoringArmorOnAttack = true;
			_properties.MeleeSkill += 999;

			if (_targetEntity != null)
			{
				local wet_tiles = [
					this.Const.Tactical.TerrainType.ShallowWater,
					this.Const.Tactical.TerrainType.DeepWater,
					this.Const.Tactical.TerrainType.Swamp
				];
				local isWet = _targetEntity.getSkills().hasSkill("terrain.swamp") || wet_tiles.find(_targetEntity.getTile().Type) != null;

				if (isWet)
				{
					this.m.IsUsingHitchance = false;
					_properties.DamageTotalMult *= 1.33;
				}
				else 
				{
				    this.m.IsUsingHitchance = true;
				}
			}

			if (this.getContainer().hasSkill("special.mc_focus") || this.m.IsEnhanced)
			{
				_properties.DamageTotalMult *= 0.20;
			}

			_properties.DamageTotalMult *= this.getBonusDamageFromResolve(_properties);
			this.removeBonusesFromWeapon(_properties);
		}
	}

	function onTargetSelected( _targetTile )
	{
		this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);

		if (this.getContainer().hasSkill("special.mc_focus"))
		{
			for( local i = 0; i < 6; i = ++i )
			{
				if (!_targetTile.hasNextTile(i))
				{
				}
				else
				{
					local tile = _targetTile.getNextTile(i);
					this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);	
				}
			}
		}
	}

	function reset( _isDone = false )
	{
		this.m.IsChained = false;
		this.m.IsUsingHitchance = true;

		if (_isDone)
		{
			this.m.IsEnhanced = false;
			this.getContainer().setBusy(false);
		}
	}

});

