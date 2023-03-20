::mods_hookExactClass("skills/actives/crack_the_whip_skill", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Whip the air, making an astonishing sound that reminding your beasts who is the boss here.";
		this.m.Icon = "skills/active_162.png";
		this.m.IconDisabled = "skills/active_162_sw.png";
	};
	obj.onAdded <- function()
	{
		this.m.FatigueCost = this.getContainer().getActor().isPlayerControlled() ? 15 : 10;
	};
	obj.getTooltip <- function()
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
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can only be used once per turn[/color]"
			});
		}

		return ret;
	};
	obj.isUsable = function()
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

		foreach( a in ::Tactical.Entities.getInstancesOfFaction(this.getContainer().getActor().getFaction()) )
		{
			if (a.getType() == ::Const.EntityType.BarbarianUnhold || a.getType() == ::Const.EntityType.BarbarianUnholdFrost)
			{
				return true;
			}
		}

		return false;
	};
	obj.onUse = function( _user, _targetTile )
	{
		local myTile = _user.getTile();
		foreach( a in ::Tactical.Entities.getInstancesOfFaction(_user.getFaction()) )
		{
			a.getSkills().removeByID("effects.sleeping");
			
			if ((a.getType() != ::Const.EntityType.BarbarianUnhold && a.getType() != ::Const.EntityType.BarbarianUnholdFrost) || !::isKindOf(a, "nggh_mod_player_beast"))
			{
				continue;
			}
			
			if (_user.isPlayerControlled())
			{
				if (a.getMoraleState() < ::Const.MoraleState.Steady)
				{
					a.setMoraleState(::Const.MoraleState.Steady);
				}
				
				this.spawnIcon("status_effect_106", a.getTile());
				continue;
			}
			
			a.setWhipped(true);
			this.spawnIcon("status_effect_106", a.getTile());
		}

		this.m.IsUsed = true;
		return true;
	};
});