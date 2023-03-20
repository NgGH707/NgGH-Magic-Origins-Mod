::mods_hookExactClass("contracts/contracts/legend_hunting_stollwurms_contract", function ( obj )
{
	local ws_onIsValid = obj.onIsValid; // Min strength 500
	obj.onIsValid = function()
	{
		foreach( bro in ::World.getPlayerRoster().getAll() )
		{
			if (bro.getLevel() >= 21 && bro.getSkills().hasSkill("perk.charm_enemy_lindwurm") && bro.getSkills().hasSkill("perk.mastery_charm"))
			{
				return true;
			}
		}

		return ws_onIsValid();
	}
});