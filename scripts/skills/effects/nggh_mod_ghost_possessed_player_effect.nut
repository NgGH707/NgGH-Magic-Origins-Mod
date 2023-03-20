this.nggh_mod_ghost_possessed_player_effect <- ::inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 1,
		OriginalFaction = 0,
		OriginalAgent = null,
		OriginalSocket = null,
		PossessorFaction = ::Const.Faction.PlayerAnimals,
		Possessor = null,
		IsActivated = false,
		IsBattleEnd = false,
		IsEnhanced = false,
		IsExorcised = false,
		AttackerID = null,
		GhostSkills = [],
		LastTile = null
	},
	function setPossessorFaction( _f )
	{
		this.m.PossessorFaction = _f;
	}

	function setExorcised( _f )
	{
		this.m.IsExorcised = _f;
	}

	function setPossessor( _f )
	{
		this.m.Possessor = _f;
	}

	function setEffect( _f )
	{
		this.m.IsEnhanced = _f;
	}

	function getName()
	{
		if (this.m.Possessor != null)
		{
			return this.m.Name + " by " + ::Const.UI.getColorizedEntityName(this.m.Possessor);
		}

		return this.skill.getName();
	}

	function create()
	{
		this.m.ID = "effects.ghost_possessed";
		this.m.Name = "Possessed";
		this.m.Icon = "skills/status_effect_69.png";
		this.m.IconMini = "status_effect_69_mini";
		this.m.Overlay = "";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function isHidden()
	{
		return !this.m.IsActivated;
	}

	function getDescription()
	{
		return "This character has been possessed, and no longer has any control over their actions and is a puppet that has no choice but to follow your will.";
	}

	function addTurns( _t )
	{
		this.m.TurnsLeft += _t;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		this.m.OriginalFaction = actor.getFaction();
		this.m.OriginalSocket = actor.getSprite("socket").getBrush().Name;
		this.m.Overlay = "status_effect_69";
		actor.getFlags().set("Charmed", true);
		this.onPossess();
	}

	function onRemoved()
	{
		if (!this.m.IsBattleEnd)
		{
			local tile = this.findTileToSpawnGhost();

			if (tile == null)
			{
				tile = this.findTileToSpawnGhost(this.m.LastTile);
			}

			if (tile != null && !::Tactical.Entities.isCombatFinished())
			{
				local info = {
					Tile = tile,
					Self = this
				};

				this.onSpawnGhost(info);

				/*if (tile.IsVisibleForPlayer)
				{
					::Tactical.CameraDirector.pushMoveToTileEvent(0, tile, -1, this.onSpawnGhost.bindenv(this), info, 200, ::Const.Tactical.Settings.CameraNextEventDelay);
					::Tactical.CameraDirector.addDelay(0.2);
				}
				else
				{
					this.onSpawnGhost(info);
				}*/
			}
		}

		foreach ( skill in this.m.GhostSkills )
		{
			skill.removeSelf();
		}

		local actor = this.getContainer().getActor();
		actor.getSprite("status_hex").Visible = false;
		actor.getSprite("status_sweat").Visible = false;
		actor.m.IsControlledByPlayer = false;
		actor.m.IsSummoned = false;
		actor.isPlayerControlled = function()
		{
			return this.getFaction() == ::Const.Faction.Player && this.m.IsControlledByPlayer;
		};

		if (this.m.OriginalAgent != null)
		{
			actor.setAIAgent(this.m.OriginalAgent);
		}

		actor.setMoraleState(::Const.MoraleState.Fleeing);
		actor.setFaction(this.m.OriginalFaction);
		actor.getSprite("socket").setBrush(this.m.OriginalSocket);
		actor.getFlags().set("Charmed", false);
		actor.setDirty(true);
	}

	function onSpawnGhost( _info )
	{
		local _tile = _info.Tile;
		local _skill = _info.Self;
		_skill.m.Possessor.m.IsAbleToDie = true;
		_skill.spawnGhostEffect(_tile);
		::Tactical.addEntityToMap(this.m.Possessor, _tile.Coords.X, _tile.Coords.Y);
		::Tactical.getRetreatRoster().remove(_skill.m.Possessor);
		::Tactical.TurnSequenceBar.addEntity(_skill.m.Possessor);

		if (_skill.m.IsExorcised)
		{
			local attacker = _skill.m.Possessor;

			if (_skill.m.AttackerID != null)
			{
				local e = ::Tactical.getEntityByID(_skill.m.AttackerID);

				if (e != null)
				{
					attacker = e;
				}
			}

			::Time.scheduleEvent(::TimeUnit.Virtual, 100, function ( _e )
			{
				local poison = _skill.m.Possessor.getSkills().getSkillByID("effects.holy_water");

				if (poison == null)
				{
					_skill.m.Possessor.getSkills().add(::new("scripts/skills/effects/holy_water_effect"));
				}
				else
				{
					poison.resetTime();
				}
			}.bindenv(_skill), _skill);
		}
	}

	function onPossess()
	{
		local actor = this.getContainer().getActor().get();
		local isHuman = actor.getFlags().has("human");
		actor.m.IsControlledByPlayer = true;
		actor.m.IsSummoned = true;

		if (!("isPlayerControlled") in actor)
		{
			actor.isPlayerControlled <- function()
			{
				return this.getFaction() == ::Const.Faction.PlayerAnimals && this.m.IsControlledByPlayer;
			};
		}
		else
		{
			actor.isPlayerControlled = function()
			{
				return this.getFaction() == ::Const.Faction.PlayerAnimals && this.m.IsControlledByPlayer;
			};
		}

		this.m.IsActivated = true;
		this.m.OriginalAgent = actor.getAIAgent();
		actor.setAIAgent(::new("scripts/ai/tactical/player_agent"));
		actor.getAIAgent().setActor(actor);

		actor.setFaction(this.m.PossessorFaction);
		actor.getSprite("socket").setBrush(this.m.Possessor.getSprite("socket").getBrush().Name);

		local sprite = actor.getSprite("status_hex");
		sprite.setBrush("ghost_mind_control");
		sprite.Visible = true;
		
		if (actor.isHiddenToPlayer())
		{
			sprite.Alpha = 255;
		}
		else
		{
			sprite.Alpha = 0;
			sprite.fadeIn(1500);
		}

		if (isHuman)
		{
			local sweat = actor.getSprite("status_sweat");
			sweat.setBrush("ghost_possess_eyes");
			sweat.Visible = true;

			if (actor.isHiddenToPlayer())
			{
				sweat.Alpha = 255;
			}
			else
			{
				sweat.Alpha = 0;
				sweat.fadeIn(1500);
			}
		}

		local depossess = ::new("scripts/skills/actives/mod_ghost_depossess");
		depossess.m.IsRemovedAfterBattle = true;
		this.getContainer().add(depossess);
		this.m.GhostSkills.push(depossess);
		//local touch = ::new("scripts/skills/actives/ghastly_touch");
		//touch.m.IsRemovedAfterBattle = true;
		//this.getContainer().add(touch);
		//this.m.GhostSkills.push(touch);
		local scream = this.m.Possessor.getType() == ::Const.EntityType.LegendBanshee ? ::new("scripts/skills/actives/mod_banshee_scream") : ::new("scripts/skills/actives/mod_horrific_scream");
		scream.m.IsRemovedAfterBattle = true;
		this.getContainer().add(scream);
		this.m.GhostSkills.push(scream);
		actor.checkMorale(10, 9000);
		actor.setDirty(true);
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		if (!this.m.IsActivated) return;
		local XPkiller = ::Math.floor(_targetEntity.getXPValue() * ::Const.XP.XPForKillerPct);
		local XPgroup = _targetEntity.getXPValue() * (1.0 - ::Const.XP.XPForKillerPct);
		this.m.Possessor.addXP(XPkiller);
		local brothers = ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player);

		if (brothers.len() == 1)
		{
			this.m.Possessor.addXP(XPgroup);
		}
		else
		{
			foreach( bro in brothers )
			{
				bro.addXP(::Math.max(1, ::Math.floor(XPgroup / brothers.len())));
			}
		}

		local roster = ::World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			if (bro.isInReserves() && bro.getSkills().hasSkill("perk.legend_peaceful"))
			{
				bro.addXP(::Math.max(1, ::Math.floor(XPgroup / brothers.len())));
			}
		}

		local stats_collector = this.m.Possessor.getSkills().getSkillByID("special.stats_collector");
		if (stats_collector != null) stats_collector.onTargetKilled(_targetEntity, _skill);
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (this.m.Possessor == null) return;
		local stats_collector = this.m.Possessor.getSkills().getSkillByID("special.stats_collector");
		if (stats_collector != null) stats_collector.onTargetHit(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);
	}

	/*function onTurnEnd()
	{
		local actor = this.getContainer().getActor();

		if (--this.m.TurnsLeft <= 0)
		{
			if (!this.m.IsActivated)
			{
				this.m.IsActivated = true;
				this.m.TurnsLeft = this.m.IsEnhanced ? 5 : 3;
				this.spawnIcon(this.m.Overlay, actor.getTile());
				this.onPossess();
			}
			else
			{
				this.removeSelf();
			}
		}
	}*/

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
		local myTile = actor.getTile();

		if (myTile.Properties.Effect != null && myTile.Properties.Effect.Type == "legend_holyflame")
		{
			this.setExorcised(true);
			this.removeSelf();
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(this.m.Possessor) + " has been expelled out of " + ::Const.UI.getColorizedEntityName(actor) + "\'s body");
			return;
		}
		else if (this.m.IsActivated && actor.getCurrentProperties().IsStunned)
		{
			this.removeSelf();
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(this.m.Possessor) + " has been expelled out of " + ::Const.UI.getColorizedEntityName(actor) + "\'s body");
			return;
		}

		if (!this.m.IsActivated && actor.getMoraleState() == ::Const.MoraleState.Fleeing)
		{
			actor.setActionPoints(0);
		}
	}

	function findTileToSpawnGhost( _tile = null )
	{
		if (_tile == null)
		{
			_tile = this.getContainer().getActor().getTile();
		}

		::Sound.play("sounds/enemies/horrific_scream_01.wav", ::Const.Sound.Volume.Skill * 1.2, _tile.Pos);

		local result = {
			TargetTile = _tile,
			Destinations = []
		};
		::Tactical.queryTilesInRange(_tile, 2, 5, false, [], this.onQueryTiles, result);

		if (result.Destinations.len() == 0)
		{
			return null;
		};

		return ::MSU.Array.rand(result.Destinations);
	}

	function onQueryTiles( _tile, _tag )
	{
		if (!_tile.IsEmpty)
		{
			return;
		}

		_tag.Destinations.push(_tile);
	}

	function onMovementCompleted( _tile )
	{
		this.m.LastTile = _tile;

		local actor = this.getContainer().getActor();

		if (_tile.Properties.Effect != null && _tile.Properties.Effect.Type == "legend_holyflame")
		{
			this.setExorcised(true);
			this.removeSelf();
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(this.m.Possessor) + " has been expelled out of " + ::Const.UI.getColorizedEntityName(actor) + "\'s body");
		}
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (this.m.IsActivated && _damageHitpoints >= ::Const.Combat.InjuryMinDamage && ::Math.rand(1, 100) <= 10)
		{
			this.removeSelf();
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(this.m.Possessor) + " has been expelled out of " + ::Const.UI.getColorizedEntityName(this.getContainer().getActor()) + "\'s body");
		}
	}

	function onUpdate( _properties )
	{
		_properties.IsAffectedByDyingAllies = false;
		_properties.IsAffectedByLosingHitpoints = false;

		if (this.m.IsActivated)
		{
			_properties.Initiative += 25;
			_properties.Bravery += 50;
			_properties.MeleeSkill += 10;
			_properties.RangedSkill += 10;
			_properties.MeleeDefense += 10;
			_properties.RangedDefense += 10;
			_properties.DamageReceivedTotalMult *= 0.75;
			return;
		}
		
		_properties.TargetAttractionMult *= 0.25;
		_properties.MoraleCheckBravery[::Const.MoraleCheckType.MentalAttack] += 25;
		_properties.MeleeSkill -= 10;
		_properties.RangedSkill -= 10;
		_properties.MeleeDefense += 10;
		_properties.RangedDefense += 10;
	}

	function onDeath( _fatalityType )
	{
		this.onRemoved();
	}

	function spawnGhostEffect( _tile )
	{
		local effect = {
			Delay = 0,
			Quantity = 12,
			LifeTimeQuantity = 12,
			SpawnRate = 100,
			Brushes = [
				"bust_ghost_01"
			],
			Stages = [
				{
					LifeTimeMin = 1.0,
					LifeTimeMax = 1.0,
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
					LifeTimeMin = 1.0,
					LifeTimeMax = 1.0,
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
					ScaleMin = 0.1,
					ScaleMax = 0.1,
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
		::Tactical.spawnParticleEffect(false, effect.Brushes, _tile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, ::createVec(0, 40));
	}

});

