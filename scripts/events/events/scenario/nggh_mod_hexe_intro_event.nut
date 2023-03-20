this.nggh_mod_hexe_intro_event <- ::inherit("scripts/events/event", {
	m = {
		Hexe = null
	},
	function create()
	{
		this.m.ID = "event.hexe_intro_event";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]Human greed is such the foulest thing. You can\'t never satisfy it, the more you obtain the more you want. Money, lust, authority is what a common human wants, but what if you want something else, Power. %witch% is an example of that greed, she want beauty, she want power. So she has learned about witchcraft and abandoned her own humanity to obtain this power. She is powerful, she knows no other hexe could have power as she is. But her last wish has never been fulfilled and so this grand ritual was prepared to grant her that wish. A beauty that can enthrall any women or men is what she would get once this ritual succeeds.\n\nEverything is going as she planned, or it should have been liked that. As %witch% looks to the right side, a rain of arrows fly through the night sky. %witch% blocks the arrows with her magic, she can no longer keep her calm, she is under attacked. Who are they? Mercenaries? Those lots from that noble house? The ritual mustn\'t be interrupted. But the reality is far from what she wanted, she starts wailing for all her plan has gone smoke or is it? %SPEECH_ON%No mercy! Let\'s their blood pay for their foolish actions. Kill every last one of them, my slaves!%SPEECH_OFF%Hearing their master order, countless beasts and human charge straight at enemy formation. A bloody battle starts now.",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Those fools! How dare you underestimate my power!",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + ::World.Assets.getBanner() + "s.png";
			}

		});
		
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_132.png[/img]The battle was soon ended in the most bloodiest way and because of it, the ritual was incomplete. Though %witch% is still granted a charming beauty but she also be punished for failing the ritual. She has been cursed, her beauty isn\'t perfect and now a voice keeps whispering in her ear. %SPEECH_ON%Seven days, prepare the offerings or your life shall be damned!%SPEECH_OFF%Within %witch%\'s sight, there are nothing but a bloody battlefield. This is a curse, this is not what she want. After that battle, most of her slaves have fallen and with this curse her power is also weaken. %SPEECH_ON%No! No! No! How can this be? I have lost everything. How on earth I can  prepare another ritual?%SPEECH_OFF%She knew it is impossible to prepare the offerings without making a big fuss in some village. This isn\'t good, they will send troops if she makes a rash move. But with a fews hours past, %witch% finds a solution. Founding a mercenary company as a disguise, it will surely lessen the suspicious from outsider and with carefully planned move she can collect the offerings.", 
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "The clock is ticking.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Hexe.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "The Hexe";
		
		foreach (b in ::World.getPlayerRoster().getAll())
		{
			if (b.getBackground().getID() == "background.hexe" || b.getFlags().has("Hexe"))
			{
				this.m.Hexe = b;
				break;
			}
		}
	}

	function onPrepareVariables( _vars )
	{
		local hexe;
		
		foreach (b in ::World.getPlayerRoster().getAll())
		{
			if (b.getBackground().getID() == "background.hexe_commander" || b.getFlags().has("Hexe"))
			{
				hexe= b;
				break;
			}
		}
		
		if (hexe == null)
		{
			_vars.push([
				"witch",
				"Ariel"
			]);
		}
		else
		{
			_vars.push([
				"witch",
				hexe.getNameOnly()
			]);
		}
	}

	function onClear()
	{
	}

});

