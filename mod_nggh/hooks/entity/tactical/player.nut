::mods_hookExactClass("entity/tactical/player", function(obj)
{
	obj.getPlannedPerks <- function()
	{
		return this.m.PlannedPerks;
	}
	
	/*
	local ws_onCombatStart = obj.onCombatStart;
	obj.onCombatStart <- function()
	{
		ws_onCombatStart();
		this.m.IsAbleToUseMagic = this.hasMagicSkill();

		if (this.m.IsAbleToUseMagic)
		{
			this.setMagicPoints(this.getStartingMagicPoints());
			this.getSkills().add(::new("")); // IMPORTANT!!! add the focus mp skill
		}
	}
	*/

	local getDailyFood = obj.getDailyFood;
	obj.getDailyFood = function()
	{
		return ::Math.max(0, getDailyFood());
	}

	local isReallyKilled = obj.isReallyKilled;
	obj.isReallyKilled = function( _fatalityType )
	{
		local simp = this.getSkills().getSkillByID("effects.simp");

		if (simp != null && simp.isMutiny())
			return true;

		return isReallyKilled(_fatalityType);
	}
});