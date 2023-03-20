::mods_hookExactClass("contracts/contracts/legend_hunting_redback_webknechts_contract", function ( obj )
{
	local ws_onIsValid = obj.onIsValid; // Min strength 100
	obj.onIsValid = function()
	{
		foreach( bro in ::World.getPlayerRoster().getAll() )
		{
			if (bro.getLevel() >= 10 && bro.getSkills().hasSkill("perk.charm_enemy_spider") && bro.getSkills().hasSkill("perk.mastery_charm"))
			{
				return true;
			}
		}

		return ws_onIsValid();
	}
});