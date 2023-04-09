this.nggh_mod_simps_fight_each_other_event <- ::inherit("scripts/events/event", {
	m = {
		Hexe = null,
		Simp1 = null,
		Simp2 = null,
	},
	function create()
	{
		this.m.ID = "event.simps_fight_each_other";
		this.m.Title = "During camp...";
		this.m.Cooldown = 31.0 * ::World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_06.png[/img]A series of shouting followed by a loud noise likes some drunkard fighting in a tarven. At first you , %hexe%, pay no heed for such thing but as a few minutes past, you doubt this ruckus will end anytime soon or atleast there will be no death. You leave your tent to see that what is going on. %randomsimp1% and %randomsimp2% are fighting. A scene looks nothing but ferocious animals figthing for domination or so as you think. Some people try to intervene and fail, some are watching with great interest.%SPEECH_ON%What is the meaning of this? Stop this maddness right away, you morons!%SPEECH_OFF%Everyone quitely look at your direction, %randomsimp1% and %randomsimp2% stop fighting then stare at you with a look of children going to be scolded. The two start to explain the reason the fight, you keep on a stern look while listening to what they have to say. You silent think:%SPEECH_ON%These fools fight just because of that. Who is more adored by me? Such simple mind, no wonder why they fall for my charm so easily. What should i do now? Name one of them to end this?%SPEECH_OFF%%hexe% smiles.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				/*
				{
					Text = "Quit this nonsense and get back to work.",
					function getResult( _event )
					{
						return 0;
					}

				},
				*/
				{
					Text = "You\'re both wrong, i dislike both of you.",
					function getResult( _event )
					{
						return "RejectAll";
					}

				},
				{
					Text = "%randomsimp1% is my favourite, everyone know that.",
					function getResult( _event )
					{
						return "ChooseSimp1";
					}

				},
				{
					Text = "Come here %randomsimp2%, my love!",
					function getResult( _event )
					{
						return "ChooseSimp2";
					}

				},
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Simp1.getImagePath());
				this.Characters.push(_event.m.Simp2.getImagePath());
				local injuries = [
					{
						ID = "injury.crushed_finger",
						Threshold = 0.25,
						Script = "injury/crushed_finger_injury"
					},
					{
						ID = "injury.bruised_leg",
						Threshold = 0.25,
						Script = "injury/bruised_leg_injury"
					},
					{
						ID = "injury.broken_nose",
						Threshold = 0.25,
						Script = "injury/broken_nose_injury"
					},
					{
						ID = "injury.grazed_neck",
						Threshold = 0.25,
						Script = "injury/grazed_neck_injury"
					},
					{
						ID = "injury.stabbed_guts",
						Threshold = 0.5,
						Script = "injury/stabbed_guts_injury"
					},
					{
						ID = "injury.injured_shoulder",
						Threshold = 0.25,
						Script = "injury/injured_shoulder_injury"
					}
				];

				local injury = _event.m.Simp1.addInjury(injuries);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Simp1.getName() + " suffers " + injury.getNameOnly()
				});

				injury = _event.m.Simp2.addInjury(injuries);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Simp2.getName() + " suffers " + injury.getNameOnly()
				});
			}

		});
		this.m.Screens.push({
			ID = "ChooseSimp1",
			Text = "[img]gfx/ui/events/event_85.png[/img]%randomsimp1% has a smirk on his face, then goes as hard as he can to make fun of %randomsimp2%. Everyone quickly follow suit to have a part of this new game. Satisfied with the scene upon your eyes, you return to your tent with %randomsimp1% follow close by.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "This\'s fun",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Simp1.getImagePath());
				local up = _event.increaseSimpLevel(_event.m.Simp1);
				local down = _event.decreaseSimpLevel(_event.m.Simp2);

				if (up != null)
				{
					this.List.push({
						id = 10,
						icon = up.getIcon(),
						text = _event.m.Simp1.getName() + "\'s simp level has increased"
					});
				}

				_event.m.Simp1.improveMood(1.0, _event.m.Hexe.getName() + " loves me");
				
				this.List.push({
					id = 10,
					icon = ::Const.MoodStateIcon[_event.m.Simp1.getMoodState()],
					text = _event.m.Simp1.getName() + ::Const.MoodStateEvent[_event.m.Simp1.getMoodState()]
				});

				if (down != null)
				{
					this.List.push({
						id = 10,
						icon = down.getIcon(),
						text = _event.m.Simp2.getName() + " is heart broken"
					});
				}

				_event.m.Simp2.worsenMood(2.5, "Heart broken by " + _event.m.Hexe.getName() + " words");

				this.List.push({
					id = 10,
					icon = ::Const.MoodStateIcon[_event.m.Simp2.getMoodState()],
					text = _event.m.Simp2.getName() + ::Const.MoodStateEvent[_event.m.Simp2.getMoodState()]
				});

				_event.m.Hexe.improveMood(1.0, "Have fun with the feelings of some fools");

				this.List.push({
					id = 10,
					icon = ::Const.MoodStateIcon[_event.m.Hexe.getMoodState()],
					text = _event.m.Hexe.getName() + ::Const.MoodStateEvent[_event.m.Hexe.getMoodState()]
				});
			}

		});
		this.m.Screens.push({
			ID = "ChooseSimp2",
			Text = "[img]gfx/ui/events/event_85.png[/img]%randomsimp2% has a smirk on his face, then goes as hard as he can to make fun of %randomsimp1%. Everyone quickly follow suit to have a part of this new game. Satisfied with the scene upon your eyes, you return to your tent with %randomsimp2% follow close by.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "This\'s fun",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Simp2.getImagePath());
				local up = _event.increaseSimpLevel(_event.m.Simp2);
				local down = _event.decreaseSimpLevel(_event.m.Simp1);

				if (up != null)
				{
					this.List.push({
						id = 10,
						icon = up.getIcon(),
						text = _event.m.Simp2.getName() + "\'s simp level has increased"
					});
				}

				_event.m.Simp2.improveMood(1.0, _event.m.Hexe.getName() + " loves me");
				
				this.List.push({
					id = 10,
					icon = ::Const.MoodStateIcon[_event.m.Simp2.getMoodState()],
					text = _event.m.Simp2.getName() + ::Const.MoodStateEvent[_event.m.Simp2.getMoodState()]
				});

				if (down != null)
				{
					this.List.push({
						id = 10,
						icon = down.getIcon(),
						text = _event.m.Simp1.getName() + " is heart broken"
					});
				}

				_event.m.Simp1.worsenMood(2.5, "Heart broken by " + _event.m.Hexe.getName() + " words");

				this.List.push({
					id = 10,
					icon = ::Const.MoodStateIcon[_event.m.Simp1.getMoodState()],
					text = _event.m.Simp1.getName() + ::Const.MoodStateEvent[_event.m.Simp1.getMoodState()]
				});

				_event.m.Hexe.improveMood(1.0, "Have fun with the feelings of some fools");

				this.List.push({
					id = 10,
					icon = ::Const.MoodStateIcon[_event.m.Hexe.getMoodState()],
					text = _event.m.Hexe.getName() + ::Const.MoodStateEvent[_event.m.Hexe.getMoodState()]
				});
			}

		});
		this.m.Screens.push({
			ID = "RejectAll",
			Text = "[img]gfx/ui/events/event_120.png[/img]%hexe% words like cold water splash at both %randomsimp1% and %randomsimp2% face. They look around and see only pity glares, humiliating themselves with such a fight.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Will they fight again?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Hexe.getImagePath());
				local down;

				if (::Math.rand(1, 100) <= 50)
				{
					down = _event.decreaseSimpLevel(_event.m.Simp1);

					if (down != null)
					{
						this.List.push({
							id = 10,
							icon = down.getIcon(),
							text = _event.m.Simp1.getName() + " is heart broken"
						});
					}

					_event.m.Simp1.worsenMood(2.5, "Heart broken by " + _event.m.Hexe.getName() + " words");
				}
				else 
				{
				    _event.m.Simp1.worsenMood(0.5, _event.m.Hexe.getName() + " dislikes me");
				}

				this.List.push({
					id = 10,
					icon = ::Const.MoodStateIcon[_event.m.Simp1.getMoodState()],
					text = _event.m.Simp1.getName() + ::Const.MoodStateEvent[_event.m.Simp1.getMoodState()]
				});

				if (::Math.rand(1, 100) <= 50)
				{
					down = _event.decreaseSimpLevel(_event.m.Simp2);

					if (down != null)
					{
						this.List.push({
							id = 10,
							icon = down.getIcon(),
							text = _event.m.Simp2.getName() + " is heart broken"
						});
					}

					_event.m.Simp2.worsenMood(2.5, "Heart broken by " + _event.m.Hexe.getName() + " words");
				}
				else 
				{
				    _event.m.Simp2.worsenMood(0.5, _event.m.Hexe.getName() + " dislikes me");
				}

				this.List.push({
					id = 10,
					icon = ::Const.MoodStateIcon[_event.m.Simp2.getMoodState()],
					text = _event.m.Simp2.getName() + ::Const.MoodStateEvent[_event.m.Simp2.getMoodState()]
				});

				_event.m.Hexe.improveMood(1.0, "Have fun with the feelings of some fools");

				this.List.push({
					id = 10,
					icon = ::Const.MoodStateIcon[_event.m.Hexe.getMoodState()],
					text = _event.m.Hexe.getName() + ::Const.MoodStateEvent[_event.m.Hexe.getMoodState()]
				});
			}

		});
	}
		

	function onUpdateScore()
	{
		local hasHexe = false;
		local simps = 0;

		foreach( bro in ::World.getPlayerRoster().getAll() )
		{
			if (bro.getFlags().has("Hexe"))
			{
				hasHexe = true;
				continue;
			}
			
			if (bro.getSkills().hasSkill("effects.simp"))
			{
				++simps;
				continue;
			}
		}

		if (!hasHexe || simps < 2)
		{
			return;
		}

		this.m.Score = simps * 20;
	}

	function onPrepare()
	{
		local hexen = [];
		local simps = [
			[],
			[],
			[],
			[],
			[]
		];

		foreach( bro in ::World.getPlayerRoster().getAll() )
		{
			if (bro.getFlags().has("Hexe"))
			{
				hexen.push(bro);
				continue;
			}
			
			local charm = bro.getSkills().getSkillByID("effects.simp");

			if (charm != null)
			{
				local lv = charm.getSimpLevel();

				if (lv > 3)
				{
					simps[4].push(bro);
				}
				else
				{
					simps[lv].push(bro);
				}
				
				continue;
			}
		}

		local candidates = [];
		this.m.Hexe = ::MSU.Array.rand(hexen);

		if (simps[0].len() > 0)
		{
			candidates.extend(simps[0]);
		}

		if (simps[1].len() > 0)
		{
			candidates.extend(simps[1]);
		}

		if (simps[2].len() > 0)
		{
			candidates.extend(simps[2]);
		}

		if (simps[3].len() > 0)
		{
			if (candidates.len() <= 10)
			{
				candidates.extend(simps[3]);
			}
			else if (::Math.rand(1, 100) <= 67)
			{
				candidates.extend(simps[3]);
			}
		}

		if (simps[4].len() > 0)
		{
			if (candidates.len() <= 10)
			{
				candidates.extend(simps[4]);
			}
			else if (::Math.rand(1, 100) <= 34)
			{
				candidates.extend(simps[4]);
			}
		}

		local r = ::Math.rand(0, candidates.len() - 1);
		this.m.Simp1 = candidates[r];
		candidates.remove(r);

		this.m.Simp2 = ::MSU.Array.rand(candidates);
	}

	function increaseSimpLevel( _bro )
	{
		local charm = _bro.getSkills().getSkillByID("effects.simp");
		charm.gainSimpLevel();
		return charm;
	}

	function decreaseSimpLevel( _bro )
	{
		local charm = _bro.getSkills().getSkillByID("effects.simp");
		charm.loseSimpLevel();
		return charm;
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hexe",
			this.m.Hexe.getName()
		]);
		_vars.push([
			"randomsimp1",
			this.m.Simp1 != null ? this.m.Simp1.getName() : ""
		]);
		_vars.push([
			"randomsimp2",
			this.m.Simp2 != null ? this.m.Simp2.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Hexe = null;
		this.m.Simp1 = null;
		this.m.Simp2 = null;
	}

});

