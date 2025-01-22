::Nggh_MagicConcept.HooksMod.hook("scripts/events/events/dlc2/location/kraken_cult_enter_event", function (q) 
{
	q.onDetermineStartScreen = @(__original) function()
	{
		return ::World.Flags.get("IsKrakenOrigin") ? "H" : __original();
	}

	q.create = @(__original) function()
	{
		__original();

		// add new screen
		m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_103.png[/img]{You watch as one of the helpers suddenly lifts into the air, and in the green light you see the slick tentacle drag him backward and it seems as though the earth itself opens up, and a thousand wet boughs and branches crinkle and drip, and rows upon rows of fangs bristle, clattering against one another as though shouldering for a slice, and the helper is thrown into it the maw and the gums twist and he is disrobed and defleshed and delimbed and destroyed. The woman chomps on another mushroom and then her hands caress bulbs of green, and you can see the tentacles slithering beneath each.%SPEECH_ON%Join us, sellsword! Let the Beast of Beasts have its feast!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s Duel!",
					function getResult( _event )
					{
						::World.State.getLastLocation().setFaction(::World.FactionManager.getFactionOfType(::Const.FactionType.Beasts).getID());
						::World.Events.showCombatDialog(false, true, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}
	
});