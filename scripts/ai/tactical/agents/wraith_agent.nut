this.wraith_agent <- this.inherit("scripts/ai/tactical/agent", {
	m = {},
	function create()
	{
		this.agent.create();
		this.m.ID = this.Const.AI.Agent.ID.Ghost;
		this.m.Properties.TargetPriorityHitchanceMult = 0.5;
		this.m.Properties.TargetPriorityHitpointsMult = 0.25;
		this.m.Properties.TargetPriorityRandomMult = 0.0;
		this.m.Properties.TargetPriorityDamageMult = 0.0;
		this.m.Properties.TargetPriorityFleeingMult = 1.0;
		this.m.Properties.TargetPriorityHittingAlliesMult = 0.1;
		this.m.Properties.TargetPriorityFinishOpponentMult = 2.75;
		this.m.Properties.TargetPriorityCounterSkillsMult = 0.5;
		this.m.Properties.TargetPriorityArmorMult = 2.0;
		this.m.Properties.TargetPriorityMoraleMult = 0.25;
		this.m.Properties.TargetPriorityBraveryMult = 0.25;
		this.m.Properties.OverallDefensivenessMult = 0.5;
		this.m.Properties.OverallFormationMult = 0.5;
		this.m.Properties.EngageWhenAlreadyEngagedMult = 0.25;
		this.m.Properties.EngageTargetMultipleOpponentsMult = 0.5;
		this.m.Properties.EngageOnGoodTerrainBonusMult = 1.0;
		this.m.Properties.EngageOnBadTerrainPenaltyMult = 1.0;
		this.m.Properties.EngageAgainstSpearwallMult = 0.25;
		this.m.Properties.EngageAgainstSpearwallWithShieldwallMult = 0.25;
		this.m.Properties.EngageTargetArmedWithRangedWeaponMult = 1.0;
		this.m.Properties.EngageTargetAlreadyBeingEngagedMult = 1.0;
		this.m.Properties.EngageLockDownTargetMult = 1.0;
		this.m.Properties.EngageRangeMin = 1;
		this.m.Properties.EngageRangeMax = 4;
		this.m.Properties.EngageRangeIdeal = 4;
		this.m.Properties.PreferCarefulEngage = false;
	}

	function onAddBehaviors()
	{
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_engage_melee"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_default"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_terror"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_disengage"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_horror"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_miasma"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_defend"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_defend_rotation"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_ghost_possess"));
	}

	function onUpdate()
	{
		local strategy = this.Tactical.Entities.getStrategy(this.getActor().getFaction());
		local ghosts = 0;

		foreach( a in this.m.KnownAllies )
		{
			if (a.getType() == this.Const.EntityType.Ghost)
			{
				ghosts = ++ghosts;
			}
		}

		if (!this.Tactical.State.isAutoRetreat() && !strategy.getStats().IsEngaged && this.m.Actor.getAttackedCount() <= 3 && this.m.KnownAllies.len() >= 6 && ghosts < this.m.KnownAllies.len() - 1 && this.Time.getRound() <= 2)
		{
			this.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.EngageMelee] = 0.0;
		}
		else if (!this.Tactical.State.isAutoRetreat() && !strategy.getStats().IsEngaged && this.m.Actor.getAttackedCount() <= 3 && this.m.KnownAllies.len() >= 6 && ghosts < this.m.KnownAllies.len() - 1 && strategy.getStats().ShortestDistanceToEnemyNotMoved >= 3)
		{
			this.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.EngageMelee] = 1.0;
			this.m.Properties.EngageTileLimit = 2;
			this.m.Properties.PreferWait = true;
		}
		else
		{
			this.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.EngageMelee] = 1.0;
			this.m.Properties.PreferWait = false;
			this.m.Properties.EngageTileLimit = 0;
		}

		local myTile = this.getActor().getTile();
		local opponentNearby = false;
		local opponents = this.getKnownOpponents();

		foreach( t in opponents )
		{
			if (t.Actor.isNull())
			{
				continue;
			}

			if (t.Actor.getMoraleState() != this.Const.MoraleState.Fleeing && t.Actor.getTile().getDistanceTo(myTile) <= 6 && t.Actor.getCurrentProperties().MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] <= 3.0)
			{
				opponentNearby = true;
				break;
			}
		}

		if (opponentNearby)
		{
			this.m.Properties.EngageRangeIdeal = 3;
			this.m.Properties.EngageRangeMax = 4;
		}
		else
		{
			this.m.Properties.EngageRangeIdeal = 4;
			this.m.Properties.EngageRangeMax = 4;
		}
	}

});

