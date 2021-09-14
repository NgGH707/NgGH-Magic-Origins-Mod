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
		LastRoundUsed = 0
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

		if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

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

