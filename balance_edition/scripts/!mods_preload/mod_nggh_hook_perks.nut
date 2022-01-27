this.getroottable().Nggh_MagicConcept.hookPerks <- function ()
{
	//
	::mods_hookExactClass("skills/perks/perk_nine_lives", function(obj) 
	{
		obj.m.NineLivesCount <- 1;

		obj.addNineLivesCount <- function( _n = 1 )
		{
			this.m.IsSpent = false;
			this.m.LastFrameUsed = 0;
			this.m.NineLivesCount = this.Math.min(9, this.m.NineLivesCount + _n);
		};
		obj.onAdded <- function()
		{
			this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		};
		obj.getName <- function()
		{
			local ret = this.skill.getName();

			if (this.m.NineLivesCount > 1)
			{
				return ret + " (" + (this.m.NineLivesCount) + ")"
			}

			return ret;
		};
		local ws_setSpent = obj.setSpent;
		obj.setSpent = function(_f)
		{
			ws_setSpent(_f);

			if (this.m.IsSpent)
			{
				--this.m.NineLivesCount;

				if (this.m.NineLivesCount <= 0)
				{
					local rune = this.getContainer().getSkillByID("special.legend_RSA_diehard");
					if (rune != null) rune.activate();
				}
				else
				{
					this.m.IsSpent = false;
					this.m.LastFrameUsed = 0;
					this.getContainer().removeByType(this.Const.SkillType.DamageOverTime);
				}
			}
		}
		obj.isHidden <- function()
		{
			return this.isSpent() || this.m.NineLivesCount <= 1;
		};
		obj.getTooltip <- function()
		{
			return [
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
					id = 6,
					type = "text",
					icon = "ui/icons/health.png",
					text = "Extra life left: [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.NineLivesCount + "[/color]"
				}
			];
		};
		local ws_onCombatStarted = obj.onCombatStarted;
		obj.onCombatStarted <- function()
		{
			ws_onCombatStarted();
			this.m.NineLivesCount = 1;
		};
		local ws_onCombatFinished = obj.onCombatFinished;
		obj.onCombatFinished <- function()
		{
			ws_onCombatFinished();
			this.m.NineLivesCount = 1;
		};
	});


	//Change to work with mounting system of goblin
	::mods_hookExactClass("skills/perks/perk_horse_liberty", function(obj) 
	{
	    obj.onUpdate <- function( _properties )
	    {
	        if (this.getContainer().getActor().isMounted())
	        {
	        	_properties.MovementFatigueCostMult *= 0.75;
	        	_properties.BraveryMult *= 1.25;
	        }
	    }
	});

	delete this.Nggh_MagicConcept.hookPerks;
}