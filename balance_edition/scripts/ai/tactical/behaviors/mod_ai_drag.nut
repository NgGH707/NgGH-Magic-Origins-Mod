this.mod_ai_drag <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		TargetTile = null,
		IsWaiting = false,
		PossibleSkills = [
			"actives.mod_kraken_move_ensnared"
		],
		Skill = null,
	},
	function create()
	{
		this.m.ID = this.Const.AI.Behavior.ID.Drag;
		this.m.Order = this.Const.AI.Behavior.Order.Drag;
		this.m.IsThreaded = false;
		this.behavior.create();
	}

	function onEvaluate( _entity , _isForce = false , _kraken = null )
	{
		this.m.Skill = null;
		this.m.TargetTile = null;
		this.m.IsWaiting = false;

		if (!_isForce || _kraken == null)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		local scoreMult = this.getProperties().BehaviorMult[this.m.ID];
		local skills = [];

		foreach( skillID in this.m.PossibleSkills )
		{
			local skill = _entity.getSkills().getSkillByID(skillID);

			if (skill != null && skill.isUsable() && skill.isAffordable())
			{
				skills.push(skill);
			}
		}

		if (skills.len() == 0)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		this.m.Skill = skills[this.Math.rand(0, skills.len() - 1)];
		local navigator = this.Tactical.getNavigator();
		local settings = navigator.createSettings();
		settings.ActionPointCosts = this.Const.PathfinderMovementAPCost;
		settings.FatigueCosts = this.Const.NoMovementFatigueCost;
		settings.FatigueCostFactor = 0.0;
		settings.ActionPointCostPerLevel = 0;
		settings.FatigueCostPerLevel = 0;
		settings.AllowZoneOfControlPassing = true;
		settings.ZoneOfControlCost = 0;
		settings.AlliedFactions = _entity.getAlliedFactions();
		settings.Faction = _entity.getFaction();

		if (navigator.findPath(_entity.getTile(), _kraken.getTile(), settings, 1))
		{
			local movementCosts = navigator.getCostForPath(_entity, settings, 9, 100);
			this.m.TargetTile = movementCosts.End;
		}
		else if (this.Tactical.TurnSequenceBar.entityWaitTurn(_entity))
		{
			this.m.IsWaiting = true;
		}
		else
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		return this.Const.AI.Behavior.Score.Drag * scoreMult;
	}

	function onBeforeExecute( _entity )
	{
	}

	function onExecute( _entity )
	{
		if (this.m.IsWaiting)
		{
			this.Tactical.TurnSequenceBar.entityWaitTurn(_entity);

			if (this.Const.AI.VerboseMode)
			{
				this.logInfo("* " + _entity.getName() + ": Waiting until others have moved!");
			}

			return true;
		}

		this.getAgent().adjustCameraToDestination(this.m.TargetTile);

		if (this.m.Skill.use(this.m.TargetTile))
		{
			local delay = 0;

			if (!_entity.isHiddenToPlayer())
			{
				delay = delay + 800;
			}

			if (this.m.TargetTile.IsVisibleForPlayer)
			{
				delay = delay + 1250;
			}

			this.getAgent().declareEvaluationDelay(delay);
		}

		return true;
	}

});

