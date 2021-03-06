this.mc_ELE_elemental_storm <- this.inherit("scripts/skills/mc_magic_skill", {
	m = {
		SnowTiles = [],
		ElementType = 0,
		//1-fire | 2-ice | 3-lightning
	},
	function create()
	{
		this.m.ID = "actives.mc_elemental_storm";
		this.m.Name = "Elemental Storm";
		this.m.Description = "Summon a storm of chaotic element to destroy you enemies. Damage based on resolve, deal reduced damage if you don\'t have a magic staff. Can not be used while engaged in melee.";
		this.m.KilledString = "Burned, curshed and freezed to death";
		this.m.Icon = "skills/active_mc_06.png";
		this.m.IconDisabled = "skills/active_mc_06_sw.png";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/schrat_uproot_01.wav",
			"sounds/enemies/dlc2/schrat_uproot_02.wav",
			"sounds/enemies/dlc2/schrat_uproot_03.wav",
			"sounds/enemies/dlc2/schrat_uproot_04.wav",
			"sounds/enemies/dlc2/schrat_uproot_05.wav"
		];
		this.m.SoundOnHit = [];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.TemporaryInjury + 3;
		this.m.Delay = 750;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsUsingHitchance = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsIgnoringRiposte = true;
		this.m.IsAOE = true;
		this.m.IsRanged = true;
		this.m.IsTargetingActor = false;
		this.m.IsConsumeConcentrate = false;
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 7;
		this.m.FatigueCost = 35;
		this.m.MinRange = 2;
		this.m.MaxRange = 4;

		for( local i = 1; i <= 3; i = ++i )
		{
			this.m.SnowTiles.push(this.MapGen.get("tactical.tile.snow" + i));
		}
	}

	function onAfterUpdate( _properties )
	{
		this.mc_magic_skill.onAfterUpdate(_properties);

		if (!this.getContainer().hasSkill("special.mc_chanting"))
		{
			this.m.ActionPointCost = 7;
			this.m.IsTargeted = false;
		}
		else 
		{
			this.m.FatigueCostMult /= 2;
			this.m.ActionPointCost = 7;
			this.m.IsTargeted = true;
		}
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
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can hit up to 7 targets but requiring to spend a turn to prepare"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Randomly deal damage with one of three element below"
			},
			{
				id = 3,
				type = "text",
				text = "[u][size=14]Fire[/size][/u]"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Deal [color=" + this.Const.UI.Color.PositiveValue + "]33%[/color] more damage"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Set the ground on fire"
			},
			{
				id = 3,
				type = "text",
				text = "[u][size=14]Ice[/size][/u]"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can chill on hit"
			},
			{
				id = 3,
				type = "text",
				text = "[u][size=14]Lightning[/size][/u]"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Deal [color=" + this.Const.UI.Color.NegativeValue + "]33%[/color] less damage"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Completely ignores armor"
			},
		]);

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

	function isUsable()
	{
		return !this.Tactical.isActive() || this.skill.isUsable() && !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
	}

	function onUse( _user, _targetTile )
	{
		if (!this.getContainer().hasSkill("special.mc_chanting"))
		{
			local chant = this.new("scripts/skills/special/mc_chanting_spell");
			chant.setSpell(this);
			this.getContainer().add(chant);
			return false;
		}

		this.spawnIcon("active_mc_06", _user.getTile());
		local tiles = this.getAffectedTiles(_targetTile);
		this.getContainer().setBusy(true);
		foreach (i, tile in tiles)
		{
			this.Time.scheduleEvent(this.TimeUnit.Real, 400 * i + 150, function ( _data )
			{
				switch (this.Math.rand(1, 3)) 
				{
			    case 1:
			   	_data.Skill.spawnFire(_data.User, _data.Tile);
			    break;

			    case 2:
			    _data.Skill.spawnIce(_data.User, _data.Tile);
			    break;

			    default:
				_data.Skill.spawnThunder(_data.User, _data.Tile);  
				}

				if (tiles.len() == i - 1)
				{
					_data.Skill.getContainer().setBusy(false);
				}
			},
			{
				Tile = tile,
				Skill = this,
				User = _user
			});
		}

		this.getContainer().removeByID("special.mc_chanting");
		return true;
	}

	function spawnFire( _user, _targetTile )
	{
		local p = {
			Type = "fire",
			Tooltip = "Fire rages here, melting armor and flesh alike",
			IsPositive = false,
			IsAppliedAtRoundStart = false,
			IsAppliedAtTurnEnd = true,
			IsAppliedOnMovement = false,
			IsAppliedOnEnter = false,
			IsByPlayer = _user.isPlayerControlled(),
			Timeout = this.Time.getRound() + 2,
			Callback = this.Const.Tactical.Common.onApplyFire,
			function Applicable( _a )
			{
				return true;
			}

		};
		
		if (_targetTile.IsOccupiedByActor)
		{
			this.m.ElementType = 1;
			this.attackEntity(_user, _targetTile.getEntity(), false);
		}
		
		if (_targetTile.Properties.Effect != null && _targetTile.Properties.Effect.Type == "fire")
		{
			_targetTile.Properties.Effect.Timeout = this.Time.getRound() + 2;
		}
		else
		{
			if (_targetTile.Properties.Effect != null)
			{
				this.Tactical.Entities.removeTileEffect(_targetTile);
			}

			_targetTile.Properties.Effect = clone p;
			local particles = [];

			for( local i = 0; i < this.Const.Tactical.FireParticles.len(); i = ++i )
			{
				particles.push(this.Tactical.spawnParticleEffect(true, this.Const.Tactical.FireParticles[i].Brushes, _targetTile, this.Const.Tactical.FireParticles[i].Delay, this.Const.Tactical.FireParticles[i].Quantity, this.Const.Tactical.FireParticles[i].LifeTimeQuantity, this.Const.Tactical.FireParticles[i].SpawnRate, this.Const.Tactical.FireParticles[i].Stages));
			}

			this.Tactical.Entities.addTileEffect(_targetTile, _targetTile.Properties.Effect, particles);

			if (_targetTile.Subtype != this.Const.Tactical.TerrainSubtype.LightSnow && _targetTile.Type != this.Const.Tactical.TerrainType.ShallowWater && _targetTile.Type != this.Const.Tactical.TerrainType.DeepWater)
			{
				_targetTile.clear(this.Const.Tactical.DetailFlag.Scorchmark);
				_targetTile.spawnDetail("impact_decal", this.Const.Tactical.DetailFlag.Scorchmark, false, true);
			}
		}

		this.m.ElementType = 0;
	}

	function spawnIce( _user, _targetTile )
	{
		if (_targetTile.IsOccupiedByActor)
		{
			local entity = _targetTile.getEntity()
			entity.getSkills().add(this.new("scripts/skills/effects/chilled_effect"));
			this.m.ElementType = 2;
			this.attackEntity(_user, entity, false);
		}

		if (_targetTile.Subtype != this.Const.Tactical.TerrainSubtype.Snow && _targetTile.Subtype != this.Const.Tactical.TerrainSubtype.LightSnow)
		{
			_targetTile.clear();
			_targetTile.Type = 0;
			this.m.SnowTiles[this.Math.rand(0, this.m.SnowTiles.len() - 1)].onFirstPass({
				X = _targetTile.SquareCoords.X,
				Y = _targetTile.SquareCoords.Y,
				W = 1,
				H = 1,
				IsEmpty = true,
				SpawnObjects = false
			});
		}

		this.m.ElementType = 0;
	}

	function spawnThunder( _user, _targetTile )
	{
		local excludedTile = [
			this.Const.Tactical.TerrainType.ShallowWater,
			this.Const.Tactical.TerrainType.DeepWater,
			this.Const.Tactical.TerrainType.Swamp
		];
		local isWetTile = excludedTile.find(_targetTile.Type) != null;

		for( local i = 0; i < this.Const.Tactical.LightningParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(true, this.Const.Tactical.LightningParticles[i].Brushes, _targetTile, this.Const.Tactical.LightningParticles[i].Delay, this.Const.Tactical.LightningParticles[i].Quantity, this.Const.Tactical.LightningParticles[i].LifeTimeQuantity, this.Const.Tactical.LightningParticles[i].SpawnRate, this.Const.Tactical.LightningParticles[i].Stages);
		}

		if ((_targetTile.IsEmpty || _targetTile.IsOccupiedByActor) && !isWetTile)
		{
			_targetTile.clear(this.Const.Tactical.DetailFlag.Scorchmark);
			_targetTile.spawnDetail("impact_decal", this.Const.Tactical.DetailFlag.Scorchmark, false, true);
		}

		if (_targetTile.IsOccupiedByActor && _targetTile.getEntity().isAttackable())
		{
			this.m.ElementType = 3;
			this.attackEntity(_user, _targetTile.getEntity(), false);
		}

		this.m.ElementType = 0;
	}
	
	function onTargetSelected( _targetTile )
	{
		local tiles = this.getAffectedTiles(_targetTile);

		foreach ( t in tiles ) 
		{
		    this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, t, t.Pos.X, t.Pos.Y);
		}
	}

	function getAffectedTiles(_targetTile)
	{
		if (_targetTile == null)
		{
			return [];
		}

		local ret = [];
		ret.push(_targetTile);

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				ret.push(_targetTile.getNextTile(i));
			}
		}

		return ret;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin += 46;
			_properties.DamageRegularMax += 68;
			_properties.DamageArmorMult *= 0.5;
			_properties.DamageTotalMult *= this.getBonusDamageFromResolve(_properties);
			this.removeBonusesFromWeapon(_properties);

			switch (this.m.ElementType) 
			{
		    case 1:
			   	_properties.DamageTotalMult *= 1.33;
			   	_properties.DamageArmorMult /= 0.5;
			   	this.m.DirectDamageMult = 0.2;
			   	this.m.InjuriesOnBody = this.Const.Injury.BurningBody;
				this.m.InjuriesOnHead = this.Const.Injury.BurningHead;

				if (_targetEntity != null)
				{
					if (_targetEntity.getType() == this.Const.EntityType.Schrat)
					{
						_properties.DamageTotalMult *= 3.0;
					}

					if (_targetEntity.getSkills().hasSkill("racial.skeleton"))
					{
						_properties.DamageTotalMult *= 0.33;
					}

					if (_targetEntity.getSkills().hasSkill("items.firearms_resistance") || _targetEntity.getSkills().hasSkill("racial.serpent"))
					{
						_properties.DamageTotalMult *= 0.66;
					}
				}
			    break;

		    case 3:
				_properties.DamageTotalMult *= 0.67;
				_properties.DamageArmorMult = 0.0;
				_properties.IsIgnoringArmorOnAttack = true;
				this.m.DirectDamageMult = 1.0;
				this.m.InjuriesOnBody = this.Const.Injury.BurningBody;
				this.m.InjuriesOnHead = this.Const.Injury.BurningHead;
				break;

			default:
				this.m.DirectDamageMult = 0.5;
				this.m.InjuriesOnBody = null;
				this.m.InjuriesOnHead = null;
			}
		}
	}
	

});

