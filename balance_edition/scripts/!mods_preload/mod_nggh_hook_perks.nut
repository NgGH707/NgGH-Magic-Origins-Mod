this.getroottable().Nggh_MagicConcept.hookPerks <- function ()
{
	//
	::mods_hookExactClass("skills/perks/perk_nine_lives", function(obj) 
	{
		obj.m.ShowTotalLives <- false;
		obj.onAdded <- function()
		{
			local actor = this.getContainer().getActor();

			if ("NineLivesCount" in actor.m)
			{
				this.setUpAsStatusEffect();
			}
		};
		local ws_setSpent = obj.setSpent;
		obj.setSpent = function(_f)
		{
			ws_setSpent(_f);

			if (_f)
			{
				local rune = this.getContainer().getSkillByID("special.legend_RSA_diehard");
				if (rune != null) rune.activate();
			}
		}
		obj.setUpAsStatusEffect <- function()
		{
			this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
			this.m.ShowTotalLives = true;
		}
		obj.isHidden <- function()
		{
			return this.isSpent();
		};
		obj.getTooltip <- function()
		{
			if (!this.m.ShowTotalLives)
			{
				return [];
			}

			local actor = this.getContainer().getActor();

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
					text = "Lives left: [color=" + this.Const.UI.Color.PositiveValue + "]" + (actor.m.NineLivesCount + 1) + "[/color]"
				}
			];
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