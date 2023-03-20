::mods_hookExactClass("contracts/contracts/legend_hunting_white_direwolf_contract", function ( obj )
{
	local ws_onIsValid = obj.onIsValid; // Min strength 200
	obj.onIsValid = function()
	{
		foreach( bro in ::World.getPlayerRoster().getAll() )
		{
			if (bro.getLevel() >= 13 && bro.getSkills().hasSkill("perk.charm_enemy_direwolf") && bro.getSkills().hasSkill("perk.mastery_charm"))
			{
				return true;
			}
		}

		return ws_onIsValid();
	}

	local ws_createStates = obj.createStates;
	obj.createStates = function()
	{
		ws_createStates();

		foreach (i, state in this.m.States) 
		{
			if (state.ID == "Running")
			{
				state.onTargetAttacked = function( _dest, _isPlayerAttacking )
				{
					if (this.Flags.get("IsDriveOff") && !this.Flags.get("IsEncounterShown"))
					{
						this.Flags.set("IsEncounterShown", true);
						local candidates = [];

						foreach( bro in ::World.getPlayerRoster().getAll() )
						{
							if (bro.getBackground().getID() == "background.houndmaster" || bro.getBackground().getID() == "background.wildman" || bro.getBackground().getID() == "background.beast_slayer" || bro.getBackground().getID() == "background.legend_muladi" || bro.getBackground().getID() == "background.legend_ranger" || bro.getBackground().getID() == "background.legend_vala" || bro.getBackground().getID() == "background.legend_commander_vala" || bro.getBackground().getID() == "background.legend_commander_ranger" || bro.getSkills().hasSkill("perk.legend_favoured_enemy_direwolf") || bro.getSkills().hasSkill("perk.charm_enemy_unhold"))
							{
								candidates.push(bro);
							}
						}

						if (candidates.len() == 0)
						{
							::World.Contracts.showCombatDialog(_isPlayerAttacking);
						}
						else
						{
							this.Contract.m.Dude = ::MSU.Array.rand(candidates);
							this.Contract.setScreen("DriveThemOff");
							::World.Contracts.showActiveContract();
						}
					}
					else if (!this.Flags.get("IsEncounterShown"))
					{
						this.Flags.set("IsEncounterShown", true);
						this.Contract.setScreen("Encounter");
						::World.Contracts.showActiveContract();
					}
					else
					{
						::World.Contracts.showCombatDialog(_isPlayerAttacking);
					}
				}
			}
		}
	}
});