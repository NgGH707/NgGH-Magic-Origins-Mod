this.mod_nggh_kraken_tentacle_agent <- ::inherit("scripts/ai/tactical/agent", {
	m = {},
	function create()
	{
		this.agent.create();
		this.m.ID = ::Const.AI.Agent.ID.KrakenTentacle;
		this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.EngageMelee] = 0.0;
		this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.AttackDefault] = 2.5;
		this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.MoveTentacle] = 0.75;
		this.m.Properties.TargetPriorityHitchanceMult = 0.35;
		this.m.Properties.TargetPriorityHitpointsMult = 0.25;
		this.m.Properties.TargetPriorityRandomMult = 0.15;
		this.m.Properties.TargetPriorityDamageMult = 0.25;
		this.m.Properties.TargetPriorityFleeingMult = 0.75;
		this.m.Properties.TargetPriorityHittingAlliesMult = 0.1;
		this.m.Properties.TargetPriorityArmorMult = 1.0;
		this.m.Properties.OverallDefensivenessMult = 0.0;
		this.m.Properties.OverallFormationMult = 0.0;
		this.m.Properties.EngageWhenAlreadyEngagedMult = 0.0;
		this.m.Properties.EngageTargetMultipleOpponentsMult = 1.0;
		this.m.Properties.EngageOnGoodTerrainBonusMult = 0.5;
		this.m.Properties.EngageOnBadTerrainPenaltyMult = 0.5;
		this.m.Properties.EngageAgainstSpearwallMult = 0.0;
		this.m.Properties.EngageAgainstSpearwallWithShieldwallMult = 0.0;
		this.m.Properties.EngageTargetArmedWithRangedWeaponMult = 0.5;
		this.m.Properties.EngageTargetAlreadyBeingEngagedMult = 1.0;
		this.m.Properties.EngageLockDownTargetMult = 1.0;
		this.m.Properties.EngageRangeMin = 1;
		this.m.Properties.EngageRangeMax = 2;
		this.m.Properties.EngageRangeIdeal = 2;
	}

	function onAddBehaviors()
	{
		this.addBehavior(::new("scripts/ai/tactical/behaviors/nggh_mod_ai_move_tentacle"));
		this.addBehavior(::new("scripts/ai/tactical/behaviors/ai_attack_default"));
		this.addBehavior(::new("scripts/ai/tactical/behaviors/ai_attack_swing"));
		this.addBehavior(::new("scripts/ai/tactical/behaviors/ai_attack_throw_net"));
		this.addBehavior(::new("scripts/ai/tactical/behaviors/ai_break_free"));
	}

	function onUpdate()
	{
		if (this.m.Actor.getMode() == 0)
		{
			this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.ThrowNet] = 1.0;
		}
		else
		{
			this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.ThrowNet] = 0.5;
		}
	}

});

