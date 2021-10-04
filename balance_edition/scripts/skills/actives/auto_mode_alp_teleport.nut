this.auto_mode_alp_teleport <- this.inherit("scripts/skills/skill", {
	m = {},
	function getMode()
	{
		return this.getContainer().getActor().getFlags().get("disable_auto_teleport");
	}
	
	function create()
	{
		this.m.ID = "actives.auto_mode_alp_teleport";
		this.m.Name = "Toggle Auto Mode";
		this.m.Description = "Allow you to turn [color=" + this.Const.UI.Color.PositiveValue + "]ON[/color]/[color=" + this.Const.UI.Color.NegativeValue + "]OFF[/color], the ability to teleport when you or an allied alp gets hit.";
		this.m.Icon = "skills/active_auto_teleport_on.png";
		this.m.IconDisabled = "skills/active_auto_teleport_off.png";
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
			return this.m.IconDisabled;
		}

		return this.m.Icon;
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

		if (!this.getMode())
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/unlocked_small.png",
				text = "Auto Teleport mode is [color=" + this.Const.UI.Color.PositiveValue + "]ON[/color]"
			});
		}
		else
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/cancel.png",
				text = "Auto Teleport mode is [color=" + this.Const.UI.Color.NegativeValue + "]OFF[/color]"
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
		local currentMode = this.getMode();
		_user.getFlags().set("disable_auto_teleport", !currentMode);
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

