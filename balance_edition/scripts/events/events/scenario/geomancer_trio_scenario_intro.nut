this.geomancer_trio_scenario_intro <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.geomancer_trio_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_153.png[/img]The world is full of wonder to be found. Will these three best friends can always be side by side on their new adventure?",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Everything will be fine, right?",
					function getResult( _event )
					{
						return 0;
					}

				},
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "Geomancer Trio";
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

