this.ai_protect_person <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		VIP = null,
		TargetTile = null,
		IsWaitingAfterMove = false,
		IsWaitingBeforeMove = false,
		IsHoldingPosition = true,
		IsDoneThisTurn = false
	},
	function setVIP( _e )
	{
		this.m.VIP = this.WeakTableRef(_e);
	}

	function isDoneThisTurn()
	{
		return this.m.IsDoneThisTurn;
	}

	function create()
	{
		this.m.ID = this.Const.AI.Behavior.ID.Protect;
		this.m.Order = this.Const.AI.Behavior.Order.Protect;
		this.m.IsThreaded = true;
		this.behavior.create();
	}

	function onEvaluate( _entity )
	{
		// Function is a generator.
		this.m.TargetTile = null;
		this.m.IsWaitingAfterMove = false;
		this.m.IsHoldingPosition = false;
		this.m.IsWaitingBeforeMove = false;
		local score = this.getProperties().BehaviorMult[this.m.ID];

		if (_entity.getFlags().has("attack_mode"))
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (this.m.VIP == null || this.m.VIP.isNull() || !this.m.VIP.isAlive())
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP || score == 0.0)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (this.m.IsDoneThisTurn)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getCurrentProperties().IsRooted)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (this.getStrategy().isDefending() && this.getStrategy().isDefendingCamp())
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		local myTile = _entity.getTile();

		if (myTile.hasZoneOfControlOtherThan(_entity.getAlliedFactions()))
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		local vip = this.m.VIP;
		local allies = this.getAgent().getKnownAllies();
		local vipStillToMove = false;
		local vipStillToMoveAndAdjacent = false;

		if (!vip.isTurnDone() && vip.getActionPoints() >= 4 && !vip.getCurrentProperties().IsStunned && !vip.getCurrentProperties().IsRooted)
		{
			vipStillToMove = true;

			if (vip.getTile().getDistanceTo(myTile) == 1)
			{
				vipStillToMoveAndAdjacent = true;
			}
		}

		if ((vipStillToMoveAndAdjacent || vipStillToMove) && this.Tactical.TurnSequenceBar.canEntityWait(_entity))
		{
			this.m.IsWaitingBeforeMove = true;
		}
		else
		{
			local func = this.selectBestTargetTile(_entity);

			while (resume func == null)
			{
				yield null;
			}

			if (this.m.TargetTile == null)
			{
				return this.Const.AI.Behavior.Score.Zero;
			}
		}

		if (!this.m.IsWaitingBeforeMove && myTile.isSameTileAs(this.m.TargetTile))
		{
			if (this.m.IsHoldingPosition)
			{
				return this.Const.AI.Behavior.Score.Zero;
			}
			else
			{
				this.m.IsHoldingPosition = true;
			}
		}

		return this.Const.AI.Behavior.Score.Protect * score;
	}

	function onTurnStarted()
	{
		this.m.IsDoneThisTurn = false;
	}

	function onTurnResumed()
	{
		this.m.IsDoneThisTurn = false;
	}

	function onBeforeExecute( _entity )
	{
		this.getAgent().getOrders().IsEngaging = false;
		this.getAgent().getOrders().IsDefending = true;
		this.getAgent().getIntentions().IsDefendingPosition = true;
		this.getAgent().getIntentions().IsEngaging = false;

		if (this.m.IsWaitingAfterMove || this.m.IsHoldingPosition)
		{
			this.m.IsDoneThisTurn = true;
		}
	}

	function onExecute( _entity )
	{
		if (this.m.IsWaitingBeforeMove)
		{
			if (this.Tactical.TurnSequenceBar.entityWaitTurn(_entity))
			{
				if (this.Const.AI.VerboseMode)
				{
					this.logInfo("* " + _entity.getName() + ": Waiting until others have moved!");
				}

				this.m.TargetTile = null;
				return true;
			}
		}

		if (this.m.IsHoldingPosition)
		{
			return true;
		}

		local navigator = this.Tactical.getNavigator();

		if (this.m.IsFirstExecuted)
		{
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
			navigator.findPath(_entity.getTile(), this.m.TargetTile, settings, 0);

			if (this.Const.AI.PathfindingDebugMode)
			{
				navigator.buildVisualisation(_entity, settings, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue());
			}

			local movement = navigator.getCostForPath(_entity, settings, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue());
			this.m.Agent.adjustCameraToDestination(movement.End);

			if (this.Const.AI.VerboseMode)
			{
				this.logInfo("* " + _entity.getName() + ": Going for protective position.");
			}

			this.m.IsFirstExecuted = false;
			return;
		}

		if (!navigator.travel(_entity, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue()))
		{
			this.m.TargetTile = null;
			return true;
		}

		return false;
	}

	function selectBestTargetTile( _entity )
	{
		// Function is a generator.
		local time = this.Time.getExactTime();
		local vip = this.m.VIP;
		local vipTile = vip.getTile();
		local myTile = _entity.getTile();
		local allAllies = this.getAgent().getKnownAllies();
		local allOpponents = this.getAgent().getKnownOpponents();
		local potential_tiles = [];

		if (this.isAllottedTimeReached(time))
		{
			yield null;
			time = this.Time.getExactTime();
		}

		local dirs = [
			0,
			0,
			0,
			0,
			0,
			0
		];
		local relevant = 0;

		foreach( o in allOpponents )
		{
			local opponent = o.Actor;
			local dist = o.Actor.getTile().getDistanceTo(vipTile);
			local score = 1.0;

			if (dist <= 11 && this.isRangedUnit(o.Actor))
			{
				score = 1.0;
			}
			else if (dist <= 6)
			{
				score = this.Math.maxf(0.0, 1.0 - dist / 6.0);
			}
			else
			{
				continue;
			}

			relevant = ++relevant;
			local dir = vipTile.getDirection8To(opponent.getTile());

			switch(dir)
			{
			case this.Const.Direction8.W:
				dirs[this.Const.Direction.NW] += 4 * score;
				dirs[this.Const.Direction.SW] += 4 * score;
				break;

			case this.Const.Direction8.E:
				dirs[this.Const.Direction.NE] += 4 * score;
				dirs[this.Const.Direction.SE] += 4 * score;
				break;

			default:
				local dir = vipTile.getDirectionTo(opponent.getTile());
				local dir_left = dir - 1 >= 0 ? dir - 1 : 6 - 1;
				local dir_right = dir + 1 < 6 ? dir + 1 : 0;
				dirs[dir] += 4 * score;
				dirs[dir_left] += 3 * score;
				dirs[dir_right] += 3 * score;
				break;
			}
		}

		relevant = this.Math.maxf(1.0, relevant);

		for( local i = 0; i != 6; i = ++i )
		{
			dirs[i] /= relevant;

			if (!vipTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = vipTile.getNextTile(i);

				if (!tile.IsEmpty && tile.ID != myTile.ID)
				{
				}
				else
				{
					local score = 1;
					local immediateBonus = 0;
					score = score + dirs[i] / this.Math.max(1, allOpponents.len()) * this.Const.AI.Behavior.ProtectAllyDirectionMult;
					score = score - myTile.getDistanceTo(tile);
					local importantAlliesAtTile = 0;

					for( local j = 0; j != 6; j = ++j )
					{
						if (!tile.hasNextTile(j))
						{
						}
						else
						{
							local adjacentTile = tile.getNextTile(j);

							if (!adjacentTile.IsOccupiedByActor)
							{
							}
							else if (this.Math.abs(tile.Level - adjacentTile.Level) > 1)
							{
							}
							else
							{
								local other = adjacentTile.getEntity();

								if (!_entity.isAlliedWith(other))
								{
									immediateBonus = immediateBonus + this.Const.AI.Behavior.ProtectAllyEngagedBonus;
								}
								else if (other.getCurrentProperties().TargetAttractionMult > 1.0 && other.getCurrentProperties().TargetAttractionMult > _entity.getCurrentProperties().TargetAttractionMult)
								{
									score = score * vip.getCurrentProperties().TargetAttractionMult;
								}
							}
						}
					}

					if (tile.Properties.Effect != null && !tile.Properties.Effect.IsPositive && tile.Properties.Effect.Applicable(_entity))
					{
						immediateBonus = immediateBonus - this.Const.AI.Behavior.ProtectAllyTileEffectPenalty;
					}

					score = score + immediateBonus;
					local already_in = false;

					foreach( t in potential_tiles )
					{
						if (t.Tile.ID == tile.ID)
						{
							t.AllyDefendBonus += vip.getCurrentProperties().TargetAttractionMult * this.Const.AI.Behavior.ProtectAllyAttractionBonus;
							t.TileBonus += dirs[i] + immediateBonus;
							t.Score += score;
							already_in = true;
							break;
						}
					}

					if (!already_in)
					{
						potential_tiles.push({
							Tile = tile,
							Score = score,
							TileBonus = dirs[i] + immediateBonus,
							AllyDefendBonus = vip.getCurrentProperties().TargetAttractionMult * this.Const.AI.Behavior.ProtectAllyAttractionBonus
						});
					}
				}
			}
		}

		if (potential_tiles.len() == 0)
		{
			return false;
		}

		local navigator = this.Tactical.getNavigator();
		local settings = navigator.createSettings();
		local myTile = _entity.getTile();
		local myFaction = _entity.getFaction();
		potential_tiles.sort(this.onSortByScore);
		local attempts = 0;
		local time = this.Time.getExactTime();
		local bestDestination;
		local bestScore = -9000;
		local bestIsForNextTurn = false;
		local bestWaitAfterMove = false;
		settings.ActionPointCosts = _entity.getActionPointCosts();
		settings.FatigueCosts = _entity.getFatigueCosts();
		settings.FatigueCostFactor = 0.0;
		settings.ActionPointCostPerLevel = _entity.getLevelActionPointCost();
		settings.FatigueCostPerLevel = _entity.getLevelFatigueCost();
		settings.AllowZoneOfControlPassing = false;
		settings.ZoneOfControlCost = this.Const.AI.Behavior.ZoneOfControlAPPenalty;
		settings.AlliedFactions = _entity.getAlliedFactions();
		settings.Faction = _entity.getFaction();

		foreach( t in potential_tiles )
		{
			if (this.isAllottedTimeReached(time))
			{
				yield null;
				time = this.Time.getExactTime();
			}

			local apCost = 0;
			local waitAfterMove = false;
			local isForNextTurn = false;
			attempts = ++attempts;

			if (attempts > this.Const.AI.Behavior.DefendMaxAttempts)
			{
				break;
			}

			if (!t.Tile.isSameTileAs(myTile))
			{
				if (navigator.findPath(myTile, t.Tile, settings, 0))
				{
					local movementCosts = navigator.getCostForPath(_entity, settings, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue());
					apCost = apCost + movementCosts.ActionPointsRequired;
					isForNextTurn = false;
					waitAfterMove = false;

					if (!movementCosts.IsComplete)
					{
						if (movementCosts.Tiles == 0)
						{
							isForNextTurn = true;
						}
						else
						{
							waitAfterMove = true;
						}
					}
				}
				else
				{
					continue;
				}
			}

			local allyDefendBonus = t.AllyDefendBonus;
			local TileBonus = t.TileBonus * this.Const.AI.Behavior.ProtectAllyDirectionMult;
			local score = TileBonus + allyDefendBonus - apCost * this.Const.AI.Behavior.ProtectAllyAPCostMult;

			if (score > bestScore)
			{
				bestDestination = t.Tile;
				bestIsForNextTurn = isForNextTurn;
				bestWaitAfterMove = waitAfterMove;
				bestScore = score;
			}
		}

		if (bestDestination != null && bestIsForNextTurn == false)
		{
			if (this.Const.AI.VerboseMode && bestDestination.isSameTileAs(_entity.getTile()))
			{
				this.logInfo("* " + _entity.getName() + ": In fact, I would prefer to remain where I am");
			}

			this.m.TargetTile = bestDestination;
			this.m.IsWaitingAfterMove = bestWaitAfterMove;
			return true;
		}

		return false;
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

	function onSortByLowestScore( _d1, _d2 )
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

});

