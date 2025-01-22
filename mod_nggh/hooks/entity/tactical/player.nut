::Nggh_MagicConcept.HooksMod.hook("scripts/entity/tactical/player", function(q)
{
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

	q.getDailyFood = @(__original) function()
	{
		return ::Math.max(0, __original());
	}

	q.isReallyKilled = @(__original) function( _fatalityType )
	{
		local simp = getSkills().getSkillByID("effects.simp");

		if (simp != null && simp.isMutiny())
			return true;

		return __original(_fatalityType);
	}
	
});