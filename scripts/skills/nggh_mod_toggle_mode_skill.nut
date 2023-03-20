this.nggh_mod_toggle_mode_skill <- ::inherit("scripts/skills/skill", {
	m = {
		FlagName = ""
	},
	function isModeEnabled()
	{
		return this.getContainer().getActor().getFlags().get(this.m.FlagName);
	}

	function setMode( _boolean )
	{
		if (typeof _boolean == "bool")
		{
			this.getContainer().getActor().getFlags().set(this.m.FlagName, _boolean);
		}
		else
		{
			this.getContainer().getActor().getFlags().set(this.m.FlagName, false);
		}
	}
	
	function create()
	{
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.Last;
		this.m.IsSerialized = false;
		this.m.IsHidden = true;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsTargetingActor = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 0;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

	// can always be used
	function isUsable()
	{
		return true;
	}

	// can always be used
	function isAffordable()
	{
		return true;
	}

	function getName()
	{
		return "Toggle " + this.m.Name;
	}

	function getDescription()
	{
		return "Allows you to turn [color=" + ::Const.UI.Color.PositiveValue + "]ON[/color]/[color=" + ::Const.UI.Color.NegativeValue + "]OFF[/color] ";
	}

	function getIcon()
	{
		if (this.isModeEnabled())
		{
			return this.m.Icon;
		}

		return this.m.IconDisabled;
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

		if (this.isModeEnabled())
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/unlocked_small.png",
				text = this.m.Name + " mode is [color=" + ::Const.UI.Color.PositiveValue + "]ON[/color]"
			});

			return ret;
		}
		
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/cancel.png",
			text = this.m.Name + " mode is [color=" + ::Const.UI.Color.NegativeValue + "]OFF[/color]"
		});

		return ret;
	}

	function onUse( _user, _targetTile )
	{
		return this.switchMode();
	}

	function switchMode( _reset = false )
	{
		if (_reset)
		{
			this.setMode(false);
		}
		else
		{
			this.setMode(!this.isModeEnabled());
		}

		this.onAfterSwitchMode();
		return true;
	}

	function onAfterSwitchMode()
	{
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

