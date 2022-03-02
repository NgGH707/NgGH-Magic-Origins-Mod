this.getroottable().HexenHooks.hookContracts <- function ()
{
	::mods_hookExactClass("contracts/contracts/legend_hunting_skin_ghouls_contract", function ( obj )
	{
		local ws_onIsValid = obj.onIsValid;
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				if (bro.getLevel() >= 13 && bro.getSkills().hasSkill("perk.charm_enemy_ghoul") && bro.getSkills().hasSkill("perk.mastery_charm"))
				{
					return true;
				}
			}

			return ws_onIsValid();
		}
	});
	::mods_hookExactClass("contracts/contracts/legend_hunting_stollwurms_contract", function ( obj )
	{
		local ws_onIsValid = obj.onIsValid; // Min strength 500
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				if (bro.getLevel() >= 21 && bro.getSkills().hasSkill("perk.charm_enemy_lindwurm") && bro.getSkills().hasSkill("perk.mastery_charm"))
				{
					return true;
				}
			}

			return ws_onIsValid();
		}
	});
	::mods_hookExactClass("contracts/contracts/legend_hunting_white_direwolf_contract", function ( obj )
	{
		local ws_onIsValid = obj.onIsValid; // Min strength 200
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
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
		local ws_onIsValid = obj.onIsValid; // Min strength 300
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				if (bro.getLevel() >= 16 && bro.getSkills().hasSkill("perk.charm_enemy_unhold") && bro.getSkills().hasSkill("perk.mastery_charm"))
				{
					return true;
				}
			}

			return ws_onIsValid();
		}
	});
	::mods_hookExactClass("contracts/contracts/legend_hunting_redback_webknechts_contract", function ( obj )
	{
		local ws_onIsValid = obj.onIsValid; // Min strength 100
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				if (bro.getLevel() >= 10 && bro.getSkills().hasSkill("perk.charm_enemy_spider") && bro.getSkills().hasSkill("perk.mastery_charm"))
				{
					return true;
				}
			}

			return ws_onIsValid();
		}
	});
	::mods_hookExactClass("contracts/contracts/legend_hunting_greenwood_schrats_contract", function ( obj )
	{
		local ws_onIsValid = obj.onIsValid; // Min strength 500
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				if (bro.getLevel() >= 21 && bro.getSkills().hasSkill("perk.charm_enemy_schrat") && bro.getSkills().hasSkill("perk.mastery_charm"))
				{
					return true;
				}
			}

			return ws_onIsValid();
		}
	});
	::mods_hookExactClass("contracts/contracts/legend_hunting_demon_alps_contract", function ( obj )
	{
		local ws_onIsValid = obj.onIsValid; // Min strength 200 
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				if (bro.getLevel() >= 13 && bro.getSkills().hasSkill("perk.charm_enemy_alps") && bro.getSkills().hasSkill("perk.mastery_charm"))
				{
					return true;
				}
			}

			return ws_onIsValid();
		}
	});


	//
	::mods_hookExactClass("contracts/contracts/return_item_contract", function(obj) 
	{
		local ws_createStates = obj.createStates;
		obj.createStates = function()
		{
			ws_createStates();
			local find;

			foreach (i, state in this.m.States )
			{
				if (state.ID == "Offer")
				{
					state.end = function()
					{
						this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
						local r = this.Math.rand(1, 100);

						if (r <= 30 || this.World.Statistics.getFlags().get("IsDoingNecromancerAmbition"))
						{
							this.Flags.set("IsCounterOffer", true);
							this.Flags.set("Bribe", this.Contract.beautifyNumber(this.Contract.m.Payment.getOnCompletion() * this.Math.rand(100, 300) * 0.01));
						}
						else if (r <= 45)
						{
							if (this.Contract.getDifficultyMult() >= 0.95)
							{
								this.Flags.set("IsNecromancer", true);
							}
						}
						else
						{
							this.Flags.set("IsBandits", true);
						}

						this.Flags.set("StartDay", this.World.getTime().Days);
						local playerTile = this.World.State.getPlayer().getTile();
						local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 10, [
							this.Const.World.TerrainType.Mountains
						]);
						local party;
						party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).spawnEntity(tile, "Thieves", false, this.Const.World.Spawn.BanditRaiders, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						party.setDescription("A group of thieves and bandits.");
						party.setFootprintType(this.Const.World.FootprintsType.Brigands);
						party.setAttackableByAI(false);
						party.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
						party.setFootprintSizeOverride(0.75);
						this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.GenericFootprints, this.Const.World.FootprintsType.Brigands, 0.75);
						this.Contract.m.Target = this.WeakTableRef(party);
						party.getSprite("banner").setBrush("banner_bandits_0" + this.Math.rand(1, 6));
						local c = party.getController();
						local wait = this.new("scripts/ai/world/orders/wait_order");
						wait.setTime(9000.0);
						c.addOrder(wait);
						this.Contract.setScreen("Overview");
						this.World.Contracts.setActiveContract(this.Contract);
					};
					break;
				}
			}
		};

		local ws_createScreens = obj.createScreens;
		obj.createScreens = function()
		{
			ws_createScreens();

			foreach (i, screen in this.m.Screens )
			{
				if (screen.ID == "CounterOffer1")
				{
					screen.start <- function()
					{
						if (this.World.Statistics.getFlags().get("IsDoingNecromancerAmbition"))
						{
							this.Options.push({
								Text = "I'll only take half of that for a favor later.",
								function getResult()
								{
									this.updateAchievement("NeverTrustAMercenary", 1, 1);
									this.World.Statistics.getFlags().increment("GiftsToNecromacer");
									this.Flags.set("Bribe", this.Math.floor(this.Flags.getAsInt("Bribe") * 0.5));
									return "CounterOffer2";
								}
							});
						}
					};
					break;
				}
			}
		};
	});

	delete this.HexenHooks.hookContracts;
}