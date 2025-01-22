::Nggh_MagicConcept.HooksMod.hook("scripts/contracts/contracts/legend_hunting_redback_webknechts_contract", function ( q )
{
	q.onIsValid = @(__original) function()
	{
		foreach( bro in ::World.getPlayerRoster().getAll() )
		{
			if (bro.getLevel() >= 10 && bro.getSkills().hasSkill("perk.charm_enemy_spider") && bro.getSkills().hasSkill("perk.mastery_charm"))
				return true;
		}

		return __original();
	}
	
});