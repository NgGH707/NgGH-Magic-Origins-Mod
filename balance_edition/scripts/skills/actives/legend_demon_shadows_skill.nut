this.legend_demon_shadows_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Tiles = [],
	},
	function hasTile( _id )
	{
		foreach (i, t in this.m.Tiles) 
		{
		    if (t.ID == _id)
		    {
		    	return true;
		    }
		}

		return false;
	}

	function updateTiles()
	{
		local new = [];

		foreach ( t in this.m.Tiles )
		{
			if (t.Properties.Effect != null && t.Properties.Effect.Type == "alp_hellfire")
			{
				new.push(t);
			}
		}

		this.m.Tiles = new;
	}

	function removeAllTiles()
	{
		foreach ( t in this.m.Tiles )
		{
			if (t.Properties.Effect != null && t.Properties.Effect.Type == "alp_hellfire")
			{
				this.Tactical.Entities.removeTileEffect(t);
			}
		}
	}

	function create()
	{
		this.m.ID = "actives.legend_demon_shadows";
		this.m.Name = "Realm of Burning Nightmares";
		this.m.Description = "Summon the hellfire to bring out the agony pain from your foe, fueling the juicy nightmare to the inferno.";
		this.m.Icon = "skills/active_alp_hellfire.png";
		this.m.IconDisabled = "skills/active_alp_hellfire_sw.png";
		this.m.Overlay = "active_alp_hellfire";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/alp_sleep_01.wav",
			"sounds/enemies/dlc2/alp_sleep_02.wav",
			"sounds/enemies/dlc2/alp_sleep_03.wav",
			"sounds/enemies/dlc2/alp_sleep_04.wav",
			"sounds/enemies/dlc2/alp_sleep_05.wav",
			"sounds/enemies/dlc2/alp_sleep_06.wav",
			"sounds/enemies/dlc2/alp_sleep_07.wav",
			"sounds/enemies/dlc2/alp_sleep_08.wav",
			"sounds/enemies/dlc2/alp_sleep_09.wav",
			"sounds/enemies/dlc2/alp_sleep_10.wav",
			"sounds/enemies/dlc2/alp_sleep_11.wav",
			"sounds/enemies/dlc2/alp_sleep_12.wav"
		];
		this.m.IsUsingActorPitch = true;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted - 1;
		this.m.Delay = 0;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = true;
		this.m.IsVisibleTileNeeded = false;
		this.m.InjuriesOnBody = this.Const.Injury.BurningBody;
		this.m.InjuriesOnHead = this.Const.Injury.BurningHead;
		this.m.DirectDamageMult = 0.35;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 0;
		this.m.MinRange = 0;
		this.m.MaxRange = 10;
		this.m.MaxLevelDifference = 4;
	}

	function onAdded()
	{
		if (!this.getContainer().getActor().isPlayerControlled())
		{
			return;
		}

		this.m.FatigueCost = 13;
		this.m.MaxRange = 8;
		this.m.IsVisibleTileNeeded = true;
	}

	function onUpdate( _properties )
	{
		_properties.InitiativeForTurnOrderAdditional += 999;
	}

	function onAfterUpdate( _properties )
	{
		local specialized = this.getContainer().hasSkill("perk.control_flame");
		this.m.FatigueCostMult = specialized ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}
	
	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Brings hellfire to the earth"
		});
		return ret;
	}

	function onTurnStart()
	{
		this.updateTiles();
	}

	function onResumeTurn()
	{
		this.updateTiles();
	}

	function onDeath()
	{
		this.removeAllTiles();
	}

	function onUse( _user, _targetTile )
	{
		local targets = [];
		local self = this;
		local applyFire = self.onApplyFirefield;
		local specialized_1 = this.getContainer().hasSkill("perk.hellish_flame");
		local specialized_2 = this.getContainer().hasSkill("perk.control_flame");
		local specialized_3 = this.getContainer().hasSkill("perk.fiece_flame");
		local time = specialized_3 ? 2 : 4;
		targets.push(_targetTile);

		for( local i = 0; i != 6; i = i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _targetTile.getNextTile(i);
				targets.push(tile);
			}

			i = ++i;
		}

		local custom = {
			Specialized_1 = specialized_1,
			Specialized_2 = specialized_2,
			Specialized_3 = specialized_3,
			UserID = _user.getID(),
		};
		local p = {
			Type = "alp_hellfire",
			Tooltip = "The inferno of nightmare, burns everything dare to go near it. Created by " + _user.getName(),
			IsAppliedAtRoundStart = false,
			IsAppliedAtTurnEnd = true,
			IsAppliedOnMovement = true,
			IsAppliedOnEnter = false,
			IsPositive = false,
			Timeout = this.Time.getRound() + time,
			IsByPlayer = _user.isPlayerControlled(),
			Callback = applyFire,
			Custom = custom,
			function Applicable( _a )
			{
				return _a;
			}
		};

		foreach( tile in targets )
		{
			if (tile.Properties.Effect != null && tile.Properties.Effect.Type == "alp_hellfire")
			{
				tile.Properties.Effect = clone p;
				tile.Properties.Effect.Timeout = this.Time.getRound() + (time * 0.5);
			}
			else
			{
				if (tile.Properties.Effect != null)
				{
					this.Tactical.Entities.removeTileEffect(tile);
				}

				tile.Properties.Effect = clone p;
				local particles = [];

				for( local i = 0; i < this.Const.Tactical.FireParticles.len(); i = i )
				{
					particles.push(this.Tactical.spawnParticleEffect(true, this.Const.Tactical.FireParticles[i].Brushes, tile, this.Const.Tactical.FireParticles[i].Delay, this.Const.Tactical.FireParticles[i].Quantity, this.Const.Tactical.FireParticles[i].LifeTimeQuantity, this.Const.Tactical.FireParticles[i].SpawnRate, this.Const.Tactical.FireParticles[i].Stages));
					i = ++i;
				}
				
				this.Tactical.Entities.addTileEffect(tile, tile.Properties.Effect, particles);
			}

			if (!this.hasTile(tile.ID))
			{
				this.m.Tiles.push(tile);
			}

			if (specialized_1 && tile.IsOccupiedByActor)
			{
				this.onApplyFirefield(tile, tile.getEntity());
			}
		}

		return true;
	}

	function onApplyFirefield( _tile, _entity )
	{
		local data = _tile.Properties.Effect;
		local custom = data.Custom;
		local damage = this.Math.rand(12, 20);
		local damageMult = 1.0;
		local injuries = null;
		local attacker = this.Tactical.getEntityByID(custom.UserID);

		if (attacker == null || !attacker.isAlive() || attacker.isDying())
		{
			attacker = null;
		}

		if (custom.Specialized_2 && _entity.getID() == custom.UserID)
		{
			return;
		}

		if (custom.Specialized_1)
		{
			damage += this.Math.rand(5, 12);
		}

		if (custom.Specialized_3)
		{
			damage += this.Math.rand(5, 20);
			injuries = this.Const.Injury.Burning;
		}

		if (_entity.getCurrentProperties().IsImmuneToFire)
		{
			damageMult *= 0.33;
		}

		if (_entity.getSkills().hasSkill("items.firearms_resistance"))
		{
			damageMult *= 0.67;
		}

		if (_entity.getSkills().hasSkill("racial.serpent"))
		{
			damageMult *= 0.67;
		}

		local types = [
			this.Const.EntityType.Schrat,
			this.Const.EntityType.SchratSmall,
			this.Const.EntityType.LegendGreenwoodSchrat,
			this.Const.EntityType.LegendGreenwoodSchratSmall,
		];

		if (types.find(_entity.getType()) != null || _entity.getFlags().has("isSmallSchrat") || _entity.getFlags().has("isSchrat"))
		{
			damageMult *= 2.0;
		}

		this.Tactical.spawnIconEffect("fire_circle", _tile, this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
		local sounds = [
			"sounds/combat/fire_01.wav",
			"sounds/combat/fire_02.wav",
			"sounds/combat/fire_03.wav",
			"sounds/combat/fire_04.wav",
			"sounds/combat/fire_05.wav",
			"sounds/combat/fire_06.wav"
		];
		this.Sound.play(sounds[this.Math.rand(0, sounds.len() - 1)], this.Const.Sound.Volume.Actor, _entity.getPos());
		local hitInfo = clone this.Const.Tactical.HitInfo;
		hitInfo.DamageRegular = damage * damageMult;
		hitInfo.DamageArmor = hitInfo.DamageRegular;
		hitInfo.DamageDirect = 0.35;
		hitInfo.BodyPart = this.Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		hitInfo.Injuries = injuries;
		hitInfo.InjuryThresholdMult = 1.15;
		hitInfo.IsPlayingArmorSound = false;
		_entity.onDamageReceived(attacker, null, hitInfo);
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local specialized_1 = this.getContainer().hasSkill("perk.hellish_flame");
			local specialized_3 = this.getContainer().hasSkill("perk.fiece_flame");
			_properties.DamageRegularMin = 12;
			_properties.DamageRegularMax = 20;
			_properties.DamageArmorMult = 1.0;
			_properties.RangedDamageMult /= 0.9;

			if (specialized_1)
			{
				_properties.DamageRegularMin += 5;
				_properties.DamageRegularMax += 12;
			}

			if (specialized_3)
			{
				_properties.DamageRegularMin += 5;
				_properties.DamageRegularMax += 20;
			}
		}
	}

	function onCombatStarted()
	{
		this.m.Tiles = [];
	}

	function onCombatFinished()
	{
		this.m.Tiles = [];
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
				local nextTile = _targetTile.getNextTile(i);
				this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, nextTile, nextTile.Pos.X, nextTile.Pos.Y);	
			}
		}
	}

});

