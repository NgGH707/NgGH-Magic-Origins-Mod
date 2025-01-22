::Nggh_MagicConcept.HooksMod.hook("scripts/contracts/contracts/legend_hunting_rock_unholds_contract", function ( q )
{
	q.onIsValid = @(__original) function()
	{
		foreach( bro in ::World.getPlayerRoster().getAll() )
		{
			if (bro.getLevel() >= 16 && bro.getSkills().hasSkill("perk.charm_enemy_unhold") && bro.getSkills().hasSkill("perk.mastery_charm"))
				return true;
		}

		return __original();
	}
	
});