this.luft_intro_event <- this.inherit("scripts/events/event", {
	m = {
		Luft = null,
		Foods = [],
		Food = null,
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
			Text = "[img]gfx/ui/events/event_12.png[/img]%SPEECH_START%Where am i? This is not my room!%SPEECH_OFF%%SPEECH_START%Who are you? What do you mean i\'m in a game?%SPEECH_OFF%%SPEECH_START%My Gosh! Please don\'t hurt me, i\'m just a cute nacho with a rat fetish. Please don\'t force me to do weird stuffs%SPEECH_OFF%%SPEECH_START%By the way, can i pet you?%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";

				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}

				if (!_event.m.HasPet)
				{
					this.Options.push({
						Text = "No! I will pet you instead",
						function getResult( _event )
						{
							return "Pet1";
						}

					});
					this.Options.push({
						Text = "Ok! But just one",
						function getResult( _event )
						{
							return "Pet2";
						}

					});
				}

				if (!_event.m.HasMeal)
				{
					this.Options.push({
						Text = "Are you hungry, Luft?",
						function getResult( _event )
						{
							return "Eat";
						}

					});
				}

				if (!_event.m.HasGivenWeapon)
				{
					this.Options.push({
						Text = "I have a gift for you!",
						function getResult( _event )
						{
							return "Weapons";
						}

					});
				}

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

				this.Options.push({
					Text = "Bless me with your wisdom",
					function getResult( _event )
					{
						return "Tips";
					}

				});

				if (_event.m.HasMeal && _event.m.HasGivenWeapon && _event.m.HasNewPerks)
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
							local new = this.Const.Perks.MeleeWeaponTrees.getRandom(exclude);
							exclude.push(new.ID);
							_event.m.Luft.getBackground().addPerkGroup(new.Tree);
						}

						if (::mods_getRegisteredMod("mod_legends_PTR") != null)
						{
							_event.m.Luft.getBackground().addPerkGroup(this.Math.rand(1, 2) == 1 ? this.Const.Perks.OneHandedTree.Tree : this.Const.Perks.TwoHandedTree.Tree);
						}
						return "A";
					}

				},
				{
					Text = "How to use bow and arrow",
					function getResult( _event )
					{
						_event.m.Luft.getBackground().addPerkGroup(this.Const.Perks.BowTree.Tree);
						_event.m.Luft.getBackground().addPerkGroup(this.Const.Perks.CrossbowTree.Tree);
						_event.m.Luft.getBackground().addPerk(this.Const.Perks.PerkDefs.QuickHands, 1);
						_event.m.Luft.getTalents()[this.Const.Attributes.RangedSkill] = 3;
						_event.m.Luft.m.Attributes = [];
						_event.m.Luft.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);

						if (::mods_getRegisteredMod("mod_legends_PTR") != null)
						{
							_event.m.Luft.getBackground().addPerkGroup(this.Const.Perks.RangedTree.Tree);
						}
						return "A";
					}

				},
				{
					Text = "How to throw and sling stone",
					function getResult( _event )
					{
						_event.m.Luft.getBackground().addPerkGroup(this.Const.Perks.SlingsTree.Tree);
						_event.m.Luft.getBackground().addPerkGroup(this.Const.Perks.ThrowingTree.Tree);
						_event.m.Luft.getBackground().addPerk(this.Const.Perks.PerkDefs.QuickHands, 1);
						_event.m.Luft.getTalents()[this.Const.Attributes.RangedSkill] = 3;
						_event.m.Luft.m.Attributes = [];
						_event.m.Luft.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);

						if (::mods_getRegisteredMod("mod_legends_PTR") != null)
						{
							_event.m.Luft.getBackground().addPerkGroup(this.Const.Perks.RangedTree.Tree);
						}
						return "A";
					}

				},
				{
					Text = "How to be useless",
					function getResult( _event )
					{
						_event.m.Luft.improveMood(1.0, "Yay i have become useless");
						return "A";
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

				_event.m.HasNewPerks = true;
			}

		});

		this.m.Screens.push({
			ID = "Eat",
			Text = "[img]gfx/ui/events/event_61.png[/img]%SPEECH_START%O' boy! Just in time for me to have breakfast. What will you give me? Such a good boy you are!%SPEECH_OFF%%SPEECH_START%I\'ll give you a pet for that.%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I heard you eat discord member for snack, is that true?",
					function getResult( _event )
					{
						return "EatDiscordMember";
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

				local quotes = [
					"I have ",
					"Hope you like ",
					"Just some ",
					"Hmm yes, ",
					"How about some ",
					"Surprise! It\'s "
				];

				foreach (i, food in _event.m.Foods ) 
				{
				   	this.Options.insert(0, {
						Text = quotes[this.Math.rand(0, quotes.len() - 1)] + "[color=#bcad8c]" + food.getName() + "[/color]",
						Index = i,
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
			Text = "[img]gfx/ui/events/event_69.png[/img]%SPEECH_START%Of course! Magda often bans people without knowing they will all sent to my tummy by doing that. Don\'t tell Magda about that or you shall be my lunch.%SPEECH_OFF%%SPEECH_START%Do you want me to show you how i do it?%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";

				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}

				local quotes = [
					"Let\'s try with ",
					"I know just the person for you, ",
					"Hmm yes, ",
					"You can have ",
				];

				foreach (i, food in _event.m.DiscordMembers ) 
				{
				   	this.Options.insert(0, {
						Text = quotes[this.Math.rand(0, quotes.len() - 1)] + "[color=#bcad8c]" + food + "[/color]",
						Name = food,
						function getResult( _event )
						{
							_event.m.DiscordMember = this.Name;
							return "EatDiscordMember2";
						}

					});
				}
			}

		});

		this.m.Screens.push({
			ID = "EatDiscordMember2",
			Text = "[img]gfx/ui/events/event_12.png[/img]%SPEECH_START%I\'m so full. You see, this is a delicacy of Discord. The finest fast food restaurant i have ever known.%SPEECH_OFF%",
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
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
				this.Text = "[img]gfx/ui/events/event_12.png[/img]%SPEECH_START%I\'m so sorry, " + _event.m.DiscordMember + "! But you are so tasty, i wish there are two of you for me to enjoy more.%SPEECH_OFF%";
				
				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}

				switch (_event.m.DiscordMember)
				{
				case "Poss":
					_event.m.Luft.getBackground().addPerk(this.Const.Perks.PerkDefs.HexenChampion, 6);
					local perk = this.new("scripts/skills/perks/perk_champion");
					_event.m.Luft.getSkills().add(perk);

					this.List.push({
						id = 10,
						icon = perk.getIcon(),
						text = _event.m.Luft.getName() + " gains '" + perk.getName() + "' perk"
					});
					break;

				case "Enduriel":
					_event.m.Luft.getBackground().addPerk(this.Const.Perks.PerkDefs.LegendFavouredEnemySkeleton, 4);
					local perk = this.new("scripts/skills/perks/perk_legend_favoured_enemy_skeleton");
					_event.m.Luft.getSkills().add(perk);
					_event.m.Luft.getLifetimeStats().Tags.increment("Enemy" + this.Const.EntityType.SkeletonLight, 20);

					this.List.push({
						id = 10,
						icon = perk.getIcon(),
						text = _event.m.Luft.getName() + " gains '" + perk.getName() + "' perk"
					});
					break;

				case "TaroEd":
					_event.m.Luft.getBackground().addPerk(this.Const.Perks.PerkDefs.BearLineBreaker, 4);
					local perk = this.new("scripts/skills/perks/perk_line_breaker");
					_event.m.Luft.getBaseProperties().Stamina += 10;
					_event.m.Luft.getSkills().add(perk);
					this.List.extend([
					{
							id = 10,
							icon = perk.getIcon(),
							text = _event.m.Luft.getName() + " gains '" + perk.getName() + "' perk"
						},
						{
							id = 17,
							icon = "ui/icons/fatigue.png",
							text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+10[/color] Fatigue"
						},
					]);
					break;

				case "MuffledMagda":
					_event.m.Luft.getBackground().addPerk(this.Const.Perks.PerkDefs.AlpShadowCopy, 5);
					
					this.List.push({
						id = 10,
						icon = "ui/perks/perk_afterimage.png",
						text = _event.m.Luft.getName() + " can learn '" + this.Const.Strings.PerkName.AlpShadowCopy + "' perk"
					});
					break;

				case "Fallen Wolf (Luke)":
					_event.m.Luft.getBackground().addPerk(this.Const.Perks.PerkDefs.LegendFavouredEnemyDirewolf, 2);
					local perk = this.new("scripts/skills/perks/perk_charm_enemy_direwolf");
					_event.m.Luft.getSkills().add(perk);
					this.List.push({
						id = 10,
						icon = perk.getIcon(),
						text = _event.m.Luft.getName() + " gains '" + perk.getName() + "' perk"
					});
					perk = this.new("scripts/skills/perks/perk_legend_favoured_enemy_direwolf");
					_event.m.Luft.getSkills().add(perk);
					this.List.push({
						id = 10,
						icon = perk.getIcon(),
						text = _event.m.Luft.getName() + " gains '" + perk.getName() + "' perk"
					});
					break;
				
				case "Wuxiangjinxing":
					local item;
					if (!this.IsAccessoryCompanionsExist)
					{
						item = this.new("scripts/items/accessory/wolf_item");
					}
					else 
					{
						item = this.new("scripts/items/accessory/wardog_item");
						item.setType(this.Const.Companions.TypeList.Nacho);
						local nacho = this.World.getTemporaryRoster().create("scripts/entity/tactical/enemies/ghoul");
						local nacho_perks = nacho.getSkills().query(this.Const.SkillType.Perk);
						foreach(perk in nacho_perks)
						{
							local quirk = "";
							foreach( i, v in this.getroottable().Const.Perks.PerkDefObjects )
							{
								if (perk.getID() == v.ID)
								{
									quirk = v.Script;
									break;
								}
							}
							if (quirk != "" && item.m.Quirks.find(quirk) == null)
							{
								item.m.Quirks.push(quirk);
							}			
						}

						item.updateCompanion();
					}
					_event.m.Luft.getItems().equip(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = _event.m.Luft.getName() + " gets " + item.getName() + " as pet"
					});
					_event.m.Luft.m.PerkPoints += 1;
					this.List.push({
						id = 10,
						icon = "ui/icons/perks",
						text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveValue + "]1[/color] perk point"
					});
					this.World.getTemporaryRoster().clear();
					break;

				case "Uberbagel":
					_event.m.Luft.grow(true);
					this.List.push({
						id = 10,
						icon = "skills/patting_skill.png",
						text = _event.m.Luft.getName() + " grows rapidly"
					});
					local perk;
					if (::mods_getRegisteredMod("mod_legends_PTR") != null)
					{
						_event.m.Luft.getBackground().addPerk(this.Const.Perks.PerkDefs.PTRRisingStar, 6);
						perk = this.new("scripts/skills/perks/perk_ptr_rising_star");
					}
					else 
					{
					    _event.m.Luft.getBackground().addPerk(this.Const.Perks.PerkDefs.Gifted, 2);
						perk = this.new("scripts/skills/perks/perk_gifted");
					}
					_event.m.Luft.getSkills().add(perk);
					this.List.push({
						id = 10,
						icon = perk.getIcon(),
						text = _event.m.Luft.getName() + " gains '" + perk.getName() + "' perk"
					});
					break;

				case "LordMidas":
					_event.m.Luft.getBackground().addPerk(this.Const.Perks.PerkDefs.PTRDiscoveredTalent, 2);
					perk = this.new("scripts/skills/perks/perk_ptr_discovered_talent");
					_event.m.Luft.getSkills().add(perk);
					this.List.push({
						id = 10,
						icon = perk.getIcon(),
						text = _event.m.Luft.getName() + " gains '" + perk.getName() + "' perk"
					});
					break;

				case "Necro":
					_event.m.Luft.getBackground().addPerk(this.Const.Perks.PerkDefs.LegendRaiseUndead, 6);
					perk = this.new("scripts/skills/perks/perk_legend_raise_undead");
					_event.m.Luft.getSkills().add(perk);
					this.List.push({
						id = 10,
						icon = perk.getIcon(),
						text = _event.m.Luft.getName() + " gains '" + perk.getName() + "' perk"
					});
					break;
				}
				
				this.List.insert(0, {
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Luft.getMoodState()],
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
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";

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
							icon = this.Const.MoodStateIcon[_event.m.Luft.getMoodState()],
							text = _event.m.Luft.getName() + this.Const.MoodStateEvent[_event.m.Luft.getMoodState()]
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
								_event.m.Weapon = this.new("scripts/items/weapons/wooden_stick");
								_event.m.Luft.getItems().equip(_event.m.Weapon);
								return "Weapons";
							}

						},
						{
							Text = "A Long Stick",
							function getResult( _event )
							{
								_event.m.Weapon = this.new("scripts/items/weapons/legend_staff");
								_event.m.Luft.getItems().equip(_event.m.Weapon);
								return "Weapons";
							}

						},
						{
							Text = "A Pointy Stick",
							function getResult( _event )
							{
								_event.m.Weapon = this.new("scripts/items/weapons/militia_spear");
								_event.m.Luft.getItems().equip(_event.m.Weapon);
								return "Weapons";
							}

						},
						{
							Text = "A Stick With A String",
							function getResult( _event )
							{
								local items = [
									["legend_sling", ""],
									["short_bow", "quiver_of_arrows"],
									["light_crossbow", "quiver_of_bolts"],
								];
								local choose = items[this.Math.rand(0, items.len() - 1)];
								_event.m.Weapon = this.new("scripts/items/weapons/" + choose[0]);
								_event.m.Luft.getItems().equip(_event.m.Weapon);

								if (choose[1] != "")
								{
									_event.m.Luft.getItems().equip(this.new("scripts/items/weapons/" + choose[1]));
								}

								return "Weapons";
							}

						},
						{
							Text = "A Hard To Use Stick",
							function getResult( _event )
							{
								_event.m.Weapon = this.new("scripts/items/weapons/wooden_flail");
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
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";

				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}

				_event.m.Luft.improveMood(4.0, "Got a head pat");
				_event.m.Luft.addXP(100, false);
				
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Luft.getMoodState()],
					text = _event.m.Luft.getName() + this.Const.MoodStateEvent[_event.m.Luft.getMoodState()]
				});
				this.List.push({
					id = 17,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]250[/color] XP"
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
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";

				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}

				_event.m.Luft.improveMood(0.5, "I just pat someone");
				_event.m.Luft.addXP(250, false);
				
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Luft.getMoodState()],
					text = _event.m.Luft.getName() + this.Const.MoodStateEvent[_event.m.Luft.getMoodState()]
				});
				this.List.push({
					id = 17,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]250[/color] XP"
				});
			}

		});


		local wisdom1 = "%SPEECH_START%They say [color=#bcad8c]Ijirok[/color] can be charmed or just put IJIROK to the seed.%SPEECH_OFF%";
		local wisdom2 = "%SPEECH_START%I heard there is an ultimate [color=#bcad8c]Simp[/color] level earned by love and rejection.%SPEECH_OFF%";
		local wisdom3 = "%SPEECH_START%Necro used to tell me, Spider can guide you to their [color=#bcad8c]Nest[/color].%SPEECH_OFF%";
		local wisdom4 = "%SPEECH_START%A wise man once told me, [color=#bcad8c]Credits[/color] can lead you to secret.%SPEECH_OFF%";
		this.m.Screens.push({
			ID = "Tips",
			Text = "[img]gfx/ui/events/event_40.png[/img]{" + wisdom1 + " | " + wisdom2 + " | " + wisdom3 + " | " + wisdom4 + "}",
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
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";

				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}

				if (!_event.m.IsReceivedBuff)
				{
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
					_event.m.IsReceivedBuff = true;
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
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
				local option_text = "You\'re welcome Luft";
				local isTrolled = false;
				local food = _event.m.Foods[_event.m.Food];
				_event.m.Luft.improveMood(0.5, "Have a good meal");
				_event.m.Luft.grow(true);

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
							text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+5[/color] Fatigue"
						},
						{
							id = 17,
							icon = "ui/icons/melee_skill.png",
							text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+3[/color] Melee Skill"
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
							text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+5[/color] Ranged Skill"
						},
						{
							id = 17,
							icon = "ui/icons/ranged_defense.png",
							text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+3[/color] Ranged Defense"
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
							text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+5[/color] Initiative"
						},
						{
							id = 17,
							icon = "ui/icons/bravery.png",
							text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+3[/color] Resolve"
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
							text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+5[/color] Fatigue"
						},
						{
							id = 17,
							icon = "ui/icons/bravery.png",
							text = _event.m.Luft.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+3[/color] Resolve"
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
					_event.m.Luft.getBaseProperties().Bravery += 2;
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
			"legend_yummy_sausages",
			"fermented_unhold_heart_item",
			"pickled_mushrooms_item",
			"dried_lamb_item",
			"black_marsh_stew_item"
		];

		while (foods.len() > 5)
		{
			local index = this.Math.rand(0, foods.len() - 1);
			foods.remove(index);
		}

		foreach ( f in foods )
		{
			this.m.Foods.push(this.new("scripts/items/supplies/" + f));
		}
		
		local foods = [
			"Enduriel",
			"TaroEd",
			"MuffledMagda",
			"Fallen Wolf (Luke)",
			"Uberbagel",
			"Wuxiangjinxing",
			"Necro"
		];

		if (this.Math.rand(1, 100) <= 25)
		{
			foods.push("Poss");
		}

		if (::mods_getRegisteredMod("mod_legends_PTR") != null)
		{
			foods.push("LordMidas");
		}

		while (foods.len() > 4)
		{
			local index = this.Math.rand(0, foods.len() - 1);
			foods.remove(index);
		}

		foreach ( f in foods )
		{
			this.m.DiscordMembers.push(f);
		}
	}

	function onPrepareVariables( _vars )
	{
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

