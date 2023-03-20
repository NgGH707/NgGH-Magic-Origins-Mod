::mods_hookExactClass("contracts/contracts/legend_hunting_skin_ghouls_contract", function ( obj )
{
	local ws_onIsValid = obj.onIsValid;
	obj.onIsValid = function()
	{
		foreach( bro in ::World.getPlayerRoster().getAll() )
		{
			if (bro.getLevel() >= 13 && bro.getSkills().hasSkill("perk.charm_enemy_ghoul") && bro.getSkills().hasSkill("perk.mastery_charm"))
			{
				return true;
			}
		}

		return ws_onIsValid();
	}
});