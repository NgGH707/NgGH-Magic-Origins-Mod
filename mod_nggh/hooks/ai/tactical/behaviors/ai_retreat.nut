::mods_hookExactClass("ai/tactical/behaviors/ai_retreat", function ( obj )
{
	obj.onEvaluate = function( _entity )
	{
		// Function is a generator.
		this.m.TargetTile = null;

		if ((::Const.AI.NoRetreatMode || ::Tactical.State.getStrategicProperties() != null && ::Tactical.State.getStrategicProperties().IsArenaMode) && !_entity.isPlayerControlled())
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getActionPoints() < ::Const.Movement.AutoEndTurnBelowAP)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getCurrentProperties().IsRooted)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		if (this.m.IsDone)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getTile().hasZoneOfControlOtherThan(_entity.getAlliedFactions()) && !_entity.isPlayerControlled())
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getType() == ::Const.EntityType.Lindwurm && _entity.getTile().getDistanceTo(_entity.getTail().getTile()) > 1)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		local score = this.getProperties().BehaviorMult[this.m.ID];

		if (!_entity.isPlayerControlled())
		{
			local allyInstances = 0.0;
			local allyInstancesMax = 0.0;
			local hostileInstances = 0.0;

			foreach( i, faction in ::Tactical.Entities.getAllInstances() )
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

			foreach( i, numPerFaction in ::Tactical.Entities.getAllInstancesMax() )
			{
				if (i == _entity.getFaction() || _entity.isAlliedWith(i))
				{
					allyInstancesMax = allyInstancesMax + numPerFaction;
				}
			}

			if (_entity.getBaseProperties().Bravery != 0 && allyInstances / allyInstancesMax >= ::Const.AI.Behavior.RetreatMinAllyRatio)
			{
				return ::Const.AI.Behavior.Score.Zero;
			}

			if (_entity.getBaseProperties().Bravery != 0 && allyInstances >= hostileInstances)
			{
				return ::Const.AI.Behavior.Score.Zero;
			}

			score = score * (1.0 + ::Const.AI.Behavior.RetreatMinAllyRatio - allyInstances / allyInstancesMax);
		}

		if (this.isAtMapBorder(_entity))
		{
			score = score * ::Const.AI.Behavior.RetreatAtMapBorderMult;
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
				return ::Const.AI.Behavior.Score.Zero;
			}
		}

		if (_entity.getMoraleState() == ::Const.MoraleState.Fleeing)
		{
			score = score * ::Const.AI.Behavior.RetreatFleeingMult;
		}

		if (_entity.getBaseProperties().Bravery == 0)
		{
			score = score * 10.0;
		}

		return ::Const.AI.Behavior.Score.Retreat * score;
	};
});