this.drums_of_war_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.drums_of_war";
		this.m.Name = "Drums of War";
		this.m.Description = "Inspire your men with rhythm of war";
		this.m.Icon = "skills/active_163.png";
		this.m.IconDisabled = "skills/active_163_sw.png";
		this.m.Overlay = "active_163";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc4/wardrums_01.wav",
			"sounds/enemies/dlc4/wardrums_02.wav",
			"sounds/enemies/dlc4/wardrums_03.wav"
		];
		this.m.SoundVolume = 1.5;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}
	
	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "Lowers the fatigue of every brother by [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] instantly."
			}
		]);
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		local myTile = _user.getTile();
		local actors = this.Tactical.Entities.getInstancesOfFaction(_user.getFaction());

		foreach( a in actors )
		{
			if (a.getID() == _user.getID())
			{
				continue;
			}

			if (a.getFatigue() == 0)
			{
				continue;
			}

			if (a.getFaction() == _user.getFaction() && !a.getSkills().hasSkill("effects.drums_of_war"))
			{
				a.getSkills().add(this.new("scripts/skills/effects/drums_of_war_effect"));
			}
		}

		this.getContainer().add(this.new("scripts/skills/effects/drums_of_war_effect"));
		return true;
	}

});

