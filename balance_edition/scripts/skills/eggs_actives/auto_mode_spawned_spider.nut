this.auto_mode_spawned_spider <- this.inherit("scripts/skills/skill", {
	m = {},
	function getMode()
	{
		return this.getContainer().getActor().getFlags().get("autopilot_spiderling");
	}

	function setMode( _boolean )
	{
		if (typeof _boolean == "bool")
		{
			this.getContainer().getActor().getFlags().set("autopilot_spiderling", _boolean);
		}
		else
		{
			this.getContainer().getActor().getFlags().set("autopilot_spiderling", false);
		}
	}
	
	function create()
	{
		this.m.ID = "actives.auto_mode_spawned_spider";
		this.m.Name = "Toggle Auto Mode";
		this.m.Description = "Allow you to turn [color=" + this.Const.UI.Color.PositiveValue + "]ON[/color]/[color=" + this.Const.UI.Color.NegativeValue + "]OFF[/color], the AI of your spawned spiders. Put them under your control or the AI. It\'s your choice.";
		this.m.Icon = "skills/active_auto_mode_on.png";
		this.m.IconDisabled = "skills/active_auto_mode_off.png";
		this.m.Overlay = "";
		this.m.SoundOnUse = [];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsSerialized = false;
		this.m.IsHidden = true;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 0;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

	function getIcon()
	{
		if (this.getMode())
		{
			return this.m.Icon;
		}

		return this.m.IconDisabled;
	}

	function isUsable()
	{
		return true;
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
		];

		if (this.m.AutoMode)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/unlocked_small.png",
				text = "Auto mode is [color=" + this.Const.UI.Color.PositiveValue + "]ON[/color]"
			});
		}
		else
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/cancel.png",
				text = "Auto mode is [color=" + this.Const.UI.Color.NegativeValue + "]OFF[/color]"
			});
		}

		return ret;
	}

	function onUse( _user, _targetTile )
	{
		return this.switchMode();
	}

	function switchMode( _reset = false )
	{
		local _user = this.getContainer().getActor();
		local actors = this.Tactical.Entities.getAllInstancesAsArray();
		local currentMode = this.getMode();
		
		if (_reset)
		{
			this.setMode(false);
		}
		else
		{
			this.setMode(!currentMode);
		}

		foreach (i, a in actors)
		{
			if (a.getSkills().hasSkill("effects.charmed"))
			{
				continue;
			}
			
		    if (!a.getFlags().has("creator") || a.getFlags().get("creator") != _user.getID())
		    {
		    	continue;
		    }

			this.onChangeAI(a);
		}

		return true;
	}

	function onChangeAI( _actor )
	{
		_actor.m.IsControlledByPlayer = !this.getMode();

		if (this.Tactical.isActive() && this.Tactical.State.m.IsAutoRetreat)
		{
			_actor.m.IsControlledByPlayer = false;
			_actor.setAIAgent(this.new("scripts/ai/tactical/agents/spider_bodyguard_agent"));
			_actor.getAIAgent().setActor(_actor);
			_actor.getAIAgent().removeBehavior(this.Const.AI.Behavior.ID.Protect);

	    	local protect = this.new("scripts/ai/tactical/behaviors/ai_protect_person");
	    	_actor.getAIAgent().addBehavior(protect);

	    	if (_actor.m.Master != null && !_actor.m.Master.isNull() && _actor.m.Master.isAlive() && !_actor.m.Master.isDying())
			{
	    		protect.setVIP(_actor.m.Master.get());
	    	}
		}
		else
		{
			if (!_actor.isPlayerControlled())
			{
		    	_actor.setAIAgent(this.new("scripts/ai/tactical/agents/spider_agent"));
			}
			else
			{
			    _actor.m.AIAgent = this.new("scripts/ai/tactical/player_agent");
			}

			_actor.getAIAgent().setActor(_actor);
		}
	}

	function onCombatStarted()
	{
		this.m.IsHidden = false;
	}

	function onCombatFinished()
	{
		this.m.IsHidden = true;
	}

});

