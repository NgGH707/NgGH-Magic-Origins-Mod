this.grant_night_vision_skill <- this.inherit("scripts/skills/skill", {
	m = {
		IsSpent = false
	},
	function create()
	{
		this.m.ID = "actives.grant_night_vision";
		this.m.Name = "Grant Night Vision";
		this.m.Description = "A simple chant to give a group of your men the ability to see through the darkness of the night.";
		this.m.Icon = "skills/active_156.png";
		this.m.IconDisabled = "skills/active_156_sw.png";
		this.m.Overlay = "active_156";
		this.m.SoundOnUse = [
			"sounds/enemies/shaman_skill_nightvision_01.wav",
			"sounds/enemies/shaman_skill_nightvision_02.wav",
			"sounds/enemies/shaman_skill_nightvision_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted + 3;
		this.m.IsSerialized = false;
		this.m.Delay = 0;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsTargetingActor = false;
		this.m.IsAttack = false;
		this.m.IsRanged = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 5;
		this.m.MinRange = 1;
		this.m.MaxRange = 7;
		this.m.MaxLevelDifference = 4;
	}

	function onAdded()
	{
		this.m.FatigueCost = this.m.Container.getActor().isPlayerControlled() ? 15 : this.m.FatigueCost;
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
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]Removes[/color] nighttime penalties to a group of allies"
			}
		];
		
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

	function isUsable()
	{
		return this.skill.isUsable() && !this.m.IsSpent;
	}

	function isViableTarget( _user, _target )
	{
		if (!_target.isAlliedWith(_user))
		{
			return false;
		}

		if (!_target.getCurrentProperties().IsAffectedByNight || !_target.getSkills().hasSkill("special.night"))
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		this.m.IsSpent = true;
		local targets = [];

		if (_targetTile.IsOccupiedByActor)
		{
			local entity = _targetTile.getEntity();

			if (this.isViableTarget(_user, entity))
			{
				targets.push(entity);
			}
		}

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local adjacent = _targetTile.getNextTile(i);

				if (adjacent.IsOccupiedByActor)
				{
					local entity = adjacent.getEntity();

					if (this.isViableTarget(_user, entity))
					{
						targets.push(entity);
					}
				}
			}
		}

		foreach( target in targets )
		{
			this.spawnIcon("status_effect_98", target.getTile());
			target.getSkills().removeByID("special.night");
		}

		if (!_user.isHiddenToPlayer())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " casts Grant Night Vision");
		}

		return true;
	}
	
	function onTargetSelected( _targetTile )
	{
		this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
		
		for( local i = 0; i < 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _targetTile.getNextTile(i);
				this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);	
			}
		}
	}

	function onTurnStart()
	{
		this.m.IsSpent = false;
	}

});

