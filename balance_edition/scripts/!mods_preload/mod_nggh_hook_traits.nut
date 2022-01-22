this.getroottable().Nggh_MagicConcept.hookTraits <- function ()
{
	// Make huge and small trait to affect spider size
	::mods_hookExactClass("skills/traits/huge_trait", function(obj) 
	{
	    obj.onAdded <- function()
	    {
	       if (this.isKindOf(this.getContainer().getActor().get(), "spider_player") && this.getContainer().getActor().getSize() < 0.9)
			{
				this.getContainer().getActor().setSize(0.9);
			}
	    }
	});


	//
	::mods_hookExactClass("skills/traits/tiny_trait", function(obj) 
	{
	  	obj.onAdded <- function()
	    {
	       if (this.isKindOf(this.getContainer().getActor().get(), "spider_player") && this.getContainer().getActor().getSize() > 0.65)
			{
				this.getContainer().getActor().setSize(0.65);
			}
	    }
	});


	//
	::mods_hookNewObject("skills/traits/seductive_trait", function ( obj )
	{
		obj.m.Bonus <- 5;
		obj.getBonus <- function()
		{
			return this.m.Bonus;
		};
		local tooltip = obj.getTooltip;
		obj.getTooltip = function()
		{
			local ret = tooltip();

			if (this.getContainer().hasSkill("spells.charm"))
			{
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/health.png",
					text = "Increases chance to charm a target by [color=" + this.Const.UI.Color.PositiveValue + "]+5%[/color]"
				});
			}

			return ret;
		};
	});


	//fix non-human has human body sprite
	::mods_hookNewObject("skills/traits/fat_trait", function ( obj )
	{
		local ws_onAdded = obj.onAdded;
		obj.onAdded <- function()
		{
			if (!this.getContainer().getActor().getFlags().has("human"))
			{
				return;
			}
			
			ws_onAdded();
		}
	});


	//Fixed issue with morale change when you has a character with unbreakable morale
	::mods_hookNewObject("skills/traits/gift_of_people_trait", function (obj)
	{
		obj.onCombatStarted = function()
		{
			this.skill.onCombatStarted();

			if (this.Math.rand(1, 10) < 10)
			{
				return;
			}

			local allies = this.Tactical.Entities.getInstancesOfFaction(this.getContainer().getActor().getFaction());
			local ownID = this.getContainer().getActor().getID();

			foreach( ally in allies )
			{
				if (ally.getID() == ownID)
				{
					continue;
				}

				local ally_morale = ally.getMoraleState();

				if (ally_morale == this.Const.MoraleState.Ignore)
				{
					continue;
				}

				if (ally_morale < this.Const.MoraleState.Confident)
				{
					ally.setMoraleState(ally_morale + 1);
				}
			}
		}
	});


	//Fixed issue with morale change when you has a character with unbreakable morale
	::mods_hookNewObject("skills/traits/double_tongued_trait", function (obj)
	{
		obj.onCombatStarted = function()
		{
			this.skill.onCombatStarted();

			if (this.Math.rand(1, 10) < 10)
			{
				return;
			}

			local allies = this.Tactical.Entities.getInstancesOfFaction(this.getContainer().getActor().getFaction());
			local ownID = this.getContainer().getActor().getID();

			foreach( ally in allies )
			{
				if (ally.getID() == ownID)
				{
					continue;
				}

				local ally_morale = ally.getMoraleState();

				if (ally_morale == this.Const.MoraleState.Ignore)
				{
					continue;
				}

				if (ally_morale > this.Const.MoraleState.Fleeing)
				{
					ally.setMoraleState(ally_morale - 1);
				}
			}
		}
	});

	delete this.Nggh_MagicConcept.hookTraits;
}