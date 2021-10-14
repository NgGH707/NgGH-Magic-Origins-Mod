this.hexen_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {
		IsLuftAdventure = false,
	},
	function create()
	{
		this.m.ID = "scenario.hexen";
		this.m.Name = "Hexe";
		this.m.Description = "[p=c][img]gfx/ui/events/event_106.png[/img][/p][p]A Hexe founds a mercenary company to secretly collect offerings for a ritual.\n\n[color=#bcad8c]Witch:[/color] Start with a hexe and some simps.\n[color=#bcad8c]Gotta catch 'em all:[/color] Charm the enemy and add them to your roster.\n[color=#bcad8c]Simps:[/color] Those fell for your charm don\'t need money, they only need love.\n[color=#bcad8c]The Price For Beauty:[/color] Have to perform a weekly ritual or face the consequences.\n[color=#bcad8c]Avatar:[/color] If your Hexe dies, the campaign ends.[/p]";
		this.m.Difficulty = 1;
		this.m.Order = 109;
		this.m.IsFixedLook = true;
		this.m.StartingBusinessReputation = 25;
		this.m.StartingRosterTier = this.Const.Roster.getTierForSize(12);
		this.setRosterReputationTiers(this.Const.Roster.createReputationTiers(this.m.StartingBusinessReputation));
	}

	function onSpawnAssets()
	{
		this.World.Flags.set("looks", this.Math.rand(9995, 9997));
		this.World.Flags.set("RitualTimer", 1);
		
		local roster = this.World.getPlayerRoster();
		local hexe;
		hexe = roster.create("scripts/entity/tactical/player_hexen");
		hexe.setStartValuesEx([
			"hexen_background"
		]);
		hexe.getBackground().buildDescription(true);
		hexe.getSkills().removeByID("trait.survivor");
		hexe.getSkills().removeByID("trait.loyal");
		hexe.getSkills().removeByID("trait.disloyal");
		hexe.getSkills().removeByID("trait.greedy");
		
		/******/
		//For testing with charmed enemy, only for Dev and modder
		//hexe.getSkills().add(this.new("scripts/skills/eggs_actives/summon_enemy"));
		//hexe.getSkills().add(this.new("scripts/skills/actives/patting_skill"));
		/******/
	
		hexe.getSkills().add(this.new("scripts/skills/traits/player_character_trait"));
		hexe.setPlaceInFormation(13);
		hexe.getFlags().set("IsPlayerCharacter", true);
		hexe.getFlags().set("Hexe_Origin", this.HexeVersion);
		hexe.getSprite("miniboss").setBrush("bust_miniboss_lone_wolf");
		hexe.m.HireTime = this.Time.getVirtualTimeF();
		hexe.m.PerkPoints = 1;
		hexe.m.LevelUps = 0;
		hexe.m.Level = 1;
		hexe.m.Talents = [];
		hexe.m.Attributes = [];
		hexe.fillTalentValues(3);
		hexe.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		
		local name = this.World.Assets.getName().toupper();
		local seed = this.World.Assets.getSeedString().toupper();
		local isSpecialSeed = this.Const.HexenEasterEggSeed.find(seed);
		local isLuftName = this.IsLuftName(name);
		
		if (isSpecialSeed != null || isLuftName)
		{
			this.getBrothersWithSpecialSeeds(isSpecialSeed, isLuftName);
		}
		else
		{
			local forcedSeed = this.isForceSeed(seed, name);
			//0:eggs - 1:spider - 2:redback - 3:wolf - 4:white wolf - 5:hyena - 6:serpent - 7:unhold - 8:ghoul - 9:alp - 10:goblin - 11:orc - 12:human - 13:ijirok - 14:lindwurm - 15:schrat - 16:bear - 17:circus

			if (forcedSeed == null)
			{
				this.randomRollStarter();
			}
			else
			{
				switch (forcedSeed)
				{
				case 0:
					for( local i = 0; i < 3; i = ++i )
					{
						local beast = roster.create("scripts/entity/tactical/player_beast/spider_eggs_player");
						beast.m.HireTime = this.Time.getVirtualTimeF();
						beast.improveMood(1.0, "...");
						beast.setScenarioValues();
						beast.addLightInjury();
						beast.setPlaceInFormation(i + 21);
					}
					
					hexe.setTitle(this.Math.rand(1, 2) == 1 ? "the Eggscellent" : "the Eggmaniac");
					break;

				case 1:
					for( local i = 0; i < 2; i = ++i )
					{
						local beast = roster.create("scripts/entity/tactical/player_beast/spider_player");
						beast.improveMood(1.0, "Still alive to serve the queen");
						beast.setScenarioValues();
						beast.setPlaceInFormation(i + 3);
						beast.addHeavyInjury();
						beast.onHired();
					}
					
					local beast = roster.create("scripts/entity/tactical/player_beast/spider_eggs_player");
					beast.m.HireTime = this.Time.getVirtualTimeF();
					beast.improveMood(1.0, "...");
					beast.setScenarioValues();
					beast.addLightInjury();
					beast.setPlaceInFormation(12);
					
					hexe.setTitle("the Spider Queen");
					break;

				case 2:
					local beast = roster.create("scripts/entity/tactical/player_beast/spider_player");
					beast.improveMood(1.0, "...");
					beast.setScenarioValues(false, true);
					beast.addLightInjury();
					beast.setPlaceInFormation(12);
					beast.onHired();
					
					hexe.setTitle("the Black Widow");
					break;
					
				case 3:
					for( local i = 0; i < 2; i = ++i )
					{
						local beast = roster.create("scripts/entity/tactical/player_beast/direwolf_player");
						beast.improveMood(1.0, "Loyal doggie");
						beast.setScenarioValues();
						beast.setPlaceInFormation(i + 3);
						beast.addHeavyInjury();
						beast.onHired();
					}
					
					hexe.setTitle("the Mother Wolf");
					break;

				case 4:
					local beast = roster.create("scripts/entity/tactical/player_beast/direwolf_player");
					beast.improveMood(1.0, "");
					beast.setScenarioValues(false, false, true);
					beast.setPlaceInFormation(12);
					beast.addHeavyInjury();
					beast.onHired();
					beast.setName("Yama-inu");
					hexe.setName("Mononoke Hime");
					hexe.setTitle("");
					break;
					
				case 5:
					for( local i = 0; i < 2; i = ++i )
					{
						local beast = roster.create("scripts/entity/tactical/player_beast/hyena_player");
						beast.improveMood(1.0, "Loyal doggie");
						beast.setScenarioValues();
						beast.setPlaceInFormation(i + 3);
						beast.addHeavyInjury();
						beast.onHired();
					}
					
					hexe.setTitle("the Desert Flower");
					break;
					
				case 6:
					for( local i = 0; i < 3; i = ++i )
					{
						local beast = roster.create("scripts/entity/tactical/player_beast/serpent_player");
						beast.improveMood(1.0, "Loyal snake pet");
						beast.setScenarioValues(i == 1);
						beast.setPlaceInFormation(i + 3);
						beast.addHeavyInjury();
						beast.onHired();
					}
					
					hexe.setTitle("the Gorgeous Viper");
					break;
					
				case 7:
					local beast = roster.create("scripts/entity/tactical/player_beast/unhold_player");
					beast.improveMood(1.0, "Still alive to serve the queen");
					beast.setScenarioValues();
					beast.setPlaceInFormation(4);
					beast.setHitpointsPct(this.Math.rand(40, 65) * 0.01);
					beast.onHired();
					hexe.setTitle("the Empress");
					break;
					
				case 8:
					for( local i = 0; i < 2; i = ++i )
					{
						local beast = roster.create("scripts/entity/tactical/player_beast/ghoul_player");
						beast.improveMood(1.0, "Loyal pet monkey");
						beast.setScenarioValues(false);
						beast.setPlaceInFormation(i + 3);
						beast.addHeavyInjury();
						beast.onHired();
					}
					
					hexe.setTitle("the Empress");
					break;
					
				case 9:
					for( local i = 0; i < 3; i = ++i )
					{
						local beast = roster.create("scripts/entity/tactical/player_beast/alp_player");
						beast.improveMood(1.0, "Enthralled");
						beast.setScenarioValues(false, false, i == 2, i < 2);
						beast.setPlaceInFormation(i == 2 ? 12 : i + 3);
						beast.addHeavyInjury();
						beast.onHired();
					}
					
					hexe.setTitle("the Dreamy Goddess");
					break;
					
				case 10:
					for( local i = 0; i < 3; i = ++i )
					{
						local isElite = this.Math.rand(1, 100) == 1;
						local isOverseer = i == 2 ? this.Math.rand(1, 20) == 1 : false;
						local isShaman = i == 2 ? this.Math.rand(1, 20) == 1 : false;
						local isRanged = i == 3;
						local goblin = roster.create("scripts/entity/tactical/player_goblin");
						goblin.improveMood(1.0, "Still alive to serve the queen");
						goblin.setScenarioValues(isElite, isRanged, isOverseer, isShaman);
						goblin.setPlaceInFormation(i + 3);
						goblin.addLightInjury();
						goblin.onHired();
					}
					
					hexe.setTitle("the Rose");
					break;
					
				case 11:
					for( local i = 0; i < 2; i = ++i )
					{
						local orc = roster.create("scripts/entity/tactical/player_orc/player_orc_young");
						orc.improveMood(1.0, "We are warriors of the mistress");
						orc.setScenarioValues(false, this.Math.rand(1, 100) == 1, false, false);
						orc.setPlaceInFormation(i + 3);
						orc.addHeavyInjury();
						orc.onHired();
					}
					
					hexe.setTitle("the Warrior Queen");
					break;
					
				case 12:
					for( local i = 0; i < 2; i = ++i )
					{
						local bro = roster.create("scripts/entity/tactical/player");
						bro.setStartValuesEx(this.Const.CharacterBackgrounds);
						bro.improveMood(1.0, "Still alive to serve the mistress");
						bro.setPlaceInFormation(i + 3);
						bro.addHeavyInjury();
						bro.onHired();
					}
					
					hexe.setTitle("the Beauty");
					break;
					
				case 13:
					local god = roster.create("scripts/entity/tactical/player_beast/trickster_god_player");
					god.improveMood(1.0, "Bodyguarding for my fairy godmother");
					god.setScenarioValues();
					god.setPlaceInFormation(4);
					god.onHired();
					god.setHitpointsPct(this.Math.rand(40, 65) * 0.01);
					hexe.setTitle("the Fairy");
					break;

				case 14:
					local beast = roster.create("scripts/entity/tactical/player_beast/lindwurm_player");
					beast.improveMood(1.0, "Pet lindwurm");
					beast.setScenarioValues();
					beast.setPlaceInFormation(4);
					beast.onHired();
					beast.setHitpointsPct(this.Math.rand(40, 65) * 0.01);
					hexe.setTitle("the Dragon Queen");
					break;

				case 15:
					local beast = roster.create("scripts/entity/tactical/player_beast/schrat_player");
					beast.improveMood(1.0, "...");
					beast.setScenarioValues();
					beast.setPlaceInFormation(4);
					beast.onHired();
					beast.setHitpointsPct(this.Math.rand(40, 65) * 0.01);
					hexe.setTitle("the Wicked");
					break;

				case 16:
					local beast = roster.create("scripts/entity/tactical/player_beast/unhold_player");
					beast.improveMood(1.0, "I\'m a bear");
					beast.setScenarioValues(false, true);
					beast.setPlaceInFormation(4);
					beast.setHitpointsPct(this.Math.rand(40, 65) * 0.01);
					beast.onHired();
					hexe.setTitle("the Enchantress");
					break;

				case 17:
					local a = [];
					hexe.getItems().unequip(hexe.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
					hexe.getItems().equip(this.new("scripts/items/weapons/battle_whip"));
					hexe.setPlaceInFormation(22);
					hexe.setTitle("the Ringmistress");
					
					local beast = roster.create("scripts/entity/tactical/player_beast/unhold_player");
					beast.improveMood(1.0, "I\'m Mor'du");
					beast.setScenarioValues(false, true);
					beast.setPlaceInFormation(4);
					beast.setHitpointsPct(this.Math.rand(40, 65) * 0.01);
					beast.onHired();
					beast.setName("Mor'du");
					a.push(beast);

					beast = roster.create("scripts/entity/tactical/player_beast/hyena_player");
					beast.improveMood(1.0, "Loyal doggie");
					beast.setScenarioValues();
					beast.setPlaceInFormation(3);
					beast.addHeavyInjury();
					beast.onHired();
					a.push(beast);

					beast = roster.create("scripts/entity/tactical/player_beast/serpent_player");
					beast.improveMood(1.0, "Talented snake");
					beast.setScenarioValues();
					beast.setPlaceInFormation(5);
					beast.addHeavyInjury();
					beast.onHired();
					a.push(beast);

					local bro = roster.create("scripts/entity/tactical/player");
					bro.setStartValuesEx(["juggler_background"]);
					bro.improveMood(1.0, "Simping to the ringmistress");
					bro.setPlaceInFormation(12);
					bro.addHeavyInjury();
					bro.onHired();
					a.push(bro);

					foreach ( _b in a )
					{
						local items = _b.getItems();
						items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Head));
						items.equip(this.Const.World.Common.pickHelmet([
							[
								1,
								"jesters_hat"
							],
						]));
					}
					break;

				case 18:
					for( local i = 0; i < 2; i = ++i )
					{
						local orc = roster.create("scripts/entity/tactical/player_orc/player_orc_young");
						orc.improveMood(1.0, "We are warriors of the mistress");
						orc.setScenarioValues(false, this.Math.rand(1, 100) == 1, false, false);
						orc.setPlaceInFormation(i + 2);
						orc.addHeavyInjury();
						orc.onHired();
					}

					for( local i = 0; i < 2; i = ++i )
					{
						local isElite = this.Math.rand(1, 100) == 1;
						local goblin = roster.create("scripts/entity/tactical/player_goblin");
						goblin.improveMood(1.0, "Still alive to serve the queen");
						goblin.setScenarioValues(isElite);
						goblin.setPlaceInFormation(i + 4);
						goblin.addLightInjury();
						goblin.onHired();
					}

					local goblin = roster.create("scripts/entity/tactical/player_goblin");
					goblin.improveMood(1.0, "Still alive to serve the queen");
					goblin.setScenarioValues(this.Math.rand(1, 100) == 1, true);
					goblin.setPlaceInFormation(12);
					goblin.addLightInjury();
					goblin.onHired();

					hexe.setTitle("Queen of Greenskin");
					break;

				case 19:
					local donation = 0;
					local free_perks = [
						"scripts/skills/perks/perk_mastery_charm",
						"scripts/skills/perks/perk_apppearance_charm", 
						"scripts/skills/perks/perk_charm_nudist",
					];
					local free_charm_perk = free_perks[this.Math.rand(0, free_perks.len() - 1)];
					hexe.setPlaceInFormation(22);
					for( local i = 0; i < 5; i = ++i )
					{
						local bro = roster.create("scripts/entity/tactical/player");
						bro.setStartValuesEx(["beggar_southern_background", "beggar_background"]);
						bro.getSkills().add(this.new("scripts/skills/traits/loyal_trait"));
						bro.setPlaceInFormation(i + 2);
						bro.addHeavyInjury();
						bro.onHired();
						local money = this.Math.rand(1, 8) * 10;
						bro.improveMood(0.5, "Amouranth\'s loyal simp");
						bro.improveMood(0.2, "Donated " + money + " crowns to Amouranth");
						bro.improveMood(0.3, (money >= 70 ? "I'm broke, but feel good for supporting Amouranth" : "Feel good for supporting Amouranth"));
						donation += money;
					}

					for( local j = 0; j < 5; j = ++j )
					{
						local isElite = this.Math.rand(1, 100) == 1;
						local goblin = roster.create("scripts/entity/tactical/player_goblin");
						goblin.getSkills().add(this.new("scripts/skills/traits/loyal_trait"));
						goblin.setScenarioValues(isElite);
						goblin.setPlaceInFormation(j + 6);
						goblin.addLightInjury();
						goblin.onHired();
						local money = this.Math.rand(1, 8) * 10;
						goblin.improveMood(0.5, "Amouranth\'s loyal simp");
						goblin.improveMood(0.2, "Donated " + money + " crowns to Amouranth");
						goblin.improveMood(0.3, (money >= 70 ? "I'm broke, but feel good for supporting Amouranth" : "Feel good for supporting Amouranth"));
						donation += money;
					}

					hexe.getItems().addToBag(this.new("scripts/items/weapons/barbarians/thorned_whip"));
					hexe.getSkills().add(this.new(free_charm_perk));
					hexe.getSkills().add(this.new("scripts/skills/traits/seductive_trait"));
					hexe.improveMood(0.5, "Finished a stream on Twitch");
					hexe.improveMood(0.5, "Received " + donation + " crowns of donation from simps");
					hexe.setName("@Amouranth");
					hexe.setTitle("ASMR streamer");
					this.World.Assets.addMoney(donation);
					this.World.Assets.m.Name = this.removeFromBeginningOfText("The ", this.removeFromBeginningOfText("the ", "@Amouranth Simps Corp"));
					break;

				default:
					for( local i = 0; i < 3; i = ++i )
					{
						local beast = roster.create("scripts/entity/tactical/player_beast/spider_player");
						beast.improveMood(1.0, "Still alive to serve the queen");
						beast.setScenarioValues();
						beast.setPlaceInFormation(i + 3);
						beast.addHeavyInjury();
						beast.onHired();
					}
					hexe.setTitle("the Spider Queen");
				}

				if (forcedSeed == null)
				{
					forcedSeed = 0;
				}

				this.logInfo("With your seed/name, your roll would be: r = " + forcedSeed);
				this.logInfo("Your starting would be: " + this.Const.HexenStartingRollName[forcedSeed]);
			} 
		}
		
		foreach ( b in roster.getAll() )
		{
			b.setVeteranPerks(2);
		}
		
		local potions = [
			"cat_potion_item",
			"cat_potion_item",
			"iron_will_potion_item",
			"iron_will_potion_item",
			"recovery_potion_item",
			"recovery_potion_item",
			"lionheart_potion_item",
			"lionheart_potion_item",
			"night_vision_elixir_item",
			"night_vision_elixir_item",
			"legend_heartwood_sap_flask_item",
			"legend_hexen_ichor_potion_item",
			"legend_skin_ghoul_blood_flask_item",
			"legend_stollwurm_blood_flask_item",
		];
		
		this.World.Assets.addBusinessReputation(this.m.StartingBusinessReputation);
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/dates_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/black_marsh_stew_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/black_marsh_stew_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/misc/witch_hair_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/misc/poisoned_apple_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/misc/werewolf_pelt_item"));
		
		if (this.Math.rand(1, 100) > 5)
		{
			this.World.Assets.getStash().add(this.new("scripts/items/accessory/" + potions[this.Math.rand(0, potions.len() - 1)]));
		}
		else
		{
			this.World.Assets.getStash().add(this.new("scripts/items/special/bodily_reward_item"));
		}
		
		if (this.Math.rand(1, 100) > 5)
		{
			this.World.Assets.getStash().add(this.new("scripts/items/accessory/" + potions[this.Math.rand(0, potions.len() - 1)]));
		}
		else
		{
			this.World.Assets.getStash().add(this.new("scripts/items/special/spiritual_reward_item"));
		}
		
		if (this.Math.rand(1, 100) == 1)
		{
			this.World.Assets.getStash().add(this.new("scripts/items/special/fountain_of_youth_item"));
		}
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() == 1)
			{
				break;
			}
		}

		local randomVillageTile = randomVillage.getTile();
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 4), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 4));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 4), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 4));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore || tile.IsOccupied)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) <= 1)
				{
				}
				else if (tile.Type != this.Const.World.TerrainType.Plains && tile.Type != this.Const.World.TerrainType.Steppe && tile.Type != this.Const.World.TerrainType.Tundra && tile.Type != this.Const.World.TerrainType.Snow)
				{
				}
				else
				{
					local path = this.World.getNavigator().findPath(tile, randomVillageTile, navSettings, 0);

					if (!path.isEmpty())
					{
						randomVillageTile = tile;
						break;
					}
				}
			}
		}
		while (1);
		
		local eventID = this.m.IsLuftAdventure ? "event.luft_scenario_intro" : "event.hexen_intro_event";
		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(this.World.Flags.getAsInt("looks"));
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList(this.Const.Music.BeastsTracks, this.Const.Music.CrossFadeTime);
			this.World.Events.fire(eventID);
		}, null);
		this.m.IsLuftAdventure = false;
	}
	
	function onInit()
	{
		this.starting_scenario.onInit();
		this.World.Assets.m.FootprintVision *= 1.5;
		local looks = this.World.Flags.getAsInt("looks") == 0 ? 9997 : this.World.Flags.getAsInt("looks");
		this.World.Assets.updateLook(this.World.Flags.has("isExposed") ? 9994 : looks);
	}
	
	function onHiredByScenario( bro )
	{
		local excluded = [
			"background.eunuch",
			"background.hexen",
			"background.hexen_commander",
		];

		if (excluded.find(bro.getBackground().getID()) == null)
		{
			bro.getSkills().add(this.new("scripts/skills/effects/fake_charmed_effect"));
		}
		else if (bro.getBackground().getID() == "background.eunuch")
		{
			bro.worsenMood(5.0, "Horrified by knowing the true nature of this company");
		}
	}
	
	function onUpdateHiringRoster( _roster )
	{
		local bros = _roster.getAll();
		local garbage = [];

		foreach( i, bro in bros )
		{
			if (this.Const.WitchHaters.find(bro.getBackground().m.ID) != null)
			{
				garbage.push(bro);
			}
			
			if (bro.getSkills().hasSkill("trait.bright"))
			{
				bro.getSkills().removeByID("trait.bright");
			}
			
			if (!bro.getSkills().hasSkill("trait.dumb") && this.Math.rand(1, 4) == 4)
			{
				bro.getSkills().add(this.new("scripts/skills/traits/dumb_trait"));
			}
		}
		
		foreach( g in garbage )
		{
			_roster.remove(g);
		}
	}

	function onCombatFinished()
	{
		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			if (bro.getFlags().get("IsPlayerCharacter"))
			{
				return true;
			}
		}

		return false;
	}

	function IsLuftName( _name )
	{
		local possibleName = [];
		local key = "LUFT";
		possibleName.push(" " + key + " ");
		possibleName.push(key + " ");
		possibleName.push(" " + key);
		possibleName.push(key);

		foreach ( p in possibleName ) 
		{
			if(_name.find(p) != null)
			{
				return true;
			}
		}

		return false;
	}
	
	function getBrothersWithSpecialSeeds( _seed , _name = false )
	{
		local roster = this.World.getPlayerRoster();
		roster.clear();
		local luft = roster.create("scripts/entity/tactical/player_luft");
		luft.worsenMood(0.5, "I\'m hungry");
		luft.setScenarioValues();
		luft.getBackground().buildDescription(true);
		luft.getSkills().add(this.new("scripts/skills/traits/player_character_trait"));
		luft.setPlaceInFormation(12);
		luft.getFlags().set("IsPlayerCharacter", true);
		luft.getFlags().set("Hexe_Origin", this.HexeVersion);
		luft.getSprite("miniboss").setBrush("bust_miniboss_lone_wolf");
		luft.m.HireTime = this.Time.getVirtualTimeF();
		luft.m.PerkPoints += 1;
		
		this.m.IsLuftAdventure = true;
		this.randomRollStarter(6);
		this.World.Flags.set("looks", 9991);
		this.World.Flags.set("IsLuftAdventure", true);
		this.World.Flags.remove("RitualTimer");
	}
	
	function isForceSeed( _inputSeed , _inputName )
	{
		local lib = this.Const.HexenNameKeyWord;

		foreach (i, array in lib)
		{
		    foreach ( name in array )
		    {
		    	local possibleName = [];
			    possibleName.push(" " + name + " ");
			    possibleName.push(name + " ");
			    possibleName.push(" " + name);
			    possibleName.push(name);

			    foreach ( p in possibleName) 
			    {
			        if(_inputName.find(p) != null)
			    	{
			    		return i;
			    	}
			    }
		    }
		}

		lib = this.Const.HexenSeedKeyWord;

		foreach ( i, string in lib )
		{
			if (_inputSeed.len() < string.len())
			{
				return null;
			}

			local keyword = _inputSeed.slice(0, string.len());
			
			if (keyword == string)
			{
				return i;
			}
		}
		
		return null;
	}

	function randomRollStarter( _fixed = 0 )
	{
		local roster = this.World.getPlayerRoster();
		local p = this.Math.rand(5, 7);
		local r = [];
		local tries = 0;

		if (p >= 7)
		{
			p = this.Math.rand(5, 7);
		}

		if (_fixed != 0 && _fixed > 2)
		{
			p = _fixed;
		}

		while (p >= 2 && tries < 40)
		{
			local list = this.Const.HexenCharmedUnitList;
			local a = list[this.Math.rand(0, list.len() - 1)];

			if (a[0] <= p)
			{
				r.push(a[1]);
				p = p - a[0];
				tries = 0;
			}
			else 
			{
				++tries;
			}
		}

		foreach ( i, script in r )
		{
			local starter = roster.create("scripts/entity/tactical/" + script);

			if (script == "player")
			{
				starter.setStartValuesEx(this.Const.CharacterBackgrounds);
				starter.improveMood(1.0, "Still alive to serve the mistress");
			}
			else 
			{
				starter.setScenarioValues();
				starter.improveMood(1.0, "Loyal servant");
			}

			starter.getSkills().removeByID("trait.disloyal");
			starter.getSkills().removeByID("trait.greedy");
			starter.setPlaceInFormation(i + 3);
			starter.onHired();

			if (!this.m.IsLuftAdventure)
			{
				starter.addHeavyInjury();
			}
		}
	}

});

