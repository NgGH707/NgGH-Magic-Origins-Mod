this.nggh_mod_ai_drag <- ::inherit("scripts/ai/tactical/behavior", {
	m = {
		Parent = null,
		TargetTile = null,
		IsWaiting = false,
		IsForceDrag = false,
		PossibleSkills = [
			"actives.kraken_move_ensnared"
		],
		Skill = null,
	},
	function setParentID( _id )
	{
		local entity = ::Tactical.getEntityByID(_id);

		if (entity != null)
		{
			this.setParent(entity);
		}
	}

	function setParent( _p )
	{
		if (_p == null)
		{
			this.m.Parent = null;
		}
		else
		{
			if (typeof _p == "instance")
			{
				this.m.Parent = _p;
			}
			else
			{
				this.m.Parent = ::WeakTableRef(_p);
			}
		}
	}

	function setForcedDrag( _f )
	{
		this.m.IsForceDrag = _f;
	}

	function create()
	{
		this.m.ID = ::Const.AI.Behavior.ID.Drag;
		this.m.Order = ::Const.AI.Behavior.Order.Drag;
		this.m.IsThreaded = false;
		this.behavior.create();
	}

	function onEvaluate( _entity )
	{
		this.m.Skill = null;
		this.m.TargetTile = null;
		this.m.IsWaiting = false;

		local scoreMult = this.getProperties().BehaviorMult[this.m.ID];
		local skills = [];

		foreach( skillID in this.m.PossibleSkills )
		{
			local skill = _entity.getSkills().getSkillByID(skillID);

			if (skill != null && this.m.IsForceDrag || (skill.isUsable() && skill.isAffordable()))
			{
				skills.push(skill);
			}
		}

		if (skills.len() == 0)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		if (this.m.Parent == null || this.m.Parent.isNull())
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		this.m.Skill = skills[0];
		local kraken = this.m.Parent.get();
		local navigator = ::Tactical.getNavigator();
		local settings = navigator.createSettings();
		settings.ActionPointCosts = ::Const.PathfinderMovementAPCost;
		settings.FatigueCosts = ::Const.NoMovementFatigueCost;
		settings.FatigueCostFactor = 0.0;
		settings.ActionPointCostPerLevel = 0;
		settings.FatigueCostPerLevel = 0;
		settings.AllowZoneOfControlPassing = true;
		settings.ZoneOfControlCost = 0;
		settings.AlliedFactions = _entity.getAlliedFactions();
		settings.Faction = _entity.getFaction();

		if (navigator.findPath(_entity.getTile(), kraken.getTile(), settings, 1))
		{
			local movementCosts = navigator.getCostForPath(_entity, settings, 9, 100);
			this.m.TargetTile = movementCosts.End;
		}
		else if (!this.m.IsForceDrag && ::Tactical.TurnSequenceBar.entityWaitTurn(_entity))
		{
			this.m.IsWaiting = true;
		}
		else
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		return ::Const.AI.Behavior.Score.Drag * scoreMult;
	}

	function onBeforeExecute( _entity )
	{
	}

	function onExecute( _entity )
	{
		if (this.m.IsWaiting)
		{
			::Tactical.TurnSequenceBar.entityWaitTurn(_entity);

			if (::Const.AI.VerboseMode)
			{
				::logInfo("* " + _entity.getName() + ": Waiting until others have moved!");
			}

			return true;
		}

		this.getAgent().adjustCameraToDestination(this.m.TargetTile);

		if (this.m.Skill.use(this.m.TargetTile))
		{
			local delay = 0;

			if (!_entity.isHiddenToPlayer())
			{
				delay = delay + 1000;
			}

			if (this.m.TargetTile.IsVisibleForPlayer)
			{
				delay = delay + 1750;
			}

			this.getAgent().declareEvaluationDelay(delay);
		}

		this.setForcedDrag(false);
		return true;
	}

});

