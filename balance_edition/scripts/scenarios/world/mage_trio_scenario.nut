this.mage_trio_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.mage_trio";
		this.m.Name = "Mage Trio";
		this.m.Description = "[p=c][img]gfx/ui/events/event_76.png[/img][/p]A trio of mages begin their adventure to seek true wisdom.\n\n[color=#bcad8c]It\'s magic:[/color] Start with three unique mages with each possesses extraordinary powers.\n[color=#bcad8c]Runestone:[/color] Start with a runestone, you can choose one of four types.\n[color=#bcad8c]Mage Guild:[/color] Mage recruits cost less to hire and demand lower wage.";
		this.m.Difficulty = 3;
		this.m.Order = 101;
		this.m.StartingBusinessReputation = 50;
		this.m.StartingRosterTier = this.Const.Roster.getTierForSize(10);
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
			bro.m.HireTime = this.Time.getVirtualTimeF();

			while (names.find(bro.getNameOnly()) != null)
			{
				bro.setName(this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
			}

			names.push(bro.getNameOnly());
		}

		//-------
		local bros = roster.getAll();
		bros[0].setStartValuesEx([
			"battlemage_background"
		]);
		bros[0].setTitle("Tri-Arts");
		bros[0].getSprite("miniboss").setBrush("bust_miniboss_lone_wolf");
		bros[0].setPlaceInFormation(4);
		bros[0].getSkills().removeByID("trait.disloyal");
		bros[0].getSkills().removeByID("trait.greedy");
		bros[0].m.PerkPoints = 0;
		bros[0].m.LevelUps = 0;
		bros[0].m.Level = 1;
		bros[0].m.XP = this.Const.LevelXP[0];
		bros[0].setVeteranPerks(2);
		
		//-------
		bros[1].setStartValuesEx([
			"elementalist_background"
		]);
		bros[1].setTitle("the All-Powerful");
		bros[1].getSprite("miniboss").setBrush("bust_miniboss_lone_wolf");
		bros[1].setPlaceInFormation(3);
		bros[1].getSkills().removeByID("trait.disloyal");
		bros[1].getSkills().removeByID("trait.greedy");
		bros[1].m.PerkPoints = 0;
		bros[1].m.LevelUps = 0;
		bros[1].m.Level = 1;
		bros[1].m.XP = this.Const.LevelXP[0];
		bros[1].setVeteranPerks(2);
		
		//-------
		bros[2].setStartValuesEx([
			"diabolist_background"
		]);
		bros[2].getSprite("miniboss").setBrush("bust_miniboss");
		bros[2].setPlaceInFormation(5);
		bros[2].getSkills().removeByID("trait.disloyal");
		bros[2].getSkills().removeByID("trait.greedy");
		bros[2].m.PerkPoints = 0;
		bros[2].m.LevelUps = 0;
		bros[2].m.Level = 1;
		bros[2].m.XP = this.Const.LevelXP[0];
		bros[2].setVeteranPerks(2);
		
		this.World.Assets.m.Money += 500;
		this.World.Assets.m.Ammo = this.World.Assets.m.Ammo / 2;
		this.World.Assets.m.Medicine += 5;
		this.World.Assets.addBusinessReputation(this.m.StartingBusinessReputation);
		this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() + 20);
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/goat_cheese_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/preserved_mead_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/dried_fruits_item"));
		
		if (this.LegendsMod.Configs().LegendArmorsEnabled())
		{
			this.World.Assets.getStash().add(this.new("scripts/items/legend_armor/armor_upgrades/legend_protective_runes_upgrade"));
		}
		else
		{
			this.World.Assets.getStash().add(this.new("scripts/items/armor_upgrades/protective_runes_upgrade"));
		}
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isIsolatedFromRoads() && ((!randomVillage.isMilitary() && randomVillage.getSize() >= 3) || randomVillage.isMilitary()))
			{
				break;
			}
		}

		local randomVillageTile = randomVillage.getTile();
		randomVillage.addSituation(this.new("scripts/entity/world/settlements/situations/mc_wandering_mage_situation"));
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 8), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 8));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 8), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 8));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.IsOccupied)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) <= 5)
				{
				}
				else if (!tile.HasRoad)
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

		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(9999);
		this.World.State.getPlayer().getSprite("body").setBrush("figure_player_9999");
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList(this.Const.Music.CivilianTracks, this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.magic_trio_scenario_intro");
		}, null);
	}

	function onInit()
	{
		this.starting_scenario.onInit();
		this.World.Assets.m.ChampionChanceAdditional += 3;
		this.World.Assets.m.XPMult *= 1.15;
		this.World.Assets.updateLook(9999);
	}

	function onUpdateHiringRoster( _roster )
	{
		local list = _roster.getAll();

		foreach (i, bro in list) 
		{
		    if (bro.getFlags().getAsInt("mc_mage") == 0)
		    {
		    	continue;
		    }

	    	bro.m.HiringCost = this.Math.ceil(bro.m.HiringCost * 0.5);
	    	bro.getBackground().m.DailyCostMult *= 0.5;
		}
	}
	
});

