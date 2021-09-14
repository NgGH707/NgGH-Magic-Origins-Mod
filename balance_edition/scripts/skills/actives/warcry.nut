this.warcry <- this.inherit("scripts/skills/skill", {
	m = {
		IsSpent = false
	},
	function create()
	{
		this.m.ID = "actives.warcry";
		this.m.Name = "Warcry";
		this.m.Description = "A deafening roar to that can easily scare the shit out of you and raise morale for your warriors.";
		this.m.Icon = "skills/active_49.png";
		this.m.IconDisabled = "skills/active_49_sw.png";
		this.m.Overlay = "active_49";
		this.m.SoundOnUse = [
			"sounds/enemies/warcry_01.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted + 1;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
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
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Triggers a morale check to raise or rally allies"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Triggers a negative morale check to enemies"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Removes the Sleeping status effect of all allies regardles the distance"
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

	function onTurnStart()
	{
		this.m.IsSpent = false;
	}

	function onUse( _user, _targetTile )
	{
		if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " uses Warcry");
		}

		local tag = {
			User = _user
		};
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 1000, this.onDelayedEffect, tag);
		this.m.IsSpent = true;
		return true;
	}

	function onDelayedEffect( _tag )
	{
		local mytile = _tag.User.getTile();
		local actors = this.Tactical.Entities.getAllInstances();
		local p = _tag.User.getCurrentProperties();
		local bonus = p.Threat + p.ThreatOnHit;

		foreach( i in actors )
		{
			foreach( a in i )
			{
				if (a.getID() == _tag.User.getID())
				{
					continue;
				}

				if (a.getFaction() == _tag.User.getFaction())
				{
					a.getSkills().removeByID("effects.sleeping");
					
					local difficulty = bonus + 10 - this.Math.pow(a.getTile().getDistanceTo(mytile), this.Const.Morale.EnemyKilledDistancePow);

					if (a.getMoraleState() == this.Const.MoraleState.Fleeing)
					{
						a.checkMorale(this.Const.MoraleState.Wavering - this.Const.MoraleState.Fleeing, difficulty);
					}
					else
					{
						a.checkMorale(1, difficulty);
					}

					a.setFatigue(a.getFatigue() - 20);
				}
				else if (!a.isAlliedWith(_tag.User))
				{
					local difficulty = 5 + bonus - this.Math.pow(a.getTile().getDistanceTo(mytile), this.Const.Morale.AllyKilledDistancePow);
					a.checkMorale(-1, difficulty, this.Const.MoraleCheckType.MentalAttack);
				}
			}
		}
	}

});

