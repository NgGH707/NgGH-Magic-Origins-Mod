this.getroottable().HexenHooks.hookContracts <- function ()
{
	::mods_hookExactClass("contracts/contracts/legend_hunting_skin_ghouls_contract", function ( obj )
	{
		local ws_onIsValid = obj.onIsValid;
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				if (bro.getSkills().hasSkill("perk.charm_enemy_ghoul") && bro.getSkills().hasSkill("perk.mastery_charm"))
				{
					return true;
				}
			}

			return ws_onIsValid();
		}
	});
	::mods_hookExactClass("contracts/contracts/legend_hunting_stollwurms_contract", function ( obj )
	{
		local ws_onIsValid = obj.onIsValid;
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				if (bro.getSkills().hasSkill("perk.charm_enemy_lindwurm") && bro.getSkills().hasSkill("perk.mastery_charm"))
				{
					return true;
				}
			}

			return ws_onIsValid();
		}
	});
	::mods_hookExactClass("contracts/contracts/legend_hunting_white_direwolf_contract", function ( obj )
	{
		local ws_onIsValid = obj.onIsValid;
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				if (bro.getSkills().hasSkill("perk.charm_enemy_direwolf") && bro.getSkills().hasSkill("perk.mastery_charm"))
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
							local bros = this.World.getPlayerRoster().getAll();
							local candidates = [];

							foreach( bro in bros )
							{
								if (bro.getBackground().getID() == "background.houndmaster" || bro.getBackground().getID() == "background.wildman" || bro.getBackground().getID() == "background.beast_slayer" || bro.getBackground().getID() == "background.legend_muladi" || bro.getBackground().getID() == "background.legend_ranger" || bro.getBackground().getID() == "background.legend_vala" || bro.getBackground().getID() == "background.legend_commander_vala" || bro.getBackground().getID() == "background.legend_commander_ranger" || bro.getSkills().hasSkill("perk.legend_favoured_enemy_direwolf") || bro.getSkills().hasSkill("perk.charm_enemy_unhold"))
								{
									candidates.push(bro);
								}
							}

							if (candidates.len() == 0)
							{
								this.World.Contracts.showCombatDialog(_isPlayerAttacking);
							}
							else
							{
								this.Contract.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];
								this.Contract.setScreen("DriveThemOff");
								this.World.Contracts.showActiveContract();
							}
						}
						else if (!this.Flags.get("IsEncounterShown"))
						{
							this.Flags.set("IsEncounterShown", true);
							this.Contract.setScreen("Encounter");
							this.World.Contracts.showActiveContract();
						}
						else
						{
							this.World.Contracts.showCombatDialog(_isPlayerAttacking);
						}
					}
				}
			}
		}
	});
	::mods_hookExactClass("contracts/contracts/legend_hunting_rock_unholds_contract", function ( obj )
	{
		local ws_onIsValid = obj.onIsValid;
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				if (bro.getSkills().hasSkill("perk.charm_enemy_unhold") && bro.getSkills().hasSkill("perk.mastery_charm"))
				{
					return true;
				}
			}

			return ws_onIsValid();
		}
	});
	::mods_hookExactClass("contracts/contracts/legend_hunting_redback_webknechts_contract", function ( obj )
	{
		local ws_onIsValid = obj.onIsValid;
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				if (bro.getSkills().hasSkill("perk.charm_enemy_spider") && bro.getSkills().hasSkill("perk.mastery_charm"))
				{
					return true;
				}
			}

			return ws_onIsValid();
		}
	});
	::mods_hookExactClass("contracts/contracts/legend_hunting_greenwood_schrats_contract", function ( obj )
	{
		local ws_onIsValid = obj.onIsValid;
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				if (bro.getSkills().hasSkill("perk.charm_enemy_schrat") && bro.getSkills().hasSkill("perk.mastery_charm"))
				{
					return true;
				}
			}

			return ws_onIsValid();
		}
	});
	::mods_hookExactClass("contracts/contracts/legend_hunting_demon_alps_contract", function ( obj )
	{
		local ws_onIsValid = obj.onIsValid;
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				if (bro.getSkills().hasSkill("perk.charm_enemy_alps") && bro.getSkills().hasSkill("perk.mastery_charm"))
				{
					return true;
				}
			}

			return ws_onIsValid();
		}
	});

	delete this.HexenHooks.hookContracts;
}