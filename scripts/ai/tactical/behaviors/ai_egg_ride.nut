this.ai_egg_ride <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		TargetTile = null,
		SecondPlanTargetTile = null,
		SelectedSkill = null,
		SecondPlanSelectedSkill = null,
		PossibleSkills = [
			"actives.attach_egg"
		],
		SecondPlanSkills = [
			"actives.spawn_spider"
		],
		BackupSkills = [
			"actives.add_egg"
		],
		IsUsingSecondPlan = false,
		LastRoundUsed = 0,
		IsDone = false,
	},
	function create()
	{
		this.m.ID = this.Const.AI.Behavior.ID.Retreat;
		this.m.Order = this.Const.AI.Behavior.Order.Retreat;
		this.m.IsThreaded = true;
		this.behavior.create();
	}

	function onEvaluate( _entity )
	{
		// Function is a generator.
		this.m.TargetTile = null;
		
		if ((this.Const.AI.NoRetreatMode || this.Tactical.State.getStrategicProperties() != null && this.Tactical.State.getStrategicProperties().IsArenaMode) && _entity.getFaction() != this.Const.Faction.Player)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (!_entity.getCurrentProperties().IsRooted)
		{
			if (this.m.IsDone)
			{
				return this.Const.AI.Behavior.Score.Zero;
			}
			
			if (_entity.getTile().hasZoneOfControlOtherThan(_entity.getAlliedFactions()) && _entity.getFaction() != this.Const.Faction.Player)
			{
				return this.Const.AI.Behavior.Score.Zero;
			}

			local score = this.getProperties().BehaviorMult[this.m.ID];

			if (_entity.getFaction() != this.Const.Faction.Player)
			{
				local allyInstances = 0.0;
				local allyInstancesMax = 0.0;
				local hostileInstances = 0.0;

				foreach( i, faction in this.Tactical.Entities.getAllInstances() )
				{
					if (faction.len() == 0)
					{
						continue;
					}

					if (i == _entity.getFaction() || _entity.isAlliedWith(i))
					{
						foreach( e in faction )
						{
							if (e.getXPValue() > 0)
							{
								allyInstances = allyInstances + 1.0;
							}
						}
					}
					else
					{
						hostileInstances = hostileInstances + faction.len() * 1.0;
					}
				}

				foreach( i, numPerFaction in this.Tactical.Entities.getAllInstancesMax() )
				{
					if (i == _entity.getFaction() || _entity.isAlliedWith(i))
					{
						allyInstancesMax = allyInstancesMax + numPerFaction;
					}
				}

				if (_entity.getBaseProperties().Bravery != 0 && allyInstances / allyInstancesMax >= this.Const.AI.Behavior.RetreatMinAllyRatio)
				{
					return this.Const.AI.Behavior.Score.Zero;
				}

				if (_entity.getBaseProperties().Bravery != 0 && allyInstances >= hostileInstances)
				{
					return this.Const.AI.Behavior.Score.Zero;
				}

				score = score * (1.0 + this.Const.AI.Behavior.RetreatMinAllyRatio - allyInstances / allyInstancesMax);
			}

			if (this.isAtMapBorder(_entity))
			{
				score = score * this.Const.AI.Behavior.RetreatAtMapBorderMult;
			}
			else
			{
				local func = this.findRetreatToPosition(_entity);

				while (resume func == null)
				{
					yield null;
				}

				if (this.m.TargetTile == null)
				{
					return this.Const.AI.Behavior.Score.Zero;
				}
			}

			if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing)
			{
				score = score * this.Const.AI.Behavior.RetreatFleeingMult;
			}

			if (_entity.getBaseProperties().Bravery == 0)
			{
				score = score * 10.0;
			}

			return this.Const.AI.Behavior.Score.Retreat * score;
		}
		else 
		{
			local score = this.getProperties().BehaviorMult[this.Const.AI.Behavior.ID.Retreat];
			this.m.SecondPlanTargetTile = null;
			this.m.SelectedSkill = null;
			this.m.SecondPlanSelectedSkill = null;
			this.m.IsUsingSecondPlan = false;

			if (score == null || score == 0)
			{
				return this.Const.AI.Behavior.Score.Zero;
			}

			local time = this.Time.getExactTime();

			if (this.Time.getRound() == this.m.LastRoundUsed)
			{
				return this.Const.AI.Behavior.Score.Zero;
			}

			foreach( skillID in this.m.PossibleSkills )
			{
				local skill = _entity.getSkills().getSkillByID(skillID);

				if (skill != null && skill.isUsable() && skill.isAffordable())
				{
					this.m.SelectedSkill = skill;
					break;
				}
			}

			if (this.m.SelectedSkill == null)
			{
				this.m.IsUsingSecondPlan = true;
			}

			yield null
			local time = this.Time.getExactTime();
			local myTile = _entity.getTile();
			local bestTile;

			local uber_drivers = [];

			for( local i = 0; i != 6; i = ++i )
			{
				if (!myTile.hasNextTile(i))
				{
				}
				else
				{
					local tile = myTile.getNextTile(i);

					if (this.Math.abs(tile.Level - myTile.Level) <= 1 && tile.IsOccupiedByActor)
					{
						local e = tile.getEntity();

						if (e.getCurrentProperties().IsRooted || e.getCurrentProperties().IsStunned)
						{
							continue;
						}

						if (e.getMoraleState() == this.Const.MoraleState.Fleeing)
						{
							continue;
						}

						if (e.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory) != null)
						{
							continue;
						}

						if (e.getFlags().has("creator") && e.getFlags().get("creator") == _entity.getID())
						{
							uber_drivers.push(e);
						}
						else if (e.getFlags().has("spider") && e.isAlliedWith(_entity)) 
						{
						  	uber_drivers.push(e);
						}
					}
				}
			}

			if (uber_drivers.len() == 0)
			{
				this.m.IsUsingSecondPlan = true;
			}

			if (this.m.IsUsingSecondPlan)
			{
				foreach( skillID in this.m.SecondPlanSkills )
				{
					local skill = _entity.getSkills().getSkillByID(skillID);

					if (skill != null)
					{
						this.m.SecondPlanSelectedSkill = skill;
						break;
					}
				}

				if (this.m.SecondPlanSelectedSkill == null)
				{
					return this.Const.AI.Behavior.Score.Zero;
				}

				if (this.m.SelectedSkill == null)
				{
					local skills = this.m.BackupSkills;

					if (_entity.getFatiguePct() >= 0.5)
					{
						skills.insert(0, "actives.recover");
					}

					foreach( skillID in skills )
					{
						local skill = _entity.getSkills().getSkillByID(skillID);

						if (skill != null && skill.isUsable() && skill.isAffordable())
						{
							this.m.SelectedSkill = skill;
							break;
						}
					}
				}

				if (this.isAllottedTimeReached(time))
				{
					yield null;
					time = this.Time.getExactTime();
				}

				local opponents = this.getAgent().getKnownOpponents();
				local tiles = []

				for( local i = 0; i != 6; i = ++i )
				{
					if (!myTile.hasNextTile(i))
					{
					}
					else
					{
						local tile = myTile.getNextTile(i);

						if (this.Math.abs(tile.Level - myTile.Level) <= 1 && tile.IsEmpty)
						{
							tiles.push(tile);
						}
					}
				}

				if (tiles.len() == 0)
				{
					return this.Const.AI.Behavior.Score.Zero;
				}

				local result = [];

				foreach ( t in tiles ) 
				{
					local dangerLevel = 0;

				    foreach( d in opponents )
					{
						if (d.Actor.isNull())
						{
							continue;
						}

						local danger = this.queryActorTurnsNearTarget(d.Actor, t, d.Actor);
						local localDanger = 3.0 - this.Math.minf(3.0, danger.Turns);
						dangerLevel += localDanger;
					}

					result.push({
						Tile = t,
						Score = dangerLevel
					});
				}

				result.sort(this.onSortByScore);
				bestTile = result[0].Tile;
				this.m.SecondPlanTargetTile = bestTile;
			}
			else
			{
				if (this.isAllottedTimeReached(time))
				{
					yield null;
					time = this.Time.getExactTime();
				}

				bestTile = this.getBestTarget(_entity, uber_drivers);
			}

			if (bestTile == null)
			{
				return this.Const.AI.Behavior.Score.Zero;
			}
			else
			{
				score = score * 10;    
			}

			this.m.TargetTile = bestTile;
			this.getAgent().getIntentions().TargetTile = bestTile;
			return this.Const.AI.Behavior.Score.Flee * score;
		}

		function onExecute( _entity )
		{
			if (!_entity.getCurrentProperties().IsRooted)
			{
				if (this.m.TargetTile == null && this.isAtMapBorder(_entity))
				{
					if (this.Const.AI.VerboseMode)
					{
						this.logInfo("* " + this.getAgent().getActor().getName() + ": Retreated!");
					}

					this.getAgent().setFinished(true);
					_entity.retreat();
					return true;
				}

				if (this.m.TargetTile != null)
				{
					local navigator = this.Tactical.getNavigator();

					if (this.m.IsFirstExecuted)
					{
						this.getAgent().getOrders().IsRetreating = true;
						local settings = navigator.createSettings();
						settings.ActionPointCosts = _entity.getActionPointCosts();
						settings.FatigueCosts = _entity.getFatigueCosts();
						settings.FatigueCostFactor = this.Const.Movement.FatigueCostFactor;
						settings.ActionPointCostPerLevel = _entity.getLevelActionPointCost();
						settings.FatigueCostPerLevel = _entity.getLevelFatigueCost();
						settings.AllowZoneOfControlPassing = true;
						settings.ZoneOfControlCost = this.Const.AI.Behavior.ZoneOfControlAPPenalty * 4;
						settings.AlliedFactions = _entity.getAlliedFactions();
						settings.Faction = _entity.getFaction();

						if (this.Const.AI.VerboseMode)
						{
							this.logInfo("* " + this.getAgent().getActor().getName() + ": Retreating.");
						}

						navigator.findPath(_entity.getTile(), this.m.TargetTile, settings, 0);

						if (this.Const.AI.PathfindingDebugMode)
						{
							navigator.buildVisualisation(_entity, settings, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue());
						}

						local movement = navigator.getCostForPath(_entity, settings, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue());
						this.m.Agent.adjustCameraToDestination(movement.End);
						this.m.IsFirstExecuted = false;
					}

					if (!navigator.travel(_entity, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue()))
					{
						if (_entity.isAlive())
						{
							if (this.isAtMapBorder(_entity))
							{
								if (this.Const.AI.VerboseMode)
								{
									this.logInfo("* " + this.getAgent().getActor().getName() + ": Retreated!");
								}

								this.getAgent().setFinished(true);
								_entity.retreat();
							}
							else if (!_entity.isHiddenToPlayer())
							{
								this.getAgent().declareAction();
							}
						}

						this.m.TargetTile = null;
						this.m.IsDone = true;
					}
					else
					{
						return false;
					}
				}

				if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP)
				{
					this.getAgent().setFinished(true);
				}

				return true;
			}

			if (this.m.IsFirstExecuted)
			{
				this.m.IsFirstExecuted = false;

				if (this.m.IsUsingSecondPlan && this.m.SecondPlanTargetTile != null)
				{
					if (this.Const.AI.VerboseMode)
					{
						this.logInfo("* " + _entity.getName() + ": Calling for an Uber.");
					}

					this.m.Agent.adjustCameraToTarget(this.m.SecondPlanTargetTile);
					this.m.SecondPlanSelectedSkill.use(this.m.SecondPlanTargetTile, true);
					this.m.SecondPlanTargetTile = null;

					if (this.m.SelectedSkill != null)
					{
						if (this.Const.AI.VerboseMode)
						{
							this.logInfo("* " + _entity.getName() + ": Taking a ride on Uber.");
						}

						local agent = this.m.Agent;
						local skill = this.m.SelectedSkill;
						local tile = this.m.TargetTile;

						this.Time.scheduleEvent(this.TimeUnit.Virtual, 750, function (_tile)
						{
							agent.adjustCameraToTarget(_tile);
							skill.use(_tile);
						}.bindenv(this), tile);
					}
				}
				else 
				{
				    if (this.Const.AI.VerboseMode)
					{
						this.logInfo("* " + _entity.getName() + ": Taking a ride on Uber.");
					}

					this.m.Agent.adjustCameraToTarget(this.m.TargetTile);
					this.m.SelectedSkill.use(this.m.TargetTile);
				}

				this.m.LastRoundUsed = this.Time.getRound();
			}
		}

		if (this.m.TargetTile != null)
		{
			if (_entity.isAlive() && (!_entity.isHiddenToPlayer() || this.m.TargetTile.IsVisibleForPlayer))
			{
				this.getAgent().declareAction(this.m.IsUsingSecondPlan ? 1000 : 0);
				this.getAgent().declareEvaluationDelay(2000);
			}

			this.m.TargetTile = null;
		}

		return true;
	}

	function getBestTarget( _entity, _targets )
	{
		if (_targets.len() == 1)
		{
			return _targets[0].getTile();
		}

		local opponents = this.getAgent().getKnownOpponents();
		local bestValue = 1.0;
		local highest = -999.0;
		local betterThanNothing;
		local bestTile;

		foreach( _uber in _targets )
		{
			local potentialValue = 1.0;

			if (_uber.getActionPoints() > this.Const.Movement.AutoEndTurnBelowAP)
			{
				potentialValue += 0.5 * (_uber.getActionPoints() - this.Const.Movement.AutoEndTurnBelowAP);
			}

			local count = _uber.getSurroundedCount();
			local p = _uber.getCurrentProperties();
			potentialValue += p.getMeleeDefense() * 0.05;
			potentialValue += p.getRangedDefense() * 0.05;
			potentialValue += _uber.getHitpoints() * 0.01;
			potentialValue += _uber.getArmor(this.Const.BodyPart.Body) * 0.01 + _uber.getArmor(this.Const.BodyPart.Head) * 0.01;

			if (count > 0)
			{
				potentialValue *= 0.2 * count;
			}

			foreach( d in opponents )
			{
				if (d.Actor.isNull())
				{
					continue;
				}

				local danger = this.queryActorTurnsNearTarget(d.Actor, _uber.getTile(), d.Actor);
				local localDanger = (3.0 - this.Math.minf(3.0, danger.Turns)) * 0.3333;
				potentialValue += localDanger;
			}

			if (_uber.isTurnDone())
			{
				potentialValue *= 0.5;
			}

			if (potentialValue > highest)
			{
				highest = potentialValue;
				betterThanNothing = _uber.getTile();
			}

			if (potentialValue >= bestValue)
			{
				bestValue = potentialValue;
				bestTile = _uber.getTile();
			}
		}

		if (bestTile == null && betterThanNothing != null)
		{
			bestTile = betterThanNothing;
		}

		return bestTile;
	}

	function isAtMapBorder( _entity )
	{
		local myTile = _entity.getTile();

		for( local i = 0; i < 6; i = ++i )
		{
			if (!myTile.hasNextTile(i))
			{
				return true;
			}
		}

		return false;
	}

	function findRetreatToPosition( _entity )
	{
		// Function is a generator.
		local time = this.Time.getExactTime();
		local myTile = _entity.getTile();
		local targets = [];
		local opponents = [];
		local mapSize = this.Tactical.getMapSize();
		local instances = this.Tactical.Entities.getAllInstances();
		local myTile = _entity.getTile();
		local dirs = [
			0,
			0,
			0,
			0,
			0,
			0
		];

		for( local i = 1; i < instances.len(); i = ++i )
		{
			if (_entity.getAlliedFactions().find(i) != null)
			{
			}
			else
			{
				foreach( opponent in instances[i] )
				{
					if (myTile.getDistanceTo(opponent.getTile()) <= 20 && !this.isKindOf(opponent, "alp"))
					{
						opponents.push(opponent);
					}

					local dir = myTile.getDirection8To(opponent.getTile());

					switch(dir)
					{
					case this.Const.Direction8.W:
						dirs[this.Const.Direction.NW] += 4;
						dirs[this.Const.Direction.SW] += 4;
						break;

					case this.Const.Direction8.E:
						dirs[this.Const.Direction.NE] += 4;
						dirs[this.Const.Direction.SE] += 4;
						break;

					default:
						local dir = myTile.getDirectionTo(opponent.getTile());
						local dir_left = dir - 1 >= 0 ? dir - 1 : 6 - 1;
						local dir_right = dir + 1 < 6 ? dir + 1 : 0;
						dirs[dir] += 4;
						dirs[dir_left] += 3;
						dirs[dir_right] += 3;
						break;
					}
				}
			}
		}

		local ap = _entity.getActionPoints();

		for( local y = 0; y < mapSize.Y; y = ++y )
		{
			local tile = this.Tactical.getTileSquare(mapSize.X - 1, y);

			if (tile.IsEmpty)
			{
				local d = myTile.getDistanceTo(tile);
				targets.push({
					Tile = tile,
					Score = d * 2 <= ap ? 0 : d,
					Dir = d * 2 <= ap ? 0 : dirs[myTile.getDirectionTo(tile)]
				});
			}
		}

		for( local y = 0; y < mapSize.Y; y = ++y )
		{
			local tile = this.Tactical.getTileSquare(0, y);

			if (tile.IsEmpty)
			{
				local d = myTile.getDistanceTo(tile);
				targets.push({
					Tile = tile,
					Score = d * 2 <= ap ? 0 : d,
					Dir = d * 2 <= ap ? 0 : dirs[myTile.getDirectionTo(tile)]
				});
			}
		}

		for( local x = 1; x < mapSize.X - 1; x = ++x )
		{
			local tile = this.Tactical.getTileSquare(x, mapSize.Y - 1);

			if (tile.IsEmpty)
			{
				local d = myTile.getDistanceTo(tile);
				targets.push({
					Tile = tile,
					Score = d * 2 <= ap ? 0 : d,
					Dir = d * 2 <= ap ? 0 : dirs[myTile.getDirectionTo(tile)]
				});
			}
		}

		for( local x = 1; x < mapSize.X - 1; x = ++x )
		{
			local tile = this.Tactical.getTileSquare(x, 0);

			if (tile.IsEmpty)
			{
				local d = myTile.getDistanceTo(tile);
				targets.push({
					Tile = tile,
					Score = d * 2 <= ap ? 0 : d,
					Dir = d * 2 <= ap ? 0 : dirs[myTile.getDirectionTo(tile)]
				});
			}
		}

		targets.sort(this.onSortByLowestScore);
		local navigator = this.Tactical.getNavigator();
		local attempts = 0;
		local bestTarget;
		local bestCost = 9000;
		local bestDanger = 9000;

		foreach( target in targets )
		{
			attempts = ++attempts;

			if (attempts > this.Const.AI.Behavior.RetreatSoftMaxAttempts && (bestDanger == 0 || attempts > this.Const.AI.Behavior.RetreatHardMaxAttempts))
			{
				break;
			}

			if (this.isAllottedTimeReached(time))
			{
				yield null;
				time = this.Time.getExactTime();
			}

			local settings = navigator.createSettings();
			settings.ActionPointCosts = _entity.getActionPointCosts();
			settings.FatigueCosts = _entity.getFatigueCosts();
			settings.FatigueCostFactor = this.Const.Movement.FatigueCostFactor;
			settings.ActionPointCostPerLevel = _entity.getLevelActionPointCost();
			settings.FatigueCostPerLevel = _entity.getLevelFatigueCost();
			settings.AllowZoneOfControlPassing = true;
			settings.ZoneOfControlCost = this.Const.AI.Behavior.ZoneOfControlAPPenalty * 4;
			settings.AlliedFactions = _entity.getAlliedFactions();
			settings.Faction = _entity.getFaction();
			settings.HeatCost = this.getAgent().isUsingHeat() ? this.Const.AI.Behavior.EngageHeatCost : 0;

			if (!navigator.findPath(myTile, target.Tile, settings, 0))
			{
				continue;
			}

			local movementCosts = navigator.getCostForPath(_entity, settings, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue());

			if (movementCosts.Tiles == 0 || movementCosts.End.isSameTileAs(myTile))
			{
				continue;
			}

			if (movementCosts.ActionPointsRequired <= bestCost || bestDanger > 0)
			{
				local danger = 0.0;

				if (!movementCosts.IsComplete)
				{
					foreach( opponent in opponents )
					{
						local turns = this.queryActorTurnsNearTarget(opponent, movementCosts.End, _entity);

						if (turns.Turns <= 2.0)
						{
							danger = danger + (2.0 - turns.Turns);
						}

						if (turns.Turns <= 1.0)
						{
							danger = danger + 1.0;
						}
					}
				}

				if (danger < bestDanger || danger <= bestDanger && movementCosts.ActionPointsRequired < bestCost)
				{
					bestTarget = target.Tile;
					bestCost = movementCosts.ActionPointsRequired;
					bestDanger = danger;
				}
			}
		}

		if (bestTarget != null)
		{
			this.m.TargetTile = bestTarget;
		}

		return true;
	}

	function onTurnStarted()
	{
		this.m.IsDone = false;
	}

	function onTurnResumed()
	{
		this.m.IsDone = false;
	}

	function onSortByLowestScore( _d1, _d2 )
	{
		if (_d1.Dir > _d2.Dir)
		{
			return 1;
		}
		else if (_d1.Dir < _d2.Dir)
		{
			return -1;
		}
		else
		{
			if (_d1.Score > _d2.Score)
			{
				return 1;
			}
			else if (_d1.Score < _d2.Score)
			{
				return -1;
			}

			return 0;
		}
	}

	function onSortByScore( _a, _b )
	{
		if (_a.Score < _b.Score)
		{
			return -1;
		}
		else if (_a.Score > _b.Score)
		{
			return 1;
		}

		return 0;
	}

});

