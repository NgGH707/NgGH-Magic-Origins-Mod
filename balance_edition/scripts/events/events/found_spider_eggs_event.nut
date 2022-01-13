this.found_spider_eggs_event <- this.inherit("scripts/events/event", {
	m = {
		Spider = null,
		JustRecruit = 0,
		Egg = null,
		SpiderRecruit = null,
		Count = 0,
	},
	function create()
	{
		this.m.ID = "event.found_spider_eggs";
		this.m.Title = "Deep in the forest...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_110.png[/img]%guide% seems to know this forest, it's behavior suggesting you follow it. As %guide% stops, you can tell this place must be one of the darkest places in the forest. You can see in the dark distance giant spiders the same as %guide% scuttling all over the place. They don't come at you as if somehow recognizing you as one of their own. While most of them act like you don't even exist a few would seem to follow %guide%. They seem willing to join your company.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Time to go back",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				this.Characters.push(_event.m.Spider.getImagePath());
				
				if (_event.m.SpiderRecruit == null && _event.m.Count < 5)
				{
					_event.m.SpiderRecruit = roster.create("scripts/entity/tactical/player_beast/spider_player");
					_event.m.SpiderRecruit.improveMood(1.0, "Found a new queen");
					_event.m.SpiderRecruit.setScenarioValues();
					_event.m.SpiderRecruit.onHired();
				}
				
				if (_event.m.SpiderRecruit != null && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
				{
					Options.insert(0, {
						Text = "We always need one more Webknecht",
						function getResult( _event )
						{
							this.World.getPlayerRoster().add(_event.m.SpiderRecruit);
							_event.m.SpiderRecruit = null;
							_event.m.JustRecruit = 1;
							_event.m.Count += 1; 
							return "A";
						}

					});
				}

				if (_event.m.Egg != null && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
				{
					Options.insert(0, {
						Text = "A Webknecht Hive is certainly useful",
						function getResult( _event )
						{
							this.World.getPlayerRoster().add(_event.m.Egg);
							_event.m.Egg = null;
							_event.m.JustRecruit = 2;
							return "A";
						}
					});
					
					this.Characters.push(_event.m.Egg.getImagePath());
				}

				this.List.push({
					id = 4,
					icon = "ui/icons/asset_brothers.png",
					text = "Your roster: [color=" + this.Const.UI.Color.PositiveValue + "]" + this.World.getPlayerRoster().getSize() + "[/color]/[color=" + this.Const.UI.Color.NegativeValue + "]" + this.World.Assets.getBrothersMax() + "[/color]",
				});
				
				if (_event.m.JustRecruit == 2)
				{
					this.List.push({
						id = 4,
						icon = "ui/orientation/spider_02_orientation.png",
						text = "A Webknecht Hive has joined the " + this.World.Assets.getName(),
					});
				}
				else if (_event.m.JustRecruit == 1)
				{
					this.List.push({
						id = 4,
						icon = "ui/orientation/spider_01_orientation.png",
						text = "A Webknecht has joined the " + this.World.Assets.getName() + " (" + _event.m.Count + ")",
					});
				}
				
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 10)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}
		
		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}
		
		local brothers = this.World.getPlayerRoster().getAll();
		local hasSpider = false;
		local totalEggs = 0;

		foreach( bro in brothers )
		{
			if (bro.getFlags().has("egg"))
			{
				++totalEggs;
			}
			
			if (bro.getFlags().has("spider"))
			{
				hasSpider = true;
			}
		}
		
		if (!hasSpider)
		{
			return;
		}
		
		if (totalEggs >= 5)
		{
			return;
		}

		this.m.Score = 150 - totalEggs * 30;
	}

	function onPrepare()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local roster = this.World.getTemporaryRoster();
		roster.clear();
		local candidates = [];
		
		foreach( bro in brothers )
		{
			if (bro.getFlags().has("spider"))
			{
				candidates.push(bro);
			}
		}
		
		this.m.Spider = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Egg = roster.create("scripts/entity/tactical/player_beast/spider_eggs_player");
		this.m.Egg.m.HireTime = this.Time.getVirtualTimeF();
		this.m.Egg.improveMood(1.0, "..........");
		this.m.Egg.setScenarioValues();
		this.m.SpiderRecruit = roster.create("scripts/entity/tactical/player_beast/spider_player");
		this.m.SpiderRecruit.improveMood(1.0, "Found a new queen");
		this.m.SpiderRecruit.setScenarioValues();
		this.m.SpiderRecruit.onHired();
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"guide",
			this.m.Spider.getName()
		]);
	}

	function onClear()
	{
		this.m.JustRecruit = 0;
		this.m.Egg = null;
		this.m.Spider = null;
		this.m.SpiderRecruit = null;
		this.m.Count = 0;
	}

});

