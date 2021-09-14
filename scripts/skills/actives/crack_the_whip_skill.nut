this.crack_the_whip_skill <- this.inherit("scripts/skills/skill", {
	m = {
		IsUsed = false
	},
	function create()
	{
		this.m.ID = "actives.crack_the_whip";
		this.m.Name = "Crack the Whip";
		this.m.Description = "Whip the air, making an astonishing sound that reminder your beasts who is the boss here.";
		this.m.Icon = "skills/active_162.png";
		this.m.IconDisabled = "skills/active_162_sw.png";
		this.m.Overlay = "active_162";
		this.m.SoundOnUse = [
			"sounds/combat/whip_01.wav",
			"sounds/combat/whip_02.wav",
			"sounds/combat/whip_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function onAdded()
	{
		this.m.FatigueCost = this.m.Container.getActor().isPlayerControlled() ? 15 : 10;
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
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Resets the morale of the all beasts to \'Steady\' if currently below"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Removes the Sleeping status effect of allies"
			}
		];
		
		if (this.m.IsUsed)
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
		if (this.m.IsUsed)
		{
			return false;
		}

		if (!this.skill.isUsable() || this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			return false;
		}
		
		if (this.getContainer().getActor().isPlayerControlled())
		{
			return true;
		}

		local actors = this.Tactical.Entities.getInstancesOfFaction(this.getContainer().getActor().getFaction());

		foreach( a in actors )
		{
			if (a.getType() == this.Const.EntityType.BarbarianUnhold || a.getType() == this.Const.EntityType.BarbarianUnholdFrost)
			{
				return true;
			}
		}

		return false;
	}

	function onUse( _user, _targetTile )
	{
		local myTile = _user.getTile();
		local actors = this.Tactical.Entities.getInstancesOfFaction(_user.getFaction());

		foreach( a in actors )
		{
			a.getSkills().removeByID("effects.sleeping");
			
			if ((a.getType() != this.Const.EntityType.BarbarianUnhold && a.getType() != this.Const.EntityType.BarbarianUnholdFrost) || !this.isKindOf(a, "player_beast"))
			{
				continue;
			}
			
			if (_user.isPlayerControlled())
			{
				if (a.getMoraleState() < this.Const.MoraleState.Steady)
				{
					a.setMoraleState(this.Const.MoraleState.Steady);
				}
				
				this.spawnIcon("status_effect_106", a.getTile());
				continue;
			}
			
			a.setWhipped(true);
			this.spawnIcon("status_effect_106", a.getTile());
		}

		this.m.IsUsed = true;
		return true;
	}

	function onTurnStart()
	{
		this.m.IsUsed = false;
	}

});

