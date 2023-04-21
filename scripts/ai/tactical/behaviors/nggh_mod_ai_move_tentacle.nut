this.nggh_mod_ai_move_tentacle <- ::inherit("scripts/ai/tactical/behavior", {
	m = {
		TargetTile = null,
		SelectedSkill = null,
		PossibleSkills = [
			"actives.kraken_move"
		]
	},
	function create()
	{
		this.m.ID = ::Const.AI.Behavior.ID.MoveTentacle;
		this.m.Order = ::Const.AI.Behavior.Order.MoveTentacle;
		this.m.IsThreaded = true;
		this.behavior.create();
	}

	function onEvaluate( _entity )
	{
		// Function is a generator.
		local score = this.getProperties().BehaviorMult[this.m.ID];
		this.m.TargetTile = null;
		this.m.SelectedSkill = null;
		local time = ::Time.getExactTime();

		if (_entity.getActionPoints() < ::Const.Movement.AutoEndTurnBelowAP)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getCurrentProperties().IsRooted)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getMoraleState() == ::Const.MoraleState.Fleeing)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		if (this.getAgent().getIntentions().IsDefendingPosition)
		{
			return ::Const.AI.Behavior.Score.Zero;
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
			return ::Const.AI.Behavior.Score.Zero;
		}

		if (!this.getAgent().hasKnownOpponent())
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		local masterTile = _entity.getParent().getTile();
		local targets = this.getAgent().getKnownOpponents();
		local potentialDestinations = [];
		local myTile = _entity.getTile();
		local myTileScore;

		foreach( t in targets )
		{
			if (this.isAllottedTimeReached(time))
			{
				yield null;
				time = ::Time.getExactTime();
			}

			local target = t.Actor;
			local targetTile = t.Actor.getTile();

			if (_entity.getMode() == 0 && target.getCurrentProperties().IsRooted)
			{
				continue;
			}

			local zocByAllies = targetTile.getZoneOfControlCountOtherThan(target.getAlliedFactions());
			local potentialTiles = this.queryDestinationsInRange(targetTile, this.getProperties().EngageRangeMin, ::Math.max(_entity.getIdealRange(), this.getProperties().EngageRangeMax));
			potentialTiles.push(myTile);

			foreach( tile in potentialTiles )
			{
				local next = false;

				foreach( pt in potentialDestinations )
				{
					if (pt.ID == tile.ID)
					{
						next = true;
						break;
					}
				}

				if (next)
				{
					continue;
				}

				local dist = myTile.getDistanceTo(tile);
				local tileScore = 30.0;
				tileScore = ::Math.maxf(1.0, score - myTile.getDistanceTo(tile));

				if (masterTile != null)
				{
					tileScore = ::Math.maxf(1.0, score - masterTile.getDistanceTo(tile));
				}

				if (target.getCurrentProperties().IsRooted)
				{
					tileScore = tileScore * ::Const.AI.Behavior.MoveTentacleTargetAlreadyRooted;
				}

				local zoc = tile.getZoneOfControlCountOtherThan(_entity.getAlliedFactions());
				tileScore = tileScore * ::Math.pow(::Const.AI.Behavior.MoveTentacleZOCMult, zoc - 1);
				tileScore = tileScore * ::Math.pow(::Const.AI.Behavior.MoveTentacleAlliesPresentMult, zocByAllies - 1);
				local targetValues = 0.0;
				local targetsInRange = this.queryTargetsInMeleeRange(this.getProperties().EngageRangeMin, ::Math.max(_entity.getIdealRange(), this.getProperties().EngageRangeMax), 4, tile);

				foreach( pr in targetsInRange )
				{
					targetValues = targetValues + this.queryTargetValue(_entity, pr);

					if (pr.getTile().getDistanceTo(tile) <= pr.getIdealRange())
					{
						targetValues = targetValues - 0.1;
					}
				}

				tileScore = tileScore * targetValues;

				if (myTile.ID == tile.ID)
				{
					tileScore = tileScore * ::Const.AI.Behavior.MoveTentacleMyTileMult;
				}

				if (masterTile != null && masterTile.getDistanceTo(tile) == 1)
				{
					tileScore = tileScore * ::Const.AI.Behavior.MoveTentacleBlockHeadMult;
				}

				potentialDestinations.push({
					Tile = tile,
					Score = tileScore,
					ID = tile.ID
				});
			}
		}

		if (potentialDestinations.len() == 0)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		potentialDestinations.sort(this.onSortByScore);
		local i = 0;

		while (i < potentialDestinations.len())
		{
			if (potentialDestinations[i].Tile.ID == myTile.ID)
			{
				this.m.TargetTile = null;
				return ::Const.AI.Behavior.Score.Zero;
			}
			else if (!this.m.SelectedSkill.isUsableOn(potentialDestinations[i].Tile))
			{
				local betweenTile = myTile.getTileBetweenThisAnd(potentialDestinations[i].Tile);

				if (!this.m.SelectedSkill.isUsableOn(betweenTile))
				{
					++i;
					continue;
				}
				else
				{
					this.m.TargetTile = betweenTile;
					break;
				}
			}
			else
			{
				this.m.TargetTile = potentialDestinations[i].Tile;
				break;
			}
		}

		if (this.m.TargetTile == null)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		this.getAgent().getIntentions().TargetTile = this.m.TargetTile;
		return ::Const.AI.Behavior.Score.MoveTentacle * score;
	}

	function onBeforeExecute( _entity )
	{
		this.getAgent().getOrders().IsEngaging = true;
		this.getAgent().getOrders().IsDefending = false;
		this.getAgent().getIntentions().IsDefendingPosition = false;
	}

	function onExecute( _entity )
	{
		if (this.m.IsFirstExecuted)
		{
			this.m.IsFirstExecuted = false;

			if (::Const.AI.VerboseMode)
			{
				::logInfo("* " + _entity.getName() + ": Moving to engage.");
			}

			this.m.Agent.adjustCameraToTarget(this.m.TargetTile);
			this.m.SelectedSkill.use(this.m.TargetTile);

			if (_entity.isAlive())
			{
				local delay = 0;

				if (!_entity.isHiddenToPlayer())
				{
					delay = delay + 1000;
				}

				if (this.m.TargetTile.IsVisibleForPlayer)
				{
					delay = delay + 1500;
				}

				this.getAgent().declareEvaluationDelay(delay);
			}
		}
		else if (!_entity.isStoringColor())
		{
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

});

