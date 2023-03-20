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
					if (::Const.GoodMoralReputaions.find(::World.Assets.getMoralReputationAsText()) != null)
					{
						return 5;
					}

					if (::Const.GoodOrigins.find(::World.Assets.getOrigin().getID()) != null)
					{
						return 5;
					}
					
					local count = 0;
					foreach( bro in ::World.getPlayerRoster().getAll() )
					{
						if (bro.getFlags().has("isBonus") && bro.getSkills().hasSkill("background.hexe"))
						{
							++count;
						}
					}
					return count;
				};
				state.end = function()
				{
					::World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
					local r = ::Math.rand(1, 100);
					local hexeCount = this.countHexe();

					if (::World.Assets.getOrigin().getID() == "scenario.hexe")
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

					this.Flags.set("StartTime", ::Time.getVirtualTimeF());
					this.Flags.set("Delay", ::Math.rand(10, 30) * 1.0);
					local envoy = ::World.getGuestRoster().create("scripts/entity/tactical/humans/firstborn");
					envoy.setName(this.Flags.get("ProtecteeName"));
					envoy.setTitle("");
					envoy.setFaction(1);
					this.Flags.set("ProtecteeID", envoy.getID());
					this.Contract.m.Home.setLastSpawnTimeToNow();
					this.Contract.setScreen("Overview");
					::World.Contracts.setActiveContract(this.Contract);
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

					if (this.Flags.has("IsFail1") || ::World.getGuestRoster().getSize() == 0)
					{
						this.Contract.setScreen("Failure1");
						::World.Contracts.showActiveContract();
					}
					else if (this.Flags.has("IsFail2"))
					{
						this.Contract.setScreen("Failure2");
						::World.Contracts.showActiveContract();
					}
					else if (this.Flags.has("IsVictory"))
					{
						if (this.Flags.get("IsCurse"))
						{
							local candidates = [];

							foreach( bro in ::World.getPlayerRoster().getAll() )
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
								this.Contract.m.Dude = ::MSU.Array.rand(candidates);
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

						::World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("StartTime") + this.Flags.get("Delay") <= ::Time.getVirtualTimeF())
					{
						if (this.Flags.get("IsHiringHexe") && ::World.getPlayerRoster().getSize() < ::World.Assets.getBrothersMax())
						{
							this.Contract.setScreen("HiringHexe");
						}
						else if (this.Flags.get("IsSpiderQueen"))
						{
							this.Contract.setScreen("SpiderQueen");
						}
						else if (this.Flags.get("IsSinisterDeal") && ::World.Assets.getStash().hasEmptySlot())
						{
							this.Contract.setScreen("SinisterDeal");
						}
						else
						{
							this.Contract.setScreen("Encounter");
						}

						::World.Contracts.showActiveContract();
					}
					else if (!this.Flags.get("IsBanterShown") && ::Math.rand(1, 1000) <= 1 && this.Flags.get("StartTime") + 6.0 <= ::Time.getVirtualTimeF())
					{
						this.Flags.set("IsBanterShown", true);
						this.Contract.setScreen("Banter");
						::World.Contracts.showActiveContract();
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
					if (::World.getPlayerRoster().getSize() < ::World.Assets.getBrothersMax())
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
						::World.Assets.addBusinessReputation(::Const.World.Assets.ReputationOnContractBetrayal);
						::World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(::Const.World.Assets.RelationCivilianContractFail * 2, "Betrayed " + this.Contract.getEmployer().getName() + " and struck a deal with witches");
						::World.Contracts.finishActiveContract(true);
						return;
					}

				}
			],
			function start()
			{
				local roster = ::World.getPlayerRoster();
				local r = ::MSU.Array.rand(::Const.CharmedListRegularContract);
				local entity = roster.create("scripts/entity/tactical/player_beast/" + r);
				entity.worsenMood(1.5, "Being sold out by mistress");
				entity.setStartValuesEx();
				entity.onHired();

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
						local p = ::World.State.getLocalCombatProperties(::World.State.getPlayer().getPos());
						p.CombatID = "Hexen";
						p.Entities = [];
						p.Music = ::Const.Music.CivilianTracks;
						p.PlayerDeploymentType = ::Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = ::Const.Tactical.DeploymentType.Line;
						::Const.World.Common.addUnitsToCombat(p.Entities, ::Const.World.Spawn.HexenAndNoSpiders, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), ::World.FactionManager.getFactionOfType(::Const.FactionType.Beasts).getID());
						::World.Contracts.startScriptedCombat(p, false, true, true);
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
						::World.Assets.addBusinessReputation(::Const.World.Assets.ReputationOnContractBetrayal);
						::World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(::Const.World.Assets.RelationCivilianContractFail * 2, "Betrayed " + this.Contract.getEmployer().getName() + " and struck a deal with witches");
						::World.Contracts.finishActiveContract(true);
						return 0;
					}
				}
			],
			function start()
			{
				local roster = ::World.getPlayerRoster();
				local hexe = roster.create("scripts/entity/tactical/player");
				hexe.setStartValuesEx(["nggh_mod_hexe_regular_background"]);
				hexe.getBackground().buildDescription(true);
				hexe.onHired();

				this.Characters.push(hexe.getImagePath());
				this.List.push({
					id = 10,
					icon = hexe.getBackground().getIcon(),
					text = hexe.getName() + " has joined your company"
				});

				foreach ( _bro in roster.getAll() )
				{
					if (_bro.getSkills().hasSkill("effects.simp"))
					{
						continue;
					}

					if (::Const.WitchHaters.find(_bro.getBackground().getID()) == null)
					{
						continue;
					}

					_bro.worsenMood(2.0, "A witch has joined " + ::World.Assets.getName());
					_bro.worsenMood(2.0, "Suspect you to be a heretic");

					if (_bro.getMoodState() < ::Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = ::Const.MoodStateIcon[_bro.getMoodState()],
							text = _bro.getName() + ::Const.MoodStateEvent[_bro.getMoodState()]
						});
					}
				}
			}
		});

	};
});