::mods_hookExactClass("entity/tactical/actor", function(obj)
{
	//obj.m.MagicPoints <- 0;
	//obj.m.PreviewMagicPoints <- 0;
	//obj.m.IsAbleToUseMagic <- false;
	obj.m.PlannedPerks <- {};

	//---------------------------------------
	// extra stuff, not related to magic
	obj.getPlannedPerks <- function()
	{
		return this.m.PlannedPerks;
	}
	obj.isMounted <- function() 
	{
		return false;
	}
	obj.getBackground <- function() 
	{
		return null;
	}
	obj.getPerkPoints <- function() 
	{
		return 0;
	}
	obj.getPerkPointsSpent <- function() 
	{
		return 0;
	}
	obj.getDaysWithCompany <- function() 
	{
		return 0;
	}
	obj.getXP <- function()
	{
		return this.m.XP;
	}
	obj.getXPForNextLevel <- function() 
	{
		return 999999;
	}
	obj.getDailyCost <- function() 
	{
		return 0;
	}
	obj.getDaysWounded <- function() 
	{
		return 0;
	}
	obj.getMoodState <- function() 
	{
		return 3;
	}
	obj.getLevelUps <- function() 
	{
		return 0;
	}
	obj.isInReserves <- function() 
	{
		return false;
	}
	obj.isStabled <- function() 
	{
		return false;
	}
	obj.getRiderID <- function() 
	{
		return "";
	}
	obj.getTalents <- function() 
	{
		return array(::Const.Attributes.COUNT, 0);
	}
	obj.isLeveled <- function() 
	{
		return false;
	}
	obj.isGuest <- function() 
	{
		return true;
	}
	obj.getPlaceInFormation <- function() 
	{
		return 21;
	}
	obj.getPercentOnKillOtherActorModifier <- function() 
	{
		return 1.0;
	}
	obj.getFlatOnKillOtherActorModifier <- function() 
	{
		return 1.0;
	}

	// for the modded item_container
	obj.isAbleToEquip <- function(_item)
	{
		return true;
	}
	obj.isAbleToUnequip <- function(_item)
	{
		return true;
	}
	obj.onAfterEquip <- function( _item )
	{
	}
	obj.onAfterUnequip <- function( _item )
	{
	}
	obj.onBeforeCombatStarted <- function()
	{
	}

	obj.getRosterTooltip <- function() 
	{
		return  [{
			id = 1,
			type = "title",
			text = this.getName()
		}];
	}
	obj.isPlayerControlled = function()
	{
		local f = this.getFaction();
		return this.m.IsControlledByPlayer && (f == ::Const.Faction.Player || f == ::Const.Faction.PlayerAnimals);
	}
	local ws_retreat = obj.retreat;
	obj.retreat = function ()
	{
		local s = this.m.Skills.getSkillByID("effects.charmed_pet");

		if (s != null)
		{
			s.onAddPetToLoot();
		}

		ws_retreat();
	};
	local ws_onFactionChanged = obj.onFactionChanged;
	obj.onFactionChanged = function ()
	{
		ws_onFactionChanged();

		local isGhoul = this.getType() == ::Const.EntityType.Ghoul || this.getType() == ::Const.EntityType.LegendSkinGhoul;

		if (isGhoul || (this.getType() != ::Const.EntityType.Player && !this.getFlags().has("human") && !this.getFlags().has("undead")))
		{
			local flip = this.isAlliedWithPlayer();

			foreach (id in ::Const.Sprites_onFactionChanged)
			{
				if (!this.hasSprite(id))
				{
					continue;
				}

				this.getSprite(id).setHorizontalFlipping(flip);
			}
		}
	};
	/*
	local ws_onAttacked = obj.onAttacked
	obj.onAttacked = function( _attacker )
	{
		if (_attacker.getCurrentProperties().IsStealthy)
		{
			if (!this.m.CurrentProperties.IsImmuneToOverwhelm && _attacker.getTile().getDistanceTo(this.getTile()) <= 1 && this.m.OverwhelmCount.find(_attacker.getID()) == null)
			{
				this.m.OverwhelmCount.push(_attacker.getID());
			}

			if (this.isPlayerControlled())
			{
				_attacker.setDiscovered(true);
				_attacker.getTile().addVisibilityForFaction(::Const.Faction.Player);
			}
			else
			{
				_attacker.getTile().addVisibilityForFaction(this.getFaction());
				this.onActorSighted(_attacker);

				if (_attacker.isPlayerControlled())
				{
					this.setDiscovered(true);
					this.getTile().addVisibilityForFaction(::Const.Faction.Player);
				}
			}

			return;
		}

		ws_onAttacked(_attacker);
	}

	// extra stuff, not related to magic
	//----------------------------------------

	
	
	obj.isAbleToUseMagic <- function()
	{
		return this.m.IsAbleToUseMagic;
	}

	obj.getMagicPoints <- function()
	{
		return this.m.MagicPoints;
	}

	obj.getMagicPointsMax <- function()
	{
		return ::Math.floor(this.getBravery() / ::Const.Nggh_Magic.BraveryToMagicPointsRate);
	}

	obj.getStartingMagicPoints <- function()
	{
		return ::Math.floor(this.getMagicPointsMax() * this.getHitpointsPct());
	}

	obj.setMagicPoints <- function( _mp )
	{
		this.m.MagicPoints = ::Math.round(_mp);
		this.setPreviewMagicPoints(_mp);
	}

	obj.setPreviewMagicPoints <- function( _mp )
	{
		this.m.PreviewMagicPoints = ::Math.round(_mp);
	}

	obj.getPreviewMagicPoints <- function()
	{
		return this.m.PreviewMagicPoints;
	}

	obj.getMagicDefense <- function()
	{
		return this.getCurrentProperties().getMagicDefense();
	}

	obj.hasMagicSkill <- function()
	{
		foreach( skill in this.getSkills().m.Skills )
		{
			if (!skill.isGarbage() && skill.isMagicSkill())
			{
				return true;
			}
		}

		return false;
	}
	*/
});