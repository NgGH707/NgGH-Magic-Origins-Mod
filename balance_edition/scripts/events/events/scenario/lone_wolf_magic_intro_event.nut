this.lone_wolf_magic_intro_event <- this.inherit("scripts/events/event", {
	m = {
		LoneWolf = null
	},
	function create()
	{
		this.m.ID = "event.lone_wolf_magic_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_137.png[/img]{You walk the stands of a jousting arena. Moldy fruits and vegetables litter the floor. Dried blood freckles the seats. And silence fills the air. When you sit, the wood of the place seems to groan in unison as though discomfited by the haunt of a rare visitor.\n\nIn your hands is a note. \'Looking fer hardy men, knowledge of the sword pref\'rred but all welcome.\' It is an old note, its purpose long since served. But what draws your eye is the price offered to the task: more crowns than you could muster in five tournaments.\n\n If this is the coin to be earned, then to hell with the jousts and the sparring. But you\'re not one to suit up for some other captain\'s orders. With all that you\'ve earned over the years you imagine you could start your own mercenary band just fine.}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A company won\'t be a bad ideal. I have been alone for so long.",
					function getResult( _event )
					{
						return "Normal";
					}
				}
			],
			function start( _event )
			{
				_event.m.Title = "Choose Your Fate";
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
				
				if (_event.m.LoneWolf != null)
				{
					this.Options.push({
						Text = "Alone! forever be alone. That is my fate",
						function getResult( _event )
						{
							return "Special";
						}
					});
				}
			}

		});
		
		this.m.Screens.push({
			ID = "Normal",
			Text = "[img]gfx/ui/events/event_137.png[/img]{You will start this campaign with a lone Spell Knight. This origin is noy that much different compare to a vanilla Lone Wolf origin beside a having a master of 1v1 battle.}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "My journey begins now.",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "I change my mind!",
					function getResult( _event )
					{
						return "A";
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "The Lone Wolf";
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
			}

		});
		
		this.m.Screens.push({
			ID = "Special",
			Text = "[img]gfx/ui/events/event_137.png[/img]{Have you read the title of this origin ? By choosing this fate you will experience how a \'True Lone Wolf\' would be. %SPEECH_ON%Embrace yourself as the journey a head, you have to face all the challenges by your own. Fear not my loner, fate will not forsake you, unique power will be bestowed upon you. With that blessing it is time for you to create a new legend now.%SPEECH_OFF% Go! Go! Go!}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "My journey begins now.",
					function getResult( _event )
					{
						_event.setTrueLoneWolf(_event.m.LoneWolf);
						
						return 0;
					}
				},
				{
					Text = "I change my mind!",
					function getResult( _event )
					{
						return "A";
					}
				}
			],
			function start( _event )
			{
				_event.m.Title = "A True Lone Wolf";
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
			}

		});
	}
	
	function setTrueLoneWolf( _bro )
	{
		local origin = this.World.Assets.getOrigin();
		origin.m.isTrueLoneWolf = true;
		this.World.Assets.m.BrothersMax = 2;
		this.World.Assets.m.BrothersMaxInCombat = 1;
		this.World.Assets.m.BrothersScaleMax = 2;
		this.World.Assets.m.BrothersScaleMin = 2;
		_bro.getSkills().add(this.new("scripts/skills/traits/true_lone_wolf"));
		_bro.m.PerkPoints = 8;
		_bro.m.LevelUps = 3;
		_bro.m.Level = 4;
		_bro.getBaseProperties().MeleeDefense += 3;
		_bro.getBaseProperties().RangedDefense += 10;
		_bro.m.Talents = [];
		local talents = _bro.getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.Hitpoints] = 3;
		talents[this.Const.Attributes.MeleeDefense] = 3;
		talents[this.Const.Attributes.Fatigue] = 3;
		talents[this.Const.Attributes.MeleeSkill] = 3;
		talents[this.Const.Attributes.RangedDefense] = 1;
		talents[this.Const.Attributes.Bravery] = 1;
		talents[this.Const.Attributes.Initiative] = 1;
		talents[this.Const.Attributes.RangedSkill] = 1;
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.spell_knight")
			{
				this.m.LoneWolf = bro;
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

