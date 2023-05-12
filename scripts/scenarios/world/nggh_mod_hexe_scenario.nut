this.nggh_mod_hexe_scenario <- ::inherit("scripts/scenarios/world/starting_scenario", {
	m = {
		Look = 9997,
		IsLuftAdventure = false,
	},
	function create()
	{
		this.m.ID = "scenario.hexe";
		this.m.Name = "Hexe";
		this.m.Description = "[p=c][img]gfx/ui/events/event_106.png[/img][/p][p]A Hexe founds a mercenary company to secretly collect offerings for a ritual.\n\n[color=#bcad8c]Witch:[/color] Start with a hexe and some simps.\n[color=#bcad8c]Gotta catch 'em all:[/color] Charm the enemy and add them to your roster.\n[color=#bcad8c]Simps:[/color] Those fell for your charm don\'t need money, they only need love.";
		this.m.Difficulty = 1;
		this.m.Order = 109;
		this.m.IsFixedLook = true;
		this.m.StartingBusinessReputation = 50;
		this.m.StartingRosterTier = ::Const.Roster.getTierForSize(12);
		this.setRosterReputationTiers(::Const.Roster.createReputationTiers(this.m.StartingBusinessReputation));
	}

	function getDescription()
	{
		return this.m.Description + "\n[color=#bcad8c]The Price For Beauty:[/color] Have to perform a ritual every " + ::Nggh_MagicConcept.HexeOriginRitual.Cooldown + " day(s) or face the consequences.\n[color=#bcad8c]Avatar:[/color] If your Hexe dies, the campaign ends.[/p]";
	}

	function onSpawnAssets()
	{
		::World.Flags.set("looks", ::Math.rand(9995, 9997));
		::World.Flags.set("RitualTimer", 2); // set at 2 will make sure the first ritual will be at days 7
		
		local roster = ::World.getPlayerRoster();
		local name = ::World.Assets.getName().toupper();
		local seed = ::World.Assets.getSeedString().toupper();
		
		if (::Const.HexeOrigin.EasterEggSeed.find(seed) != null || this.isLuftName(name))
		{
			this.setupLuftStart();
		}
		else
		{
			local forced_start_ID = this.isForceSeed(seed, name);
			//0:eggs - 1:spider - 2:redback - 3:wolf - 4:white wolf - 5:hyena - 6:serpent - 7:unhold - 8:ghoul - 9:alp - 10:goblin - 11:orc - 12:human - 13:ijirok - 14:lindwurm - 15:schrat - 16:bear - 17:circus

			if (::Const.HexeOrigin.SeedsStartWithWhip.find(forced_start_ID) != null)
			{
				::Nggh_MagicConcept.ForceWhipPerk = true;
			}

			local hexe = roster.create("scripts/entity/tactical/player");
			hexe.setStartValuesEx(["nggh_mod_hexe_commander_background"]);
			hexe.getBackground().buildDescription(true);
			hexe.getSkills().removeByID("trait.survivor");
			hexe.getSkills().removeByID("trait.loyal");
			hexe.getSkills().removeByID("trait.disloyal");
			hexe.getSkills().removeByID("trait.greedy");
			hexe.setPlaceInFormation(13);
			hexe.m.HireTime = ::Time.getVirtualTimeF();
			hexe.m.PerkPoints = 1;
			hexe.m.LevelUps = 0;
			hexe.m.Level = 1;
			hexe.m.Talents = [];
			hexe.m.Attributes = [];
			hexe.fillTalentValues(3);
			hexe.fillAttributeLevelUpValues(::Const.XP.MaxLevelWithPerkpoints - 1);

			if (forced_start_ID == null)
			{
				this.setupRandomStart();
			}
			else
			{
				if (forced_start_ID == null)
				{
					::logError("forceSeed = null");
				}
				else
				{
					::logInfo("With your seed/name, your start id = " + forced_start_ID);
					::logInfo("Your starting party would be: " + ::Const.HexeOrigin.StartingRollNames[forced_start_ID]);
				}

				this.setupSpecialStart(forced_start_ID, hexe);
			}
		}
		
		foreach ( b in roster.getAll() )
		{
			b.setVeteranPerks(2);
		}
		
		::World.Assets.addBusinessReputation(this.m.StartingBusinessReputation);
		::World.Assets.getStash().add(::new("scripts/items/supplies/dates_item"));
		::World.Assets.getStash().add(::new("scripts/items/supplies/black_marsh_stew_item"));
		::World.Assets.getStash().add(::new("scripts/items/supplies/black_marsh_stew_item"));
		::World.Assets.getStash().add(::new("scripts/items/misc/poisoned_apple_item"));
		::World.Assets.getStash().add(::new("scripts/items/misc/werewolf_pelt_item"));
		::World.Assets.getStash().add(::new("scripts/items/misc/witch_hair_item"));
			
		// add 2 random potions
		local weightedContainer = ::MSU.Class.WeightedContainer(::Const.HexeOrigin.PossibleStartingPotions);
		
		for (local i = 0; i < 2; ++i)
		{
			::World.Assets.getStash().add(::new("scripts/items/" + weightedContainer.roll()));
		}
		
		if (::Math.rand(1, 100) == 1)
		{
			::World.Assets.getStash().add(::new("scripts/items/special/fountain_of_youth_item"));
		}
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != ::World.EntityManager.getSettlements().len(); ++i )
		{
			randomVillage = ::World.EntityManager.getSettlements()[i];

			if (!randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() == 1)
			{
				break;
			}
		}

		local randomVillageTile = randomVillage.getTile();
		local navSettings = ::World.getNavigator().createSettings();
		navSettings.ActionPointCosts = ::Const.World.TerrainTypeNavCost_Flat;

		do
		{
			local x = ::Math.rand(::Math.max(2, randomVillageTile.SquareCoords.X - 4), ::Math.min(::Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 4));
			local y = ::Math.rand(::Math.max(2, randomVillageTile.SquareCoords.Y - 4), ::Math.min(::Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 4));

			if (!::World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = ::World.getTileSquare(x, y);

				if (tile.Type == ::Const.World.TerrainType.Ocean || tile.Type == ::Const.World.TerrainType.Shore || tile.IsOccupied)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) <= 1)
				{
				}
				else if (tile.Type != ::Const.World.TerrainType.Plains && tile.Type != ::Const.World.TerrainType.Steppe && tile.Type != ::Const.World.TerrainType.Tundra && tile.Type != ::Const.World.TerrainType.Snow)
				{
				}
				else
				{
					local path = ::World.getNavigator().findPath(tile, randomVillageTile, navSettings, 0);

					if (!path.isEmpty())
					{
						randomVillageTile = tile;
						break;
					}
				}
			}
		}
		while (1);
		
		local eventID = this.m.IsLuftAdventure ? "event.luft_scenario_intro" : "event.hexe_intro_event";
		::World.State.m.Player = ::World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		::World.Assets.updateLook(::World.Flags.getAsInt("looks"));
		::World.getCamera().setPos(::World.State.m.Player.getPos());
		::Time.scheduleEvent(::TimeUnit.Real, 1000, function ( _tag )
		{
			::Music.setTrackList(::Const.Music.BeastsTracks, ::Const.Music.CrossFadeTime);
			::World.Events.fire(eventID);
		}, null);

		::Nggh_MagicConcept.ForceWhipPerk = false;
		this.m.IsLuftAdventure = false;
	}
	
	function onInit()
	{
		this.starting_scenario.onInit();
		::World.Assets.m.FootprintVision *= 1.5;
	}

	function updateLook()
	{
		local looks = ::World.Flags.getAsInt("looks") == 0 ? this.m.Look : ::World.Flags.getAsInt("looks");
		::World.State.getPlayer().getSprite("body").setBrush("figure_player_" + (::World.Flags.has("isExposed") ? 9994 : looks));
	}
	
	function onHiredByScenario( _bro )
	{
		if ([
			"background.eunuch",
			"background.hexe",
			"background.hexe_commander",
		].find(_bro.getBackground().getID()) == null)
		{
			_bro.getSkills().add(::new("scripts/skills/hexe/nggh_mod_fake_charmed_effect"));
		}
		else if (_bro.getBackground().getID() == "background.eunuch")
		{
			_bro.worsenMood(5.0, "Horrified by knowing the true nature of this company");
		}
	}
	
	function onUpdateHiringRoster( _roster )
	{
		local bros = _roster.getAll();
		local garbage = [];

		foreach( i, bro in bros )
		{
			if (::Const.WitchHaters.find(bro.getBackground().m.ID) != null)
			{
				garbage.push(bro);
			}
			
			if (bro.getSkills().hasSkill("trait.bright"))
			{
				bro.getSkills().removeByID("trait.bright");
			}
			
			if (!bro.getSkills().hasSkill("trait.dumb") && ::Math.rand(1, 100) <= 25)
			{
				bro.getSkills().add(::new("scripts/skills/traits/dumb_trait"));
			}
		}
		
		foreach( g in garbage )
		{
			_roster.remove(g);
		}
	}

	function onCombatFinished()
	{
		foreach( bro in ::World.getPlayerRoster().getAll() )
		{
			if (bro.getFlags().get("IsPlayerCharacter"))
			{
				return true;
			}
		}

		return false;
	}

	function isLuftName( _name )
	{
		local key = "LUFT";
		local possibleName = [];
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

	function isForceSeed( _inputSeed , _inputName )
	{
		// check name first
		foreach (i, array in ::Const.HexeOrigin.NameKeywords)
		{
		    foreach (name in array)
		    {
		    	local possibleName = [];
			    possibleName.push(" " + name + " ");
			    possibleName.push(name + " ");
			    possibleName.push(" " + name);
			    possibleName.push(name);

			    foreach (p in possibleName) 
			    {
			        if (_inputName.find(p) != null)
			    	{
			    		return i;
			    	}
			    }
		    }
		}

		// then check the seed
		local length = _inputSeed.len();
		foreach (i, string in ::Const.HexeOrigin.SeedKeywords)
		{
			if (string.len() > length)
			{
				return null;
			}

			local keyword = string.len() == length ? _inputSeed : _inputSeed.slice(0, string.len());
			
			if (keyword == string)
			{
				return i;
			}
		}
		
		return null;
	}
	
	function setupLuftStart()
	{
		local roster = ::World.getPlayerRoster();
	
		::World.Flags.set("looks", 9991);
		::World.Flags.remove("RitualTimer");
		::World.Flags.set("IsLuftAdventure", true);
		::logInfo("With your seed/name, your start id = LUFT");

		local luft = roster.create("scripts/entity/tactical/player_beast/nggh_mod_luft_player");
		luft.setStartValuesEx();
		luft.getBackground().buildDescription(true);
		luft.worsenMood(0.5, "I\'m hungry");
		luft.setPlaceInFormation(12);
		luft.m.HireTime = ::Time.getVirtualTimeF();
		
		this.m.IsLuftAdventure = true;
		this.setupRandomStart(6, false);
		this.addScenarioPerk(luft.getBackground(), ::Const.Perks.PerkDefs.NggHCharmEnemyGhoul, 4);
	}

	function setupSpecialStart( _id, _hexe )
	{
		local roster = ::World.getPlayerRoster();

		switch(_id)
		{
		case 0:
			for( local i = 0; i < 3; ++i )
			{
				local beast = roster.create("scripts/entity/tactical/player_beast/nggh_mod_spider_eggs_player");
				beast.improveMood(1.0, "Eggs! Eggs! Eggs!");
				beast.setStartValuesEx();
				beast.setPlaceInFormation(i + 21);
				beast.addLightInjury();
				beast.onHired();
			}
			
			_hexe.setTitle(::Math.rand(1, 2) == 1 ? "the Eggscellent" : "the Eggmaniac");
			break;

		case 1:
			for( local i = 0; i < 2; ++i )
			{
				local beast = roster.create("scripts/entity/tactical/player_beast/nggh_mod_spider_player");
				beast.improveMood(1.0, "Still alive to serve the queen");
				beast.setStartValuesEx();
				beast.setPlaceInFormation(i + 3);
				beast.addHeavyInjury();
				beast.onHired();
			}
			
			local beast = roster.create("scripts/entity/tactical/player_beast/nggh_mod_spider_eggs_player");
			beast.improveMood(1.0, "...");
			beast.setStartValuesEx();
			beast.setPlaceInFormation(12);
			beast.addLightInjury();
			beast.onHired();
			
			_hexe.setTitle("the Spider Queen");
			break;

		case 2:
			local beast = roster.create("scripts/entity/tactical/player_beast/nggh_mod_spider_player");
			beast.improveMood(1.0, "...");
			beast.setStartValuesEx(false, true);
			beast.addLightInjury();
			beast.setPlaceInFormation(12);
			beast.onHired();
			
			_hexe.setTitle("the Black Widow");
			break;
			
		case 3:
			for( local i = 0; i < 2; ++i )
			{
				local beast = roster.create("scripts/entity/tactical/player_beast/nggh_mod_direwolf_player");
				beast.improveMood(1.0, "Loyal doggie");
				beast.setStartValuesEx();
				beast.setPlaceInFormation(i + 3);
				beast.addHeavyInjury();
				beast.onHired();
			}
			
			_hexe.setTitle("the Mother Wolf");
			break;

		case 4:
			local beast = roster.create("scripts/entity/tactical/player_beast/nggh_mod_direwolf_player");
			beast.improveMood(1.0, "");
			beast.setStartValuesEx(false, true);
			beast.setPlaceInFormation(12);
			beast.addHeavyInjury();
			beast.onHired();
			beast.setName("Yama-inu");

			// dunno if you know this name
			_hexe.setName("Mononoke Hime");
			_hexe.setTitle("");
			break;
			
		case 5:
			for( local i = 0; i < 2; ++i )
			{
				local beast = roster.create("scripts/entity/tactical/player_beast/nggh_mod_hyena_player");
				beast.improveMood(1.0, "Loyal doggie");
				beast.setStartValuesEx();
				beast.setPlaceInFormation(i + 3);
				beast.addHeavyInjury();
				beast.onHired();
			}
			
			_hexe.setTitle("the Desert Lily");
			break;
			
		case 6:
			for( local i = 0; i < 3; ++i )
			{
				local beast = roster.create("scripts/entity/tactical/player_beast/nggh_mod_serpent_player");
				beast.improveMood(1.0, "Loyal snake pet");
				beast.setStartValuesEx(i == 1 ? ::Math.rand(1, 100) <= 10 : false);
				beast.setPlaceInFormation(i + 3);
				beast.addHeavyInjury();
				beast.onHired();
			}
			
			_hexe.setTitle("the Gorgeous Viper");
			break;
			
		case 7:
			local beast = roster.create("scripts/entity/tactical/player_beast/nggh_mod_unhold_player");
			beast.improveMood(1.0, "Still alive to serve the queen");
			beast.setStartValuesEx();
			beast.setPlaceInFormation(4);
			beast.setHitpointsPct(::Math.rand(40, 65) * 0.01);
			beast.onHired();
			_hexe.setTitle("the Empress");
			break;
			
		case 8:
			for( local i = 0; i < 2; ++i )
			{
				local beast = roster.create("scripts/entity/tactical/player_beast/nggh_mod_ghoul_player");
				beast.improveMood(1.0, "Loyal pet monkey");
				beast.setStartValuesEx(false, false, ::Math.rand(1, 100) <= 15 ? 2 : 1);
				beast.setPlaceInFormation(i + 3);
				beast.addHeavyInjury();
				beast.onHired();
			}
			
			_hexe.setTitle("the Empress");
			break;
			
		case 9:
			for( local i = 0; i < 3; ++i )
			{
				local beast = roster.create("scripts/entity/tactical/player_beast/nggh_mod_alp_player");
				beast.improveMood(1.0, "Enthralled");
				beast.setStartValuesEx();
				beast.setPlaceInFormation(i == 2 ? 12 : i + 3);
				beast.addHeavyInjury();
				beast.onHired();
			}
			
			_hexe.setTitle("the Dreamy Goddess");
			break;
			
		case 10:
			for( local i = 0; i < ::Math.rand(3, 4); ++i )
			{
				local goblin = roster.create("scripts/entity/tactical/nggh_mod_player_goblin");
				goblin.improveMood(1.0, "Still alive to serve the queen");
				goblin.setStartValuesEx();
				goblin.setPlaceInFormation(i + 3);
				goblin.addLightInjury();
				goblin.onHired();
			}
			
			_hexe.setTitle("the Rose");
			break;
			
		case 11:
			for( local i = 0; i < 2; ++i )
			{
				local orc = roster.create("scripts/entity/tactical/nggh_mod_player_orc");
				orc.improveMood(1.0, "We are warriors of the mistress");
				orc.setStartValuesEx();
				orc.setPlaceInFormation(i + 3);
				orc.addHeavyInjury();
				orc.onHired();
			}
			
			_hexe.setTitle("the Warrior Queen");
			break;
			
		case 12:
			for( local i = 0; i < 2; ++i )
			{
				local bro = roster.create("scripts/entity/tactical/player");
				bro.setStartValuesEx(::Const.CharacterBackgrounds);
				bro.improveMood(1.0, "Still alive to serve the mistress");
				bro.setPlaceInFormation(i + 3);
				bro.addHeavyInjury();
				bro.onHired();
			}
			
			_hexe.setTitle("the Beauty");
			break;
			
		case 13:
			local god = roster.create("scripts/entity/tactical/player_beast/nggh_mod_trickster_god_player");
			god.improveMood(1.0, "Bodyguarding for my fairy godmother");
			god.setStartValuesEx();
			god.setPlaceInFormation(4);
			god.onHired();
			god.setHitpointsPct(::Math.rand(40, 65) * 0.01);
			_hexe.setTitle("the Fairy");
			break;

		case 14:
			local beast = roster.create("scripts/entity/tactical/player_beast/nggh_mod_lindwurm_player");
			beast.improveMood(1.0, "Pet lindwurm");
			beast.setStartValuesEx(false, ::Math.rand(1, 100) <= 5);
			beast.setPlaceInFormation(4);
			beast.onHired();
			beast.setHitpointsPct(::Math.rand(40, 65) * 0.01);
			_hexe.setTitle("the Dragon Queen");
			break;

		case 15:
			if (::Math.rand(1, 100) <= 33)
			{
				for (local i = 0; i < 3; ++i)
				{
					local beast = roster.create("scripts/entity/tactical/player_beast/nggh_mod_schrat_small_player");
					beast.improveMood(1.0, "...");
					beast.setStartValuesEx(i == 1 ? ::Math.rand(1, 100) <= 25 : false);
					beast.setPlaceInFormation(i + 3);
					beast.onHired();
				}
			}
			else
			{
				local beast = roster.create("scripts/entity/tactical/player_beast/nggh_mod_schrat_player");
				beast.improveMood(1.0, "...");
				beast.setStartValuesEx();
				beast.setPlaceInFormation(4);
				beast.onHired();
				beast.setHitpointsPct(::Math.rand(40, 65) * 0.01);
			}

			_hexe.setTitle("the Wicked");
			break;

		case 16:
			local beast = roster.create("scripts/entity/tactical/player_beast/nggh_mod_unhold_player");
			beast.improveMood(1.0, "I\'m a bear");
			beast.setStartValuesEx(false, true);
			beast.setPlaceInFormation(4);
			beast.setHitpointsPct(::Math.rand(40, 65) * 0.01);
			beast.setName("Mor'du");
			beast.onHired();

			_hexe.setTitle("the Enchantress");
			break;

		case 17:
			_hexe.setPlaceInFormation(22);
			_hexe.setTitle("the Ringmistress");
			
			local a = [];
			local beast = roster.create("scripts/entity/tactical/player_beast/nggh_mod_unhold_player");
			beast.improveMood(1.0, "I\'m Mor'du");
			beast.setStartValuesEx(false, true);
			beast.setPlaceInFormation(4);
			beast.setHitpointsPct(::Math.rand(40, 65) * 0.01);
			beast.setName("Mor'du");
			a.push(beast);

			beast = roster.create("scripts/entity/tactical/player_beast/nggh_mod_hyena_player");
			beast.improveMood(1.0, "Loyal doggie");
			beast.setStartValuesEx();
			beast.setPlaceInFormation(3);
			beast.addHeavyInjury();
			a.push(beast);

			beast = roster.create("scripts/entity/tactical/player_beast/nggh_mod_serpent_player");
			beast.improveMood(1.0, "Talented snake");
			beast.setStartValuesEx();
			beast.setPlaceInFormation(5);
			beast.addHeavyInjury();
			a.push(beast);

			local bro = roster.create("scripts/entity/tactical/player");
			bro.setStartValuesEx(["juggler_background"]);
			bro.improveMood(1.0, "Simping to the ringmistress");
			bro.setPlaceInFormation(12);
			bro.addHeavyInjury();
			a.push(bro);

			foreach ( _b in a )
			{
				_b.onHired();

				local items = _b.getItems();
				items.unequip(items.getItemAtSlot(::Const.ItemSlot.Head));
				items.equip(::Const.World.Common.pickHelmet([[1, "jesters_hat"]]));
			}
			break;

		case 18:
			for( local i = 0; i < 2; ++i )
			{
				local orc = roster.create("scripts/entity/tactical/nggh_mod_player_orc");
				orc.improveMood(1.0, "We are warriors of the mistress");
				orc.setStartValuesEx();
				orc.setPlaceInFormation(i + 2);
				orc.addHeavyInjury();
				orc.onHired();
			}

			for( local i = 0; i < 2; ++i )
			{
				local goblin = roster.create("scripts/entity/tactical/nggh_mod_player_goblin");
				goblin.improveMood(1.0, "Still alive to serve the queen");
				goblin.setStartValuesEx();
				goblin.setPlaceInFormation(i + 4);
				goblin.addLightInjury();
				goblin.onHired();
			}

			local goblin = roster.create("scripts/entity/tactical/nggh_mod_player_goblin");
			goblin.improveMood(1.0, "Still alive to serve the queen");
			goblin.setStartValuesEx(false, ::Const.Goblin.Variants.find(::Const.EntityType.GoblinAmbusher));
			goblin.setPlaceInFormation(12);
			goblin.addLightInjury();
			goblin.onHired();

			_hexe.setTitle("Queen of Greenskin");
			break;

		case 19:
			local donation = 0;
			_hexe.setPlaceInFormation(22);
			_hexe.getSkills().add(::new(::Const.Perks.PerkDefObjects[::MSU.Array.rand([::Const.Perks.PerkDefs.NggHCharmSpec, ::Const.Perks.PerkDefs.NggHCharmNudist, ::Const.Perks.PerkDefs.NggHCharmAppearance])].Script));
			_hexe.getSkills().add(::new("scripts/skills/traits/seductive_trait"));
			_hexe.getItems().addToBag(::new("scripts/items/weapons/barbarians/thorned_whip"));

			for( local i = 0; i < 5; ++i )
			{
				local bro = roster.create("scripts/entity/tactical/player");
				bro.setStartValuesEx(["beggar_southern_background", "beggar_background"]);
				bro.getSkills().add(::new("scripts/skills/traits/loyal_trait"));
				bro.setPlaceInFormation(i + 2);
				bro.addHeavyInjury();
				bro.onHired();
				local money = ::Math.rand(1, 8) * 10;
				bro.improveMood(0.5, "Amouranth\'s loyal simp");
				bro.improveMood(0.2, "Donated " + money + " crowns to Amouranth");
				bro.improveMood(0.3, (money >= 70 ? "I'm broke, but feel good for supporting Amouranth" : "Feel good for supporting Amouranth"));
				donation += money;

				local goblin = roster.create("scripts/entity/tactical/nggh_mod_player_goblin");
				goblin.setStartValuesEx();
				goblin.getSkills().add(::new("scripts/skills/traits/loyal_trait"));
				goblin.setPlaceInFormation(i + 11);
				goblin.addLightInjury();
				goblin.onHired();
				money = ::Math.rand(1, 8) * 10;
				goblin.improveMood(0.5, "Amouranth\'s loyal simp");
				goblin.improveMood(0.2, "Donated " + money + " crowns to Amouranth");
				goblin.improveMood(0.3, (money >= 70 ? "I'm broke, but feel good for supporting Amouranth" : "Feel good for supporting Amouranth"));
				donation += money;
			}
			
			_hexe.improveMood(0.5, "Finished a stream");
			_hexe.improveMood(0.5, "Received " + donation + " crowns of donation from gullible simps");
			_hexe.setName("@Amouranth");
			_hexe.setTitle("ASMR streamer");
			::World.Assets.addMoney(donation);
			::World.Assets.m.Name = ::removeFromBeginningOfText("The ", ::removeFromBeginningOfText("the ", "@Amouranth Simps Corp"));
			break;

		case 20:
			// the witch
			this.removeTraitsFrom(_hexe);
			_hexe.setName("Schierke");
			_hexe.setTitle("");
			_hexe.getSkills().add(::new("scripts/skills/traits/tiny_trait"));
			_hexe.getSkills().add(::new("scripts/skills/traits/light_trait"));
			_hexe.getItems().equip(::new("scripts/items/weapons/legend_staff_gnarled"));
			_hexe.getItems().equip(::Const.World.Common.pickHelmet([[1, "dark_cowl"]]));
			this.addScenarioPerk(_hexe.getBackground(), ::Const.Perks.PerkDefs.LegendMagicMissile);

			// berserker
			local guts = roster.create("scripts/entity/tactical/player");
			guts.setStartValuesEx(["legend_berserker_background"], true, 0, false);
			guts.setTitle("the Black Swordsman");
			guts.setName("Guts");
			guts.onHired();

			this.removeTraitsFrom(guts);
			this.addScenarioPerk(guts.getBackground(), ::Const.Perks.PerkDefs.SpecSword);
			guts.getSkills().add(::new("scripts/skills/traits/huge_trait"));
			guts.getSkills().add(::new("scripts/skills/traits/heavy_trait"));
			guts.getSkills().add(::new("scripts/skills/traits/tough_trait"));
			guts.getSkills().add(::new("scripts/skills/traits/strong_trait"));
			guts.getSkills().add(::new("scripts/skills/injury_permanent/missing_eye_injury"));
			guts.getItems().equip(::new("scripts/items/weapons/greatsword"));
			guts.getItems().equip(::Const.World.Common.pickHelmet([[1, "full_helm"]]));
			guts.getItems().equip(::Const.World.Common.pickArmor([[1, "coat_of_plates"]]));

			// branded peasant
			local casca = roster.create("scripts/entity/tactical/player");
			casca.setStartValuesEx(["belly_dancer_background"]);
			casca.setTitle("the Branded Girl");
			casca.setName("Casca");
			casca.onHired();

			this.removeTraitsFrom(casca);
			casca.getSkills().add(::new("scripts/skills/traits/fear_beasts_trait"));
			casca.getSkills().add(::new("scripts/skills/traits/mad_trait"));

			// brat thief
			local isidro = roster.create("scripts/entity/tactical/player");
			isidro.setStartValuesEx(["thief_background"]);
			isidro.setName("Isidro");
			isidro.setTitle("");
			isidro.onHired();

			this.removeTraitsFrom(isidro);
			isidro.getSkills().add(::new("scripts/skills/traits/cocky_trait"));
			isidro.getSkills().add(::new("scripts/skills/traits/dexterous_trait"));
			isidro.getSkills().add(::new("scripts/skills/traits/quick_trait"));
			isidro.getSkills().add(::new("scripts/skills/traits/tiny_trait"));

			// knight woman
			local farnese = roster.create("scripts/entity/tactical/player");
			farnese.setStartValuesEx(["female_adventurous_noble_background"], true, 1, false);
			farnese.getSprite("hair").setBrush("hair_blonde_21");
			farnese.setTitle("de Vandimion");
			farnese.setName("Farnese");
			farnese.onHired();

			this.removeTraitsFrom(farnese);
			this.addScenarioPerk(farnese.getBackground(), ::Const.Perks.PerkDefs.SpecSword);
			farnese.getSkills().add(::new("scripts/skills/traits/hesitant_trait"));
			farnese.getSkills().add(::new("scripts/skills/traits/fainthearted_trait"));
			farnese.getItems().equip(::new("scripts/items/weapons/noble_sword"));
			farnese.getItems().equip(::Const.World.Common.pickArmor([[1, "mail_hauberk"]]));

			// knight woman's servant
			local serpico = roster.create("scripts/entity/tactical/player");
			serpico.setStartValuesEx(["servant_background"], true, -1, false);
			serpico.getSprite("hair").setBrush("hair_blonde_03");
			serpico.setName("Serpico");
			serpico.setTitle("");
			serpico.onHired();

			this.removeTraitsFrom(serpico);
			this.addScenarioPerk(serpico.getBackground(), ::Const.Perks.PerkDefs.SpecSword);
			serpico.getSkills().add(::new("scripts/skills/traits/irrational_trait"));
			serpico.getSkills().add(::new("scripts/skills/traits/loyal_trait"));
			serpico.getSkills().add(::new("scripts/skills/traits/bright_trait"));
			serpico.getItems().equip(::new("scripts/items/weapons/fencing_sword"));
			serpico.getItems().equip(::Const.World.Common.pickArmor([
				[1, "seedmaster_noble_armor"],
				[1, "citreneking_noble_armor"],
			]));
			break;

		case 21:
			local credits = 5;
			local num = ::Math.rand(1, 3);
			_hexe.setPlaceInFormation(11);
			_hexe.setTitle("the Coven Leader");

			for( local i = 0; i < num; ++i )
			{
				local hexe = roster.create("scripts/entity/tactical/player");
				hexe.setStartValuesEx(["nggh_mod_hexe_regular_background"]);
				hexe.getBackground().buildDescription(true);
				hexe.setPlaceInFormation(12 + i);
				hexe.onHired();
				credits += 3;
			}

			this.setupRandomStart(credits, false);
			break;

		case 22:
			for( local i = 0; i < 2; ++i )
			{
				local beast = roster.create("scripts/entity/tactical/player_beast/nggh_mod_alp_player");
				beast.improveMood(1.0, "Enthralled");
				beast.setStartValuesEx(false, true, 0);
				beast.setPlaceInFormation(i == 2 ? 12 : 14);
				beast.addHeavyInjury();
				beast.onHired();

				// why not?
				beast.getItems().equip(::new("scripts/items/weapons/legend_swordstaff"));
				beast.setTitle("the Hell Guard");

				// add specialized perk group too
				local background = beast.getBackground();
				background.addPerkGroup(::Const.Perks.SpearTree.Tree);

				if (::Is_PTR_Exist)
				{
					background.addPerkGroup(::Const.Perks.TwoHandedTree.Tree);
				}
			}
			
			_hexe.setTitle("the Demon Countess");
			_hexe.getItems().equip(::new("scripts/items/weapons/barbarians/claw_club"));
			_hexe.getItems().equip(::Const.World.Common.pickArmor([[3, "oriental/vizier_gear"]]));
			_hexe.getItems().equip(::Const.World.Common.pickHelmet([[1, "cultist_leather_hood"]]));
			_hexe.getBaseProperties().Hitpoints += 15;
			_hexe.getBaseProperties().Stamina += 20;
			_hexe.getBaseProperties().MeleeSkill += 20;
			_hexe.getBaseProperties().MeleeDefense += 10;
			_hexe.getSkills().update();
			_hexe.setHitpoints(1.0);
			break;

		default:
			for( local i = 0; i < 3; ++i )
			{
				local beast = roster.create("scripts/entity/tactical/player_beast/nggh_mod_spider_player");
				beast.improveMood(1.0, "Still alive to serve the queen");
				beast.setStartValuesEx();
				beast.setPlaceInFormation(i + 3);
				beast.addHeavyInjury();
				beast.onHired();
			}

			_hexe.setTitle("the Spider Queen");
		}
	}

	function setupRandomStart( _credits = 0 , _declare = true )
	{
		if (_declare)
		{
			::logInfo("Your starting party would be: RANDOM");
		}
		
		local c = 2;

		if (_credits >= 2)
		{
			c = _credits;
		}
		else
		{
			c = ::Math.rand(5, 7)

			if (c >= 7)
			{
				c = ::Math.rand(5, 7);
			}
		}

		::logInfo("Your party budget: " + c + " credits");
		this.spawnStarterFromList(this.pickStarter(c));
	}

	function pickStarter( _credits )
	{
		local ret = [];
		local tries = 0;

		while (_credits >= 2 && tries < 250)
		{
			local r = ::MSU.Array.rand(::Const.HexeOrigin.PossibleStartingPlayers);

			if (r.Cost > _credits)
			{
				++tries;
				continue;
			}

			::logInfo("rolled: " + r.Name + " , cost: " + r.Cost + " credits");
			_credits -= r.Cost;
			ret.push(r.Script);
			tries = 0;
		}

		return ret;
	}

	function spawnStarterFromList( _list )
	{
		local roster = ::World.getPlayerRoster();

		foreach ( i, script in _list )
		{
			local starter = roster.create("scripts/entity/tactical/" + script);

			if (script == "player")
			{
				starter.setStartValuesEx(::Const.CharacterBackgrounds);
				starter.improveMood(1.0, "Still alive to serve the mistress");
			}
			else 
			{
				starter.setStartValuesEx();
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

	function removeTraitsFrom( _bro )
	{
		foreach(trait in _bro.getSkills().getAllSkillsOfType(::Const.SkillType.Trait))
		{
			if (trait.isType(::Const.SkillType.Background))
			{
				continue;
			}

			trait.removeSelf();
		}
	}

});

