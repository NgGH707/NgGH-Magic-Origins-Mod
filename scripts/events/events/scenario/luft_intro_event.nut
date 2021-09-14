this.luft_intro_event <- this.inherit("scripts/events/event", {
	m = {
		Luft = null,
	},
	function create()
	{
		this.m.ID = "event.luft_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_14.png[/img]%SPEECH_START%Greetings stranger! I\'m Luft.%SPEECH_OFF%%SPEECH_START%I\'d love to talk more about my hat and Legends mod but i\'m kinda hungry now. Would you kindly show me where I can have a good meal?%SPEECH_OFF%%SPEECH_START%Thanks! Such a good boy you are.%SPEECH_OFF%%SPEECH_START%Can i pet you?%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "No! But i will pet you",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Gimme a nice pet, daddy",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "I heard you eat discord member for lunch",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";

				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "The Skin Ghoul Mascot";
		
		local brothers = this.World.getPlayerRoster().getAll();
		
		foreach (b in brothers)
		{
			if (b.getFlags().has("luft"))
			{
				this.m.Luft = b;
				break;
			}
		}
	}

	function onPrepareVariables( _vars )
	{	
	}

	function onClear()
	{
	}

});

