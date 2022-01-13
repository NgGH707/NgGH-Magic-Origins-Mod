this.geomancer_trio_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {
		Look = 9998,
	},
	function create()
	{
		this.m.ID = "scenario.geomancer_trio";
		this.m.Name = "Geomancer Trio";
		this.m.Description = "[p=c][img]gfx/ui/events/event_153.png[/img][/p]A trio of geomancers who are expert of controlling and commanding the earth.\n\n[color=#bcad8c]Geomancer:[/color] Start with three geomancers with each possesses incredible powers.\n[color=#bcad8c]Pocket Sand:[/color] All southern recruit can throw sand at enemy\'s face.\n[color=#bcad8c]Three Best Friends:[/color] If all of your three starting geomancers should die, your campaign ends.";
		this.m.Difficulty = 2;
		this.m.Order = 101;
		this.m.StartingBusinessReputation = 200;
		this.m.StartingRosterTier = this.Const.Roster.getTierForSize(8);
		this.setRosterReputationTiers(this.Const.Roster.createReputationTiers(this.m.StartingBusinessReputation));
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();
		local names = [];

		for( local i = 0; i < 3; i = ++i )
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.setStartValuesEx([
				"geomancer_background"
			]);
			bro.getSprite("miniboss").setBrush("bust_miniboss");
			bro.getBackground().addPerk(this.Const.Perks.PerkDefs.LegendThrowSand);
			bro.getSkills().removeByID("trait.survivor");
			bro.getSkills().removeByID("trait.greedy");
			bro.getSkills().removeByID("trait.loyal");
			bro.getSkills().removeByID("trait.disloyal");
			bro.getSkills().add(this.new("scripts/skills/perks/perk_legend_throw_sand"));
			bro.getSkills().add(this.new("scripts/skills/traits/player_character_trait"));
			bro.getFlags().set("IsPlayerCharacter", true);
			bro.m.PerkPoints = 0;
			bro.m.LevelUps = 0;
			bro.m.Level = 1;
			bro.m.XP = this.Const.LevelXP[0];
			bro.setVeteranPerks(2);
			bro.m.HireTime = this.Time.getVirtualTimeF();

			while (names.find(bro.getNameOnly()) != null)
			{
				bro.setName(this.Const.Strings.SouthernNames[this.Math.rand(0, this.Const.Strings.SouthernNames.len() - 1)]);
			}

			names.push(bro.getNameOnly());
		}

		local bros = roster.getAll();
		bros[0].getBackground().m.RawDescription = "{He starts out as a fool who knew nothing about geomancy and now he is more than capable of raising a hill in the middle of a plain. Now who dares to call him as a good-for-nothing mage.}";
		bros[0].setPlaceInFormation(3);
		
		//--------
		bros[1].getBackground().m.RawDescription = "{Studying about mineral and geomancy at a youth. He has never stopped improving his understanding about the earth and the world, the wisest man in the trio.}";
		bros[1].setPlaceInFormation(4);
		bros[1].m.PerkPoints = 1;
		bros[1].m.LevelUps = 1;
		bros[1].m.Level = 2;
		bros[1].m.XP = this.Const.LevelXP[1];
		
		//--------
		bros[2].getBackground().m.RawDescription = "{He once told to be a member of a secret organization. His past is still a mystery, but his skill in geomancy is splenlid to say the least. At best, don\'t you dare asking about his past or a mountain will be your grave.}";
		bros[2].setPlaceInFormation(5);
		
		this.World.Assets.m.Money += 500;
		this.World.Assets.m.ArmorParts = this.World.Assets.m.ArmorParts / 1.2;
		this.World.Assets.m.Ammo = this.World.Assets.m.Ammo * 2;
		this.World.Assets.addBusinessReputation(this.m.StartingBusinessReputation);
		this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() + 10);
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/dried_lamb_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/wine_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/loot/ornate_tome_item"));
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isIsolatedFromRoads() && randomVillage.isSouthern() && randomVillage.hasBuilding("building.arena"))
			{
				break;
			}

			i = ++i;
		}

		if (randomVillage.hasBuilding("building.arena"))
		{
			randomVillage.addSituation(this.new("scripts/entity/world/settlements/situations/arena_tournament_situation"));
		}

		local randomVillageTile = randomVillage.getTile();

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 1), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 1));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 1), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 1));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) == 0)
				{
				}
				else if (!tile.HasRoad)
				{
				}
				else
				{
					randomVillageTile = tile;
					break;
				}
			}
		}
		while (1);

		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(9998);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList(this.Const.Music.CivilianTracks, this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.geomancer_trio_scenario_intro");
		}, null);
	}

	function onInit()
	{
		this.starting_scenario.onInit();
		this.World.Assets.m.ExtraLootChance += 33;
		this.World.Assets.m.RosterSizeAdditionalMin = 3,
		this.World.Assets.m.RosterSizeAdditionalMax = 5;
	}

	function updateLook()
	{
		this.World.State.getPlayer().getSprite("body").setBrush("figure_player_" + this.m.Look);
	}

	function onHiredByScenario( bro )
	{
		if (bro.m.Ethnicity != 1)
		{
			return;
		}

		bro.improveMood(0.5, "Learn how to play dirty");
		bro.getBackground().addPerk(this.Const.Perks.PerkDefs.LegendThrowSand);
		bro.getSkills().add(this.new("scripts/skills/perks/perk_legend_throw_sand"));
	}

	function onCombatFinished()
	{
		local roster = this.World.getPlayerRoster().getAll();
		local geomancer = 0;

		foreach( bro in roster )
		{
			if (bro.getFlags().get("IsPlayerCharacter"))
			{
				geomancer = ++geomancer;
				geomancer = geomancer;
			}
		}

		if (geomancer == 2 && !this.World.Flags.get("GeomancersOriginDeath2"))
		{
			this.World.Flags.set("GeomancersOriginDeath2", true);

			foreach( bro in roster )
			{
				if (bro.getFlags().get("IsPlayerCharacter"))
				{
					bro.getBackground().m.RawDescription = "{%fullname% is somber about the passing of a good friend, but he looks to the future knowing that he has someone behind him at all times. Behind him in a brotherly way, that is. And spiritually. Brotherly and spiritually, only.}";
					bro.getBackground().buildDescription(true);
				}
			}
		}
		else if (geomancer == 1 && !this.World.Flags.get("GeomancersOriginDeath1"))
		{
			this.World.Flags.set("GeomancersOriginDeath1", true);

			foreach( bro in roster )
			{
				if (bro.getFlags().get("IsPlayerCharacter"))
				{
					bro.getBackground().m.RawDescription = "{You should know something, captain. I\'m glad you stay out of the fray. I haven\'t felt this alive in what must be ten years. And if you see me out there about to go down, you stay right where you are, because I\'ll be right where I want to be.}";
					bro.getBackground().buildDescription(true);
				}
			}
		}

		return geomancer != 0;
	}
	
});

