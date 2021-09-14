this.intimidate_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.intimidate";
		this.m.Name = "Intimidate";
		this.m.Description = "Frighten your enemies with your fierce appearance, make they hesitate to act and more likely to miss their attacks or being scared. ";
		this.m.Icon = "ui/perks/active_intimidate.png";
		this.m.IconDisabled = "ui/perks/active_intimidate_sw.png";
		this.m.Overlay = "active_intimidate";
		this.m.SoundOnUse = [
			"sounds/enemies/lindwurm_flee_01.wav",
			"sounds/enemies/lindwurm_flee_02.wav",
			"sounds/enemies/lindwurm_flee_03.wav",
			"sounds/enemies/lindwurm_flee_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted - 1;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 2;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
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
				text = "Applies [color=" + this.Const.UI.Color.NegativeValue + "]Intimidated[/color] to any enemy within [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.MaxRange + "[/color] tiles radius"
			}
		];

		return ret;
	}

	function onUse( _user, _targetTile )
	{
		if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName());
		}

		local tag = {
			User = _user
		};
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 1000, this.onDelayedEffect, tag);
		return true;
	}

	function onDelayedEffect( _tag )
	{
		local mytile = _tag.User.getTile();
		local actors = this.Tactical.Entities.getAllInstances();

		foreach( i in actors )
		{
			foreach( a in i )
			{
				if (a.getID() == _tag.User.getID())
				{
					continue;
				}

				if (a.getTile().getDistanceTo(mytile) > 3)
				{
					continue;
				}

				if (a.getMoraleState() == this.Const.MoraleState.Ignore)
				{
					continue;
				}

				if (!a.isAlliedWith(_tag.User))
				{
					local difficulty = 10 - this.Math.pow(a.getTile().getDistanceTo(mytile), this.Const.Morale.AllyKilledDistancePow);
					local effect = this.new("scripts/skills/effects/intimidated_effect");
					
					if(!a.checkMorale(0, difficulty, this.Const.MoraleCheckType.MentalAttack))
					{
						effect.m.IsWorsen = true;
					}

					a.getSkills().add(effect);
				}
			}
		}
	}


});

