this.ai_move_tail_player <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		TargetTile = null,
		SelectedSkill = null,
		PossibleSkills = [
			"actives.move_tail",
			"actives.legend_stollwurm_move_tail"
		],
		AttackSkills = [
			"actives.tail_slam"
		],
		LastRoundUsed = 0
	},
	function create()
	{
		this.m.ID = this.Const.AI.Behavior.ID.MoveTail;
		this.m.Order = this.Const.AI.Behavior.Order.MoveTail;
		this.m.IsThreaded = true;
		this.behavior.create();
	}

	function onEvaluate( _entity )
	{
		// Function is a generator.
		local score = this.getProperties().BehaviorMult[this.m.ID];
		this.m.TargetTile = null;
		this.m.SelectedSkill = null;
		local time = this.Time.getExactTime();

		if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getCurrentProperties().IsRooted)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (this.getAgent().getIntentions().IsDefendingPosition)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (this.Time.getRound() == this.m.LastRoundUsed)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}
		
		if (_entity.getTile().getDistanceTo(_entity.getBody().getTile()) <= 2)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		local skills = [];

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
			return this.Const.AI.Behavior.Score.Zero;
		}

		local myTile = _entity.getTile();
		local bodyTile = _entity.getBody().getTile();
		local bestValue = 0.0;
		local myValue = 0.0;
		local bestTile;
		local attackSkill = this.selectSkill(this.m.AttackSkills);
		local targetsInMelee = this.queryTargetsInMeleeRange();

		if (myTile.getDistanceTo(bodyTile) <= this.Const.AI.Behavior.MoveTailMaxDistanceToHead)
		{
			myValue = 1.0 + this.Const.AI.Behavior.MoveTailCurrentTileBonus + this.getBestTarget(_entity, attackSkill, targetsInMelee, myTile).Score;
			bestValue = myValue;
			bestTile = myTile;

			if (targetsInMelee.len() != 0)
			{
				score = score * this.Const.AI.Behavior.MoveTailAlreadyEngagedMult;
			}
		}
		else
		{
			score = score * this.Const.AI.Behavior.MoveTailNearHeadMult;
		}

		local potentialTiles = this.queryDestinationsInRange(bodyTile, 1, this.Const.AI.Behavior.MoveTailMaxDistanceToHead);
		yield null;
		time = this.Time.getExactTime();

		foreach( potentialTile in potentialTiles )
		{
			if (this.isAllottedTimeReached(time))
			{
				yield null;
				time = this.Time.getExactTime();
			}

			local potentialValue = 1.0;
			local targets = this.queryTargetsInMeleeRange(1, 1, 1, potentialTile);

			if (targets.len() != 0)
			{
				potentialValue = potentialValue + this.getBestTarget(_entity, attackSkill, targets, potentialTile).Score;
			}

			if (potentialValue > bestValue)
			{
				bestValue = potentialValue;
				bestTile = potentialTile;
			}
		}

		if (bestTile == null)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (myValue >= bestValue)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		this.m.TargetTile = bestTile;
		this.getAgent().getIntentions().TargetTile = bestTile;
		return this.Const.AI.Behavior.Score.MoveTail * score;
	}

	function onExecute( _entity )
	{
		if (this.m.IsFirstExecuted)
		{
			this.m.IsFirstExecuted = false;

			if (this.Const.AI.VerboseMode)
			{
				this.logInfo("* " + _entity.getName() + ": Moving tail.");
			}

			this.m.Agent.adjustCameraToTarget(this.m.TargetTile);
			this.m.SelectedSkill.use(this.m.TargetTile);
			this.m.LastRoundUsed = this.Time.getRound();
		}

		if (this.m.TargetTile != null)
		{
			if (_entity.isAlive() && (!_entity.isHiddenToPlayer() || this.m.TargetTile.IsVisibleForPlayer))
			{
				this.getAgent().declareAction();
				this.getAgent().declareEvaluationDelay(2000);
			}

			this.m.TargetTile = null;
		}

		return true;
	}

	function getBestTarget( _entity, _skill, _targets, _tile )
	{
		local ourTile = _tile;
		local bestTarget;
		local bestScore = 0.0;
		local bestCombinedValue = 0.0;

		foreach( target in _targets )
		{
			if (_skill == null || _skill.onVerifyTarget(ourTile, target.getTile()))
			{
				local score = 0.0;
				local combinedValue = this.queryTargetValue(_entity, target, _skill);
				local targetTile = target.getTile();
				local dir = ourTile.getDirectionTo(target.getTile());
				local dir_left = dir - 1 >= 0 ? dir - 1 : this.Const.Direction.COUNT - 1;
				local dir_farleft = dir_left - 1 >= 0 ? dir_left - 1 : this.Const.Direction.COUNT - 1;

				if (ourTile.hasNextTile(dir_left))
				{
					local tile = ourTile.getNextTile(dir_left);

					if (this.Math.abs(tile.Level - ourTile.Level) <= 1 && tile.IsOccupiedByActor)
					{
						if (tile.getEntity().isAlliedWith(_entity))
						{
							combinedValue = combinedValue - (1.0 - this.getProperties().TargetPriorityHittingAlliesMult);
						}
						else
						{
							combinedValue = combinedValue + this.queryTargetValue(_entity, tile.getEntity(), _skill);
							score = score + 1.0;
						}
					}
				}

				if (ourTile.hasNextTile(dir_farleft))
				{
					local tile = ourTile.getNextTile(dir_farleft);

					if (this.Math.abs(tile.Level - ourTile.Level) <= 1 && tile.IsOccupiedByActor)
					{
						if (tile.getEntity().isAlliedWith(_entity))
						{
							combinedValue = combinedValue - (1.0 - this.getProperties().TargetPriorityHittingAlliesMult);
						}
						else
						{
							combinedValue = combinedValue + this.queryTargetValue(_entity, tile.getEntity(), _skill);
							score = score + 1.0;
						}
					}
				}

				if (score > bestScore || score == bestScore && combinedValue > bestCombinedValue)
				{
					bestTarget = target;
					bestCombinedValue = combinedValue;
					bestScore = score;
				}
			}
		}

		return {
			Target = bestTarget,
			Score = bestCombinedValue
		};
	}

});

