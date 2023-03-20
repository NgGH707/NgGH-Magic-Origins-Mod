::mods_hookExactClass("contracts/contracts/legend_hunting_demon_alps_contract", function ( obj )
{
	local ws_onIsValid = obj.onIsValid; // Min strength 200 
	obj.onIsValid = function()
	{
		foreach( bro in ::World.getPlayerRoster().getAll() )
		{
			if (bro.getLevel() >= 13 && bro.getSkills().hasSkill("perk.charm_enemy_alp") && bro.getSkills().hasSkill("perk.mastery_charm"))
			{
				return true;
			}
		}

		return ws_onIsValid();
	}
});