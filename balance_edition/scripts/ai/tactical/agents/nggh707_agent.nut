this.nggh707_agent <- this.inherit("scripts/ai/tactical/agent", {
	m = {},
	function create()
	{
		this.agent.create();
		this.m.ID = this.Const.AI.Agent.ID.Necromancer;
		this.m.Properties.OverallMagnetismMult = 3.0;
	}

	function onAddBehaviors()
	{
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_flee"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_break_free"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_puncture"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_default"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_raise_undead_nggh707"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_possess_undead_nggh707"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_engage_ranged"));
	}

	function onTurnStarted()
	{
		this.agent.onTurnStarted();
		local allies = this.Tactical.Entities.getInstancesOfFaction(this.getActor().getFaction());
		local myTile = this.getActor().getTile();
		local nearest = 9999;

		foreach( a in allies )
		{
			if (a.getID() == this.getActor().getID())
			{
				continue;
			}

			local d = a.getTile().getDistanceTo(myTile);

			if (d < nearest)
			{
				nearest = d;
			}
		}

		if (nearest >= 10)
		{
			this.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.EngageRanged] = 1.0;
		}
		else
		{
			this.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.EngageRanged] = 0.0;
		}
	}

});

