this.magic_trio_scenario_intro <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.magic_trio_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_54.png[/img]Three mages are on a journey to seek knowlegde. What could go possibly wrong? Let put that to the side and choose a runestone for you to start with.",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Lucky.",
					function getResult( _event )
					{
						_event.createRune(105);
						return 0;
					}

				},
				{
					Text = "Brimstone.",
					function getResult( _event )
					{
						_event.createRune(106);
						return 0;
					}

				},
				{
					Text = "Shielding.",
					function getResult( _event )
					{
						_event.createRune(100);
						return 0;
					}

				},
				{
					Text = "Repulsion.",
					function getResult( _event )
					{
						_event.createRune(103);
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

	function createRune( _variant )
	{
		if (this.LegendsMod.Configs().LegendArmorsEnabled() && (_variant == 100 || _variant == 103))
		{
			local rune = this.new("scripts/items/legend_helmets/runes/legend_rune_shielding");

			if (_variant == 103)
			{
				local rune = this.new("scripts/items/legend_armor/runes/legend_rune_repulsion");
			}

			rune.setRuneVariant(_variant);
			this.World.Assets.getStash().add(rune);
		}
		else
		{
			local rune = this.new("scripts/items/rune_sigils/legend_vala_inscription_token");
			rune.setRuneVariant(_variant);
			rune.updateRuneSigilToken();
			this.World.Assets.getStash().add(rune);
		}
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "Mage Trio";
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

