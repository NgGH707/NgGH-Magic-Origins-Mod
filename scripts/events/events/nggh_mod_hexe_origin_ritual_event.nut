this.nggh_mod_hexe_origin_ritual_event <- ::inherit("scripts/events/event", {
	m = {
		Hexe = null,
		Town = null,

		// ambush factors
		AmbushChance = 5,
		DifficultyMult = 0.0,
		DifficultyMultScale = 0.0,
		ChampionChance = 0,
		ResourceBoost = 0,

		// processing ritual
		IsSucceed = false,
		ChosenItems = [],
		Offerings = [],
		Simps = [],
		Money = 0,
	},
	function getAmbushChance()
	{
		return this.m.AmbushChance;
	}

	function isAmbushed()
	{
		local rolled = ::Math.rand(1, 100);

		if (rolled > this.getAmbushChance())
		{
			::logInfo("Hexe Origin Ritual - No ambushed attack today (Chance: " + this.getAmbushChance() + ", Rolled: " + rolled + ")");
			return false;
		}

		::logInfo("Hexe Origin Ritual - Ambushed time!!! (Chance: " + this.getAmbushChance() + ", Rolled: " + rolled + ")");
		return true;
	}

	function create()
	{
		this.m.ID = "event.hexe_origin_ritual";
		this.m.Title = "At some place...";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_36.png[/img]%hexe% finishes her preparation for the offerings. Her servants also stand in line, all that is left is a chant to start off the ritual./n/nWhile speaking the unholy lines, a gust of pure blackness would engulf you and your thralls. It happens so quick, the offerings have already disappeared into the black void. And then a whisper could be heard from behind you %SPEECH_ON%Your offerings please me...%SPEECH_OFF%%hexe% let out a sigh of relief. So this is what must be done every week... Is such a price worth eternal beauty and power?",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "A price i have to pay.",
					function getResult( _event )
					{
						if (_event.m.ChosenItems.len() != 0)
						{
							return "LevelupSimp";
						}

						if (_event.isAmbushed())
						{
							
							return "Ambush";
						}

						return 0;
					}

				},
				
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Hexe.getImagePath());
				
				if (_event.m.Money != 0)
				{
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You sacrifice [color=" + ::Const.UI.Color.NegativeEventValue + "]" + _event.m.Money + "[/color] Crowns"
					});
					
					::World.Assets.addMoney(-_event.m.Money);
				}
				
				local Stash = ::World.Assets.getStash();
				
				foreach ( _item in _event.m.Offerings )
				{	
					this.List.push({
						id = 4,
						icon = "ui/items/" + _item.getIcon(),
						text = "You sacrifice " + _item.getName()
					});
					
					Stash.remove(_item);
				}
				
				if (::World.Flags.get("isExposed"))
				{
					this.List.push({
						id = 10,
						icon = "skills/status_effect_49.png",
						text = _event.m.Hexe.getName() + " is lifted from the curse"
					});
					
					_event.m.Hexe.improveMood(6.0, "The curse is lifted. I have regained my beauty");
					this.List.push({
						id = 10,
						icon = ::Const.MoodStateIcon[_event.m.Hexe.getMoodState()],
						text = _event.m.Hexe.getName() + ::Const.MoodStateEvent[_event.m.Hexe.getMoodState()]
					});
					
					_event.m.Hexe.getFlags().remove("isCursed");
					_event.m.Hexe.getSkills().removeByID("effects.cursed");
					_event.m.Hexe.getSkills().removeByID("effects.cursed_badly");
					::World.Flags.set("looks", ::Math.rand(9995, 9997));
					::World.Flags.set("isExposed", false);
					::World.Assets.updateLook();

					foreach ( bro in ::World.getPlayerRoster().getAll() )
					{
						local skill = bro.getSkills().getSkillByID("effects.simp");

						if (skill == null)
						{
							continue;
						}

						if (!bro.getFlags().get("isCursed"))
						{
							continue;
						}

						if (::Math.rand(1, 100) <= 66)
						{
							skill.gainSimpLevel();

							this.List.push({
								id = 10,
								icon = bro.getBackground().getIcon(),
								text = bro.getNameOnly() + " regains the lost simp level"
							});
						}

						bro.getFlags().set("isCursed", false);
					}

					return;
				}
				
				local effect = ::new("scripts/skills/effects_world/nggh_mod_blessed_effect");
				_event.m.Hexe.improveMood(1.0, "Blessed");
				_event.m.Hexe.getSkills().add(effect);

				this.List.extend([
					{
						id = 10,
						icon = "skills/status_effect_73.png",
						text = _event.m.Hexe.getName() + " is blessed with power"
					},
					{
						id = 10,
						icon = ::Const.MoodStateIcon[_event.m.Hexe.getMoodState()],
						text = _event.m.Hexe.getName() + ::Const.MoodStateEvent[_event.m.Hexe.getMoodState()]
					}
				]);
			}

		});
		
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_12.png[/img]%hexe% hurriedly finishes her preparation for the offerings but things aren't right. %hexe% has the feeling she hasn't gathered enough offerings for the ritual. Her mind racing, she wonders what could happen if she arose the ire of her master.\n\nSuddenly, a black wind would come forth. A chill running through her spine as she can at first hear whisperings in her mind but without a moments notice the whispers would become screams of rage. %SPEECH_ON%Such a pitiful offering, you dare think this is worthy of my attention!%SPEECH_OFF%Pain can be felt all over %hexe%'s body, she screams out a cry of agony. %hexe% can feel her false youth being torn from her as she watches her hands wrinkle and age rapidly. Even her own power feels weaker and weaker. %hexe% breaks down and begs for forgiveness, she wishes her god to pity her and give her another chance.%SPEECH_ON%There won't be next time. I expect a worthy offering next time. If you fail me, death will be a blessing once I'm done with you. %SPEECH_OFF%Still shivering, %hexe% forces herself to stand up. Her true form has been revealed and her power has been sapped so gathering the offerings will be a little harder but she has no other choice. She must gather more offerings or eternal torment awaits her.",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "No! This can\'t be.",
					function getResult( _event )
					{
						if (_event.isAmbushed())
						{
							return "Ambush";
						}

						return 0;
					}

				},
				
			],
			function start( _event )
			{
				local effect = ::new("scripts/skills/effects_world/nggh_mod_world_cursed_badly_effect");
				local Factions = [];
				local FactionIDs = [];
				local RelationShips = [];
				Factions.extend(::World.FactionManager.getFactionsOfType(::Const.FactionType.NobleHouse));
				Factions.extend(::World.FactionManager.getFactionsOfType(::Const.FactionType.Settlement));
				
				foreach ( f in Factions )
				{
					FactionIDs.push(f.getID());
					RelationShips.push(f.getPlayerRelation());
				}
				
				effect.m.Factions = FactionIDs;
				effect.m.PlayerRelations = RelationShips;
				_event.m.Hexe.worsenMood(3.0, "Cursed for not collecting enough offerings");
				_event.m.Hexe.getSkills().add(effect);

				if (::Nggh_MagicConcept.HexeOriginRitual.IsLoseLevelWhenFail)
				{
					foreach ( bro in ::World.getPlayerRoster().getAll() )
					{
						local skill = bro.getSkills().getSkillByID("effects.simp");

						if (skill == null)
						{
							continue;
						}

						if (skill.getSimpLevel() <= 0)
						{
							continue;
						}

						_event.decreaseSimpLevel(bro);
					}
				}

				::World.FactionManager.makeNoblesUnfriendlyToPlayer();
				::World.FactionManager.makeSettlementsUnfriendlyToPlayer();
				::World.Flags.add("isExposed", true);
				::World.Assets.updateLook();

				this.List.extend([
					{
						id = 10,
						icon = effect.getIcon(),
						text = _event.m.Hexe.getName() + " is cursed"
					},
					{
						id = 10,
						icon = ::Const.MoodStateIcon[_event.m.Hexe.getMoodState()],
						text = _event.m.Hexe.getName() + ::Const.MoodStateEvent[_event.m.Hexe.getMoodState()]
					}
				]);

				this.Characters.push(_event.m.Hexe.getImagePath());
			}

		});

		this.m.Screens.push({
			ID = "LevelupSimp",
			Text = "[img]gfx/ui/events/event_140.png[/img] In addition to the blessing, you may offer some more to allow one of your chosen followers grants a gift of power. What is your answer? And who will you choose?",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Maybe at a later time.",
					function getResult( _event )
					{
						if (_event.isAmbushed())
						{
							return "Ambush";
						}

						return 0;
					}

				},
			],
			function start( _event )
			{
				foreach (i, s in _event.m.Simps)
				{
					this.Options.push({
						Actor = s,
						Text = s.getName() + " - " + s.getSkills().getSkillByID("effects.simp").getName(),
						function getResult( _e )
						{
							::logInfo("Hexe Origin Ritual - Selected option: \"" + this.Text + "\"");
							_e.increaseSimpLevel(this.Actor);
							_e.consumeChosenItems();

							if (_e.isAmbushed())
							{
								return "Ambush";
							}

							return 0;
						}

					});

					this.Characters.push(s.getImagePath());
				}

				this.List.push({
					id = 1,
					icon = "ui/icons/dub.png",
					text = "[color=" + ::Const.UI.Color.DamageValue + "]--- Demanded Offerings ---[/color]"
				});

				foreach (item in _event.m.ChosenItems)
				{
					this.List.push({
						id = 1,
						icon = "ui/items/" + item.getIcon(),
						text = item.getName()
					});
				}
			}

		});

		this.m.Screens.push({
			ID = "Ambush",
			Text = "[img]gfx/ui/events/event_43.png[/img]%SPEECH_START%That\'s it! We catch you red handed, witch. Burn her! Hang her! Don\'t let her bring her malice curse to our town.\"[/color] A man shouts.\n\nWell-armed men starts to pour out from all side, they must be witch hunters hired by %town%. %hexe% silently thinks.%SPEECH_ON%Those bastards surely want me dead and at a time likes this.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To arms!",
					function getResult( _event )
					{
						_event.spawnWitchHunterParty(::World.State.getPlayer().getTile());
						return 0;
					}

				},
			],
			function start( _event )
			{
			}

		});
	}

	function onPrepare()
	{
		this.calcDifficultyMult();
		this.m.ResourceBoost = this.calcResourceBoost();
		this.m.DifficultyMultScale = this.getScaledDifficultyMult();
		local brothers = ::World.getPlayerRoster().getAll();
		
		foreach (bro in brothers)
		{
			if (!bro.getFlags().has("isBonus") && bro.getFlags().has("Hexe"))
			{
				this.m.Hexe = bro;
				break;
			}
		}
		
		local days = ::World.getTime().Days;
		local modifier = this.getModifier(days);
		local randomness = ::Math.rand(::Nggh_MagicConcept.HexeOriginRitual.RandomizeMin, ::Nggh_MagicConcept.HexeOriginRitual.RandomizeMax) * 0.01;
		local party_strength = ::World.State.getPlayer().getStrength();
		::logInfo("Hexe Origin Ritual - Current party strength? " + party_strength);
		local Required = ::Math.max(1, ::Math.ceil(party_strength * (::Nggh_MagicConcept.HexeOriginRitual.Mult + modifier) * randomness));
		::logInfo("Hexe Origin Ritual - Required offering value? " + Required);

		if (!::World.Flags.get("isExposed"))
		{
			if (::Math.rand(1, 100) <= ::Math.ceil(::Nggh_MagicConcept.HexeOriginRitual.UnluckyChance + ::World.Flags.getAsInt("HexeOriginLucky") * 1.5))
			{
				Required = ::Math.ceil(Required * ::Nggh_MagicConcept.HexeOriginRitual.UnluckyMult);
				::logInfo("Hexe Origin Ritual - Required offering value increases! " + Required + " is the new value (Very unlucky you are)");
				::World.Flags.set("HexeOriginLucky", 0);
			}
			else
			{
				::World.Flags.increment("HexeOriginLucky");
			}
		}

		local Money = ::Math.ceil(Required * 0.33);
		::logInfo("Hexe Origin Ritual - Pay a portion with money: " + Money);
		Required = ::Math.max(0, Required - Money);
		local QualifiedItems = this.onPrepareOfferings();
		local List = [];
		local NumList = [];
		local Has = 0;
		
		if (::World.Assets.getMoney() >= Money)
		{
			this.m.Money += Money;
			::logInfo("Hexe Origin Ritual - Sufficient money, 33% is paid first");
		}
		else
		{
			this.m.Money += ::World.Assets.getMoney();
			Required += Money - ::World.Assets.getMoney();
			::logInfo("Hexe Origin Ritual - Insufficient money! That\'s all you got, " + (Money - ::World.Assets.getMoney()));
		}
		
		foreach ( a in QualifiedItems.First )
		{
			if (Has >= Required)
			{
				break;
			}

			local i = List.find(a.Item.getName());

			if (i != null)
			{
				++NumList[i];
			}
			else
			{
				List.push(a.Item.getName());
				NumList.push(1);
			}
			
			this.m.Offerings.push(a.Item);
			Has += a.Value;
		}

		if (Has < Required && QualifiedItems.Second.len() != 0)
		{
			local tries = 0;

			while (QualifiedItems.Second.len() > 0 && tries < 100)
			{
				local index = ::Math.rand(0, QualifiedItems.Second.len() - 1);
				local find = QualifiedItems.Second.remove(index);

				if (find != null)
				{
					this.m.Offerings.push(find.Item);
					Has += find.Value;
				}
				else
				{
				    ++tries;
				}

				if (Has >= Required)
				{
					break;
				}
			}
		}

		foreach (i, name in List)
		{
			::logInfo("Hexe Origin Ritual - Sacrifice item: " + name + (NumList[i] > 1 ? " (x" + NumList[i] + ")" : ""));
		}
		
		if (Has < Required && ::World.Assets.getMoney() > Required - Has)
		{
			::logInfo("Hexe Origin Ritual - Pay the rest with money - 100% is paid");
			this.m.Money += Required - Has;
			Has = Required;
		}
		
		this.m.IsSucceed = Has >= Required;

		if (this.m.IsSucceed)
		{
			local candidates = [];

			foreach (bro in brothers)
			{
				local skill = bro.getSkills().getSkillByID("effects.simp");

				if (skill == null)
				{
					continue;
				}

				if (skill.getSimpLevel() >= ::Const.Simp.MaximumLevel)
				{
					continue;
				}

				candidates.push(bro);
			}

			if (candidates.len() != 0)
			{
				local num = ::Math.min(2, candidates.len());
				local selectedID = [];
				local lv = 0;

				while (this.m.Simps.len() < num)
				{
					local index = ::Math.rand(0, candidates.len() - 1);
					local pick = candidates.remove(index);

					if (pick != null)
					{
						lv += pick.getSkills().getSkillByID("effects.simp").getSimpLevel();
						this.m.Simps.push(pick);
					}

					/*
					if (selectedID.find(pick.getID()) == null)
					{
						lv += pick.getSkills().getSkillByID("effects.simp").getSimpLevel();
						selectedID.push(pick.getID());
						this.m.Simps.push(pick);
					}
					*/
				}

				// get the average simp level
				lv = ::Math.max(1, ::Math.ceil(lv / num));
				local v = lv >= 7 ? 2450 + 500 * (lv - 7) : 350 * lv;
				local items = [];
				local all = [];
				all.extend(QualifiedItems.First);
				all.extend(QualifiedItems.Second);

				while(v > 0 && all.len() != 0)
				{
					local index = ::Math.rand(0, all.len() - 1);
					local find = all.remove(index);

					if (find != null)
					{
						::logInfo("Hexe Origin Ritual - Simp leveling up item: " + find.Item.getName());
						items.push(find.Item);
						v -= find.Value;
					}
				}

				if (v <= 0)
				{
					this.m.ChosenItems.extend(items);
				}
			}
		}

		this.m.AmbushChance = this.recalculateAmbushChance();
	}
	
	function getModifier( _days )
	{
		if (_days <= 50)
		{
			return 0;
		}
		
		return ::Math.min(6, ::Math.max(1, ::Math.floor(_days / 80)));
	}

	function recalculateAmbushChance()
	{
		local playerTile = ::World.State.getPlayer().getTile();
		local towns = ::World.EntityManager.getSettlements();
		local nearest = 9999;
		local best;

		foreach( t in towns )
		{
			if (t.isMilitary() || ::isKindOf(t, "city_state"))
			{
				continue;
			}

			local faction = t.getFactionOfType(::Const.FactionType.Settlement);

			if (faction == null)
			{
				continue;
			}

			if (faction.getPlayerRelation() >= 90.0)
			{
				continue;
			}

			local d = playerTile.getDistanceTo(t.getTile());

			if (d >= 7)
			{
				continue;
			}

			if (d <= nearest)
			{
				nearest = d;
				best = t;
			}
		}

		if (best == null)
		{
			return 0;
		}

		this.m.Town = best;
		local randomness = ::Math.rand(80, 120) * 0.01;
		local chance = ::Math.ceil(7.5 * (8 - nearest) * randomness);
		local ret = ::Math.max(5, ::Math.min(95, chance));
		::logInfo("Hexe Origin Ritual - Calculating ambushed chance... Finished! -> Result: " + ret + "%");
		return ret;
	}
	
	function onPrepareOfferings()
	{
		local table = {
			QualifiedItems = [],
			TradeGood = [],
			Crafting = [],
			Loot = []
		};
		
		foreach ( _item in ::World.Assets.getStash().getItems() )
		{
			if (_item == null)
			{
				continue;
			}
			
			this.processThisItemValue(_item, table);
		}
		
		if (table.TradeGood.len() != 0)
		{
			table.QualifiedItems.extend(table.TradeGood);
		}
		
		if (table.Loot.len() != 0)
		{
			table.QualifiedItems.extend(table.Loot);
		}
		
		if (table.QualifiedItems.len() > 1)
		{
			table.QualifiedItems.sort(this.onSortByValueAscend);
		}
		
		return {
			First = table.QualifiedItems,
			Second = table.Crafting,
		};
	}
	
	function processThisItemValue( _item , _table )
	{
		if (_item.isItemType(::Const.Items.ItemType.Loot))
		{
			_table.Loot.push({
				Item = _item,
				Value = ::Math.floor(_item.m.Value * 1.25),
			});
		}
		else if (_item.isItemType(::Const.Items.ItemType.Crafting))
		{
			_table.Crafting.push({
				Item = _item,
				Value = ::Math.floor(_item.m.Value * 1.1),
			});
		}
		else if (_item.isItemType(::Const.Items.ItemType.TradeGood) && _item.getID().find("tent.") == null)
		{
			_table.TradeGood.push({
				Item = _item,
				Value = ::Math.floor(_item.m.Value * 1.5),
			});
		}
	}
	
	function onSortByValueAscend( _a, _b )
	{
		if (_a.Value > _b.Value)
		{
			return -1;
		}
		else if (_a.Value < _b.Value)
		{
			return 1;
		}

		return 0;
	}
	
	function onSortByValueDescend( _a, _b )
	{
		if (_a.Value > _b.Value)
		{
			return 1;
		}
		else if (_a.Value < _b.Value)
		{
			return -1;
		}

		return 0;
	}
	
	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hexe",
			this.m.Hexe.getNameOnly()
		]);

		if (this.m.Town != null)
		{
			_vars.push([
				"town",
				this.m.Town.getName()
			]);
		}
	}
	
	function onDetermineStartScreen()
	{
		::logInfo("Hexe Origin Ritual - Is Succeed? " + this.m.IsSucceed);
		return this.m.IsSucceed ? "A" : "B";
	}

	function onClear()
	{
		this.m.Hexe = null;
		this.m.Town = null;
		this.m.IsSucceed = false;
		this.m.ChosenItems = [];
		this.m.Simps = [];
		this.m.Money = 0;
		this.m.Offerings = [];
		this.m.AmbushChance = 5;
		this.m.DifficultyMult = 0.0;
		this.m.DifficultyMultScale = 0.0;
		this.m.ResourceBoost = 0;
	}

	function increaseSimpLevel( _bro )
	{
		_bro.getSkills().getSkillByID("effects.simp").gainSimpLevel();
		_bro.improveMood(1.0, this.m.Hexe.getName() + " loves me");
		_bro.getSkills().add(::new("scripts/skills/effects_world/nggh_mod_blessed_effect"));
		::logInfo("Hexe Origin Ritual - " + _bro.getNameOnly() + " gains a simp level");
		//return charm;
	}

	function decreaseSimpLevel( _bro )
	{
		_bro.getFlags().set("isCursed", true);
		_bro.getSkills().getSkillByID("effects.simp").loseSimpLevel();
		_bro.worsenMood(1.0, this.m.Hexe.getNameOnly() + " scares me");
		//return charm;
	}

	function consumeChosenItems()
	{
		foreach( item in this.m.ChosenItems )
		{
			::World.Assets.getStash().remove(item);
		}

		this.m.ChosenItems = [];
	}

	function spawnWitchHunterParty( _tile )
	{
		::World.State.setPause(true);
		local faction = this.m.Town.getFactionOfType(::Const.FactionType.Settlement);
		
		if (faction == null)
		{
			faction = ::World.FactionManager.getFaction(this.m.Town.getFaction());
		}
		
		local party = faction.spawnEntity(_tile, "Witch Hunters", false, null, 0);
		local template = ::Const.World.Common.buildDynamicTroopList(::Const.World.Spawn.Nggh_WitchHunter, this.getResources());
		local troopMbMap = {};

		party.getSprite("banner").setBrush(this.m.Town.getBanner());
		party.getSprite("body").setBrush(template.Body);
		party.setMovementSpeed(::Const.World.MovementSettings.Speed * template.MovementSpeedMult);
		party.setVisibilityMult(template.VisibilityMult);
		party.setVisionRadius(::Const.World.Settings.Vision * template.VisionMult);
		party.setDescription("Brave men sent from [color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.Town.getName() + "[/color] to vanquish heretics.");
		party.setFootprintType(::Const.World.FootprintsType.Militia);
		party.setAttackableByAI(false);
		party.setAlwaysAttackPlayer(true);
		party.setUsingGlobalVision(true);
		party.getFlags().set("WitchHunters", true);
		party.getLoot().Money = ::Math.rand(100, 200);
		party.getLoot().ArmorParts = ::Math.rand(0, 25);
		party.getLoot().Medicine = ::Math.rand(0, 5);
		party.getLoot().Ammo = ::Math.rand(0, 30);
		
		// have to manually add the additional champion from the event 
		foreach( troop in template.Troops )
		{
			local key = "Enemy" + troop.Type.ID;
			if (!(key in troopMbMap))
			{
				troopMbMap[key] <- ::Const.LegendMod.GetFavEnemyBossChance(troop.Type.ID);
			}

			local mb = troopMbMap[key];

			for( local i = 0; i != troop.Num; ++i )
			{
				::Const.World.Common.addTroop(party, troop, false, this.m.ChampionChance + mb);
			}
		}

		faction.addPlayerRelation(-faction.getPlayerRelation() + 10, "Heretics");
		party.updatePlayerRelation();
		party.updateStrength();
		local c = party.getController();
		c.getBehavior(::Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		local attack = ::new("scripts/ai/world/orders/intercept_order");
		attack.setTarget(::World.State.getPlayer());
		c.addOrder(attack);
	}

	function getResources()
	{
		return (100 + this.m.ResourceBoost) * this.m.DifficultyMult * this.m.DifficultyMultScale;
	}

	function calcDifficultyMult()
	{
		local r;

		if (::World.getTime().Days < 20)
		{
			r = ::Math.rand(1, 30);
		}
		else if (::World.getTime().Days < 40)
		{
			r = ::Math.rand(1, 80);
		}
		else
		{
			r = ::Math.rand(1, 100);
		}

		if (r <= 30)
		{
			this.m.ChampionChance = 0;
			this.m.DifficultyMult = ::Math.rand(70, 85) * 0.01;
		}
		else if (r <= 80)
		{
			this.m.ChampionChance = 1;
			this.m.DifficultyMult = ::Math.rand(95, 105) * 0.01;
		}
		else
		{
			this.m.ChampionChance = 4;
			this.m.DifficultyMult = ::Math.rand(115, 135) * 0.01;
		}

		this.m.ChampionChance += this.getAdditionalChampionChance();
	}

	function getAdditionalChampionChance()
	{
		if (::World.getTime().Days < 50)
		{
			return 0;
		}
		else if (::World.getTime().Days < 90)
		{
			return 1;
		}
		else
		{
			return 3;
		}
	}

	function getScaledDifficultyMult()
	{
		local s = ::Math.maxf(0.75, ::Math.pow(0.01 * ::World.State.getPlayer().getStrength(), 0.85));
		local d = ::Math.minf(5.0, s);
		return d * ::Const.Difficulty.EnemyMult[::World.Assets.getCombatDifficulty()];
	}

	function calcResourceBoost()
	{
		local defaultBoost = -10;
		local dayModifier = ::Math.min(::World.getTime().Days / 5, 30);
		return defaultBoost + dayModifier;
	}

});

