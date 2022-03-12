this.getroottable().HexenHooks.hookContracts <- function ()
{
	//
	::mods_hookExactClass("contracts/contracts/hunting_hexen_contract", function(obj) 
	{
		local ws_createStates = obj.createStates;
		obj.createStates = function()
		{
			ws_createStates();

			foreach(i, state in this.m.States)
			{
				if (state.ID == "Offer")
				{
					state.countHexe <- function()
					{
						local moral = [
							"Chivalrous",
							"Saintly"
						];
						local exclude = [
							"scenario.legends_crusader",
							"scenario.legends_inquisition",
							"scenario.sato_escaped_slaves",
							"scenario.paladins",
						];

						if (moral.find(this.World.Assets.getMoralReputationAsText()) != null)
						{
							return 5;
						}

						if (this.World.Assets.getOrigin() != null && exclude.find(this.World.Assets.getOrigin().getID()) != null)
						{
							return 5;
						}

						local brothers = this.World.getPlayerRoster().getAll();
						local count = 0;

						foreach( bro in brothers )
						{
							if (bro.getFlags().has("isBonus") && bro.getSkills().hasSkill("background.hexen"))
							{
								++count;
							}
						}

						return count;
					};
					state.end = function()
					{
						this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
						local r = this.Math.rand(1, 100);
						local isRight = this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
						local hexeCount = this.countHexe();

						if (isRight)
						{
							if (r <= 20)
							{
								this.Flags.set("IsSpiderQueen", true);
							}
							else if (r <= 37)
							{
								this.Flags.set("IsEnchantedVillager", true);
							}
							else if (r <= 60)
							{
								this.Flags.set("IsSinisterDeal", true);
							}
							else if (hexeCount < 3)
							{
							    this.Flags.set("IsHiringHexe", true);
							}
						}
						else
						{
							if (r <= 15)
							{
								this.Flags.set("IsSpiderQueen", true);
							}
							else if (r <= 35)
							{
								this.Flags.set("IsCurse", true);
							}
							else if (r <= 45)
							{
								this.Flags.set("IsEnchantedVillager", true);
							}
							else if (r <= 55)
							{
								this.Flags.set("IsSinisterDeal", true);
							}
							else if (r <= 65 && hexeCount < 1)
							{
							    this.Flags.set("IsHiringHexe", true);
							}
						}

						this.Flags.set("StartTime", this.Time.getVirtualTimeF());
						this.Flags.set("Delay", this.Math.rand(10, 30) * 1.0);
						local envoy = this.World.getGuestRoster().create("scripts/entity/tactical/humans/firstborn");
						envoy.setName(this.Flags.get("ProtecteeName"));
						envoy.setTitle("");
						envoy.setFaction(1);
						this.Flags.set("ProtecteeID", envoy.getID());
						this.Contract.m.Home.setLastSpawnTimeToNow();
						this.Contract.setScreen("Overview");
						this.World.Contracts.setActiveContract(this.Contract);
					};
				}
				else if (state.ID == "Running")
				{
					state.update = function()
					{
						if (!this.Contract.isPlayerNear(this.Contract.getHome(), 600))
						{
							this.Flags.set("IsFail2", true);
						}

						if (this.Flags.has("IsFail1") || this.World.getGuestRoster().getSize() == 0)
						{
							this.Contract.setScreen("Failure1");
							this.World.Contracts.showActiveContract();
						}
						else if (this.Flags.has("IsFail2"))
						{
							this.Contract.setScreen("Failure2");
							this.World.Contracts.showActiveContract();
						}
						else if (this.Flags.has("IsVictory"))
						{
							if (this.Flags.get("IsCurse"))
							{
								local bros = this.World.getPlayerRoster().getAll();
								local candidates = [];

								foreach( bro in bros )
								{
									if (bro.getSkills().hasSkill("trait.superstitious"))
									{
										candidates.push(bro);
									}
								}

								if (candidates.len() == 0)
								{
									this.Contract.setScreen("Success");
								}
								else
								{
									this.Contract.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];
									this.Contract.setScreen("Curse");
								}
							}
							else if (this.Flags.get("IsEnchantedVillager"))
							{
								this.Contract.setScreen("EnchantedVillager");
							}
							else
							{
								this.Contract.setScreen("Success");
							}

							this.World.Contracts.showActiveContract();
						}
						else if (this.Flags.get("StartTime") + this.Flags.get("Delay") <= this.Time.getVirtualTimeF())
						{
							if (this.Flags.get("IsHiringHexe") && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
							{
								this.Contract.setScreen("HiringHexe");
							}
							else if (this.Flags.get("IsSpiderQueen"))
							{
								this.Contract.setScreen("SpiderQueen");
							}
							else if (this.Flags.get("IsSinisterDeal") && this.World.Assets.getStash().hasEmptySlot())
							{
								this.Contract.setScreen("SinisterDeal");
							}
							else
							{
								this.Contract.setScreen("Encounter");
							}

							this.World.Contracts.showActiveContract();
						}
						else if (!this.Flags.get("IsBanterShown") && this.Math.rand(1, 1000) <= 1 && this.Flags.get("StartTime") + 6.0 <= this.Time.getVirtualTimeF())
						{
							this.Flags.set("IsBanterShown", true);
							this.Contract.setScreen("Banter");
							this.World.Contracts.showActiveContract();
						}
					}
				}
			}
		};

		local ws_createScreens = obj.createScreens;
		obj.createScreens = function()
		{
			ws_createScreens();

			foreach(i, screen in this.m.Screens)
			{
				if (screen.ID == "SinisterDeal")
				{
					screen.Text = "[img]gfx/ui/events/event_106.png[/img]{%randombrother% whistles and tips his cap at the beautiful ladies which have arrived seemingly out of nowhere to swoon before the company. You hold the sellsword back and step forward, but before you can speak one of the women holds her hands up and strides to meet you.%SPEECH_ON%Let me show you my true self, sellsword.%SPEECH_OFF%Her arms go to her sides and there turn grey and shrivel like wet almond skin. Once bright and silken hair falls out in long wispy strands until her grotesque skull is bared, the last roots there holding clumped assemblage of gnats and lice like final congregates upon a dying world. She bows, her face up toward you with a yellow grin shorn across it.%SPEECH_ON%We\'ve great power, sellsword, of this you surely see. I offer you a deal.%SPEECH_OFF%She produces a tiny vial in each hand, one carrying a drop of green liquid, the other blue. She smiles and spins them in her fingers as she talks.%SPEECH_ON%A drink for the body, or for the spirit. Men would kill for either. I offer you one in exchange for the firstborn\'s life. Or you want to keep one of my slave as a pet. What worth is the offspring of a stranger? You\'ve slaughtered your fair share, have you not? Stand aside, sellsword, and let us have this one. Or confront us, risk your men\'s lives, and your own, all for some runt who won\'t remember your face in due time. It\'s your choice.%SPEECH_OFF%}";
					screen.start <- function()
					{
						if (this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
						{
							this.Options.push({
								Text = "I desire a loyal slave to do my bidding.",
								function getResult()
								{
									return "SinisterDealCharmedSlave";
								}
							});
						}
					};
				}
			}

			this.m.Screens.push({
				ID = "SinisterDealCharmedSlave",
				Title = "Near %townname%",
				Text = "[img]gfx/ui/events/event_106.png[/img]{With a flip of her hand and a bump of her wrist the witch shunts the green and blue vial down her sleeve.%SPEECH_ON%A smart man you are, sellsword.%SPEECH_OFF%She snorts harshly, her fat nose shriveling into a maggot\'s girth before flopping back down.%SPEECH_ON%I do sense sharp minded men in your blood, sellsword. I\'d almost want to have the blood for myself.%SPEECH_OFF%Her eyes stare at you like a cat upon a delimbed cricket, a cricket which still dares to move. But then her smile returns, more gum than teeth, more black than pink.%SPEECH_ON%Ah, well, a deal is a deal. Here you are.%SPEECH_OFF% As she speaks a creature comes out of the shadow behind her, it lowers its head at you. Distracted by it when you look back the witches are gone. You hear the faint cry of horrific torture, its distance seemingly both near and far, and you\'ve little doubt that it is the demise of %employer%\'s firstborn.}",
				Image = "",
				List = [],
				Characters = [],
				Options = [
					{
						Text = "Too good a trade to refuse.",
						function getResult()
						{
							this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 2, "Betrayed " + this.Contract.getEmployer().getName() + " and struck a deal with witches");
							this.World.Contracts.finishActiveContract(true);
							return;
						}

					}
				],
				function start()
				{
					local roster = this.World.getPlayerRoster();
					local r = this.Const.CharmedListRegularContract[this.Math.rand(0, this.Const.CharmedListRegularContract.len() - 1)];
					local entity = roster.create("scripts/entity/tactical/" + r);
					entity.worsenMood(1.5, "Being sold out by master");
					entity.setScenarioValues();
					entity.onHired();
					entity.getSkills().add(this.new("scripts/skills/effects/fake_charmed_effect"));

					this.Characters.push(entity.getImagePath());
					this.List.push({
						id = 10,
						icon = entity.getBackground().getIcon(),
						text = entity.getName() + " has joined your company"
					});
				}

			});
			this.m.Screens.push({
				ID = "HiringHexe",
				Title = "Near %townname%",
				Text = "[img]gfx/ui/events/event_106.png[/img]{A lone woman crosses your path and approaches between a gap of trees.%SPEECH_ON% Let us not fight immediately, I have an offer to tell you. You surely know who am i, don\'t you?%SPEECH_OFF%You gesture  her to continue.%SPEECH_ON%You see, I\'ve great power, don\'t you think power like this would be needed at some time. Let me have the firstborn\'s life in exchange of my service. You won\'t regret for allowing me joining your company, i can guarantee that. Think about.%SPEECH_OFF%}",
				Image = "",
				List = [],
				Options = [
					{
						Text = "I will never yield that boy to you hags. To arms!",
						function getResult()
						{
							local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
							p.CombatID = "Hexen";
							p.Entities = [];
							p.Music = this.Const.Music.CivilianTracks;
							p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
							p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.HexenAndNoSpiders, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
							this.World.Contracts.startScriptedCombat(p, false, true, true);
							return 0;
						}
					},
					{
						Text = "Welcome to the company, sister!",
						function getResult()
						{
							return "SinisterDealHireHexe";
						}
					}
				],
			});
			this.m.Screens.push({
				ID = "SinisterDealHireHexe",
				Title = "Near %townname%",
				Text = "[img]gfx/ui/events/event_106.png[/img]{The witch smiles.%SPEECH_ON%A man is nothing without an able body to maneuver him through the world. Thanks for letting me be a part of your company. Well then please allow me to fetch my pay.%SPEECH_OFF%. The witch walks quickly through you then puts on a sprint likes a cat pounds at its prey. A lone cry is all that\'s left, piping up in else where near here. No doubt it is the demise of %employer%\'s firstborn.}",
				Image = "",
				List = [],
				Characters = [],
				Options = [
					{
						Text = "Be quick! We don\'t have time to play around",
						function getResult()
						{
							this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 2, "Betrayed " + this.Contract.getEmployer().getName() + " and struck a deal with witches");
							this.World.Contracts.finishActiveContract(true);
							return;
						}

					}
				],
				function start()
				{
					local roster = this.World.getPlayerRoster();
					local brothers = roster.getAll();
					local hexe = roster.create("scripts/entity/tactical/player_hexen");
					hexe.setStartValuesEx([
						"lesser_hexen_background"
					]);
					hexe.getBackground().buildDescription(true);
					hexe.onHired();

					this.Characters.push(hexe.getImagePath());
					this.List.push({
						id = 10,
						icon = hexe.getBackground().getIcon(),
						text = hexe.getName() + " has joined your company"
					});

					foreach ( _bro in brothers )
					{
						if (_bro.getSkills().hasSkill("effects.fake_charmed"))
						{
							continue;
						}

						if (this.Const.WitchHaters.find(_bro.getBackground().getID()) == null)
						{
							continue;
						}

						_bro.worsenMood(2.0, "A witch has joined " + this.World.Assets.getName());
						_bro.worsenMood(2.0, "Suspect you to be a heretic");

						if (_bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[_bro.getMoodState()],
								text = _bro.getName() + this.Const.MoodStateEvent[_bro.getMoodState()]
							});
						}
					}
				}
			});

		};
	});


	//
	::mods_hookExactClass("contracts/contracts/legend_hunting_coven_leader_contract", function(obj) 
	{
		local ws_createStates = obj.createStates;
		obj.createStates = function()
		{
			ws_createStates();

			foreach(i, state in this.m.States)
			{
				if (state.ID == "Offer")
				{
					state.countHexe <- function()
					{
						local moral = [
							"Chivalrous",
							"Saintly"
						];
						local exclude = [
							"scenario.legends_crusader",
							"scenario.legends_inquisition",
							"scenario.sato_escaped_slaves",
							"scenario.paladins",
						];

						if (moral.find(this.World.Assets.getMoralReputationAsText()) != null)
						{
							return 5;
						}

						if (this.World.Assets.getOrigin() != null && exclude.find(this.World.Assets.getOrigin().getID()) != null)
						{
							return 5;
						}

						local brothers = this.World.getPlayerRoster().getAll();
						local count = 0;

						foreach( bro in brothers )
						{
							if (bro.getFlags().has("isBonus") && bro.getSkills().hasSkill("background.hexen"))
							{
								++count;
							}
						}

						return count;
					};
					state.end = function()
					{
						this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
						local r = this.Math.rand(1, 100);
						local isRight = this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
						local hexeCount = this.countHexe();

						if (isRight)
						{
							if (r <= 20)
							{
								this.Flags.set("IsSpiderQueen", true);
							}
							else if (r <= 37)
							{
								this.Flags.set("IsEnchantedVillager", true);
							}
							else if (r <= 60)
							{
								this.Flags.set("IsSinisterDeal", true);
							}
							else if (hexeCount < 3)
							{
							    this.Flags.set("IsHiringHexe", true);
							}
						}
						else
						{
							if (r <= 20)
							{
								this.Flags.set("IsSpiderQueen", true);
							}
							else if (r <= 20)
							{
								this.Flags.set("IsCurse", true);
							}
							else if (r <= 35)
							{
								this.Flags.set("IsEnchantedVillager", true);
							}
							else if (r <= 50)
							{
								this.Flags.set("IsSinisterDeal", true);
							}
							else if (r <= 70 && hexeCount < 1)
							{
							    this.Flags.set("IsHiringHexe", true);
							}
						}

						this.Flags.set("StartTime", this.Time.getVirtualTimeF());
						this.Flags.set("Delay", this.Math.rand(10, 30) * 1.0);
						local envoy = this.World.getGuestRoster().create("scripts/entity/tactical/humans/firstborn");
						envoy.setName(this.Flags.get("ProtecteeName"));
						envoy.setTitle("");
						envoy.setFaction(1);
						this.Flags.set("ProtecteeID", envoy.getID());
						this.Contract.m.Home.setLastSpawnTimeToNow();
						this.Contract.setScreen("Overview");
						this.World.Contracts.setActiveContract(this.Contract);
					};
				}
				else if (state.ID == "Running")
				{
					state.update = function()
					{
						if (!this.Contract.isPlayerNear(this.Contract.getHome(), 600))
						{
							this.Flags.set("IsFail2", true);
						}

						if (this.Flags.has("IsFail1") || this.World.getGuestRoster().getSize() == 0)
						{
							this.Contract.setScreen("Failure1");
							this.World.Contracts.showActiveContract();
						}
						else if (this.Flags.has("IsFail2"))
						{
							this.Contract.setScreen("Failure2");
							this.World.Contracts.showActiveContract();
						}
						else if (this.Flags.has("IsVictory"))
						{
							if (this.Flags.get("IsCurse"))
							{
								local bros = this.World.getPlayerRoster().getAll();
								local candidates = [];

								foreach( bro in bros )
								{
									if (bro.getSkills().hasSkill("trait.superstitious"))
									{
										candidates.push(bro);
									}
								}

								if (candidates.len() == 0)
								{
									this.Contract.setScreen("Success");
								}
								else
								{
									this.Contract.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];
									this.Contract.setScreen("Curse");
								}
							}
							else if (this.Flags.get("IsEnchantedVillager"))
							{
								this.Contract.setScreen("EnchantedVillager");
							}
							else
							{
								this.Contract.setScreen("Success");
							}

							this.World.Contracts.showActiveContract();
						}
						else if (!this.TempFlags.has("IsEncounterShown") && this.Flags.get("StartTime") + this.Flags.get("Delay") <= this.Time.getVirtualTimeF())
						{
							this.TempFlags.set("IsEncounterShown", true);

							if (this.Flags.get("IsHiringHexe") && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
							{
								this.Contract.setScreen("HiringHexe");
							}
							else if (this.Flags.get("IsSpiderQueen"))
							{
								this.Contract.setScreen("SpiderQueen");
							}
							else if (this.Flags.get("IsSinisterDeal") && this.World.Assets.getStash().hasEmptySlot())
							{
								this.Contract.setScreen("SinisterDeal");
							}
							else
							{
								this.Contract.setScreen("Encounter");
							}

							this.World.Contracts.showActiveContract();
						}
						else if (!this.Flags.get("IsBanterShown") && this.Math.rand(1, 1000) <= 1 && this.Flags.get("StartTime") + 6.0 <= this.Time.getVirtualTimeF())
						{
							this.Flags.set("IsBanterShown", true);
							this.Contract.setScreen("Banter");
							this.World.Contracts.showActiveContract();
						}	
					}
				}
			}
		};

		local ws_createScreens = obj.createScreens;
		obj.createScreens = function()
		{
			ws_createScreens();

			foreach(i, screen in this.m.Screens)
			{
				if (screen.ID == "SinisterDeal")
				{
					screen.Text = "[img]gfx/ui/events/event_106.png[/img]{%randombrother% whistles and tips his cap at the beautiful ladies which have arrived seemingly out of nowhere to swoon before the company. You hold the sellsword back and step forward, but before you can speak one of the women holds her hands up and strides to meet you.%SPEECH_ON%Let me show you my true self, sellsword.%SPEECH_OFF%Her arms go to her sides and there turn grey and shrivel like wet almond skin. Once bright and silken hair falls out in long wispy strands until her grotesque skull is bared, the last roots there holding clumped assemblage of gnats and lice like final congregates upon a dying world. She bows, her face up toward you with a yellow grin shorn across it.%SPEECH_ON%We\'ve great power, sellsword, of this you surely see. I offer you a deal.%SPEECH_OFF%She produces a tiny vial in each hand, one carrying a drop of green liquid, the other blue. She smiles and spins them in her fingers as she talks.%SPEECH_ON%A drink for the body, or for the spirit. Men would kill for either. I offer you one in exchange for the firstborn\'s life. Or you want to keep one of my slave as a pet. What worth is the offspring of a stranger? You\'ve slaughtered your fair share, have you not? Stand aside, sellsword, and let us have this one. Or confront us, risk your men\'s lives, and your own, all for some runt who won\'t remember your face in due time. It\'s your choice.%SPEECH_OFF%}";
					screen.start <- function()
					{
						if (this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
						{
							this.Options.push({
								Text = "I desire a loyal slave to do my bidding.",
								function getResult()
								{
									return "SinisterDealCharmedSlave";
								}
							});
						}
					};
				}
			}

			this.m.Screens.push({
				ID = "SinisterDealCharmedSlave",
				Title = "Near %townname%",
				Text = "[img]gfx/ui/events/event_106.png[/img]{With a flip of her hand and a bump of her wrist the witch shunts the green and blue vial down her sleeve.%SPEECH_ON%A smart man you are, sellsword.%SPEECH_OFF%She snorts harshly, her fat nose shriveling into a maggot\'s girth before flopping back down.%SPEECH_ON%I do sense sharp minded men in your blood, sellsword. I\'d almost want to have the blood for myself.%SPEECH_OFF%Her eyes stare at you like a cat upon a delimbed cricket, a cricket which still dares to move. But then her smile returns, more gum than teeth, more black than pink.%SPEECH_ON%Ah, well, a deal is a deal. Here you are.%SPEECH_OFF% As she speaks a creature comes out of the shadow behind her, it lowers its head at you. Distracted by it when you look back the witches are gone. You hear the faint cry of horrific torture, its distance seemingly both near and far, and you\'ve little doubt that it is the demise of %employer%\'s firstborn.}",
				Image = "",
				List = [],
				Characters = [],
				Options = [
					{
						Text = "Too good a trade to refuse.",
						function getResult()
						{
							this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 2, "Betrayed " + this.Contract.getEmployer().getName() + " and struck a deal with witches");
							this.World.Contracts.finishActiveContract(true);
							return;
						}

					}
				],
				function start()
				{
					local roster = this.World.getPlayerRoster();
					local r = this.Const.CharmedListSpecialContract[this.Math.rand(0, this.Const.CharmedListSpecialContract.len() - 1)];
					local entity = roster.create("scripts/entity/tactical/" + r);
					entity.worsenMood(1.0, "Being sold out by master");
					entity.setScenarioValues();
					entity.onHired();
					entity.getSkills().add(this.new("scripts/skills/effects/fake_charmed_effect"));

					this.Characters.push(entity.getImagePath());
					this.List.push({
						id = 10,
						icon = entity.getBackground().getIcon(),
						text = entity.getName() + " has joined your company"
					});
				}

			});
			this.m.Screens.push({
				ID = "HiringHexe",
				Title = "Near %townname%",
				Text = "[img]gfx/ui/events/event_106.png[/img]{A lone woman crosses your path and approaches between a gap of trees.%SPEECH_ON% Let us not fight immediately, I have an offer to tell you. You surely know who am i, don\'t you?%SPEECH_OFF%You gesture  her to continue.%SPEECH_ON%You see, I\'ve great power, don\'t you think power like this would be needed at some time. Let me have the firstborn\'s life in exchange of my service. You won\'t regret for allowing me joining your company, i can guarantee that. Think about.%SPEECH_OFF%}",
				Image = "",
				List = [],
				Options = [
					{
						Text = "I will never yield that boy to you hags. To arms!",
						function getResult()
						{
							local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
							p.CombatID = "Hexen";
							p.Entities = [];
							p.Music = this.Const.Music.CivilianTracks;
							p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
							p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.HexenAndNoSpiders, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
							this.World.Contracts.startScriptedCombat(p, false, true, true);
							return 0;
						}

					},
					{
						Text = "Welcome to the company, sister!",
						function getResult()
						{
							return "SinisterDealHireHexe";
						}
					}
				],
			});
			this.m.Screens.push({
				ID = "SinisterDealHireHexe",
				Title = "Near %townname%",
				Text = "[img]gfx/ui/events/event_106.png[/img]{The witch smiles.%SPEECH_ON%A man is nothing without an able body to maneuver him through the world. Thanks for letting me be a part of your company. Well then please allow me to fetch my pay.%SPEECH_OFF%. The witch walks quickly through you then puts on a sprint likes a cat pounds at its prey. A lone cry is all that\'s left, piping up in else where near here. No doubt it is the demise of %employer%\'s firstborn.}",
				Image = "",
				List = [],
				Characters = [],
				Options = [
					{
						Text = "Be quick! We don\'t have time to play around",
						function getResult()
						{
							this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 2, "Betrayed " + this.Contract.getEmployer().getName() + " and struck a deal with witches");
							this.World.Contracts.finishActiveContract(true);
							return;
						}

					}
				],
				function start()
				{
					local roster = this.World.getPlayerRoster();
					local brothers = roster.getAll();
					local hexe = roster.create("scripts/entity/tactical/player_hexen");
					hexe.setStartValuesEx([
						"lesser_hexen_background"
					]);
					hexe.getBackground().buildDescription(true);
					hexe.onHired();

					this.Characters.push(hexe.getImagePath());
					this.List.push({
						id = 10,
						icon = hexe.getBackground().getIcon(),
						text = hexe.getName() + " has joined your company"
					});

					foreach ( _bro in brothers )
					{
						if (_bro.getSkills().hasSkill("effects.fake_charmed"))
						{
							continue;
						}

						if (this.Const.WitchHaters.find(_bro.getBackground().getID()) == null)
						{
							continue;
						}

						_bro.worsenMood(2.0, "A witch has joined " + this.World.Assets.getName());
						_bro.worsenMood(2.0, "Suspect you to be a heretic");

						if (_bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[_bro.getMoodState()],
								text = _bro.getName() + this.Const.MoodStateEvent[_bro.getMoodState()]
							});
						}
					}
				}

			});

		};

		local ws_onIsValid = obj.onIsValid;
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				if (bro.getLevel() >= 20 && bro.getSkills().hasSkill("perk.mastery_charm"))
				{
					return true;
				}
			}

			return ws_onIsValid();
		};
	});


	::mods_hookExactClass("contracts/contracts/legend_hunting_skin_ghouls_contract", function ( obj )
	{
		local ws_onIsValid = obj.onIsValid;
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				if (bro.getLevel() >= 13 && bro.getSkills().hasSkill("perk.charm_enemy_ghoul") && bro.getSkills().hasSkill("perk.mastery_charm"))
				{
					return true;
				}
			}

			return ws_onIsValid();
		}
	});
	::mods_hookExactClass("contracts/contracts/legend_hunting_stollwurms_contract", function ( obj )
	{
		local ws_onIsValid = obj.onIsValid; // Min strength 500
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				if (bro.getLevel() >= 21 && bro.getSkills().hasSkill("perk.charm_enemy_lindwurm") && bro.getSkills().hasSkill("perk.mastery_charm"))
				{
					return true;
				}
			}

			return ws_onIsValid();
		}
	});
	::mods_hookExactClass("contracts/contracts/legend_hunting_white_direwolf_contract", function ( obj )
	{
		local ws_onIsValid = obj.onIsValid; // Min strength 200
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				if (bro.getLevel() >= 13 && bro.getSkills().hasSkill("perk.charm_enemy_direwolf") && bro.getSkills().hasSkill("perk.mastery_charm"))
				{
					return true;
				}
			}

			return ws_onIsValid();
		}

		local ws_createStates = obj.createStates;
		obj.createStates = function()
		{
			ws_createStates();

			foreach (i, state in this.m.States) 
			{
				if (state.ID == "Running")
				{
					state.onTargetAttacked = function( _dest, _isPlayerAttacking )
					{
						if (this.Flags.get("IsDriveOff") && !this.Flags.get("IsEncounterShown"))
						{
							this.Flags.set("IsEncounterShown", true);
							local bros = this.World.getPlayerRoster().getAll();
							local candidates = [];

							foreach( bro in bros )
							{
								if (bro.getBackground().getID() == "background.houndmaster" || bro.getBackground().getID() == "background.wildman" || bro.getBackground().getID() == "background.beast_slayer" || bro.getBackground().getID() == "background.legend_muladi" || bro.getBackground().getID() == "background.legend_ranger" || bro.getBackground().getID() == "background.legend_vala" || bro.getBackground().getID() == "background.legend_commander_vala" || bro.getBackground().getID() == "background.legend_commander_ranger" || bro.getSkills().hasSkill("perk.legend_favoured_enemy_direwolf") || bro.getSkills().hasSkill("perk.charm_enemy_unhold"))
								{
									candidates.push(bro);
								}
							}

							if (candidates.len() == 0)
							{
								this.World.Contracts.showCombatDialog(_isPlayerAttacking);
							}
							else
							{
								this.Contract.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];
								this.Contract.setScreen("DriveThemOff");
								this.World.Contracts.showActiveContract();
							}
						}
						else if (!this.Flags.get("IsEncounterShown"))
						{
							this.Flags.set("IsEncounterShown", true);
							this.Contract.setScreen("Encounter");
							this.World.Contracts.showActiveContract();
						}
						else
						{
							this.World.Contracts.showCombatDialog(_isPlayerAttacking);
						}
					}
				}
			}
		}
	});
	::mods_hookExactClass("contracts/contracts/legend_hunting_rock_unholds_contract", function ( obj )
	{
		local ws_onIsValid = obj.onIsValid; // Min strength 300
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				if (bro.getLevel() >= 16 && bro.getSkills().hasSkill("perk.charm_enemy_unhold") && bro.getSkills().hasSkill("perk.mastery_charm"))
				{
					return true;
				}
			}

			return ws_onIsValid();
		}
	});
	::mods_hookExactClass("contracts/contracts/legend_hunting_redback_webknechts_contract", function ( obj )
	{
		local ws_onIsValid = obj.onIsValid; // Min strength 100
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				if (bro.getLevel() >= 10 && bro.getSkills().hasSkill("perk.charm_enemy_spider") && bro.getSkills().hasSkill("perk.mastery_charm"))
				{
					return true;
				}
			}

			return ws_onIsValid();
		}
	});
	::mods_hookExactClass("contracts/contracts/legend_hunting_greenwood_schrats_contract", function ( obj )
	{
		local ws_onIsValid = obj.onIsValid; // Min strength 500
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				if (bro.getLevel() >= 21 && bro.getSkills().hasSkill("perk.charm_enemy_schrat") && bro.getSkills().hasSkill("perk.mastery_charm"))
				{
					return true;
				}
			}

			return ws_onIsValid();
		}
	});
	::mods_hookExactClass("contracts/contracts/legend_hunting_demon_alps_contract", function ( obj )
	{
		local ws_onIsValid = obj.onIsValid; // Min strength 200 
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				if (bro.getLevel() >= 13 && bro.getSkills().hasSkill("perk.charm_enemy_alps") && bro.getSkills().hasSkill("perk.mastery_charm"))
				{
					return true;
				}
			}

			return ws_onIsValid();
		}
	});


	//
	::mods_hookExactClass("contracts/contracts/return_item_contract", function(obj) 
	{
		local ws_createStates = obj.createStates;
		obj.createStates = function()
		{
			ws_createStates();
			local find;

			foreach (i, state in this.m.States )
			{
				if (state.ID == "Offer")
				{
					state.end = function()
					{
						this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
						local r = this.Math.rand(1, 100);

						if (r <= 30 || this.World.Statistics.getFlags().get("IsDoingNecromancerAmbition"))
						{
							this.Flags.set("IsCounterOffer", true);
							this.Flags.set("Bribe", this.Contract.beautifyNumber(this.Contract.m.Payment.getOnCompletion() * this.Math.rand(100, 300) * 0.01));
						}
						else if (r <= 45)
						{
							if (this.Contract.getDifficultyMult() >= 0.95)
							{
								this.Flags.set("IsNecromancer", true);
							}
						}
						else
						{
							this.Flags.set("IsBandits", true);
						}

						this.Flags.set("StartDay", this.World.getTime().Days);
						local playerTile = this.World.State.getPlayer().getTile();
						local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 10, [
							this.Const.World.TerrainType.Mountains
						]);
						local party;
						party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).spawnEntity(tile, "Thieves", false, this.Const.World.Spawn.BanditRaiders, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						party.setDescription("A group of thieves and bandits.");
						party.setFootprintType(this.Const.World.FootprintsType.Brigands);
						party.setAttackableByAI(false);
						party.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
						party.setFootprintSizeOverride(0.75);
						this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.GenericFootprints, this.Const.World.FootprintsType.Brigands, 0.75);
						this.Contract.m.Target = this.WeakTableRef(party);
						party.getSprite("banner").setBrush("banner_bandits_0" + this.Math.rand(1, 6));
						local c = party.getController();
						local wait = this.new("scripts/ai/world/orders/wait_order");
						wait.setTime(9000.0);
						c.addOrder(wait);
						this.Contract.setScreen("Overview");
						this.World.Contracts.setActiveContract(this.Contract);
					};
					break;
				}
			}
		};

		local ws_createScreens = obj.createScreens;
		obj.createScreens = function()
		{
			ws_createScreens();

			foreach (i, screen in this.m.Screens )
			{
				if (screen.ID == "CounterOffer1")
				{
					screen.start <- function()
					{
						if (this.World.Statistics.getFlags().get("IsDoingNecromancerAmbition"))
						{
							this.Options.push({
								Text = "I'll only take half of that for a favor later.",
								function getResult()
								{
									this.updateAchievement("NeverTrustAMercenary", 1, 1);
									this.World.Statistics.getFlags().increment("GiftsToNecromacer");
									this.Flags.set("Bribe", this.Math.floor(this.Flags.getAsInt("Bribe") * 0.5));
									return "CounterOffer2";
								}
							});
						}
					};
					break;
				}
			}
		};
	});

	delete this.HexenHooks.hookContracts;
}