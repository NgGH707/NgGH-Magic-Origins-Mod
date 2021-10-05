// a testing scenario, not an origin
this.nggh_dev_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.secret";
		this.m.Name = "Secret";
		this.m.Description = "[p=c][img]gfx/ui/events/event_103.png[/img][/p][p]How can you find this? You are not suppose to see this. Oh well! you earn this. Go ahead, try it!!!.\n\n[color=#bcad8c]Only You:[/color] Start with only one starter and the campaign will end if said starter dies.\n[color=#bcad8c]Beast of Beasts:[/color] As you can see you are a fearsome Kraken with unstoppable power.\n[color=#bcad8c]Stranger Thing:[/color] Your food spoils at much slower rate, don\'t ask why.\n[color=#c90000]Kaiju Fight:[/color] Have an epic battle with another Kraken at start, there is no turning back.[/p]";
		this.m.Difficulty = 1;
		this.m.Order = 0;
	}

	function isValid()
	{
		return this.AddedSecret;
	}

	function onInit()
	{
		this.starting_scenario.onInit();
		this.m.RosterTier = 1;
		this.World.Assets.m.VisionRadiusMult *= 1.5;
		this.World.Assets.m.FoodAdditionalDays += 5;
		this.World.Assets.m.ChampionChanceAdditional += 15;
		this.World.Assets.updateLook(9990);
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





























































	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();
		local kraken = roster.create("scripts/entity/tactical/minions/special/dev_files/kraken_player");
		kraken.setScenarioValues();
		kraken.setVeteranPerks(2);
		kraken.getBackground().m.RawDescription = "A true terror of the depth, has decided to start its hunt on the land of human. Time to hunt and kill, let your hunger be satiety with fresh prey.";
		kraken.getBackground().buildDescription(true);
		kraken.getSkills().removeByID("trait.survivor");
		kraken.getSkills().removeByID("trait.loyal");
		kraken.getSkills().removeByID("trait.disloyal");
		kraken.getSkills().removeByID("trait.greedy");
		kraken.setPlaceInFormation(13);
		kraken.m.HireTime = this.Time.getVirtualTimeF();
		kraken.getSprite("miniboss").setBrush("bust_miniboss");
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/strange_meat_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/strange_meat_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/strange_meat_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/strange_meat_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/legend_human_parts"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/legend_human_parts"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/legend_yummy_sausages"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/legend_yummy_sausages"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/legend_yummy_sausages"));
		this.World.Assets.m.Money = this.World.Assets.m.Money + 1000;
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() <= 1)
			{
				break;
			}
		}

		local randomVillageTile = randomVillage.getTile();
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 3), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 3));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 3), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 3));

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
		this.World.Assets.updateLook(9993);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.World.Flags.set("IsKrakenCultVisited", true);
		this.World.Flags.set("IsKrakenOrigin", true);
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList(this.Const.Music.ArenaTracks, this.Const.Music.CrossFadeTime);
		}, null);
	}

});

