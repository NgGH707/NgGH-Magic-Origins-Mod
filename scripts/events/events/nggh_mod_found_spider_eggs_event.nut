this.nggh_mod_found_spider_eggs_event <- ::inherit("scripts/events/event", {
	m = {
		Egg = null,
		Spider = null,
		SpiderRecruit = null,
		JustRecruit = 0,
		Count = 0,
	},
	function create()
	{
		this.m.ID = "event.found_spider_eggs";
		this.m.Title = "Deep in the forest...";
		this.m.Cooldown = 45.0 * ::World.getTime().SecondsPerDay;
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
						::World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = ::World.getTemporaryRoster();
				this.Characters.push(_event.m.Spider.getImagePath());
				
				if (_event.m.SpiderRecruit == null && _event.m.Count < 5)
				{
					_event.m.SpiderRecruit = roster.create("scripts/entity/tactical/player_beast/nggh_mod_spider_player");
					_event.m.SpiderRecruit.improveMood(1.0, "Found a new queen");
					_event.m.SpiderRecruit.setStartValuesEx();
				}
				
				if (_event.m.SpiderRecruit != null && ::World.getPlayerRoster().getSize() < ::World.Assets.getBrothersMax())
				{
					Options.insert(0, {
						Text = "We always need one more Webknecht",
						function getResult( _event )
						{
							::World.getPlayerRoster().add(_event.m.SpiderRecruit);
							_event.m.SpiderRecruit.onHired();
							_event.m.SpiderRecruit = null;
							_event.m.JustRecruit = 1;
							_event.m.Count += 1; 
							return "A";
						}

					});
				}

				if (_event.m.Egg != null && ::World.getPlayerRoster().getSize() < ::World.Assets.getBrothersMax())
				{
					Options.insert(0, {
						Text = "Webknecht Eggs are certainly useful",
						function getResult( _event )
						{
							::World.getPlayerRoster().add(_event.m.Egg);
							_event.m.Egg.onHired();
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
					text = "Your roster: [color=" + ::Const.UI.Color.PositiveValue + "]" + ::World.getPlayerRoster().getSize() + "[/color]/[color=" + ::Const.UI.Color.NegativeValue + "]" + ::World.Assets.getBrothersMax() + "[/color]",
				});
				
				if (_event.m.JustRecruit == 2)
				{
					this.List.push({
						id = 4,
						icon = "ui/orientation/spider_02_orientation.png",
						text = "Webknecht Eggs have joined the " + ::World.Assets.getName(),
					});
				}
				else if (_event.m.JustRecruit == 1)
				{
					this.List.push({
						id = 4,
						icon = "ui/orientation/spider_01_orientation.png",
						text = "A Webknecht has joined the " + ::World.Assets.getName() + " (" + _event.m.Count + ")",
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (::World.getTime().Days < 25)
		{
			return;
		}

		if ([
			::Const.World.TerrainType.Forest,
			::Const.World.TerrainType.LeaveForest,
			::Const.World.TerrainType.AutumnForest
		].find(::World.State.getPlayer().getTile().Type) == null)
		{
			return;
		}
		
		if (::World.getPlayerRoster().getSize() >= ::World.Assets.getBrothersMax())
		{
			return;
		}
		
		local hasSpider = false;
		local totalEggs = 0;

		foreach( bro in ::World.getPlayerRoster().getAll() )
		{
			if (bro.getFlags().has("spider"))
			{
				hasSpider = true;
				continue;
			}

			if (bro.getFlags().has("egg"))
			{
				++totalEggs;
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

		this.m.Score = 120 - totalEggs * 25;
	}

	function onPrepare()
	{
		local roster = ::World.getTemporaryRoster();
		roster.clear();
		local candidates = [];
		
		foreach( bro in ::World.getPlayerRoster().getAll() )
		{
			if (bro.getFlags().has("spider"))
			{
				candidates.push(bro);
			}
		}
		
		this.m.Spider = ::MSU.Array.rand(candidates);

		this.m.Egg = roster.create("scripts/entity/tactical/player_beast/nggh_mod_spider_eggs_player");
		this.m.Egg.improveMood(1.0, "..........");
		this.m.Egg.setStartValuesEx();

		this.m.SpiderRecruit = roster.create("scripts/entity/tactical/player_beast/nggh_mod_spider_player");
		this.m.SpiderRecruit.improveMood(1.0, "Found a new queen");
		this.m.SpiderRecruit.setStartValuesEx();
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

