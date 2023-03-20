this.fire_mortar <- this.inherit("scripts/skills/skill", {
	m = {
		SiegeWeapon = null,
		AffectedTiles = []
	},
	function setWeapon( _w )
	{
		this.m.SiegeWeapon = _w;
	}

	function create()
	{
		this.m.ID = "actives.fire_mortar";
		this.m.Name = "Fire Mortar";
		this.m.Description = "Fire! Let your enemies have a taste of you little toy. Can not be used while engaged in melee.";
		this.m.KilledString = "Blown to bits";
		this.m.Icon = "skills/active_211.png";
		this.m.IconDisabled = "skills/active_211_sw.png";
		this.m.Overlay = "active_211";
		this.m.SoundOnUse = [
			"sounds/combat/dlc6/fire_mortar_01.wav",
			"sounds/combat/dlc6/fire_mortar_02.wav",
			"sounds/combat/dlc6/fire_mortar_03.wav",
			"sounds/combat/dlc6/fire_mortar_04.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/dlc6/fire_mortar_impact_01.wav",
			"sounds/combat/dlc6/fire_mortar_impact_01.wav",
			"sounds/combat/dlc6/fire_mortar_impact_01.wav",
			"sounds/combat/dlc6/fire_mortar_impact_01.wav"
		];
		this.m.SoundOnHitDelay = 0;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 5;
		this.m.IsSerialized = false;
		this.m.Delay = 2500;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsAOE = true;
		this.m.IsTargetingActor = false;
		this.m.IsUsingHitchance = false;
		this.m.IsRangeLimitsEnforced = false;
		this.m.IsDoingForwardMove = true;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsRemovedAfterBattle = true;
		this.m.InjuriesOnBody = this.Const.Injury.BurningAndPiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.BurningAndPiercingHead;
		this.m.DirectDamageMult = 0.2;
		this.m.ActionPointCost = 7;
		this.m.FatigueCost = 5;
		this.m.MinRange = 4;
		this.m.MaxRange = 99;
		this.m.MaxLevelDifference = 4;
	}
	
	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range from [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMinRange() + "[/color] to [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles on even ground"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "Shots can easily go astray and hit other tiles"
			}
		]);

		local mortar = this.m.SiegeWeapon != null && this.m.SiegeWeapon.isLoaded();

		if (mortar)
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/icons/ammo.png",
				text = "A [color=" + this.Const.UI.Color.PositiveValue + "]loaded Mortar[/color] is nearby"
			});
		}
		else
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Needs to reload your mortar[/color]"
			});
		}

		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not be used because this character is engaged in melee[/color]"
			});
		}

		return ret;
	}

	function isUsable()
	{
		return this.skill.isUsable() && this.m.SiegeWeapon != null && this.m.SiegeWeapon.isLoaded() && !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
	}
	
	function onAfterUpdate( _properties )
	{
		local IsSpecialized = this.getContainer().hasSkill("background.legend_inventor");
		this.m.FatigueCostMult = IsSpecialized ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		this.m.ActionPointCost = IsSpecialized ? 5 : 7;
	}

	function isWaitingOnImpact()
	{
		return this.m.AffectedTiles.len() != 0;
	}

	function getAffectedTiles( _targetTile )
	{
		local ret = [
			_targetTile
		];
		local myTile = this.getContainer().getActor().getTile();

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

	function updateImpact()
	{
		if (this.m.AffectedTiles.len() != 0)
		{
			this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], 1.0, this.m.AffectedTiles[0].Pos);
			this.Time.scheduleEvent(this.TimeUnit.Real, 1400, this.onImpact.bindenv(this), this);
		}
	}

	function onUse( _user, _targetTile )
	{
		local myTile = _user.getTile();
		local dis = myTile.getDistanceTo(_targetTile);
		local targetTiles = this.getAffectedTiles(_targetTile);

		if (dis > 11 && this.Math.rand(1, 100) <= 25 + (dis - 12) * 10)
		{
			targetTiles = this.getAffectedTiles(this.MSU.Array.getRandom(targetTiles));
		}

		this.m.AffectedTiles = this.getAffectedTiles(this.MSU.Array.getRandom(targetTiles));
		this.m.SiegeWeapon.getFlags().set("isLoaded", false);

		foreach( tile in this.m.AffectedTiles )
		{
			tile.Properties.IsMarkedForImpact = true;
			tile.spawnDetail("mortar_target_02", this.Const.Tactical.DetailFlag.SpecialOverlay, false, true);
		}

		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, this.onSpawnFireEffect.bindenv(this), this);

		if (!_user.isHiddenToPlayer())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " fires a shell high in the air");
		}

		return true;
	}

	function onSpawnFireEffect( _tag )
	{
		local myTile = _tag.m.SiegeWeapon != null ? _tag.m.SiegeWeapon.getTile() : _tag.getContainer().getActor().getTile();

		if (_tag.getContainer().getActor().isAlliedWithPlayer())
		{
			for( local i = 0; i < this.Const.Tactical.MortarFireRightParticles.len(); i = ++i )
			{
				local effect = this.Const.Tactical.MortarFireRightParticles[i];
				this.Tactical.spawnParticleEffect(false, effect.Brushes, myTile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 0));
			}
		}
		else
		{
			for( local i = 0; i < this.Const.Tactical.MortarFireLeftParticles.len(); i = ++i )
			{
				local effect = this.Const.Tactical.MortarFireLeftParticles[i];
				this.Tactical.spawnParticleEffect(false, effect.Brushes, myTile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 0));
			}
		}
		
		this.Time.scheduleEvent(this.TimeUnit.Real, 150, function (_tag) 
		{
			_tag.m.SiegeWeapon.getSprite("body").setBrush("mortar_02");
		}, _tag);
		_tag.updateImpact();
	}

	function onImpact( _tag )
	{
		this.Tactical.EventLog.log("A mortar shell impacts on the battlefield");
		this.Tactical.getCamera().quake(this.createVec(0, -1.0), 6.0, 0.16, 0.35);

		for( local i = 0; i < this.Const.Tactical.MortarImpactParticles.len(); i = ++i )
		{
			local effect = this.Const.Tactical.MortarImpactParticles[i];
			this.Tactical.spawnParticleEffect(false, effect.Brushes, _tag.m.AffectedTiles[0], effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 0));
		}

		foreach( t in _tag.m.AffectedTiles )
		{
			t.clear(this.Const.Tactical.DetailFlag.SpecialOverlay);
			t.Properties.IsMarkedForImpact = false;

			if (t.IsOccupiedByActor)
			{
				local target = t.getEntity();

				if (target.getMoraleState() != this.Const.MoraleState.Ignore)
				{
					target.checkMorale(-1, 0);
					target.getSkills().add(this.new("scripts/skills/effects/shellshocked_effect"));
				}

				_tag.attackEntity(_tag.getContainer().getActor(), target);
			}

			if (t.Type != this.Const.Tactical.TerrainType.ShallowWater && t.Type != this.Const.Tactical.TerrainType.DeepWater)
			{
				t.clear(this.Const.Tactical.DetailFlag.Scorchmark);
				t.spawnDetail("impact_decal", this.Const.Tactical.DetailFlag.Scorchmark, false, true);
			}
		}

		_tag.m.AffectedTiles = [];
	}
	
	function onTargetSelected( _targetTile )
	{
		this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
		
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
	
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin = 48;
			_properties.DamageRegularMax = 88;
			_properties.DamageArmorMult = 0.7;
		}
	}

});

