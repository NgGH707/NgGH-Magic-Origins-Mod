this.mc_ELE_lightning <- this.inherit("scripts/skills/mc_magic_skill", {
	m = {
		SoundOnLightning = [
			"sounds/combat/dlc2/legendary_lightning_01.wav",
			"sounds/combat/dlc2/legendary_lightning_02.wav"
		],
		IsChained = false,
		AdditionalAccuracy = 10,
		AdditionalHitChance = -4
	},
	function create()
	{
		this.m.ID = "actives.mc_lightning";
		this.m.Name = "Lightning Strike";
		this.m.Description = "Call down a lightning strike to electrocute your target. Accuracy based on ranged skill, Damage based on resolve, deal reduced damage if you don\'t have a magic staff. Can not be used while engaged in melee.";
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
			"sounds/combat/dlc2/legendary_lightning_01.wav",
			"sounds/combat/dlc2/legendary_lightning_02.wav"
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
		this.m.IsShieldwallRelevant = false;
		this.m.IsIgnoreBlockTarget = true;
		this.m.IsOnlyInCalculation = true;
		this.m.IsRanged = true;
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
		local ret = this.getDefaultRangedTooltip();
		ret.extend([
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
				text = "Deal extra damage to target standing on wet tile"
			}
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
		this.Time.scheduleEvent(this.TimeUnit.Real, 400, function ( _data )
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

			_data.Skill.reset(true);
		},
		{
			Tile = _targetTile,
			Skill = this,
			User = _user
		});

		return true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin += 15;
			_properties.DamageRegularMax += 35;
			_properties.DamageArmorMult *= 0.0;
			_properties.IsIgnoringArmorOnAttack = true;
			_properties.RangedSkill += this.m.AdditionalAccuracy;
			_properties.HitChanceAdditionalWithEachTile += this.m.AdditionalHitChance;

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

			_properties.DamageTotalMult *= this.getBonusDamageFromResolve(_properties);
			this.removeBonusesFromWeapon(_properties);
		}
	}

	function onTargetSelected( _targetTile )
	{
		this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
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

