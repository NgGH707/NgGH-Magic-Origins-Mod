this.nggh_mod_auto_mode_spawned_spider <- ::inherit("scripts/skills/nggh_mod_toggle_mode_skill", {
	m = {},
	function create()
	{
		this.nggh_mod_toggle_mode_skill.create();
		this.m.ID = "actives.auto_mode_spawned_spider";
		this.m.Name = "Autopilot";
		this.m.FlagName = "autopilot_spiderling";
		this.m.Description = "the autopilot mode of your spawned spiders.";
		this.m.Icon = "skills/active_auto_mode_on.png";
		this.m.IconDisabled = "skills/active_auto_mode_off.png";
	}

	function onAfterSwitchMode()
	{
		local id = this.getContainer().getActor().getID();

		foreach (i, a in ::Tactical.Entities.getAllInstancesAsArray())
		{
		    if (!a.getFlags().has("Source") || a.getFlags().get("Source") != id)
		    {
		    	continue;
		    }

			this.onChangeAI(a);
		}
	}

	function onChangeAI( _actor )
	{
		// make spiderlings become fodders for you to retreat
		if (::Tactical.isActive() && ::Tactical.State.m.IsAutoRetreat)
		{
			_actor.m.IsControlledByPlayer = false;
			_actor.setAIAgent(::new("scripts/ai/tactical/agents/spider_bodyguard_agent"));
			_actor.getAIAgent().setActor(_actor);
			_actor.getAIAgent().removeBehavior(::Const.AI.Behavior.ID.Protect);
	    	
	    	if (_actor.m.Master != null && !_actor.m.Master.isNull() && _actor.m.Master.isAlive() && !_actor.m.Master.isDying())
			{
				local protect = ::new("scripts/ai/tactical/behaviors/ai_protect_person");
	    		protect.setVIP(_actor.m.Master.get());
	    		_actor.getAIAgent().addBehavior(protect);
	    	}

	    	return;
		}

		// switch control between player and ai
		_actor.m.IsControlledByPlayer = !this.isModeEnabled();
		
		if (!_actor.isPlayerControlled())
		{
	    	_actor.setAIAgent(::new("scripts/ai/tactical/agents/spider_agent"));
		}
		else
		{
		    _actor.setAIAgent(::new("scripts/ai/tactical/player_agent"));
		}

		_actor.getAIAgent().setActor(_actor);
	}


});

