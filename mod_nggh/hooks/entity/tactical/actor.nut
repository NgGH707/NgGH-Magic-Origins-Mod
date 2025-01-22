::Nggh_MagicConcept.HooksMod.hook("scripts/entity/tactical/actor", function(q)
{
	//obj.m.MagicPoints <- 0;
	//obj.m.PreviewMagicPoints <- 0;
	//obj.m.IsAbleToUseMagic <- false;
	q.m.PlannedPerks <- {};

	//---------------------------------------
	// extra stuff, not related to magic
	q.getPlannedPerks <- function()
	{
		return m.PlannedPerks;
	}

	q.isMounted <- function() 
	{
		return false;
	}

	q.getBackground <- function() 
	{
		return null;
	}

	q.getPerkPoints <- function() 
	{
		return 0;
	}

	q.getPerkPointsSpent <- function() 
	{
		return 0;
	}

	q.getDaysWithCompany <- function() 
	{
		return 0;
	}

	q.getXP <- function()
	{
		return m.XP;
	}

	q.getXPForNextLevel <- function() 
	{
		return 999999;
	}

	q.getDailyCost <- function() 
	{
		return 0;
	}

	q.getDaysWounded <- function() 
	{
		return 0;
	}

	q.getMoodState <- function() 
	{
		return 3;
	}

	q.getLevelUps <- function() 
	{
		return 0;
	}

	q.isInReserves <- function() 
	{
		return false;
	}

	q.getTalents <- function() 
	{
		return array(::Const.Attributes.COUNT, 0);
	}

	q.isLeveled <- function() 
	{
		return false;
	}

	q.isGuest <- function() 
	{
		return true;
	}

	q.getPlaceInFormation <- function() 
	{
		return 21;
	}

	// for the modded item_container
	q.isAbleToEquip <- function( _item )
	{
		return true;
	}

	q.isAbleToUnequip <- function( _item )
	{
		return true;
	}

	q.onAfterEquip <- function( _item )
	{
	}

	q.onAfterUnequip <- function( _item )
	{
	}

	q.onBeforeCombatStarted <- function()
	{
	}

	q.getRosterTooltip <- function() 
	{
		return  [{
			id = 1,
			type = "title",
			text = getName()
		}];
	}

	q.isPlayerControlled = @() function()
	{
		local f = getFaction();
		return m.IsControlledByPlayer && (f == ::Const.Faction.Player || f == ::Const.Faction.PlayerAnimals);
	}

	q.retreat = @(__original) function()
	{
		local s = getSkills().getSkillByID("effects.charmed_pet");

		if (s != null)
			s.onAddPetToLoot();

		__original();
	}

	q.onFactionChanged = @(__original) function()
	{
		__original();

		local isGhoul = getType() == ::Const.EntityType.Ghoul || getType() == ::Const.EntityType.LegendSkinGhoul;

		if (isGhoul || (getType() != ::Const.EntityType.Player && !getFlags().has("human") && !getFlags().has("undead")))
		{
			local flip = isAlliedWithPlayer();

			foreach (id in ::Const.Sprites_onFactionChanged)
			{
				if (!hasSprite(id))
					continue;

				getSprite(id).setHorizontalFlipping(flip);
			}
		}
	}

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