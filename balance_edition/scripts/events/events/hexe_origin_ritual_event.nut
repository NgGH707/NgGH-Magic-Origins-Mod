this.hexe_origin_ritual_event <- this.inherit("scripts/events/event", {
	m = {
		Mult = 7.0,
		Hexe = null,
		Town = null,
		Money = 0,
		AmbushChance = 5,
		DifficultyMult = 0.0,
		DifficultyMultScale = 0.0,
		ChampionChance = 0,
		ResourceBoost = 0,
		IsSucceed = false,
		Offerings = [],
	},
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
						if (this.Math.rand(1, 100) <= _event.m.AmbushChance)
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
						text = "You sacrifice [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Money + "[/color] Crowns"
					});
					
					this.World.Assets.addMoney(-_event.m.Money);
				}
				
				local Stash = this.World.Assets.getStash();
				
				foreach ( _item in _event.m.Offerings )
				{	
					this.List.push({
						id = 4,
						icon = "ui/items/" + _item.getIcon(),
						text = "You sacrifice " + _item.getName()
					});
					
					Stash.remove(_item);
				}
				
				local cursed = _event.m.Hexe.getSkills().getSkillByID("effects.lesser_cursed");
				
				if (cursed != null)
				{
					this.List.push({
						id = 10,
						icon = "skills/status_effect_49.png",
						text = _event.m.Hexe.getName() + " is lifted from the curse"
					});
					
					_event.m.Hexe.improveMood(6.0, "The curse is lifted. I have regained my beauty");
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Hexe.getMoodState()],
						text = _event.m.Hexe.getName() + this.Const.MoodStateEvent[_event.m.Hexe.getMoodState()]
					});
					
					_event.m.Hexe.getFlags().remove("isCursed");
					cursed.removeSelf();
					this.World.Flags.remove("isExposed");
					this.World.Flags.set("looks", this.Math.rand(9995, 9997));
					this.World.Assets.updateLook();
					return;
				}
				else
				{
					cursed = _event.m.Hexe.getSkills().getSkillByID("effects.cursed");
					
					if (cursed != null)
					{
						this.List.push({
							id = 10,
							icon = "skills/status_effect_49.png",
							text = _event.m.Hexe.getName() + " is lifted from the curse"
						});
						
						_event.m.Hexe.improveMood(6.0, "The curse is lifted. I have regained my beauty");
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[_event.m.Hexe.getMoodState()],
							text = _event.m.Hexe.getName() + this.Const.MoodStateEvent[_event.m.Hexe.getMoodState()]
						});
						
						_event.m.Hexe.getFlags().remove("isCursed");
						cursed.removeSelf();
						this.World.Flags.remove("isExposed");
						this.World.Flags.set("looks", this.Math.rand(9995, 9997));
						this.World.Assets.updateLook();
						return;
					}
				}
				
				local effect = this.new("scripts/skills/effects_world/blessed_effect");
				this.List.push({
					id = 10,
					icon = "skills/status_effect_73.png",
					text = _event.m.Hexe.getName() + " is blessed with power"
				});
				
				_event.m.Hexe.improveMood(1.0, "Blessed");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Hexe.getMoodState()],
					text = _event.m.Hexe.getName() + this.Const.MoodStateEvent[_event.m.Hexe.getMoodState()]
				});
				_event.m.Hexe.getSkills().add(effect);
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
						if (this.Math.rand(1, 100) <= _event.m.AmbushChance)
						{
							return "Ambush";
						}

						return 0;
					}

				},
				
			],
			function start( _event )
			{
				local effect = this.new("scripts/skills/effects_world/cursed_effect");
				this.Characters.push(_event.m.Hexe.getImagePath());
				this.List.push({
					id = 10,
					icon = effect.getIcon(),
					text = _event.m.Hexe.getName() + " is cursed"
				});
				_event.m.Hexe.worsenMood(3.0, "Cursed for not collecting enough offerings");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Hexe.getMoodState()],
					text = _event.m.Hexe.getName() + this.Const.MoodStateEvent[_event.m.Hexe.getMoodState()]
				});
				
				local FM = this.World.FactionManager;
				local Factions = [];
				local FactionIDs = [];
				local RelationShips = [];
				Factions.extend(FM.getFactionsOfType(2));
				Factions.extend(FM.getFactionsOfType(3));
				
				foreach ( f in Factions )
				{
					FactionIDs.push(f.getID());
					RelationShips.push(f.getPlayerRelation());
				}
				
				effect.m.Faction = FactionIDs;
				effect.m.PlayerRelation = RelationShips;
				_event.m.Hexe.getSkills().add(effect);
				
				FM.makeNoblesUnfriendlyToPlayer();
				FM.makeSettlementsUnfriendlyToPlayer();
				this.World.Flags.add("isExposed", true);
				this.World.Assets.updateLook();
			}

		});

		this.m.Screens.push({
			ID = "Ambush",
			Text = "[img]gfx/ui/events/event_43.png[/img]%SPEECH_START%That\'s it! We catch you doing your witchcraft. Smite the heretic, burn the witch.\"[/color] A man shouts.\n\nWell-armed men starts to pour out from all side, they must be witch hunters hired by %town%. %hexe% silently thinks.%SPEECH_ON%Those bastards surely want me dead and at a time likes this.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To arms!",
					function getResult( _event )
					{
						_event.spawnWitchHunterParty(this.World.State.getPlayer().getTile());
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
		local brothers = this.World.getPlayerRoster().getAll();
		
		foreach (b in brothers)
		{
			if (!b.getFlags().has("isBonus") && (b.getFlags().has("Hexe") || b.getBackground().getID() == "background.hexen_commander"))
			{
				this.m.Hexe = b;
				break;
			}
		}
		
		local days = this.World.getTime().Days;
		local modifier = this.getModifier(days);
		local randomness = this.Math.rand(7, 15) * 0.1;
		local party_strength = this.World.State.getPlayer().getStrength();
		this.logInfo("Current party strength? " + party_strength);
		local Required = this.Math.max(1, this.Math.ceil(party_strength * (this.m.Mult + modifier) * randomness));
		this.logInfo("Offerings value required? " + Required);

		if (this.Math.rand(1, 100) <= 5)
		{
			Required = this.Math.ceil(Required * 5);
			this.logInfo("Total offerings value required? " + Required + " (Very unlucky you are");
		}

		local Money = this.Math.ceil(Required * 0.33);
		this.logInfo("Pay a portion with money? " + Money);
		Required = this.Math.max(0, Required - Money);
		local Has = 0;
		local QualifiedItems = this.onPrepareOfferings();
		
		if (this.World.Assets.getMoney() >= Money)
		{
			this.m.Money += Money;
			this.logInfo("Has enough money - 33% is paid");
		}
		else
		{
			this.m.Money += this.World.Assets.getMoney();
			Required += Money - this.World.Assets.getMoney();
			this.logInfo("Insufficient money! " + (Money - this.World.Assets.getMoney()));
		}
		
		foreach ( a in QualifiedItems.First )
		{
			if (Has >= Required)
			{
				break;
			}
			
			this.logInfo("Sacrifice item? " + a.Item.getName());
			this.m.Offerings.push(a.Item);
			Has += a.Value;
		}

		if (Has < Required && QualifiedItems.Second.len() != 0)
		{
			local tries = 0;

			while (QualifiedItems.Second.len() > 0 && tries < 100)
			{
				local index = this.Math.rand(0, QualifiedItems.Second.len() - 1);
				local find = QualifiedItems.Second.remove(index);

				if (find != null)
				{
					this.logInfo("Sacrifice item? " + find.Item.getName());
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
		
		if (Has < Required && this.World.Assets.getMoney() > Required - Has)
		{
			this.logInfo("Sacrifice the rest of required money - 100% is paid");
			this.m.Money += Required - Has;
			Has = Required;
		}
		
		this.m.IsSucceed = Has >= Required;
		this.m.AmbushChance = this.getAmbushChance();
	}
	
	function getModifier( _days )
	{
		if (_days <= 75)
		{
			return 0;
		}
		
		return this.Math.min(5, this.Math.max(1, this.Math.floor(_days / 100)));
	}

	function getAmbushChance()
	{
		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local nearest = 9999;
		local best;

		foreach( t in towns )
		{
			if (t.isMilitary() || this.isKindOf(t, "city_state"))
			{
				continue;
			}

			local faction = t.getFactionOfType(this.Const.FactionType.Settlement);

			if (faction != null)
			{
				if (faction.getPlayerRelation() >= 90.0)
				{
					continue;
				}
			}
			else
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
		local mult = 7.5;
		local randomness = this.Math.rand(80, 120) * 0.01;
		local chance = this.Math.ceil((8 - nearest) * mult * randomness);
		return this.Math.max(5, this.Math.min(95, chance));
	}
	
	function onPrepareOfferings()
	{
		local AllItems = this.World.Assets.getStash().getItems();
		local ret = [];
		local ret1 = [];
		local ret2 = [];
		local ret3 = [];
		local QualifiedItems = [];
		
		foreach ( _item in AllItems )
		{
			if (_item == null)
			{
				continue;
			}
			
			local _value = this.determineThisItemValue(_item);
			
			if (_value != 0)
			{
				QualifiedItems.push(_item);
			}
		}
		
		foreach ( _item in QualifiedItems )
		{
			local _v = this.determineThisItemValue(_item);

			if (_item.isItemType(this.Const.Items.ItemType.TradeGood))
			{
				ret1.push({
					Item = _item,
					Value = _v,
				});
			}
			else if (_item.isItemType(this.Const.Items.ItemType.Loot))
			{
				ret2.push({
					Item = _item,
					Value = _v,
				});
			}
			else if (_item.isItemType(this.Const.Items.ItemType.Crafting))
			{
				ret3.push({
					Item = _item,
					Value = _v,
				});
			}
		}
		
		if (ret1.len() != 0)
		{
			ret.extend(ret1);
		}
		
		if (ret2.len() != 0)
		{
			ret.extend(ret2);
		}
		
		if (ret.len() >= 2)
		{
			ret.sort(this.onSortByValueAscend);
		}
		
		return {
			First = ret,
			Second = ret3,
		};

	}
	
	function determineThisItemValue( _item )
	{
		local p = 0;
		local exclude = [
			"tent.craft_tent",
			"tent.enchant_tent",
			"tent.fletcher_tent",
			"tent.gather_tent",
			"tent.healer_tent",
			"tent.hunter_tent",
			"tent.repair_tent",
			"tent.scout_tent",
			"tent.scrap_tent",
			"tent.training_tent",
		];

		if (_item.isItemType(this.Const.Items.ItemType.Loot))
		{
			p = _item.m.Value * 1.33;
		}
		else if (_item.isItemType(this.Const.Items.ItemType.Crafting))
		{
			p = _item.m.Value * 1.25;
		}
		else if (_item.isItemType(this.Const.Items.ItemType.TradeGood) && exclude.find(_item.getID()) == null)
		{
			p = _item.m.Value * 1.5;
		}
		
		p = this.Math.floor(p);
		return p;
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
		this.logInfo("Choosing screen - Is Succeed? " + this.m.IsSucceed);
		return this.m.IsSucceed ? "A" : "B";
	}

	function onClear()
	{
		this.m.Hexe = null;
		this.m.Town = null;
		this.m.Money = 0;
		this.m.IsSucceed = false;
		this.m.Offerings = [];
		this.m.AmbushChance = 5;
		this.m.DifficultyMult = 0.0;
		this.m.DifficultyMultScale = 0.0;
		this.m.ResourceBoost = 0;
	}

	function spawnWitchHunterParty( _tile )
	{
		local faction = this.World.FactionManager.getFaction(this.m.Town.getFaction());
		local party = faction.spawnEntity(_tile, "Witch Hunters", false, null, 0);
		local resources = this.getResources();
		local template = this.Const.World.Common.buildDynamicTroopList(this.Const.World.Spawn.MC_WitchHunter, resources);
		local troopMbMap = {};
		party.getSprite("banner").setBrush(this.m.Town.getBanner());
		party.getSprite("body").setBrush(template.Body);
		party.setMovementSpeed(this.Const.World.MovementSettings.Speed * template.MovementSpeedMult * 5.0);
		party.setVisibilityMult(template.VisibilityMult);
		party.setVisionRadius(this.Const.World.Settings.Vision * template.VisionMult);
		party.setDescription("Brave men sent from [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.Town.getName() + "[/color] to vanquish heretics.");
		party.setFootprintType(this.Const.World.FootprintsType.Militia);
		party.setAttackableByAI(false);
		party.setAlwaysAttackPlayer(true);
		party.setUsingGlobalVision(true);
		party.getFlags().add("WitchHunters", true);
		party.getLoot().Money = this.Math.rand(100, 200);
		party.getLoot().ArmorParts = this.Math.rand(0, 25);
		party.getLoot().Medicine = this.Math.rand(0, 5);
		party.getLoot().Ammo = this.Math.rand(0, 30);
		
		foreach( troop in template.Troops )
		{
			local key = "Enemy" + troop.Type.ID;
			if (!(key in troopMbMap))
			{
				troopMbMap[key] <- this.Const.LegendMod.GetFavEnemyBossChance(troop.Type.ID);
			}

			local mb = troopMbMap[key];

			for( local i = 0; i != troop.Num; i = ++i )
			{
				this.Const.World.Common.addTroop(party, troop, false, this.m.ChampionChance + mb);
			}
		}

		faction.addPlayerRelation(-faction.getPlayerRelation() + 10, "Heretics");
		party.updatePlayerRelation();
		party.updateStrength();
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		local attack = this.new("scripts/ai/world/orders/intercept_order");
		attack.setTarget(this.World.State.getPlayer());
		c.addOrder(attack);
	}

	function getResources()
	{
		return (100 + this.m.ResourceBoost) * this.m.DifficultyMult * this.m.DifficultyMultScale;
	}

	function calcDifficultyMult()
	{
		local r;

		if (this.World.getTime().Days < 20)
		{
			r = this.Math.rand(1, 30);
		}
		else if (this.World.getTime().Days < 40)
		{
			r = this.Math.rand(1, 80);
		}
		else
		{
			r = this.Math.rand(1, 100);
		}

		if (r <= 30)
		{
			this.m.ChampionChance = 0;
			this.m.DifficultyMult = this.Math.rand(70, 85) * 0.01;
		}
		else if (r <= 80)
		{
			this.m.ChampionChance = 0;
			this.m.DifficultyMult = this.Math.rand(95, 105) * 0.01;
		}
		else
		{
			this.m.ChampionChance = 3;
			this.m.DifficultyMult = this.Math.rand(115, 135) * 0.01;
		}

		this.m.ChampionChance += this.getAdditionalChampionChance();
	}

	function getAdditionalChampionChance()
	{
		if (this.World.getTime().Days < 50)
		{
			return 0;
		}
		else if (this.World.getTime().Days < 90)
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
		local s = this.Math.maxf(0.75, 0.9 * this.Math.pow(0.01 * this.World.State.getPlayer().getStrength(), 0.85));
		local d = this.Math.minf(5.0, s);
		return d * this.Const.Difficulty.EnemyMult[this.World.Assets.getCombatDifficulty()];
	}

	function calcResourceBoost()
	{
		local defaultBoost = -10;
		local dayModifier = this.Math.min(this.World.getTime().Days / 5, 30);
		return defaultBoost + dayModifier;
	}

});

