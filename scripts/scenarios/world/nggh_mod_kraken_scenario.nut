// an experimental origin
this.nggh_mod_kraken_scenario <- ::inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.kraken";
		this.m.Name = "Beast of Beasts";
		this.m.Description = "[p=c][img]gfx/ui/events/event_103.png[/img][/p][p]What if you can play as a kraken?.\n\n[color=#bcad8c]Only You:[/color] Start with only one starter and the campaign will end if said starter dies.\n[color=#bcad8c]Beast of Beasts:[/color] As you can see you are a fearsome Kraken.\n[color=#bcad8c]Stranger Thing:[/color] Your food spoils at much slower rate, also gains strange meat whenever you kill an enemy, don\'t ask why.\n[color=#c90000]Kaiju Fight:[/color] Have an epic battle with another Kraken at start, it\'s not optional thou.[/p]";
		this.m.Difficulty = 1;
		this.m.Order = 110;
		this.m.StartingBusinessReputation = 500;
		this.m.StartingRosterTier = ::Const.Roster.getTierForSize(1);
		this.m.RosterTierMax = ::Const.Roster.getTierForSize(15);
		this.setRosterReputationTiers(::Const.Roster.createReputationTiers(this.m.StartingBusinessReputation));
	}

	/*
	function isValid()
	{
		return this.AddedSecret;
	}
	*/

	function onSpawnAssets()
	{
		local kraken = ::World.getPlayerRoster().create("scripts/entity/tactical/player_beast/nggh_mod_kraken_player");
		kraken.setStartValuesEx();
		kraken.m.HireTime = ::Time.getVirtualTimeF();
		kraken.getSprite("miniboss").setBrush("bust_miniboss_lone_wolf");
		kraken.getBackground().m.RawDescription = "A true terror of the depth has decided to start its hunt on the land of human. Time to hunt and kill, let your hunger be satiated with fresh prey.";
		kraken.getBackground().buildDescription(true);
		kraken.getSkills().removeByID("trait.survivor");
		kraken.getSkills().removeByID("trait.loyal");
		kraken.getSkills().removeByID("trait.disloyal");
		kraken.getSkills().removeByID("trait.greedy");
		kraken.setPlaceInFormation(13);
		kraken.setVeteranPerks(2);
		
		::World.Assets.addBusinessReputation(this.m.StartingBusinessReputation);
		::World.Assets.m.Money += 1000;

		for (local i = 0; i < 10; ++i)
		{
			::World.Assets.getStash().add(::new("scripts/items/supplies/strange_meat_item"));
		}
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != ::World.EntityManager.getSettlements().len(); ++i )
		{
			randomVillage = ::World.EntityManager.getSettlements()[i];

			if (!randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() <= 1)
			{
				break;
			}
		}

		local randomVillageTile = randomVillage.getTile();
		local navSettings = ::World.getNavigator().createSettings();
		navSettings.ActionPointCosts = ::Const.World.TerrainTypeNavCost_Flat;

		do
		{
			local x = ::Math.rand(::Math.max(2, randomVillageTile.SquareCoords.X - 3), ::Math.min(::Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 3));
			local y = ::Math.rand(::Math.max(2, randomVillageTile.SquareCoords.Y - 3), ::Math.min(::Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 3));

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

		::World.State.m.Player = ::World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		::World.State.getPlayer().getSprite("body").setBrush("figure_player_9990");
		::World.getCamera().setPos(::World.State.getPlayer().getPos());
		::World.Flags.set("IsKrakenCultVisited", true);
		::World.Flags.set("IsKrakenOrigin", true);
		::Time.scheduleEvent(::TimeUnit.Real, 1000, function ( _tag ) {
			::Music.setTrackList(::Const.Music.BeastsTracks, ::Const.Music.CrossFadeTime);
		}, null);
	}

	function onInit()
	{
		this.starting_scenario.onInit();
		::World.Assets.m.VisionRadiusMult *= 1.5;
		::World.Assets.m.FoodAdditionalDays += 5;
		::World.Assets.m.ChampionChanceAdditional += 10;
	}

	function onActorKilled( _actor, _killer, _combatID )
	{
		if (::Tactical.State.getStrategicProperties().IsArenaMode)
		{
			return;
		}

		if (_killer == null)
		{
			return;
		}

		if (!_killer.getFlags().has("kraken") && !_killer.getFlags().has("kraken_tentacle"))
		{
			return;
		}

		if ([
			::Const.BloodType.Red,
			::Const.BloodType.Dark,
			::Const.BloodType.Green,
		].find(_actor.getBloodType()) == null)
		{
			return;
		}

		if (_actor.isPlacedOnMap() && _actor.getTile() != null)
		{
			local tile = _actor.getTile();
			local item = ::new("scripts/items/supplies/strange_meat_item");
			tile.Items.push(item);
			tile.IsContainingItems = true;
			item.m.Tile = tile;
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

	function updateLook()
	{
		::World.State.getPlayer().getSprite("body").setBrush("figure_player_9990");
	}

});

