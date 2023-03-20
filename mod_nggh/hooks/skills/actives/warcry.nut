::mods_hookExactClass("skills/actives/warcry", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "A deafening roar to that can easily scare the shit out of you and raise morale for your warriors.";
		this.m.Icon = "skills/active_49.png";
		this.m.IconDisabled = "skills/active_49_sw.png";
		this.m.Order = ::Const.SkillOrder.UtilityTargeted + 1;
		this.m.MaxRange = 4;
	};
	obj.onAdded <- function()
	{
		if (this.getContainer().getActor().isPlayerControlled())
		{
			this.m.FatigueCost = 30;
			this.m.ActionPointCost = 4;
		}
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
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Affects every entity within [color=" + ::Const.UI.Color.PositiveValue + "]" + (::Nggh_MagicConcept.IsOPMode ? this.getMaxRange() + 8 : this.getMaxRange()) + "[/color] tiles distance"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Triggers a positive morale check or rally allies"
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
				text = "Removes the Sleeping status effect of anyone within range"
			}
		];
		
		if (this.m.IsSpent)
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
	obj.onDelayedEffect = function( _tag )
	{
		local mytile = _tag.User.getTile();
		local f = _tag.User.getFaction();
		local p = _tag.User.getCurrentProperties();
		local bonus = p.Threat + ::Math.min(15, p.ThreatOnHit);
		local isPlayer = _tag.User.getFaction() == ::Const.Faction.Player;

		foreach( i in ::Tactical.Entities.getAllInstances() )
		{
			foreach( a in i )
			{
				if (a.getID() == _tag.User.getID())
				{
					continue;
				}

				local dis = a.getTile().getDistanceTo(mytile);

				if (!::Nggh_MagicConcept.IsOPMode && dis > 4)
				{
					continue;
				} 

				if (a.getFaction() == f)
				{
					local difficulty = 10 + bonus - ::Math.pow(dis, ::Const.Morale.EnemyKilledDistancePow);

					if (a.getMoraleState() == ::Const.MoraleState.Fleeing)
					{
						a.checkMorale(::Const.MoraleState.Wavering - ::Const.MoraleState.Fleeing, difficulty);
					}
					else
					{
						a.checkMorale(1, difficulty);
					}

					if (a.getFaction() != ::Const.Faction.Player) a.setFatigue(a.getFatigue() - 20);
				}
				else if (a.getFaction() == ::Const.Faction.PlayerAnimals && isPlayer)
				{
				}
				else
				{
					local difficulty = bonus + 10 - ::Math.pow(dis, ::Const.Morale.AllyKilledDistancePow);
					a.checkMorale(-1, difficulty, ::Const.MoraleCheckType.MentalAttack);
				}

				a.getSkills().removeByID("effects.sleeping");
			}
		}
	};
});