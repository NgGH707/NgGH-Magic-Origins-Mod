this.ai_raise_undead_nggh707 <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		TargetTile = null,
		PossibleSkills = [
			"actives.raise_undead"
		],
		Skill = null,
		IsTravelling = false
	},
	function create()
	{
		this.m.ID = this.Const.AI.Behavior.ID.RaiseUndead;
		this.m.Order = this.Const.AI.Behavior.Order.RaiseUndead;
		this.m.IsThreaded = true;
		this.behavior.create();
	}

	function onEvaluate( _entity )
	{
		// Function is a generator.
		this.m.Skill = null;
		this.m.TargetTile = null;
		this.m.IsTravelling = false;
		local time = this.Time.getExactTime();
		local scoreMult = this.getProperties().BehaviorMult[this.m.ID];

		if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		this.m.Skill = this.selectSkill(this.m.PossibleSkills);

		if (this.m.Skill == null)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		scoreMult = scoreMult * this.getFatigueScoreMult(this.m.Skill);
		local myTile = _entity.getTile();
		local potentialDanger = this.getPotentialDanger(true);
		local currentDanger = 0.0;
		yield null;

		foreach( t in potentialDanger )
		{
			local d = this.queryActorTurnsNearTarget(t, myTile, _entity);

			if (d.Turns <= 1.0)
			{
				currentDanger = currentDanger + (1.0 - d.Turns);
			}
		}

		yield null;
		local corpses = this.Tactical.Entities.getCorpses();

		if (corpses.len() == 0)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		local potentialCorpses = [];
		local alliedFactions = _entity.getAlliedFactions();

		foreach( c in corpses )
		{
			if (!c.IsEmpty)
			{
				continue;
			}

			if (!c.IsCorpseSpawned || !c.Properties.get("Corpse").IsResurrectable)
			{
				continue;
			}

			if (this.getAgent().getIntentions().IsDefendingPosition && !this.m.Skill.isInRange(c))
			{
				continue;
			}

			local score = 1.0;
			local dist = c.getDistanceTo(myTile);

			if (dist > this.Const.AI.Behavior.RaiseUndeadMaxDistance)
			{
				continue;
			}

			if (this.m.Skill.isInRange(c) && !this.m.Skill.onVerifyTarget(myTile, c))
			{
				continue;
			}

			if (this.isAllottedTimeReached(time))
			{
				yield null;
				time = this.Time.getExactTime();
			}

			local isWeaponOnGround = false;

			if (c.IsContainingItems)
			{
				foreach( item in c.Items )
				{
					if (item.isItemType(this.Const.Items.ItemType.MeleeWeapon))
					{
						isWeaponOnGround = true;
						break;
					}
				}
			}

			score = score + c.Properties.get("Corpse").Value * this.Const.AI.Behavior.RaiseUndeadStrengthMult * (isWeaponOnGround ? 1.0 : this.Const.AI.Behavior.RaiseUndeadNoWeaponMult);
			local mag = this.queryOpponentMagnitude(c, this.Const.AI.Behavior.RaiseUndeadMagnitudeMaxRange);
			score = score + mag.Opponents * (1.0 - mag.AverageDistanceScore) * this.Math.maxf(0.5, 1.0 - mag.AverageEngaged) * this.Const.AI.Behavior.RaiseUndeadOpponentValue;

			if (c.hasZoneOfOccupationOtherThan(alliedFactions))
			{
				if (dist <= 2)
				{
					score = score + this.Const.AI.Behavior.RaiseUndeadNearEnemyNearMeValue;
				}
				else
				{
					score = score + this.Const.AI.Behavior.RaiseUndeadNearEnemyValue;
				}

				for( local i = 0; i != 6; i = ++i )
				{
					if (!c.hasNextTile(i))
					{
					}
					else
					{
						local tile = c.getNextTile(i);

						if (tile.IsOccupiedByActor && !tile.hasZoneOfOccupationOtherThan(tile.getEntity().getAlliedFactions()))
						{
							if (dist <= 2)
							{
								score = score + this.Const.AI.Behavior.RaiseUndeadNearFreeEnemyNearMeValue;
							}
							else
							{
								score = score + this.Const.AI.Behavior.RaiseUndeadNearFreeEnemyValue;
							}

							if (tile.Properties.IsMarkedForImpact || this.hasNegativeTileEffect(tile, tile.getEntity()))
							{
								score = score + this.Const.AI.Behavior.RaiseUndeadLockIntoNegativeEffect;
							}
						}
					}
				}
			}

			if (currentDanger != 0)
			{
				score = score - dist * this.Const.AI.Behavior.RaiseUndeadDistToMeValue;
			}

			potentialCorpses.push({
				Tile = c,
				Distance = dist,
				Score = score
			});
		}

		if (potentialCorpses.len() == 0)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		potentialCorpses.sort(this.onSortByScore);
		local navigator = this.Tactical.getNavigator();
		local bestTarget;
		local bestIntermediateTile;
		local bestCost = -9999;
		local bestTiles = 0;
		local n = 0;
		local maxRange = this.m.Skill.getMaxRange();
		local entityActionPointCosts = _entity.getActionPointCosts();
		local entityFatigueCosts = _entity.getFatigueCosts();

		foreach( t in potentialCorpses )
		{
			n = ++n;

			if (n > this.Const.AI.Behavior.RaiseUndeadMaxAttempts && bestTarget != null)
			{
				break;
			}

			if (this.isAllottedTimeReached(time))
			{
				yield null;
				time = this.Time.getExactTime();
			}

			local score = 0 + t.Score;
			local tiles = 0;
			local intermediateTile;

			if (!this.m.Skill.isInRange(t.Tile))
			{
				local settings = navigator.createSettings();
				settings.ActionPointCosts = entityActionPointCosts;
				settings.FatigueCosts = entityFatigueCosts;
				settings.FatigueCostFactor = 0.0;
				settings.ActionPointCostPerLevel = _entity.getLevelActionPointCost();
				settings.FatigueCostPerLevel = _entity.getLevelFatigueCost();
				settings.AllowZoneOfControlPassing = false;
				settings.ZoneOfControlCost = this.Const.AI.Behavior.ZoneOfControlAPPenalty;
				settings.AlliedFactions = _entity.getAlliedFactions();
				settings.Faction = _entity.getFaction();

				if (!_entity.getCurrentProperties().IsRooted && navigator.findPath(myTile, t.Tile, settings, maxRange))
				{
					local movementCosts = navigator.getCostForPath(_entity, settings, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue());

					if (movementCosts.IsComplete && !this.m.Skill.onVerifyTarget(movementCosts.End, t.Tile))
					{
						continue;
					}

					if (!movementCosts.IsComplete)
					{
						intermediateTile = movementCosts.End;
					}

					if (movementCosts.End.IsBadTerrain)
					{
						score = score - this.Const.AI.Behavior.RaiseUndeadMoveToBadTerrainPenalty * this.getProperties().EngageOnBadTerrainPenaltyMult;
					}

					if (this.getProperties().EngageOnBadTerrainPenaltyMult != 0.0)
					{
						score = score - movementCosts.End.TVLevelDisadvantage;
					}

					score = score - movementCosts.ActionPointsRequired;
					score = score + movementCosts.End.Level;
					local inAllyZOC = _entity.getTile().getZoneOfControlCount(_entity.getFaction());
					local danger = 0.0;
					local danger_intermediate = 0.0;
					score = score + inAllyZOC * this.Const.AI.Behavior.RaiseUndeadAllyZocBonus;

					foreach( opponent in potentialDanger )
					{
						if (this.isAllottedTimeReached(time))
						{
							yield null;
							time = this.Time.getExactTime();
						}

						if (!this.isRangedUnit(opponent))
						{
							local d = this.queryActorTurnsNearTarget(opponent, t.Tile, _entity);
							danger = danger + this.Math.maxf(0.0, 1.0 - d.Turns);

							if (!movementCosts.IsComplete)
							{
								local id = this.queryActorTurnsNearTarget(opponent, movementCosts.End, _entity);
								danger_intermediate = danger_intermediate + this.Math.maxf(0.0, 1.0 - id.Turns);
								d = d.Turns > id.Turns ? id : d;
							}

							if (d.Turns <= 1.0)
							{
								if (d.InZonesOfControl != 0 || opponent.getCurrentProperties().IsRooted)
								{
									score = score - this.Const.AI.Behavior.RaiseUndeadLowDangerPenalty;
								}
								else
								{
									score = score - this.Const.AI.Behavior.RaiseUndeadHighDangerPenalty;
								}
							}
						}
						else if (!opponent.getTile().hasZoneOfControlOtherThan(opponent.getAlliedFactions()) && opponent.getTile().getDistanceTo(movementCosts.End) <= opponent.getIdealRange())
						{
							local d = movementCosts.End.getZoneOfControlCount(_entity.getFaction()) == 0 ? 0.5 : 1.0;
							danger = danger + d;

							if (movementCosts.End.getZoneOfControlCount(_entity.getFaction()) == 0)
							{
								score = score - this.Const.AI.Behavior.RaiseUndeadHighDangerPenalty;
							}
							else
							{
								score = score - this.Const.AI.Behavior.RaiseUndeadLowDangerPenalty;
							}
						}

						if (danger >= this.Const.AI.Behavior.RaiseUndeadMaxDanger || danger_intermediate >= this.Const.AI.Behavior.RaiseUndeadMaxDanger)
						{
							break;
						}
					}

					if (danger >= this.Const.AI.Behavior.RaiseUndeadMaxDanger || danger_intermediate >= this.Const.AI.Behavior.RaiseUndeadMaxDanger)
					{
						continue;
					}

					tiles = movementCosts.Tiles;
				}
				else
				{
					continue;
				}
			}
			else
			{
				for( ; currentDanger >= this.Const.AI.Behavior.RaiseUndeadMaxDanger;  )
				{
				}

				if (!this.m.Skill.onVerifyTarget(myTile, t.Tile))
				{
					continue;
				}

				score = score + myTile.Level;
			}

			if (score > bestCost)
			{
				bestTarget = t.Tile;
				bestCost = score;
				bestTiles = tiles;
				bestIntermediateTile = intermediateTile;
			}
		}

		if (bestTarget == null)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		this.m.TargetTile = bestTarget;
		this.m.IsTravelling = !this.m.Skill.isInRange(this.m.TargetTile);

		if (this.m.IsTravelling && bestIntermediateTile != null && bestIntermediateTile.ID == myTile.ID)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		scoreMult = scoreMult * (1.0 + bestTarget.Properties.get("Corpse").Value / 25.0);
		scoreMult = scoreMult * this.Math.maxf(0.0, 1.0 - currentDanger / this.Const.AI.Behavior.RaiseUndeadMaxDanger);
		return this.Const.AI.Behavior.Score.RaiseUndead * scoreMult;
	}

	function onBeforeExecute( _entity )
	{
		if (this.m.IsTravelling)
		{
			this.getAgent().getOrders().IsEngaging = true;
			this.getAgent().getOrders().IsDefending = false;
			this.getAgent().getIntentions().IsDefendingPosition = false;
			this.getAgent().getIntentions().IsEngaging = true;
		}
	}

	function onExecute( _entity )
	{
		if (this.m.IsFirstExecuted)
		{
			if (this.m.IsTravelling)
			{
				local navigator = this.Tactical.getNavigator();
				local settings = navigator.createSettings();
				settings.ActionPointCosts = _entity.getActionPointCosts();
				settings.FatigueCosts = _entity.getFatigueCosts();
				settings.FatigueCostFactor = 0.0;
				settings.ActionPointCostPerLevel = _entity.getLevelActionPointCost();
				settings.FatigueCostPerLevel = _entity.getLevelFatigueCost();
				settings.AllowZoneOfControlPassing = false;
				settings.ZoneOfControlCost = this.Const.AI.Behavior.ZoneOfControlAPPenalty;
				settings.AlliedFactions = _entity.getAlliedFactions();
				settings.Faction = _entity.getFaction();
				navigator.findPath(_entity.getTile(), this.m.TargetTile, settings, this.m.Skill.getMaxRange());

				if (this.Const.AI.PathfindingDebugMode)
				{
					navigator.buildVisualisation(_entity, settings, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue());
				}

				local movement = navigator.getCostForPath(_entity, settings, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue());
				this.getAgent().adjustCameraToDestination(movement.End);

				if (this.Const.AI.VerboseMode)
				{
					this.logInfo("* " + _entity.getName() + ": Moving into range to use Raise Undead");
				}

				this.m.IsFirstExecuted = false;
				return false;
			}
			else
			{
				if (this.m.TargetTile.IsVisibleForPlayer && _entity.isHiddenToPlayer())
				{
					_entity.setDiscovered(true);
					_entity.getTile().addVisibilityForFaction(this.Const.Faction.Player);
				}

				this.getAgent().adjustCameraToTarget(_entity.getTile());
				this.m.IsFirstExecuted = false;
				return false;
			}
		}

		if (this.m.IsTravelling)
		{
			if (!this.Tactical.getNavigator().travel(_entity, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue()))
			{
				this.m.TargetTile = null;
				return true;
			}
		}
		else
		{
			if (this.Const.AI.VerboseMode)
			{
				this.logInfo("* " + _entity.getName() + ": Using Raise Undead!");
			}
			
			this.Tactical.spawnSpriteEffect("necro_quote_10", this.createColor("#ffffff"), _entity.getTile(), this.Const.Tactical.Settings.SkillOverlayOffsetX, 160, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayStayDuration, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);

			if (this.m.Skill.use(this.m.TargetTile))
			{
				if (!_entity.isHiddenToPlayer() || this.m.TargetTile.IsVisibleForPlayer)
				{
					this.getAgent().declareAction();
					this.getAgent().declareEvaluationDelay(1500);
				}

				this.commandRecentlyRaised(_entity, this.m.TargetTile);
			}

			this.m.Skill = null;
			this.m.TargetTile = null;
			return true;
		}
	}

	function commandRecentlyRaised( _entity, _tile )
	{
		if (!_tile.IsOccupiedByActor)
		{
			return;
		}

		local myTile = _entity.getTile();
		local agent = _tile.getEntity().getAIAgent();

		if (myTile.getDistanceTo(_tile) > 3)
		{
			return;
		}

		if (agent.getBehavior(this.Const.AI.Behavior.ID.Protect) != null)
		{
			return;
		}

		local allies = this.getAgent().getKnownAllies();
		local protectors = 0;
		local priorityTargets = 0;

		foreach( a in allies )
		{
			if (a.getAIAgent().getBehavior(this.Const.AI.Behavior.ID.Protect) != null)
			{
				protectors = ++protectors;
			}
			else if (a.getCurrentProperties().TargetAttractionMult > 1.0)
			{
				priorityTargets = ++priorityTargets;
			}
		}

		if (priorityTargets == 0)
		{
			return;
		}

		if (protectors < this.Math.max(1, allies.len() * 0.1) || priorityTargets == 1 && allies.len() <= 2)
		{
			agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_protect"));
		}
	}

	function onSortByScore( _a, _b )
	{
		if (_a.Score > _b.Score)
		{
			return -1;
		}
		else if (_a.Score < _b.Score)
		{
			return 1;
		}

		return 0;
	}

});

