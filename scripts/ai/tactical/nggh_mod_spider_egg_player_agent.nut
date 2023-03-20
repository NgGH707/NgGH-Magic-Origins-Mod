this.nggh_mod_spider_egg_player_agent <- ::inherit("scripts/ai/tactical/agent", {
	m = {},
	function create()
	{
		this.agent.create();
		this.m.ID = ::Const.AI.Agent.ID.Player;
		this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.Retreat] = 0.0;
		this.addBehavior(::new("scripts/ai/tactical/behaviors/ai_flee"));
		this.addBehavior(::new("scripts/ai/tactical/behaviors/ai_break_free"));
		this.addBehavior(::new("scripts/ai/tactical/behaviors/ai_egg_ride"));
	}

});

