this.mod_ghost_possessed_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 1,
		OriginalFaction = 0,
		OriginalAgent = null,
		OriginalSocket = null,
		PossessorFaction = 0,
		Possessor = null,
		IsActivated = false,
		IsBattleEnd = false,
		IsEnhanced = false,
		GhostSkills = [],
		LastTile = null
	},
	function setPossessorFaction( _f )
	{
		this.m.PossessorFaction = _f;
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
			return this.m.Name + " by " + this.Const.UI.getColorizedEntityName(this.m.Possessor);
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
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function isHidden()
	{
		return !this.m.IsActivated;
	}

	function getDescription()
	{
		return "This character has been possessed, and no longer has any control over their actions and is a puppet that has no choice but to obey a master. Wears off in [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] turn(s).";
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

			if (tile != null && !this.Tactical.Entities.isCombatFinished())
			{
				this.spawnGhostEffect(tile);
				this.Tactical.addEntityToMap(this.m.Possessor, tile.Coords.X, tile.Coords.Y);

				if (!this.m.Possessor.isPlayerControlled() && this.m.Possessor.getType() != this.Const.EntityType.Serpent)
				{
					this.Tactical.getTemporaryRoster().remove(this.m.Possessor);
				}

				this.Tactical.TurnSequenceBar.addEntity(this.m.Possessor);
			}
		}

		foreach ( skill in this.m.GhostSkills )
		{
			skill.removeSelf();
		}

		local actor = this.getContainer().getActor();
		actor.getSprite("status_hex").Visible = false;

		if (this.m.OriginalAgent != null)
		{
			actor.setAIAgent(this.m.OriginalAgent);
		}

		actor.setMoraleState(this.Const.MoraleState.Fleeing);
		actor.setFaction(this.m.OriginalFaction);
		actor.getSprite("socket").setBrush(this.m.OriginalSocket);
		actor.getFlags().set("Charmed", false);
		actor.setDirty(true);
	}

	function onPossess()
	{
		local actor = this.getContainer().getActor();

		if (actor.isPlayerControlled())
		{
			this.m.OriginalAgent = actor.getAIAgent();
			actor.setAIAgent(this.new("scripts/ai/tactical/agents/charmed_player_agent"));
			actor.getAIAgent().setActor(actor);
		}

		local sprite = actor.getSprite("status_hex");
		sprite.setBrush("true_mind_control");
		sprite.Visible = true;

		actor.setFaction(this.m.PossessorFaction);
		actor.getSprite("socket").setBrush(this.m.Possessor.getSprite("socket").getBrush().Name);

		if (actor.isHiddenToPlayer())
		{
			sprite.Alpha = 255;
		}
		else
		{
			sprite.Alpha = 0;
			sprite.fadeIn(1500);
		}

		local AI = actor.getAIAgent();
		AI.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_ghost_possess"));
		AI.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_terror"));
		local touch = this.new("scripts/skills/actives/ghastly_touch");
		this.getContainer().add(touch);
		this.m.GhostSkills.push(touch);
		local scream = this.m.Possessor.getType() == this.Const.EntityType.LegendBanshee ? this.new("scripts/skills/actives/legend_banshee_scream") : this.new("scripts/skills/actives/horrific_scream");
		this.getContainer().add(scream);
		this.m.GhostSkills.push(scream);
		actor.checkMorale(10, 9000);
		actor.setDirty(true);
	}

	function onTurnEnd()
	{
		local actor = this.getContainer().getActor();

		if (--this.m.TurnsLeft <= 0)
		{
			if (!this.m.IsActivated)
			{
				this.m.IsActivated = true;
				this.m.TurnsLeft = this.m.IsEnhanced ? 4 : 2;
				this.spawnIcon(this.m.Overlay, actor.getTile());
				this.onPossess();
			}
			else
			{
				this.removeSelf();
			}
		}
	}

	function onTurnStart()
	{
		if (this.m.IsActivated && this.getContainer().getActor().getCurrentProperties().IsStunned)
		{
			this.removeSelf();
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.m.Possessor) + " has been expelled out of " + this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + "\'s body");
		}
	}

	function findTileToSpawnGhost( _tile = null )
	{
		if (_tile == null)
		{
			_tile = this.getContainer().getActor().getTile();
		}

		this.Sound.play("sounds/enemies/horrific_scream_01.wav", this.Const.Sound.Volume.Skill * 1.2, _tile.Pos);

		local result = {
			TargetTile = _tile,
			Destinations = []
		};
		this.Tactical.queryTilesInRange(_tile, 2, 6, false, [], this.onQueryTiles, result);

		if (result.Destinations.len() == 0)
		{
			return null;
		};

		return result.Destinations[this.Math.rand(0, result.Destinations.len() - 1)];
	}

	function onQueryTiles( _tile, _tag )
	{
		if (!_tile.IsEmpty)
		{
			return;
		}

		_tag.Destinations.push(_tile);
	}

	function onCombatFinished()
	{
		this.m.IsBattleEnd = true;

		if (this.Tactical.Entities.getInstancesNum(this.Const.Faction.Player) == 0)
		{
			this.getContainer().getActor().kill(null, null, this.Const.FatalityType.Suicide);
		}

		this.skill.onCombatFinished();
	}

	function onMovementCompleted( _tile )
	{
		this.m.LastTile = _tile;
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (this.m.IsActivated && _damageHitpoints >= this.Const.Combat.InjuryMinDamage && this.Math.rand(1, 100) <= 25)
		{
			this.removeSelf();
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.m.Possessor) + " has been expelled out of " + this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + "\'s body");
		}
	}

	function onUpdate( _properties )
	{
		_properties.IsAffectedByDyingAllies = false;
		_properties.IsAffectedByLosingHitpoints = false;

		if (this.m.IsActivated)
		{
			_properties.Initiative += 25;
			_properties.MeleeSkill += 10;
			_properties.RangedSkill += 10;
			_properties.MeleeDefense += 10;
			_properties.RangedDefense += 10;
			_properties.DamageReceivedTotalMult *= 0.75;
		}
		else
		{
			_properties.TargetAttractionMult *= 0.25;
			_properties.MoraleCheckBravery[this.Const.MoraleCheckType.MentalAttack] += 150;

			if (this.getContainer().getActor().getMoraleState() < this.Const.MoraleState.Steady)
			{
				_properties.MeleeSkill -= 35;
				_properties.RangedSkill -= 35;
				_properties.MeleeDefense += 35;
				_properties.RangedDefense += 35;
			}
		}
	}

	function onDeath()
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
	}

});

