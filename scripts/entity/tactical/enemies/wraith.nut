this.wraith <- this.inherit("scripts/entity/tactical/actor", {
	m = {
		DistortTargetA = null,
		DistortTargetPrevA = this.createVec(0, 0),
		DistortAnimationStartTimeA = 0,
		DistortTargetB = null,
		DistortTargetPrevB = this.createVec(0, 0),
		DistortAnimationStartTimeB = 0,
		DistortTargetC = null,
		DistortTargetPrevC = this.createVec(0, 0),
		DistortAnimationStartTimeC = 0,
		DistortTargetD = null,
		DistortTargetPrevD = this.createVec(0, 0),
		DistortAnimationStartTimeD = 0,
		LastAttackerID = null,
		LastRound = 0,
		Counter = 0,
	},
	function create()
	{
		this.m.Type = this.Const.EntityType.Ghost;
		this.m.BloodType = this.Const.BloodType.None;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.m.IsEmittingMovementSounds = false;
		this.actor.create();
		this.m.Name = "Wraith";
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/ghost_death_01.wav",
			"sounds/enemies/ghost_death_02.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/geist_idle_13.wav",
			"sounds/enemies/geist_idle_14.wav",
			"sounds/enemies/geist_idle_15.wav",
			"sounds/enemies/geist_idle_16.wav",
			"sounds/enemies/geist_idle_17.wav"
		];
		this.m.SoundPitch = this.Math.rand(90, 110) * 0.01;
		this.getFlags().add("undead");
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/wraith_agent");
		this.m.AIAgent.setActor(this);
		this.m.XP = 50000;
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (!this.Tactical.State.isScenarioMode() && _killer != null && _killer.isPlayerControlled())
		{
			this.updateAchievement("OvercomingFear", 1, 1);
		}

		if (_tile != null)
		{
			local effect = {
				Delay = 0,
				Quantity = 12,
				LifeTimeQuantity = 12,
				SpawnRate = 100,
				Brushes = [
					"bust_wraith_01"
				],
				Stages = [
					{
						LifeTimeMin = 1.0,
						LifeTimeMax = 1.0,
						ColorMin = this.createColor("ffffff5f"),
						ColorMax = this.createColor("ffffff5f"),
						ScaleMin = 1.0,
						ScaleMax = 1.0,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = this.createVec(-1.0, -1.0),
						DirectionMax = this.createVec(1.0, 1.0),
						SpawnOffsetMin = this.createVec(-10, -10),
						SpawnOffsetMax = this.createVec(10, 10),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 0)
					},
					{
						LifeTimeMin = 1.0,
						LifeTimeMax = 1.0,
						ColorMin = this.createColor("ffffff2f"),
						ColorMax = this.createColor("ffffff2f"),
						ScaleMin = 0.9,
						ScaleMax = 0.9,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = this.createVec(-1.0, -1.0),
						DirectionMax = this.createVec(1.0, 1.0),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 0)
					},
					{
						LifeTimeMin = 0.1,
						LifeTimeMax = 0.1,
						ColorMin = this.createColor("ffffff00"),
						ColorMax = this.createColor("ffffff00"),
						ScaleMin = 0.1,
						ScaleMax = 0.1,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = this.createVec(-1.0, -1.0),
						DirectionMax = this.createVec(1.0, 1.0),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 0)
					}
				]
			};
			this.Tactical.spawnParticleEffect(false, effect.Brushes, _tile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 40));
			this.onSpawnMiasma(_tile);
		}

		local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);

		foreach ( poorVictim in brothers ) 
		{
		    if (!poorVictim.getFlags().get("IsPlayerCharacter"))
		    {
		    	local color;
				do
				{
					color = this.createColor("#ff0000");
					color.varyRGB(0.75, 0.75, 0.75);
				}
				while (color.R + color.G + color.B <= 150);
				this.Tactical.spawnSpriteEffect("effect_pentagram_02", color, poorVictim.getTile(), !poorVictim.getSprite("status_hex").isFlippedHorizontally() ? 10 : -5, 88, 3.0, 1.0, 0, 400, 300);
		    	this.Tactical.CameraDirector.addMoveToTileEvent(0, poorVictim.getTile());
				this.Tactical.CameraDirector.addDelay(1.5);
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this) + " isn't died alone");
				poorVictim.kill(this, null, this.Const.FatalityType.Decapitated);
		    	break;
		    }
		}

		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function onInit()
	{
		this.actor.onInit();
		this.setRenderCallbackEnabled(true);
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Ghost);
		b.ActionPoints = 9;
		b.Hitpoints = 10;
		b.Bravery = 999;
		b.Stamina = 100;
		b.MeleeSkill = 100;
		b.MeleeDefense = 50;
		b.RangedDefense = 999;
		b.Initiative = 0;
		b.InitiativeForTurnOrderAdditional = -190;
		b.Vision = 99;
		b.Threat = 999;
		b.ThreatOnHit = 999;
		b.DamageMinimum = 25;
		b.DamageRegularMin = 25;
		b.DamageRegularMax = 35;
		b.DamageReceivedRangedMult = 0.0;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToRoot = true;
		b.IsImmuneToDisarm = true;
		b.IsImmuneToFire = true;
		b.IsImmuneToSurrounding = true;
		b.IsFleetfooted = true;
		b.IsIgnoringArmorOnAttack = true;
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsAffectedByRain = false;
		b.FatalityChanceMult = 10000.0;
		b.MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] = 10000.0;
		//b.IsAttackingOnZoneOfControlEnter = true;
		//b.IsAttackingOnZoneOfControlAlways = true;

		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.SameMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.m.MaxTraversibleLevels = 4;
		this.m.Items.getAppearance().Body = "bust_wraith_01";
		this.addSprite("socket").setBrush("bust_base_undead");
		this.addSprite("fog").setBrush("bust_wraith_fog_02");
		local body = this.addSprite("body");
		body.setBrush("bust_wraith_01");
		body.varySaturation(0.25);
		body.varyColor(0.2, 0.2, 0.2);
		local head = this.addSprite("head");
		head.setBrush("bust_wraith_01");
		head.varySaturation(0.25);
		head.varyColor(0.2, 0.2, 0.2);
		local blur_1 = this.addSprite("blur_1");
		blur_1.setBrush("bust_wraith_01");
		blur_1.varySaturation(0.25);
		blur_1.varyColor(0.2, 0.2, 0.2);
		local blur_2 = this.addSprite("blur_2");
		blur_2.setBrush("bust_wraith_01");
		blur_2.varySaturation(0.25);
		blur_2.varyColor(0.2, 0.2, 0.2);
		this.addDefaultStatusSprites();
		local rage = this.addSprite("status_rage");
		rage.setHorizontalFlipping(true);
		rage.setBrush("mind_control");
		rage.Visible = false;
		this.setSpriteOffset("status_rage", this.createVec(-15, 0));
		this.getSprite("status_rooted").Scale = 0.55;
		this.setSpriteOffset("status_rooted", this.createVec(-5, -5));

		local skill = this.new("scripts/skills/actives/horror_skill");
		skill.m.MaxRange = 3;
		skill.m.ActionPointCost = 5;
		this.m.Skills.add(skill);

		skill = this.new("scripts/skills/actives/miasma_skill");
		skill.m.MaxRange = 4;
		skill.m.ActionPointCost = 5;
		this.m.Skills.add(skill);

		skill = this.new("scripts/skills/actives/horrific_scream");
		skill.m.MaxRange = 4;
		skill.m.ActionPointCost = 3;
		this.m.Skills.add(skill);

		skill = this.new("scripts/skills/actives/ghastly_touch");
		skill.m.MaxRange = 2;
		skill.m.ActionPointCost = 3;
		this.m.Skills.add(skill);

		skill = this.new("scripts/skills/actives/mod_ghost_possess");
		skill.m.IsEnhanced = true;
		this.m.Skills.add(skill);

		this.m.Skills.add(this.new("scripts/skills/racial/ghost_racial"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fearsome"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_footwork"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_rotation"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_anticipation"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_legend_terrifying_visage"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fast_adaption"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_killing_frenzy"));

		local NineLives = this.new("scripts/skills/perks/perk_nine_lives");
		NineLives.addNineLivesCount(9);
		this.m.Skills.add(NineLives);

		if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
		{
			b.Initiative += 100;
			this.m.CurrentProperties = clone b;
			this.m.Skills.add(this.new("scripts/skills/perks/perk_dodge"));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_legend_levitation"));
		}
		
		this.makeMiniboss();
	}

	function onRender()
	{
		this.actor.onRender();

		if (this.m.DistortTargetA == null)
		{
			this.m.DistortTargetA = this.createVec(this.Math.rand(0, 8) - 4, this.Math.rand(0, 8) - 4);
			this.m.DistortAnimationStartTimeA = this.Time.getVirtualTimeF();
		}

		if (this.moveSpriteOffset("head", this.m.DistortTargetPrevA, this.m.DistortTargetA, 3.8, this.m.DistortAnimationStartTimeA))
		{
			this.m.DistortAnimationStartTimeA = this.Time.getVirtualTimeF();
			this.m.DistortTargetPrevA = this.m.DistortTargetA;
			this.m.DistortTargetA = this.createVec(this.Math.rand(0, 8) - 4, this.Math.rand(0, 8) - 4);
		}

		if (this.m.DistortTargetB == null)
		{
			this.m.DistortTargetB = this.createVec(this.Math.rand(0, 8) - 4, this.Math.rand(0, 8) - 4);
			this.m.DistortAnimationStartTimeB = this.Time.getVirtualTimeF();
		}

		if (this.moveSpriteOffset("blur_1", this.m.DistortTargetPrevB, this.m.DistortTargetB, 4.9000001, this.m.DistortAnimationStartTimeB))
		{
			this.m.DistortAnimationStartTimeB = this.Time.getVirtualTimeF();
			this.m.DistortTargetPrevB = this.m.DistortTargetB;
			this.m.DistortTargetB = this.createVec(this.Math.rand(0, 8) - 4, this.Math.rand(0, 8) - 4);
		}

		if (this.m.DistortTargetC == null)
		{
			this.m.DistortTargetC = this.createVec(this.Math.rand(0, 8) - 4, this.Math.rand(0, 8) - 4);
			this.m.DistortAnimationStartTimeC = this.Time.getVirtualTimeF();
		}

		if (this.moveSpriteOffset("body", this.m.DistortTargetPrevC, this.m.DistortTargetC, 4.3, this.m.DistortAnimationStartTimeC))
		{
			this.m.DistortAnimationStartTimeC = this.Time.getVirtualTimeF();
			this.m.DistortTargetPrevC = this.m.DistortTargetC;
			this.m.DistortTargetC = this.createVec(this.Math.rand(0, 8) - 4, this.Math.rand(0, 8) - 4);
		}

		if (this.m.DistortTargetD == null)
		{
			this.m.DistortTargetD = this.createVec(this.Math.rand(0, 8) - 4, this.Math.rand(0, 8) - 4);
			this.m.DistortAnimationStartTimeD = this.Time.getVirtualTimeF();
		}

		if (this.moveSpriteOffset("blur_2", this.m.DistortTargetPrevD, this.m.DistortTargetD, 5.5999999, this.m.DistortAnimationStartTimeD))
		{
			this.m.DistortAnimationStartTimeD = this.Time.getVirtualTimeF();
			this.m.DistortTargetPrevD = this.m.DistortTargetD;
			this.m.DistortTargetD = this.createVec(this.Math.rand(0, 8) - 4, this.Math.rand(0, 8) - 4);
		}
	}
	
	function makeMiniboss()
	{
		if (!this.actor.makeMiniboss())
		{
			return false;
		}
		
		this.getSprite("miniboss").setBrush("bust_miniboss"); 
		this.m.Skills.add(this.new("scripts/skills/perks/perk_hold_out"));
		return true;
	}
	
	function activateCheatPunish()
	{
		local b = this.m.BaseProperties;
		b.ActionPoints = 12;
		b.HitChance = [
			0,
			100
		];
		
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts =  [0, 0, 0, 0, 0, 0, 0, 0, 0];
		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this) + " has become enraged and want to hunt you down to the last one");
	}

	/*function onMissed( _attacker, _skill, _dontShake = false )
	{
		this.actor.onMissed(_attacker, _skill, _dontShake);

		if (_attacker != null)
		{
			if (this.Time.getRound() == this.m.LastRound && this.m.LastAttackerID == _attacker.getID())
			{
				++this.m.Counter;
			}
			else
			{
				this.m.Counter = 0;
			}

			this.m.LastAttackerID = _attacker.getID();
			this.m.LastRound = this.Time.getRound();

			if (this.m.Counter > 6)
			{
				_attacker.killSilently();
			}
		}
	}*/

	/*function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		local ret = this.actor.onDamageReceived(_attacker, _skill, _hitInfo);

		if (_attacker != null)
		{
			if (this.Time.getRound() == this.m.LastRound && this.m.LastAttackerID == _attacker.getID())
			{
				++this.m.Counter;
			}
			else
			{
				this.m.Counter = 0;
			}

			this.m.LastAttackerID = _attacker.getID();
			this.m.LastRound = this.Time.getRound();

			if (this.m.Counter > 6)
			{
				_attacker.killSilently();
			}
		}
		
		return ret;
	}*/
	
	function killSilently()
	{
		this.activateCheatPunish();
	}
	
	function kill( _killer = null, _skill = null, _fatalityType = this.Const.FatalityType.None, _silent = false )
	{
		_fatalityType = this.Const.FatalityType.None;
		
		if (_killer == null && _skill == null && _fatalityType == this.Const.FatalityType.None && !_silent)
		{
			this.m.Hitpoints = this.m.Hitpoints == 0 ? 1 : this.m.Hitpoints;
			this.Tactical.EventLog.log("[color=" + this.Const.UI.Color.DamageValue + "]Cheater!!! You have angered me[/color]");
			this.Tactical.spawnSpriteEffect("status_effect_111", this.createColor("#ffffff"), this.getTile(), this.Const.Tactical.Settings.SkillOverlayOffsetX, this.Const.Tactical.Settings.SkillOverlayOffsetY, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayStayDuration, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
			return this.activateCheatPunish();
		}
		
		if (_killer == null || _skill == null)
		{
			this.m.Hitpoints = this.m.Hitpoints == 0 ? 1 : this.m.Hitpoints;
			this.Tactical.EventLog.log("Such pitiful lucky hits can\'t kill " + this.Const.UI.getColorizedEntityName(this));
			this.Tactical.spawnSpriteEffect("status_effect_111", this.createColor("#ffffff"), this.getTile(), this.Const.Tactical.Settings.SkillOverlayOffsetX, this.Const.Tactical.Settings.SkillOverlayOffsetY, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayStayDuration, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
			return;
		}
		
		this.actor.kill(_killer, _skill, _fatalityType, _silent);
	}
	
	function onPlacedOnMap()
	{
		this.actor.onPlacedOnMap();
		this.onSpawnMiasma();
	}

	function onTurnStart()
	{
		this.actor.onTurnStart();
		this.onSpawnMiasma();
	}
	
	function wait()
	{
		this.actor.wait();
		this.onSpawnMiasma();
	}

	function onTurnEnd()
	{
		this.actor.onTurnEnd();
		this.onSpawnMiasma();
	}
	
	function onMovementStart( _tile, _numTiles )
	{
		this.actor.onMovementStart(_tile, _numTiles);
		this.onRemoveMiasma(_tile);
	}
	
	function onMovementFinish( _tile )
	{
		this.actor.onMovementFinish(_tile);
		this.onSpawnMiasma(_tile);
	}
	
	function onSpawnMiasma( _tile = null )
	{
		local myTile = _tile != null ? _tile : this.getTile();
		local affectedTiles = [
			myTile,
		];

		for( local i = 0; i != 6; i = ++i )
		{
			if (!myTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = myTile.getNextTile(i);
				affectedTiles.push(tile);
			}
		}

		local p = {
			Type = "miasma",
			Tooltip = "Miasma lingers here, harmful to any living being",
			IsPositive = true,
			IsAppliedAtRoundStart = false,
			IsAppliedAtTurnEnd = true,
			IsAppliedOnMovement = true,
			IsAppliedOnEnter = true,
			IsByPlayer = false,
			Timeout = this.Time.getRound() + 2,
			Callback = this.Const.Tactical.Common.onApplyMiasma,
			function Applicable( _a )
			{
				return !_a.getFlags().has("undead");
			}

		};

		foreach( tile in affectedTiles )
		{
			if (tile.Properties.Effect != null && tile.Properties.Effect.Type == "miasma")
			{
				tile.Properties.Effect.Timeout = this.Time.getRound() + 2;
				tile.Properties.Effect.IsAppliedAtTurnEnd = true;
				tile.Properties.Effect.IsAppliedOnMovement = true;
				tile.Properties.Effect.IsAppliedOnEnter = true;
			}
			else
			{
				if (tile.Properties.Effect != null)
				{
					this.Tactical.Entities.removeTileEffect(tile);
				}

				tile.Properties.Effect = clone p;
				local particles = [];

				for( local i = 0; i < this.Const.Tactical.MiasmaParticles.len(); i = ++i )
				{
					particles.push(this.Tactical.spawnParticleEffect(true, this.Const.Tactical.MiasmaParticles[i].Brushes, tile, this.Const.Tactical.MiasmaParticles[i].Delay, this.Const.Tactical.MiasmaParticles[i].Quantity, this.Const.Tactical.MiasmaParticles[i].LifeTimeQuantity, this.Const.Tactical.MiasmaParticles[i].SpawnRate, this.Const.Tactical.MiasmaParticles[i].Stages));
				}

				this.Tactical.Entities.addTileEffect(tile, tile.Properties.Effect, particles);
			}
		}
	}
	
	function onRemoveMiasma( _tile = null )
	{
		local myTile = _tile != null ? _tile : this.getTile();
		local affectedTiles = [
			myTile,
		];

		for( local i = 0; i != 6; i = ++i )
		{
			if (!myTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = myTile.getNextTile(i);
				affectedTiles.push(tile);
			}
		}
		
		foreach( tile in affectedTiles )
		{
			if (tile.Properties.Effect != null)
			{
				this.Tactical.Entities.removeTileEffect(tile);
			}
		}
	}

});

