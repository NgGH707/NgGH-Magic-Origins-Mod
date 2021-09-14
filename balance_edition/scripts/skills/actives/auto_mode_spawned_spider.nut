this.auto_mode_spawned_spider <- this.inherit("scripts/skills/skill", {
	m = {
		AutoMode = false
	},
	function getMode()
	{
		return this.m.AutoMode;
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
		this.switchMode();
		return true;
	}

	function switchMode( _reset = false )
	{
		local _user = this.getContainer().getActor();
		local actors = this.Tactical.Entities.getAllInstancesAsArray();
		this.m.AutoMode = !this.m.AutoMode;

		if (_reset)
		{
			this.m.AutoMode = false;
		}

		foreach (i, a in actors)
		{
		    if (!a.getFlags().has("creator") || a.getFlags().get("creator") != _user.getID())
		    {
		    	continue;
		    }

	    	if (a.getSkills().hasSkill("special.egg_attachment"))
			{
				continue;
			}

			a.m.IsControlledByPlayer = !this.m.AutoMode;
			a.onFactionChanged();
		}
	}

	function onCombatStarted()
	{
		this.m.AutoMode = false;
		this.m.IsHidden = false;
	}

	function onCombatFinished()
	{
		this.m.IsHidden = true;
	}

});

