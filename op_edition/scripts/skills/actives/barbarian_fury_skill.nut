this.barbarian_fury_skill <- this.inherit("scripts/skills/skill", {
	m = {
		IsSpent = false
	},
	function create()
	{
		this.m.ID = "actives.barbarian_fury";
		this.m.Name = "Barbarian Fury";
		this.m.Description = "Switch places with another character directly adjacent, provided neither the target is stunned or rooted, nor the character using the skill is. Rotate the battle line to keep fresh troops in front!";
		this.m.Icon = "skills/active_175.png";
		this.m.IconDisabled = "skills/active_175_sw.png";
		this.m.Overlay = "active_175";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc4/barbarian_fury_01.wav",
			"sounds/enemies/dlc4/barbarian_fury_02.wav",
			"sounds/enemies/dlc4/barbarian_fury_03.wav",
			"sounds/enemies/dlc4/barbarian_fury_04.wav",
			"sounds/enemies/dlc4/barbarian_fury_05.wav",
			"sounds/enemies/dlc4/barbarian_fury_06.wav",
			"sounds/enemies/dlc4/barbarian_fury_07.wav",
			"sounds/enemies/dlc4/barbarian_fury_08.wav",
			"sounds/enemies/dlc4/barbarian_fury_09.wav",
			"sounds/enemies/dlc4/barbarian_fury_10.wav",
			"sounds/enemies/dlc4/barbarian_fury_11.wav",
			"sounds/enemies/dlc4/barbarian_fury_12.wav"
		];
		this.m.SoundVolume = 1.15;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 5;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}
	
	function getTooltip()
	{
		local value = this.Math.round(this.Math.minf(0.5, this.getContainer().getActor().getCurrentProperties().Bravery * 0.005) * 100);
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
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			}
		];

		if (this.getContainer().getActor().getCurrentProperties().IsRooted)
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not be used while rooted[/color]"
			});
		}
		
		if (this.m.IsSpent)
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can only be used once per turn[/color]"
			});
		}

		return ret;
	}

	function getCursorForTile( _tile )
	{
		return this.Const.UI.Cursor.Rotation;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.m.IsSpent && !this.getContainer().getActor().getCurrentProperties().IsRooted;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		local target = _targetTile.getEntity();

		if (!target.isAlliedWith(this.getContainer().getActor()))
		{
			return false;
		}

		return this.skill.onVerifyTarget(_originTile, _targetTile) && !target.getCurrentProperties().IsStunned && !target.getCurrentProperties().IsRooted && target.getCurrentProperties().IsMovable;
	}

	function onTurnStart()
	{
		this.m.IsSpent = false;
	}

	function onUse( _user, _targetTile )
	{
		this.m.IsSpent = true;
		local target = _targetTile.getEntity();
		this.Tactical.getNavigator().switchEntities(_user, target, null, null, 1.0);
		return true;
	}

});

