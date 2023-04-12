this.nggh_mod_luft_intro_event <- ::inherit("scripts/events/event", {
	m = {
		Luft = null,
		Foods = [],
		Food = null,
		Index = 0,
		DiscordMembers = [],
		DiscordMember = null,
		Weapon = null,
		IsReceivedBuff = false,
		HasPet = false,
		HasGivenWeapon = false,
		HasMeal = false,
		HasNewPerks = null,
	},
	function create()
	{
		this.m.ID = "event.luft_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_12.png[/img]%SPEECH_START%Where am i? This is not my basement!%SPEECH_OFF%%SPEECH_START%Who are you? What do you mean i\'m in a game?%SPEECH_OFF%%SPEECH_START%My Gosh! Please don\'t hurt me, i\'m just a cute nacho with a rat fetish. Please don\'t force me to do weird stuffs%SPEECH_OFF%%SPEECH_START%By the way, can i pet you?%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Banner = "ui/banners/" + ::World.Assets.getBanner() + "s.png";

				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}

				if (!_event.m.HasPet)
				{
					if (::Math.rand(1, 100) <= 50)
					{
						this.Options.push({
							Text = "No! I will pet you instead",
							function getResult( _event )
							{
								return "Pet1";
							}

						});
					}
					else
					{
						this.Options.push({
							Text = "Ok! But just one",
							function getResult( _event )
							{
								return "Pet2";
							}

						});
					}

					if (::Math.rand(1, 100) <= 40)
					{
						this.Options.push({
							Text = "Yes and bless me with your wisdom",
							function getResult( _event )
							{
								return "Tips";
							}

						});
					}
				}

				if (_event.m.Index == 0)
				{
					_event.m.Index = ::Math.rand(1, 2);
				}

				if (!_event.m.HasMeal)
				{
					if (_event.m.Index == 1)
					{
						this.Options.push({
							Text = "I heard you like to eat discord member for snack, is that true?",
							function getResult( _event )
							{
								return "EatDiscordMember";
							}

						});
					}
					else 
					{
					    this.Options.push({
							Text = "Are you hungry, Luft?",
							function getResult( _event )
							{
								return "Eat";
							}

						});
					}
				}

				/*
				if (!_event.m.HasNewPerks)
				{
					this.Options.push({
						Text = "You must learn to know .....",
						function getResult( _event )
						{
							return "PerkGroups";
						}

					});
				}
				*/

				if (_event.m.HasMeal || _event.m.HasNewPerks || _event.m.HasPet)
				{
					this.Options.push({
						Text = "I\'ll set you free, Luft!",
						function getResult( _event )
						{
							return 0;
						}

					});
				}
			}

		});

		this.m.Screens.push({
			ID = "PerkGroups",
			Text = "[img]gfx/ui/events/event_15.png[/img]%SPEECH_START%What??? Please don't hold high hope on me!%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "How to use melee weapons",
					function getResult( _event )
					{	
						local exclude = [];

						while (exclude.len() < 3)
						{
							local new = ::Const.Perks.MeleeWeaponTrees.getRandom(exclude);
							exclude.push(new.ID);
							_event.m.Luft.getBackground().addPerkGroup(new.Tree);
						}

						_event.m.Weapon = ::new("scripts/items/weapons/" + ::MSU.Array.rand([
							"wooden_stick",
							"wooden_flail",
							"legend_staff",
							"shortsword",
							"scramasax",
							"militia_spear",
							"hand_axe"
						]));
						_event.m.Luft.getItems().equip(_event.m.Weapon);

						if (::Is_PTR_Exist)
						{
							_event.m.Luft.getBackground().addPerkGroup(::Math.rand(1, 2) == 1 ? ::Const.Perks.OneHandedTree.Tree : ::Const.Perks.TwoHandedTree.Tree);
						}

						return "A";
					}

				},
				{
					Text = "How to use bow and arrow",
					function getResult( _event )
					{
						_event.m.Luft.getBackground().addPerkGroup(::Const.Perks.BowTree.Tree);
						_event.m.Luft.getBackground().addPerkGroup(::Const.Perks.CrossbowTree.Tree);
						_event.m.Luft.getBackground().addPerk(::Const.Perks.PerkDefs.QuickHands, 1);
						_event.m.Luft.getTalents()[::Const.Attributes.RangedSkill] = 3;
						_event.m.Luft.m.Attributes = [];
						_event.m.Luft.fillAttributeLevelUpValues(::Const.XP.MaxLevelWithPerkpoints - 1);

						local choose = ::MSU.Array.rand([
							["short_bow", "quiver_of_arrows"],
							["light_crossbow", "quiver_of_bolts"],
						]);
						_event.m.Weapon = ::new("scripts/items/weapons/" + choose[0]);
						_event.m.Luft.getItems().equip(_event.m.Weapon);
						_event.m.Luft.getItems().equip(::new("scripts/items/ammo/" + choose[1]));

						if (::Is_PTR_Exist)
						{
							_event.m.Luft.getBackground().addPerkGroup(::Const.Perks.RangedTree.Tree);
						}

						return "A";
					}

				},
				{
					Text = "How to throw and sling stone",
					function getResult( _event )
					{
						_event.m.Luft.getBackground().addPerkGroup(::Const.Perks.SlingTree.Tree);
						_event.m.Luft.getBackground().addPerkGroup(::Const.Perks.ThrowingTree.Tree);
						_event.m.Luft.getBackground().addPerk(::Const.Perks.PerkDefs.QuickHands, 1);
						_event.m.Luft.getTalents()[::Const.Attributes.RangedSkill] = 2;
						_event.m.Luft.m.Attributes = [];
						_event.m.Luft.fillAttributeLevelUpValues(::Const.XP.MaxLevelWithPerkpoints - 1);
						_event.m.Weapon = ::new("scripts/items/weapons/legend_sling");
						_event.m.Luft.getItems().equip(_event.m.Weapon);

						if (::Is_PTR_Exist)
						{
							_event.m.Luft.getBackground().addPerkGroup(::Const.Perks.RangedTree.Tree);
						}

						return "A";
					}

				},
				{
					Text = "How to do nothing",
					function getResult( _event )
					{
						_event.m.Luft.improveMood(1.0, "Yay!!! Become useless");
						return "A";
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + ::World.Assets.getBanner() + "s.png";

				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}

				_event.m.HasNewPerks = true;
			}

		});

		this.m.Screens.push({
			ID = "Eat",
			Text = "[img]gfx/ui/events/event_61.png[/img]%SPEECH_START%O' boy! Just in time for breakfast. What will you give me? Such a good boy you are!%SPEECH_OFF%%SPEECH_START%I\'ll give you a pet for that.%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Banner = "ui/banners/" + ::World.Assets.getBanner() + "s.png";

				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}

				foreach (i, food in _event.m.Foods ) 
				{
				   	this.Options.insert(0, {
				   		Index = i,
						Text = ::MSU.Array.rand([
							"I have",
							"Hope you like",
							"Just some",
							"Hmm yes!!!",
							"How about some",
							"Surprise! It\'s"
						]) + " [color=#bcad8c]" + food.getName() + "[/color]",

						function getResult( _event )
						{
							_event.m.Food = this.Index;
							return "E";
						}

					});
				}

				_event.m.HasMeal = true;
			}

		});

		this.m.Screens.push({
			ID = "EatDiscordMember",
			Text = "[img]gfx/ui/events/event_69.png[/img]%SPEECH_START%Of course! Magda often bans people without knowing they will be sent to my tummy by doing that. Don\'t tell Magda about that or you too will be my lunch.%SPEECH_OFF%%SPEECH_START%Do you want me to show you how i do it?%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Banner = "ui/banners/" + ::World.Assets.getBanner() + "s.png";

				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}

				foreach (i, food in _event.m.DiscordMembers ) 
				{
				   	this.Options.insert(0, {
				   		Name = food,
						Text = ::MSU.Array.rand([
							"Let\'s try with",
							"I know just the person for you,",
							"Hmm yes!!!",
							"You can have",
							"No hard feelings, "
						]) + " [color=#bcad8c]" + food + "[/color]",
						
						function getResult( _event )
						{
							_event.m.DiscordMember = this.Name;
							return "EatDiscordMember2";
						}

					});
				}

				_event.m.HasMeal = true;
			}

		});

		this.m.Screens.push({
			ID = "EatDiscordMember2",
			Text = "[img]gfx/ui/events/event_12.png[/img]%SPEECH_START%Delicious! No you know why i like vore so much. You see, this is a delicacy of Discord. The finest fast food restaurant i have ever known.%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To see to believe",
					function getResult( _event )
					{
						return "A";
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + ::World.Assets.getBanner() + "s.png";
				//this.Text = "[img]gfx/ui/events/event_12.png[/img]%SPEECH_START%I\'m so sorry, " + _event.m.DiscordMember + "! But you are so tasty, i wish there are two of you for me to enjoy more.%SPEECH_OFF%";
				
				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}

				local def;

				switch (_event.m.DiscordMember)
				{
				case "Poss":
					def = ::Const.Perks.PerkDefObjects[::Const.Perks.PerkDefs.NggHMiscChampion];
					::World.Assets.getOrigin().addScenarioPerk(_event.m.Luft.getBackground(), ::Const.Perks.PerkDefs.NggHMiscChampion, 6);
					break;

				case "MuffledMagda":
					def = ::Const.Perks.PerkDefObjects[::Const.Perks.PerkDefs.LegendTeacher];
					::World.Assets.getOrigin().addScenarioPerk(_event.m.Luft.getBackground(), ::Const.Perks.PerkDefs.LegendTeacher, 4);
					break;

				case "Warrior Alpha Male (Luke)":
					def = ::Const.Perks.PerkDefObjects[::Const.Perks.PerkDefs.LegendFavouredEnemyDirewolf];
					::World.Assets.getOrigin().addScenarioPerk(_event.m.Luft.getBackground(), ::Const.Perks.PerkDefs.LegendFavouredEnemyDirewolf, 2);
					break;

				case "Necro":
					def = ::Const.Perks.PerkDefObjects[::Const.Perks.PerkDefs.NggHAlpShadowCopy];
					::World.Assets.getOrigin().addScenarioPerk(_event.m.Luft.getBackground(), ::Const.Perks.PerkDefs.NggHAlpShadowCopy, 5);
					break;

				case "LordMidas":
					def = ::Const.Perks.PerkDefObjects[::Const.Perks.PerkDefs.PTRDiscoveredTalent];
					::World.Assets.getOrigin().addScenarioPerk(_event.m.Luft.getBackground(), ::Const.Perks.PerkDefs.PTRDiscoveredTalent, 3);
					break;

				case "Enduriel":
					def = ::Const.Perks.PerkDefObjects[::Const.Perks.PerkDefs.LegendSkillfulStacking];
					::World.Assets.getOrigin().addScenarioPerk(_event.m.Luft.getBackground(), ::Const.Perks.PerkDefs.LegendSkillfulStacking, 4);
					break;

				case "TaroEld":
					def = ::Const.Perks.PerkDefObjects[::Const.Perks.PerkDefs.HoldOut];
					::World.Assets.getOrigin().addScenarioPerk(_event.m.Luft.getBackground(), ::Const.Perks.PerkDefs.HoldOut, 1);

					local trait = ::new("scripts/skills/traits/strong_trait");
					_event.m.Luft.getSkills().add(trait);
					this.List.push({
						id = 10,
						icon = trait.getIcon(),
						text = _event.m.Luft.getName() + " gains '" + trait.getName() + "' trait"
					});
					break;

				case "Uberbagel":
					if (::Is_PTR_Exist)
					{
						def = ::Const.Perks.PerkDefObjects[::Const.Perks.PerkDefs.PTRRisingStar];
						::World.Assets.getOrigin().addScenarioPerk(_event.m.Luft.getBackground(), ::Const.Perks.PerkDefs.PTRRisingStar, 6);
					}
					else 
					{
						def = ::Const.Perks.PerkDefObjects[::Const.Perks.PerkDefs.Gifted];
						::World.Assets.getOrigin().addScenarioPerk(_event.m.Luft.getBackground(), ::Const.Perks.PerkDefs.Gifted, 2);
					}
					break;
				
				case "Wuxiangjinxing":
					local item;
					if (!::Is_AccessoryCompanions_Exist)
					{
						item = ::new("scripts/items/accessory/wolf_item");
					}
					else 
					{
						item = ::new("scripts/items/accessory/wardog_item");
						item.setType(::Const.Companions.TypeList.Nacho);
						item.updateCompanion();
					}

					_event.m.Luft.m.PerkPoints += 1;
					_event.m.Luft.getItems().equip(item);
					this.List.extend([
						{
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = _event.m.Luft.getName() + " gets " + item.getName() + " as pet"
						},
						{
							id = 10,
							icon = "ui/icons/perks",
							text = _event.m.Luft.getName() + " gains [color=" + ::Const.UI.Color.PositiveValue + "]1[/color] perk point"
						}
					]);

					::World.getTemporaryRoster().clear();
					break;
				}

				this.List.push({
					id = 10,
					icon = def.Icon,
					text = _event.m.Luft.getName() + " gains '" + def.Name + "' perk"
				});
				
				this.List.insert(0, {
					id = 10,
					icon = ::Const.MoodStateIcon[_event.m.Luft.getMoodState()],
					text = _event.m.Luft.getName() + " is fulled"
				});
			}

		});

		this.m.Screens.push({
			ID = "Weapons",
			Text = "[img]gfx/ui/events/event_62.png[/img]%SPEECH_START%Today isn\'t my birthday, but i have a gift out of nowhere from a mysterious person on the other side of the monitor screen. Thanks! I want to pet you more.%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Banner = "ui/banners/" + ::World.Assets.getBanner() + "s.png";

				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}

				if (_event.m.Weapon != null)
				{
					this.List.push({
						id = 10,
						icon = "ui/items/" + _event.m.Weapon.getIcon(),
						text = _event.m.Luft.getName() + " gets a " + _event.m.Weapon.getName()
					});
				}

				if (_event.m.HasGivenWeapon)
				{
					this.Options.push({
						Text = "Surprise!!!",
						function getResult( _event )
						{
							return "A";
						}

					});

					if (_event.m.Weapon == null)
					{
						_event.m.Luft.worsenMood(0.5, "I got trolled");

						this.List.push({
							id = 10,
							icon = ::Const.MoodStateIcon[_event.m.Luft.getMoodState()],
							text = _event.m.Luft.getName() + ::Const.MoodStateEvent[_event.m.Luft.getMoodState()]
						});
					}
				}
				else 
				{
				    this.Options.extend([
					    {
							Text = "A Stick",
							function getResult( _event )
							{
							
								return "Weapons";
							}

						},
						{
							Text = "A Long Stick",
							function getResult( _event )
							{
								_event.m.Weapon = ::new("scripts/items/weapons/legend_staff");
								_event.m.Luft.getItems().equip(_event.m.Weapon);
								return "Weapons";
							}

						},
						{
							Text = "A Pointy Stick",
							function getResult( _event )
							{
								_event.m.Weapon = ::new("scripts/items/weapons/militia_spear");
								_event.m.Luft.getItems().equip(_event.m.Weapon);
								return "Weapons";
							}

						},
						{
							Text = "A Stick With A String",
							function getResult( _event )
							{
								

								return "Weapons";
							}

						},
						{
							Text = "A Hard To Use Stick",
							function getResult( _event )
							{
								_event.m.Weapon = ::new("scripts/items/weapons/wooden_flail");
								_event.m.Luft.getItems().equip(_event.m.Weapon);
								return "Weapons";
							}

						},
						{
							Text = "Nothing",
							function getResult( _event )
							{
								return "Weapons";
							}

						},
					]);

					_event.m.HasGivenWeapon = true;
				}
			}

		});

		this.m.Screens.push({
			ID = "Pet1",
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
						_event.m.HasPet = true;
						return "A";
					}

				},
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + ::World.Assets.getBanner() + "s.png";

				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}

				_event.m.Luft.improveMood(4.0, "Got a head pat");
				_event.m.Luft.addXP(100, false);
				
				this.List.push({
					id = 10,
					icon = ::Const.MoodStateIcon[_event.m.Luft.getMoodState()],
					text = _event.m.Luft.getName() + ::Const.MoodStateEvent[_event.m.Luft.getMoodState()]
				});
				this.List.push({
					id = 17,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Luft.getName() + " gains [color=" + ::Const.UI.Color.PositiveEventValue + "]250[/color] XP"
				});
			}

		});

		this.m.Screens.push({
			ID = "Pet2",
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
						_event.m.HasPet = true;
						return "A";
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + ::World.Assets.getBanner() + "s.png";

				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}

				_event.m.Luft.improveMood(0.5, "I just pat someone");
				_event.m.Luft.addXP(250, false);
				
				this.List.push({
					id = 10,
					icon = ::Const.MoodStateIcon[_event.m.Luft.getMoodState()],
					text = _event.m.Luft.getName() + ::Const.MoodStateEvent[_event.m.Luft.getMoodState()]
				});
				this.List.push({
					id = 17,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Luft.getName() + " gains [color=" + ::Const.UI.Color.PositiveEventValue + "]250[/color] XP"
				});
			}

		});

		this.m.Screens.push({
			ID = "Tips",
			Text =  "",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Please tell me more!",
					function getResult( _event )
					{
						return "Tips";
					}

				},
				{
					Text = "How wise you\'re!",
					function getResult( _event )
					{
						return "A";
					}

				},
			],
			function start( _event )
			{
				this.Text = "[img]gfx/ui/events/event_40.png[/img]{";

				foreach (tip in ::Const.LuftTips)
				{
					this.Text += "%SPEECH_START%" + tip + "%SPEECH_OFF% | ";
				}

				this.Text += "}";
				this.Banner = "ui/banners/" + ::World.Assets.getBanner() + "s.png";

				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}

				if (!_event.m.IsReceivedBuff)
				{
					_event.m.Luft.improveMood(0.5, "Someone asked for my wisdom");
					_event.m.Luft.getBaseProperties().Bravery += 5;
					_event.m.Luft.getSkills().update();
					_event.m.IsReceivedBuff = true;
					_event.m.HasPet = true;
					
					this.List.extend([
						{
							id = 10,
							icon = ::Const.MoodStateIcon[_event.m.Luft.getMoodState()],
							text = _event.m.Luft.getName() + ::Const.MoodStateEvent[_event.m.Luft.getMoodState()]
						},
						{
							id = 17,
							icon = "ui/icons/bravery.png",
							text = _event.m.Luft.getName() + " gains [color=" + ::Const.UI.Color.PositiveEventValue + "]+5[/color] Resolve"
						}
					]);
				}
			}

		});

		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_61.png[/img]%SPEECH_START%Thanks, man! It\'s delicious%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Banner = "ui/banners/" + ::World.Assets.getBanner() + "s.png";
				local option_text = "You\'re welcome Luft";
				local isTrolled = false;
				local food = _event.m.Foods[_event.m.Food];
				_event.m.Luft.improveMood(0.5, "Have a good meal");
				_event.m.Luft.grow(true);

				local size = 9990 + _event.m.Luft.getSize();
				::World.Flags.set("looks", size);
				::World.Assets.updateLook(size);

				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}

				switch (food.getID()) 
				{
				case "supplies.black_marsh_stew":
					_event.m.Luft.getBaseProperties().Stamina += 5;
					_event.m.Luft.getBaseProperties().MeleeDefense += 3;
					this.List.extend([
						{
							id = 17,
							icon = "ui/icons/fatigue.png",
							text = _event.m.Luft.getName() + " gains [color=" + ::Const.UI.Color.PositiveEventValue + "]+5[/color] Fatigue"
						},
						{
							id = 17,
							icon = "ui/icons/melee_skill.png",
							text = _event.m.Luft.getName() + " gains [color=" + ::Const.UI.Color.PositiveEventValue + "]+3[/color] Melee Skill"
						},
					]);
					break;

				case "supplies.dried_lamb":
					_event.m.Luft.getBaseProperties().RangedSkill += 5;
					_event.m.Luft.getBaseProperties().RangedDefense += 5;
					this.List.extend([
						{
							id = 17,
							icon = "ui/icons/ranged_skill.png",
							text = _event.m.Luft.getName() + " gains [color=" + ::Const.UI.Color.PositiveEventValue + "]+5[/color] Ranged Skill"
						},
						{
							id = 17,
							icon = "ui/icons/ranged_defense.png",
							text = _event.m.Luft.getName() + " gains [color=" + ::Const.UI.Color.PositiveEventValue + "]+3[/color] Ranged Defense"
						},
					]);
					break;

				case "supplies.pickled_mushrooms_item":
					_event.m.Luft.getBaseProperties().Initiative += 5;
					_event.m.Luft.getBaseProperties().Bravery += 3;
					this.List.extend([
						{
							id = 17,
							icon = "ui/icons/initiative.png",
							text = _event.m.Luft.getName() + " gains [color=" + ::Const.UI.Color.PositiveEventValue + "]+5[/color] Initiative"
						},
						{
							id = 17,
							icon = "ui/icons/bravery.png",
							text = _event.m.Luft.getName() + " gains [color=" + ::Const.UI.Color.PositiveEventValue + "]+3[/color] Resolve"
						},
					]);
					break;

				case "supplies.fermented_unhold_heart":
					_event.m.Luft.getBaseProperties().Stamina += 5;
					_event.m.Luft.getBaseProperties().Bravery += 3;
					this.List.extend([
						{
							id = 17,
							icon = "ui/icons/fatigue.png",
							text = _event.m.Luft.getName() + " gains [color=" + ::Const.UI.Color.PositiveEventValue + "]+5[/color] Fatigue"
						},
						{
							id = 17,
							icon = "ui/icons/bravery.png",
							text = _event.m.Luft.getName() + " gains [color=" + ::Const.UI.Color.PositiveEventValue + "]+3[/color] Resolve"
						},
					]);
					break;

				case "supplies.legend_yummy_sausages":
					_event.m.Luft.getBaseProperties().Hitpoints += 5;
					_event.m.Luft.getBaseProperties().MeleeSkill += 3;
					this.List.extend([
						{
							id = 17,
							icon = "ui/icons/health.png",
							text = _event.m.Luft.getName() + " gains [color=" + ::Const.UI.Color.PositiveEventValue + "]+5[/color] Hitpoints"
						},
						{
							id = 17,
							icon = "ui/icons/melee_skill.png",
							text = _event.m.Luft.getName() + " gains [color=" + ::Const.UI.Color.PositiveEventValue + "]+3[/color] Melee Skill"
						},
					]);
					break;
				
				case "supplies.goat_cheese":
					_event.m.Luft.getBaseProperties().Hitpoints += 5;
					_event.m.Luft.getBaseProperties().Bravery += 2;
					this.List.extend([
						{
							id = 17,
							icon = "ui/icons/health.png",
							text = _event.m.Luft.getName() + " gains [color=" + ::Const.UI.Color.PositiveEventValue + "]+5[/color] Hitpoints"
						},
						{
							id = 17,
							icon = "ui/icons/bravery.png",
							text = _event.m.Luft.getName() + " gains [color=" + ::Const.UI.Color.PositiveEventValue + "]+2[/color] Resolve"
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
							text = _event.m.Luft.getName() + " gains [color=" + ::Const.UI.Color.PositiveEventValue + "]+5[/color] Hitpoints"
						},
						{
							id = 17,
							icon = "ui/icons/fatigue.png",
							text = _event.m.Luft.getName() + " gains [color=" + ::Const.UI.Color.PositiveEventValue + "]+7[/color] Fatigue"
						},
					]);
					break;

				case "supplies.strange_meat":
					this.Text = "[img]gfx/ui/events/event_14.png[/img]%SPEECH_START%Hmm yes! I hope this is not rat meat%SPEECH_OFF%";
					option_text = "It\'s rat meat";
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
							text = _event.m.Luft.getName() + " gains [color=" + ::Const.UI.Color.PositiveEventValue + "]+2[/color] Hitpoints"
						},
						{
							id = 17,
							icon = "ui/icons/bravery.png",
							text = _event.m.Luft.getName() + " gains [color=" + ::Const.UI.Color.PositiveEventValue + "]+2[/color] Resolve"
						},
						{
							id = 17,
							icon = "ui/icons/fatigue.png",
							text = _event.m.Luft.getName() + " gains [color=" + ::Const.UI.Color.PositiveEventValue + "]+2[/color] Fatigue"
						},
						{
							id = 17,
							icon = "ui/icons/initiative.png",
							text = _event.m.Luft.getName() + " gains [color=" + ::Const.UI.Color.PositiveEventValue + "]+2[/color] Initiative"
						},
						{
							id = 17,
							icon = "ui/icons/melee_skill.png",
							text = _event.m.Luft.getName() + " gains [color=" + ::Const.UI.Color.PositiveEventValue + "]+2[/color] Melee Skill"
						},
						{
							id = 17,
							icon = "ui/icons/ranged_skill.png",
							text = _event.m.Luft.getName() + " gains [color=" + ::Const.UI.Color.PositiveEventValue + "]+2[/color] Ranged Skill"
						},
						{
							id = 17,
							icon = "ui/icons/melee_defense.png",
							text = _event.m.Luft.getName() + " gains [color=" + ::Const.UI.Color.PositiveEventValue + "]+2[/color] Melee Defense"
						},
						{
							id = 17,
							icon = "ui/icons/ranged_defense.png",
							text = _event.m.Luft.getName() + " gains [color=" + ::Const.UI.Color.PositiveEventValue + "]+2[/color] Ranged Defense"
						},
					]);
					break;
				}
				
				
				this.List.insert(0, {
					id = 10,
					icon = ::Const.MoodStateIcon[_event.m.Luft.getMoodState()],
					text = _event.m.Luft.getName() + ::Const.MoodStateEvent[_event.m.Luft.getMoodState()]
				});
				_event.m.Luft.getSkills().update();

				this.Options.insert(0, {
					Text = option_text,
					function getResult( _event )
					{
						if (isTrolled)
						{
							_event.m.Luft.worsenMood(2.0, "Someone fed me with rat meat");
						}

						return "A";
					}

				});

			}

		});
	}

	function onPrepare()
	{
		this.m.Title = "The Skin Ghoul Mascot";
		
		foreach (b in ::World.getPlayerRoster().getAll())
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
			"legend_yummy_sausages",
			"fermented_unhold_heart_item",
			"pickled_mushrooms_item",
			"dried_lamb_item",
			"black_marsh_stew_item"
		];

		while (foods.len() > 5)
		{
			foods.remove(::Math.rand(0, foods.len() - 1));
		}

		foreach ( f in foods )
		{
			this.m.Foods.push(::new("scripts/items/supplies/" + f));
		}
		
		local foods = [
			"Enduriel",
			"TaroEld",
			"MuffledMagda",
			"Warrior Alpha Male (Luke)",
			"Uberbagel",
			"Wuxiangjinxing",
			"Necro"
		];

		if (::Math.rand(1, 100) <= 25)
		{
			foods.push("Poss");
		}

		if (::Is_PTR_Exist)
		{
			foods.push("LordMidas");
		}

		while (foods.len() > 4)
		{
			foods.remove(::Math.rand(0, foods.len() - 1));
		}

		this.m.DiscordMembers.extend(foods);
	}

	function onPrepareVariables( _vars )
	{
	}

	function onUpdateScore()
	{
		return;
	}

	function onClear()
	{
		this.m.Luft = null;
		this.m.Food = null;
		this.m.IsReceivedBuff = false;
		this.m.Foods = [];
		this.m.Food = null;
		this.m.DiscordMembers = [];
		this.m.DiscordMember = null;
		this.m.Weapon = null;
		this.m.IsReceivedBuff = false;
		this.m.HasPet = false;
		this.m.HasGivenWeapon = false;
		this.m.HasMeal = false;
		this.m.HasNewPerks = null;
	}

});

