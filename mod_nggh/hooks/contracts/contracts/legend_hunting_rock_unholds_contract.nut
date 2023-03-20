::mods_hookExactClass("contracts/contracts/legend_hunting_rock_unholds_contract", function ( obj )
{
	local ws_onIsValid = obj.onIsValid; // Min strength 300
	obj.onIsValid = function()
	{
		foreach( bro in ::World.getPlayerRoster().getAll() )
		{
			if (bro.getLevel() >= 16 && bro.getSkills().hasSkill("perk.charm_enemy_unhold") && bro.getSkills().hasSkill("perk.mastery_charm"))
			{
				return true;
			}
		}

		return ws_onIsValid();
	}
});