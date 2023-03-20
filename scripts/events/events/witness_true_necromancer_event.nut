this.witness_true_necromancer_event <- this.inherit("scripts/events/event", {
	m = {
		Necromancer = null,
		Representative = null,
		SelectedNamed = null,
		PlayerNamed = null,
		AvailableNamed = [],
		NamedLoots = [],
		SpawnList = null,
	},
	function create()
	{
		this.m.ID = "event.witness_true_necromancer";
		this.m.Title = "At some place...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "Meet",
			Text = "[img]gfx/ui/events/event_76.png[/img]As you're traveling a cloaked man would seem to appear from out of nowhere, greeting you with a crooked grin.%SPEECH_ON%Greeting sellswords, may I have but a moment of your time. I promise it's well worth it.%SPEECH_OFF%Silence follows for what seemed like an eternity as you and your brothers stared at the stranger in apprehension and fear. His apperance was in every sense of normal for that of a noble highborn, yet for some unknown reason everyone felt an undescribable dread. Your eyes constantly drifting towards the man's hand with a skull ring, its ruby eyes glistening like fire. Finally you'd break free from the silence inducing fear before speaking freely.%SPEECH_ON%What business do you have old man? %SPEECH_OFF%The decrept noble's grin would stretch further as he spoke.%SPEECH_ON%I'm a simple relic seeker, and you good sirs have something that I'm quite interested in. %SPEECH_OFF% Confused you would stare the man down. Normally you would be excited for a bargain but this man reaked of death. His words may of been sweet but his very being smelled of rot. Your eyes would shift around scanning for threats unsure if this was a trap or simply a misunderstanding. The old man would give a playful grin before speaking again.%SPEECH_ON%No need to be on guard good sirs, I do not seek conflict merely trade%SPEECH_OFF%You and your men would watch as the noble pulled several large items out of a small sack tied at his hip that physically had no possible way to dwell within.%SPEECH_ON%What trickery is this!%SPEECH_OFF%The old man wouldn't say a word but the smug grin on his face spoke a thousand. The items produced were nothing but masterpieces whose craftsmenship seemed unrivaled. As you and your men would stare in envy one of your own would whisper in your ear. %SPEECH_ON%Those look mighty expensive sir, should be butcher the noble and take it for ourselves? %SPEECH_OFF%The thought is appealing but still, the smell of death eminating from the supposed noble would suggestion perhaps caution is the best route.",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "Of course! Let\'s me see what you can offer.",
					function getResult( _event )
					{
						return "Trade";
					}

				},
				/*
				{
					Text = "I have a better deal. Give me all of your valuables!",
					function getResult( _event )
					{
						return "Rob";
					}

				},
				*/
				{
					Text = "It is a lovely offer. But i have to decline it.",
					function getResult( _event )
					{
						return 0;
					}

				},
				
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Representative.getImagePath());
				this.Characters.push(_event.m.Necromancer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Trade",
			Text = "With a bright smile on his face, the old man speaks.%SPEECH_ON%Very well! Here have a look and make up your mind. You can pick one of these, and I shall take your %item% in return. A fair trade, right?%SPEECH_OFF%All of them are amazing items but so is your %item%, you wonder if it's truly worth this deal. Nevermind the fact that you still doubt if you could trust the man who reeked of death, but by the way his eyes lingered at your %item% you sensed he truly desired it.",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [],
			function start( _event )
			{
				this.Characters.push(_event.m.Representative.getImagePath());
				this.Characters.push(_event.m.Necromancer.getImagePath());
				local yourItem = _event.m.PlayerNamed;
				local tradeItems = _event.m.AvailableNamed;
				
				this.List.extend([
					{
						id = 1,
						icon = "ui/icons/dub.png",
						text = "[color=" + this.Const.UI.Color.DamageValue + "]--- Trade your ---[/color]"
					},
					{
						id = 2,
						icon = "ui/items/" + yourItem.getIcon(),
						text = yourItem.getName()
					},
					{
						id = 3,
						icon = "ui/icons/dub.png",
						text = "[color=" + this.Const.UI.Color.DamageValue + "]--- For one of these ---[/color]"
					},
				]);
				
				for ( local i = 0; i < 5; i = ++i )
				{	
					this.List.extend([
						{
							id = 4 + i,
							icon = "ui/items/" + tradeItems[i].getIcon(),
							text = tradeItems[i].getName()
						},
						{
							id = 1,
							icon = "ui/icons/dub.png",
							text = ""
						},
					]);
				}
				
				local quotes = [
					"Let\' s trade for the ",
					"I shall take the ",
					"Certainly, the ",
				]
				
				this.Options.push({
					Text = quotes[this.Math.rand(0, quotes.len() - 1)] + _event.m.AvailableNamed[0].getName(),
					function getResult( _event )
					{
						_event.m.SelectedNamed = _event.m.AvailableNamed[0];
						return "FinishTrade";
					}
				});
				
				this.Options.push({
					Text = quotes[this.Math.rand(0, quotes.len() - 1)] + _event.m.AvailableNamed[1].getName(),
					function getResult( _event )
					{
						_event.m.SelectedNamed = _event.m.AvailableNamed[1];
						return "FinishTrade";
					}
				});
				
				this.Options.push({
					Text = quotes[this.Math.rand(0, quotes.len() - 1)] + _event.m.AvailableNamed[2].getName(),
					function getResult( _event )
					{
						_event.m.SelectedNamed = _event.m.AvailableNamed[2];
						return "FinishTrade";
					}
				});
				
				this.Options.push({
					Text = quotes[this.Math.rand(0, quotes.len() - 1)] + _event.m.AvailableNamed[3].getName(),
					function getResult( _event )
					{
						_event.m.SelectedNamed = _event.m.AvailableNamed[3];
						return "FinishTrade";
					}
				});
				
				this.Options.push({
					Text = quotes[this.Math.rand(0, quotes.len() - 1)] + _event.m.AvailableNamed[4].getName(),
					function getResult( _event )
					{
						_event.m.SelectedNamed = _event.m.AvailableNamed[4];
						return "FinishTrade";
					}
				});
				
				this.Options.push({
					Text = "I change my mind.",
					function getResult( _event )
					{
						return "Meet";
					}

				});
				
			}

		});
		this.m.Screens.push({
			ID = "FinishTrade",
			Text = "[img]gfx/ui/events/event_76.png[/img]You get what you chose and in return the old man takes your %item%. You would wait for a moment and look around as expecting a trap or some sort of curse to be cast upon you but in a sort of disappointing way it all went smoothly Maybe you were too cautious, he does seem like a friendly old man. With joyful tone the old man would speak.%SPEECH_ON%It's truly a pleasure to do business with you, sellswords! May some day we meet again.%SPEECH_OFF%Suddenly a gust of wind would blind you and your troop and as your vision cleared you'd find yourself standing alone with no trace of the interaction except the new item held in your hands.",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "Farewell!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local yourItem = _event.m.PlayerNamed;
				local tradeItem = _event.m.SelectedNamed;
				
				this.Characters.push(_event.m.Representative.getImagePath());
				this.Characters.push(_event.m.Necromancer.getImagePath());
				this.World.Assets.getStash().remove(yourItem);
				this.World.Assets.getStash().add(tradeItem);
				this.List.extend([
					{
						id = 10,
						icon = "ui/items/" + tradeItem.getIcon(),
						text = "You [color=" + this.Const.UI.Color.DamageValue + "]gain[/color] " + tradeItem.getName()
					},
					{
						id = 1,
						icon = "ui/icons/dub.png",
						text = ""
					},
					{
						id = 1,
						icon = "ui/icons/dub.png",
						text = ""
					},
					{
						id = 11,
						icon = "ui/items/" + yourItem.getIcon(),
						text = "You [color=" + this.Const.UI.Color.DamageValue + "]lose[/color] " + yourItem.getName()
					},
				]);				
			}

		});
		
		this.m.Screens.push({
			ID = "Rob",
			Text = "[img]gfx/ui/events/event_29.png[/img]The old man laughs as though he heard a joke.%SPEECH_ON%Perhaps your true calling in life sellswords is comedy. You truly are the greatest jester I've ever seen, suggesting something as ridiculous as that. Anyway, shall we continue this comedy act? If it makes you more comfortable, you's can all attack at once. I wouldn't want this to be unfair. %SPEECH_OFF%Your eyes widen as you didn't expect to see this kind of reaction from an old man. You've seen good bluffs before but this felt different, it felt like a sincere expression of power despite it coming from a mere old man. As if to confirm your fears one of your men would point out four shadows from afar. A chill runs through your spine as though a freezing wind blew by. You begin to regret this decision.",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "What has we gotten into!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.UndeadTracks;
						properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						properties.Loot = [];
						properties.Loot.extend(_event.m.NamedLoots);
						properties.Loot.extend(_event.onPrepareRewards());
						properties.Entities = [];
						properties.Entities.push(clone _event.m.SpawnList.Necromancer);
						properties.Entities.push(clone _event.m.SpawnList.SwordSaint);
						properties.Entities.push(clone _event.m.SpawnList.SwordSaint);
						properties.Entities.push(clone _event.m.SpawnList.Wraith);
						properties.Entities.push(clone _event.m.SpawnList.Wraith);

						local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID();

						for( local i = 0; i < properties.Entities.len(); i = ++i )
						{
							properties.Entities[i].Faction <- f;
						}
						
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}
				},
				{
					Text = "Pardon me! It was a tasteless joke.",
					function getResult( _event )
					{
						return 0;
					}

				},
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Representative.getImagePath());
				this.Characters.push(_event.m.Necromancer.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 50)
		{
			return;
		}
		
		local AllItems = this.World.Assets.getStash().getItems();
		local hasNamed = 0;
		
		foreach ( _item in AllItems )
		{
			if (_item == null)
			{
				continue;
			}
			
			if (!_item.isItemType(this.Const.Items.ItemType.Named))
			{
			}
			else if (_item.isItemType(this.Const.Items.ItemType.Weapon) || _item.isItemType(this.Const.Items.ItemType.Shield))
			{
				hasNamed += 1;
			}
		}
		
		if (hasNamed == 0)
		{
			return;
		}

		this.m.Score = 100 + 90 * hasNamed;
	}

	function onPrepare()
	{
		local AllItems = this.World.Assets.getStash().getItems();
		local NamedItems = [];
		
		foreach ( _item in AllItems )
		{
			if (_item == null)
			{
				continue;
			}
			
			if (!_item.isItemType(this.Const.Items.ItemType.Named))
			{
			}
			else if (_item.isItemType(this.Const.Items.ItemType.Weapon) || _item.isItemType(this.Const.Items.ItemType.Shield))
			{
				NamedItems.push(_item);
			}
		}
		
		this.m.PlayerNamed = NamedItems[this.Math.rand(0, NamedItems.len() - 1)];
		
		local scriptFiles = this.IO.enumerateFiles(this.isKindOf(this.m.PlayerNamed, "weapon") ? "scripts/items/weapons/named/" : "scripts/items/shields/named/");
		local selectedScripts = [];
		local s;
		scriptFiles.remove(scriptFiles.find(this.isKindOf(this.m.PlayerNamed, "weapon") ? "scripts/items/weapons/named/named_weapon" : "scripts/items/shields/named/named_shield"));
		
		while (selectedScripts.len() < 5)
		{
			s = scriptFiles[this.Math.rand(0, scriptFiles.len() - 1)];
			selectedScripts.push(s);
		}
		
		foreach ( script in selectedScripts )
		{
			local _i = this.new(script);
			_i.onAddedToStash(null);
			this.m.AvailableNamed.push(_i);
			this.m.NamedLoots.push(script);
		}
		
		for ( local i = 0; i < 4; i = ++i )
		{
			this.m.NamedLoots.push(scriptFiles[this.Math.rand(0, scriptFiles.len() - 1)]);
		}
		
		local roster = this.World.getTemporaryRoster();
		local brothers = this.World.getPlayerRoster().getAll();
		local candidate;

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				candidate = bro;
				break;
			}
		}
		
		if (candidate == null)
		{
			candidate = brothers[this.Math.rand(0, brothers.len() - 1)];
		}
		
		this.m.Representative = candidate;
		this.m.Necromancer = roster.create("scripts/entity/tactical/enemies/true_necromancer");
		this.m.Necromancer.assignRandomEquipment();
		/*
		this.m.SpawnList = {
			Necromancer = {
				ID = this.Const.EntityType.Necromancer,
				Variant = 0,
				Strength = 999999999,
				Cost = 10,
				Row = 3,
				Script = "scripts/entity/tactical/enemies/true_necromancer",
			},
			SwordSaint = {
				ID = this.Const.EntityType.ZombieBetrayer,
				Variant = 0,
				Strength = 50000,
				Cost = 10,
				Row = 0,
				Script = "scripts/entity/tactical/enemies/zombie_swordsaint",
			},
			Wraith = {
				ID = this.Const.EntityType.Ghost,
				Variant = 0,
				Strength = 10000,
				Cost = 10,
				Row = 2,
				Script = "scripts/entity/tactical/enemies/wraith",
			},
		};
		*/
	}

	function onPrepareRewards()
	{
		local ret = [];
		local num = this.Math.rand(2, 7);

		for (local i = 0; i < num; i++) 
		{
		    ret.push("scripts/items/misc/legend_ancient_scroll_item");
		}

		local potions = [
			"cat_potion_item",
			"cat_potion_item",
			"iron_will_potion_item",
			"iron_will_potion_item",
			"recovery_potion_item",
			"recovery_potion_item",
			"lionheart_potion_item",
			"lionheart_potion_item",
			"night_vision_elixir_item",
			"night_vision_elixir_item",
			"legend_heartwood_sap_flask_item",
			"legend_hexen_ichor_potion_item",
			"legend_skin_ghoul_blood_flask_item",
			"legend_stollwurm_blood_flask_item",
		];

		for (local i = 0; i < 3; i++) 
		{
		    ret.push("scripts/items/accessory/" + potions[this.Math.rand(0, potions.len() - 1)]);
		}

		ret.push("scripts/items/loot/ornate_tome_item");
		ret.push("scripts/items/special/fountain_of_youth_item");
		ret.push("scripts/items/special/trade_jug_01_item");
		return ret;
	}
	
	function onDetermineStartScreen()
	{
		return "Meet";
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"leader",
			this.m.Representative.getName()
		]);
		
		_vars.push([
			"me",
			this.m.Necromancer.getName()
		]);
		
		_vars.push([
			"item",
			this.m.PlayerNamed.getName()
		]);
	}

	function onClear()
	{
		this.m.Necromancer = null;
		this.m.Representative = null;
		this.m.SpawnList = null;
		this.m.PlayerNamed = null;
		this.m.SelectedNamed = null;
		this.m.AvailableNamed = [];
		this.m.NamedLoots = [];
		this.World.getTemporaryRoster().clear();
	}

});

