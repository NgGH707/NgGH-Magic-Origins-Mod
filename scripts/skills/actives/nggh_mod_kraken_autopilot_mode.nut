this.nggh_mod_kraken_autopilot_mode <- ::inherit("scripts/skills/nggh_mod_toggle_mode_skill", {
	m = {},
	function create()
	{
		this.nggh_mod_toggle_mode_skill.create();
		this.m.ID = "actives.kraken_autopilot_mode";
		this.m.Name = "Autopilot";
		this.m.FlagName = "tentacle_autopilot";
		this.m.Description = "the autopilot mode of your tentacles.";
		this.m.Icon = "skills/active_autopilot_tentacle_on.png";
		this.m.IconDisabled = "skills/active_autopilot_tentacle_off.png";
	}

	function onAfterSwitchMode()
	{
		local kraken = this.getContainer().getActor();
		local id = kraken.getID();

		foreach (i, t in kraken.getTentacles())
		{
		    if (t.isNull() || t.isDying() || !t.isAlive())
			{
				continue;
			}

			this.onChangeAI(t);
		}
	}

	function onChangeAI( _actor )
	{
		// make spiderlings become fodders for you to retreat
		if (::Tactical.isActive() && ::Tactical.State.m.IsAutoRetreat)
		{
			_actor.m.IsControlledByPlayer = false;

			if (_actor.getAIAgent().getID() != ::Const.AI.Agent.ID.KrakenTentacle)
			{
				_actor.setAIAgent(::new("scripts/ai/tactical/agents/mod_nggh_kraken_tentacle_agent"));
				_actor.getAIAgent().setActor(_actor);
			}

			local actor = this.getContainer().getActor();
	    	
	    	if (actor != null && !actor.isNull() && actor.isAlive() && !actor.isDying())
			{
				local protect = ::new("scripts/ai/tactical/behaviors/ai_protect_person");
	    		protect.setVIP(actor.get());
	    		_actor.getAIAgent().addBehavior(protect);
	    	}

	    	return;
		}

		// switch control between player and ai
		_actor.m.IsControlledByPlayer = !this.isModeEnabled();
		
		if (!_actor.isPlayerControlled())
		{
	    	_actor.setAIAgent(::new("scripts/ai/tactical/agents/mod_nggh_kraken_tentacle_agent"));
		}
		else
		{
		    _actor.setAIAgent(::new("scripts/ai/tactical/player_agent"));
		}

		_actor.getAIAgent().setActor(_actor);
	}


});

