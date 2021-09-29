this.luft_intro_event <- this.inherit("scripts/events/event", {
	m = {
		Luft = null,
		Food = null,
	},
	function create()
	{
		this.m.ID = "event.luft_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_12.png[/img]%SPEECH_START%Greetings stranger! I\'m Luft.%SPEECH_OFF%%SPEECH_START%I\'d love to talk more about my hat and Legends mod but i\'m kinda hungry now. Would you kindly show me where I can have a good meal?%SPEECH_OFF%%SPEECH_START%Thanks! Such a good boy you are.%SPEECH_OFF%%SPEECH_START%Can i pet you?%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "No! But i will pet you",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Gimme a nice pet, daddy",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Yes! And bless me with your wisdom",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "I heard you eat discord member for lunch",
					function getResult( _event )
					{
						local brothers = this.World.getPlayerRoster().getAll();
						foreach ( bro in brothers )
						{
							this.World.getPlayerRoster().remove(bro);
						}
						return 0;
					}

				},
				
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";

				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}

				this.Options.insert(2, {
					Text = "No! But i\'ll let you eat [color=#bcad8c]" + this.m.Food.getName() + "[/color]",
					function getResult( _event )
					{
						return "F";
					}

				});
			}

		});

		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_69.png[/img]",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "That\'s right! Who\'s the good Luft?",
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

				_event.m.Luft.improveMood(1.5, "Got a head pat");
				_event.m.Luft.getBaseProperties().Hitpoints += 10;
				_event.m.Luft.getSkills().update();
				
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Luft.getMoodState()],
					text = _event.m.Luft.getName() + this.Const.MoodStateEvent[_event.m.Luft.getMoodState()]
				});
				this.List.push({
					id = 17,
					icon = "ui/icons/health.png",
					text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+10[/color] Hitpoints"
				});

			}

		});

		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_85.png[/img]",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Love it",
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

				_event.m.Luft.improveMood(0.5, "I just pat someone");
				_event.m.Luft.addXP(500, false);
				
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Luft.getMoodState()],
					text = _event.m.Luft.getName() + this.Const.MoodStateEvent[_event.m.Luft.getMoodState()]
				});
				this.List.push({
					id = 17,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]500[/color] XP"
				});

			}

		});


		local wisdom1 = "%SPEECH_START%They say [color=#bcad8c]Ijirok[/color] can be charmed or just put IJIROK to the seed.%SPEECH_OFF%";
		local wisdom2 = "%SPEECH_START%I heard there is an ultimate [color=#bcad8c]Simp[/color] level earned by love and rejection.%SPEECH_OFF%";
		local wisdom3 = "%SPEECH_START%Necro used to tell me, Spider can guide you to their [color=#bcad8c]Nest[/color].%SPEECH_OFF%";
		local wisdom4 = "%SPEECH_START%A wise man once told me, [color=#bcad8c]Credits[/color] can lead you to secret.%SPEECH_OFF%";
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_40.png[/img]{" + wisdom1 + " | " + wisdom2 + " | " + wisdom3 + " | " + wisdom4 + "}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "How wise you\'re!",
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

				_event.m.Luft.improveMood(0.5, "Someone asked for my wisdom");
				_event.m.Luft.getBaseProperties().Bravery += 5;
				_event.m.Luft.getSkills().update();
				
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Luft.getMoodState()],
					text = _event.m.Luft.getName() + this.Const.MoodStateEvent[_event.m.Luft.getMoodState()]
				});
				this.List.push({
					id = 17,
					icon = "ui/icons/bravery.png",
					text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+5[/color] Resolve"
				});

			}

		});

		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_61.png[/img]%SPEECH_START%Thanks, man! It was delicious%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
				local option_text = "You\'re welcome Luft";
				local isTrolled = false;
				_event.m.Luft.improveMood(0.5, "Have a good meal");

				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}

				switch (this.m.Food.getID()) 
				{
				case "supplies.legend_yummy_sausages":
					_event.m.Luft.getBaseProperties().Hitpoints += 5;
					_event.m.Luft.getBaseProperties().MeleeSkill += 3;
					this.List.extend([
						{
							id = 17,
							icon = "ui/icons/health.png",
							text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+5[/color] Hitpoints"
						},
						{
							id = 17,
							icon = "ui/icons/melee_skill.png",
							text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+3[/color] Melee Skill"
						},
					]);
					break;
				
				case "supplies.goat_cheese":
					_event.m.Luft.getBaseProperties().Hitpoints += 5;
					_event.m.Luft.getBaseProperties().Resolve += 2;
					this.List.extend([
						{
							id = 17,
							icon = "ui/icons/health.png",
							text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+5[/color] Hitpoints"
						},
						{
							id = 17,
							icon = "ui/icons/bravery.png",
							text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Resolve"
						},
					]);
					break;

				case "supplies.legend_pie":
					_event.m.Luft.getBaseProperties().Hitpoints += 5;
					_event.m.Luft.getBaseProperties().Stamina += 5;
					this.List.extend([
						{
							id = 17,
							icon = "ui/icons/health.png",
							text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+5[/color] Hitpoints"
						},
						{
							id = 17,
							icon = "ui/icons/fatigue.png",
							text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+7[/color] Fatigue"
						},
					]);
					break;

				case "supplies.strange_meat":
					this.Text = "[img]gfx/ui/events/event_14.png[/img]%SPEECH_START%Hmm yes! I hope this is not rat meat%SPEECH_OFF%";
					op_text = "It\'s rat meat";
					isTrolled = true;
					_event.m.Luft.getBaseProperties().Hitpoints += 2;
					_event.m.Luft.getBaseProperties().Bravery += 2;
					_event.m.Luft.getBaseProperties().Stamina += 2;
					_event.m.Luft.getBaseProperties().Initiative += 2;
					_event.m.Luft.getBaseProperties().MeleeSkill += 2;
					_event.m.Luft.getBaseProperties().RangedSkill += 2;
					_event.m.Luft.getBaseProperties().MeleeDefense += 2;
					_event.m.Luft.getBaseProperties().RangedDefense += 2;
					this.List.extend([
						{
							id = 17,
							icon = "ui/icons/health.png",
							text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Hitpoints"
						},
						{
							id = 17,
							icon = "ui/icons/bravery.png",
							text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Resolve"
						},
						{
							id = 17,
							icon = "ui/icons/fatigue.png",
							text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Fatigue"
						},
						{
							id = 17,
							icon = "ui/icons/initiative.png",
							text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Initiative"
						},
						{
							id = 17,
							icon = "ui/icons/melee_skill.png",
							text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Melee Skill"
						},
						{
							id = 17,
							icon = "ui/icons/ranged_skill.png",
							text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Ranged Skill"
						},
						{
							id = 17,
							icon = "ui/icons/melee_defense.png",
							text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Melee Defense"
						},
						{
							id = 17,
							icon = "ui/icons/ranged_defense.png",
							text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Ranged Defense"
						},
					]);
					break;
				}
				
				this.List.insert(0, {
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Luft.getMoodState()],
					text = _event.m.Luft.getName() + this.Const.MoodStateEvent[_event.m.Luft.getMoodState()]
				});
				_event.m.Luft.getSkills().update();

				this.Options.push({
					Text = option_text,
					function getResult( _event )
					{
						if (isTrolled)
						{
							_event.m.Luft.worsenMood(1.5, "Someone fed me with rat meat");
						}

						return 0;
					}

				});

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

		local foods = [
			"strange_meat_item",
			"legend_pie_item",
			"goat_cheese_item",
			"legend_yummy_sausages"
		];
		this.m.Food = this.new("scripts/items/supplies/" + foods[this.Math.rand(0, foods.len() - 1)]);
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Luft = null;
		this.m.Food = null;
	}

});

