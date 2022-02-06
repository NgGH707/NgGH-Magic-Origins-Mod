this.mc_GEO_earthquake <- this.inherit("scripts/skills/mc_magic_skill", {
	m = {
		DamageMin = 10,
		DamageMax = 25,
		DazeChance = 25
	},
	function create()
	{
		this.mc_magic_skill.create();
		this.m.ID = "actives.mc_earthquake";
		this.m.Name = "Earthquake";
		this.m.Description = "Cause a large scale seismic activity in a huge area that can potentially daze enemies, make them lose their balance. Fatigue damage based on resolve, deal reduced fatigue damage if you don\'t have a magic staff. Can not be used while engaged in melee.";
		this.m.KilledString = "Swallowed by the Earth";
		this.m.Icon = "skills/active_mc_09.png";
		this.m.IconDisabled = "skills/active_mc_09_sw.png";
		this.m.Overlay = "active_mc_09";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/schrat_uproot_01.wav",
			"sounds/enemies/dlc2/schrat_uproot_02.wav",
			"sounds/enemies/dlc2/schrat_uproot_03.wav",
			"sounds/enemies/dlc2/schrat_uproot_04.wav",
			"sounds/enemies/dlc2/schrat_uproot_05.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/dlc2/schrat_uproot_hit_01.wav",
			"sounds/enemies/dlc2/schrat_uproot_hit_02.wav",
			"sounds/enemies/dlc2/schrat_uproot_hit_03.wav",
			"sounds/enemies/dlc2/schrat_uproot_hit_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.TemporaryInjury + 2;
		this.m.Delay = 750;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoreBlockTarget = true;
		this.m.IsUsingHitchance = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsIgnoringRiposte = true;
		this.m.IsAOE = true;
		this.m.IsTargetingActor = false;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 40;
		this.m.MinRange = 3;
		this.m.MaxRange = 5;
		this.m.MaxRangeBonus = 9;
	}
	
	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		local properties = this.getContainer().getActor().getCurrentProperties()
		local mult = this.getBonusDamageFromResolve(properties);
		local damage_max = this.Math.floor(this.m.DamageMax * mult * properties.FatigueDealtPerHitMult);
		local damage_min = this.Math.floor(this.m.DamageMin * mult * properties.FatigueDealtPerHitMult);
		ret.extend([
			{
				id = 9,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "Inflicts [color=" + this.Const.UI.Color.DamageValue + "]" + damage_min + "[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + damage_max + "[/color] fatigue damage"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.MinRange + "[/color] - [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.MaxRange + "[/color] tiles on even ground, more if casting downhill"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has a chance to [color=" + this.Const.UI.Color.NegativeValue + "]Daze[/color] or [color=" + this.Const.UI.Color.NegativeValue + "]Distracted[/color] on hit"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Huge area of effect"
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
	
	function onAfterUpdate( _properties )
	{
		this.mc_magic_skill.onAfterUpdate(_properties);
		this.m.MaxRange = _properties.IsSpecializedInMC_Magic ? 6 : 5;
	}

	function applyEffectToTarget( _user, _target, _targetTile )
	{
		if (_target.isNonCombatant())
		{
			return;
		}
		
		if (_target.getFlags().has("zombie_minion"))
		{
			_target.getSkills().add(this.new("scripts/skills/effects/staggered_effect"));
			
			if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " has staggered " + this.Const.UI.getColorizedEntityName(_target) + " for 2 turns");
			}
		}

		local chance = this.m.DazeChance;
		
		if (this.Math.rand(1, 100) > this.m.DazeChance)
		{
			return;
		}
		
		local effect = this.Math.rand(1, 3);
		
		if (!_target.getCurrentProperties().IsImmuneToStun && effect == 1)
		{
			_target.getSkills().add(this.new("scripts/skills/effects/dazed_effect"));
			
			if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " has dazed " + this.Const.UI.getColorizedEntityName(_target) + " for 2 turns");
			}
		}
		else
		{
			local r = this.Math.rand(1, 2) == 1 ? "distracted_effect" : "staggered_effect";
			_target.getSkills().add(this.new("scripts/skills/effects/" + r));
		}
	}

	function onUse( _user, _targetTile )
	{
		local myTile = _user.getTile();
		local tiles = this.getAffectedTiles(_targetTile);
		tiles.push(_targetTile);
		this.getContainer().setBusy(true);
		//this.Tactical.CameraDirector.addMoveSlowlyToTileEvent(100, _targetTile);
		//this.Tactical.CameraDirector.addDelay(1.5);
		local flying_enemies = [
			this.Const.EntityType.FlyingSkull,
			this.Const.EntityType.SkeletonLichMirrorImage,
			this.Const.EntityType.Ghost,
			this.Const.EntityType.AlpShadow,
			this.Const.EntityType.LegendBanshee,
		];
		local properties = _user.getCurrentProperties();
		local mult = this.getBonusDamageFromResolve(properties);
		
		foreach (t in tiles)
		{
			if (this.Math.rand(1, 100) <= 75)
			{
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 100 + 50 * this.Math.rand(1, 8), function( _tile )
				{
					for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
					{
						this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, _tile, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity * 0.5, this.Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages, this.createVec(0, -30));
					}
				}.bindenv(this), t);
			}
			
			if (t.IsOccupiedByActor)
			{
				local entity = t.getEntity();
				local skills = entity.getSkills();
				skills.removeByID("effects.shieldwall");
				skills.removeByID("effects.spearwall");
				skills.removeByID("effects.riposte");

				if (skills.hasSkill("racial.ghost") || skills.hasSkill("effects.legend_levitating") || flying_enemies.find(entity.getType()) != null)
				{
					continue;
				}
				
				if (entity.m.IsShakingOnHit)
				{
					this.Tactical.getShaker().shake(entity, t, 10);
					_user.playSound(this.Const.Sound.ActorEvent.Move, 2.0);
				}
				
				local damage = this.Math.rand(this.m.DamageMin, this.m.DamageMax) * mult * properties.FatigueDealtPerHitMult;
				this.applyFatigueDamage(entity, this.Math.floor(damage));
				this.applyEffectToTarget(_user, entity, t);
			}
		}
		
		this.getContainer().setBusy(false);
		return true;
	}
	
	function onTargetSelected( _targetTile )
	{
		local tiles = this.getAffectedTiles(_targetTile);
		
		this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
		
		if (tiles.len() != 0)
		{
			foreach( t in tiles )
			{
				this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, t, t.Pos.X, t.Pos.Y);
			}
		}
	}
	
	function getAffectedTiles( _targetTile )
	{
		local ret;
		local allNextTiles = [];
		local availableTiles = [];
		local selectedTilesID = [];
		
		selectedTilesID.push(_targetTile.ID);

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local nextTile = _targetTile.getNextTile(i);

				if (this.Math.abs(nextTile.Level - _targetTile.Level) > 1)
				{
				}
				else
				{
					allNextTiles.push(nextTile);
					availableTiles.push(nextTile);
					selectedTilesID.push(nextTile.ID);
				}
			}
		}
		
		if (availableTiles.len() <= 0)
		{
			return null;
		}
		
		foreach (t in allNextTiles)
		{
			for( local i = 0; i < 6; i = ++i )
			{
				if (!t.hasNextTile(i))
				{
				}
				else
				{
					local i = t.getNextTile(i);

					if (selectedTilesID.find(i.ID) != null || this.Math.abs(i.Level - t.Level) > 1)
					{
					}
					else
					{
						availableTiles.push(i);
						selectedTilesID.push(i.ID);
					}
				}
			}
		}
		
		if (availableTiles.len() <= 0)
		{
			return null;
		}
		else
		{
			return availableTiles;
		}
	}
	
});

