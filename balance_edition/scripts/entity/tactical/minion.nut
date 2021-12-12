this.minion <- this.inherit("scripts/entity/tactical/actor", {
	m = {
		Dominate = null,
		Master = null,
		Weight = 0,
		IsGuest = true,
		Talents = [],
		CombatStats = {
			DamageDealtHitpoints = 0,
			DamageDealtArmor = 0,
			DamageReceivedHitpoints = 0,
			DamageReceivedArmor = 0,
			Kills = 0,
			XPGained = 0
		},
		LifetimeStats = {
			Kills = 0,
			Battles = 0,
			BattlesWithoutMe = 0,
			MostPowerfulVanquished = "",
			MostPowerfulVanquishedXP = 0,
			MostPowerfulVanquishedType = 0,
			FavoriteWeapon = "",
			FavoriteWeaponUses = 0,
			CurrentWeaponUses = 0,
			Tags = null
		},
	},
	
	function getMaster()
	{
		return this.m.Master;
	}
	
	function setMaster( _m )
	{
		if (_m == null)
		{
			this.m.Master = null;
		}
		else if (typeof _m == "instance")
		{
			this.m.Master = _m;
		}
		else 
		{
		 	this.m.Master = this.WeakTableRef(_m);   
		}
	}

	function getCombatStats()
	{
		return this.m.Master != null && !this.m.Master.isNull() ? this.m.Master.getCombatStats() : this.m.CombatStats;
	}

	function getLifetimeStats()
	{
		return this.m.Master != null && !this.m.Master.isNull() ? this.m.Master.getLifetimeStats() : this.m.LifetimeStats;
	}
	
	function getDominate()
	{
		return this.m.Dominate;
	}
	
	function setDominate( _d )
	{
		this.m.Dominate = _d;
	}
	
	function getWeight()
	{
		return this.m.Weight;
	}
	
	function setWeight( _value )
	{
		this.m.Weight = _value;
	}

	function setGuest( _f )
	{
		this.m.IsGuest = true;
	}

	function isGuest()
	{
		return this.m.IsGuest;
	}

	function getPlaceInFormation()
	{
		return 21;
	}

	function getTalents()
	{
		return this.m.Talents;
	}

	function getBackground()
	{
		return null;
	}

	function isPlayerControlled()
	{
		return this.m.IsControlledByPlayer && (this.getFaction() == this.Const.Faction.Player || this.getFaction() == this.Const.Faction.PlayerAnimals);
	}

	function getImagePath( _ignoreLayers = [] )
	{
		local result = "tacticalentity(" + this.m.ContentID + "," + this.getID() + ",socket,miniboss,arrow";

		for( local i = 0; i < _ignoreLayers.len(); i = i )
		{
			result = result + ("," + _ignoreLayers[i]);
			i = ++i;
		}

		result = result + ")";
		return result;
	}

	function getOverlayImage()
	{
		if (this.m.Type == 106 || this.m.Type == 107 || this.m.Type == 108 || this.m.Type == 109 || this.m.Type == 110)
		{
			return "zombie_02_orientation";
		}
		else
		{
			return this.Const.EntityIcon[this.m.Type];
		}
	}

	function create()
	{
		this.m.Talents.resize(this.Const.Attributes.COUNT, 0);
		this.m.IsControlledByPlayer = true;
		this.m.IsSummoned = true;
		this.actor.create();
		this.getFlags().add("can_be_possessed");
		this.getFlags().set("PotionLastUsed", 0.0);
		this.getFlags().set("PotionsUsed", 0);
		this.m.LifetimeStats.Tags = this.new("scripts/tools/tag_collection");
		this.m.Items.getData()[this.Const.ItemSlot.Offhand][0] = -1;
		this.m.Items.getData()[this.Const.ItemSlot.Mainhand][0] = -1;
		this.m.Items.getData()[this.Const.ItemSlot.Head][0] = -1;
		this.m.Items.getData()[this.Const.ItemSlot.Body][0] = -1;
		this.m.Items.getData()[this.Const.ItemSlot.Ammo][0] = -1;
	}

	function onInit()
	{
		this.actor.onInit();
		this.m.Skills.add(this.new("scripts/skills/effects/battle_standard_effect"));
		this.m.Skills.add(this.new("scripts/skills/actives/break_ally_free_skill"));

		if (this.Const.DLC.Unhold)
		{
			this.m.Skills.add(this.new("scripts/skills/actives/wake_ally_skill"));
		}
	}
	
	function onActorKilled( _actor, _tile, _skill )
	{
		if (!this.m.IsAlive || this.m.IsDying)
		{
			return;
		}
		
		if (this.getFaction() == this.Const.Faction.Player || this.getFaction() == this.Const.Faction.PlayerAnimals)
		{
			local XPkiller = this.Math.floor(_actor.getXPValue() * this.Const.XP.XPForKillerPct);
			local XPgroup = _actor.getXPValue() * (1.0 - this.Const.XP.XPForKillerPct);
			this.addXP(XPkiller);
			local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);
			
			if (this.m.Master != null && !this.m.Master.isNull() && this.m.Master.isAlive() && !this.m.Master.isDying())
			{
				this.getMaster().getCombatStats().Kills += 1;
				this.getMaster().getLifetimeStats().Kills += 1;
				this.Const.LegendMod.SetFavoriteEnemyKill(this.getMaster(), _actor);
			}
			
			if (brothers.len() == 1)
			{
				this.addXP(XPgroup);
			}
			else
			{
				foreach( bro in brothers )
				{
					bro.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));
				}
			}
		}

		this.m.Skills.onTargetKilled(_actor, _skill);
	}
	
	function addXP( _xp, _scale = true )
	{
		if (this.m.Master != null && !this.m.Master.isNull() && this.m.Master.isAlive() && !this.m.Master.isDying())
		{
			this.getMaster().addXP(_xp);
		}
	}
	
	function afterLoad()
	{
		this.setFaction(this.Const.Faction.PlayerAnimals);
	}

	function onAfterInit()
	{
		this.updateOverlay();
		this.setSpriteOffset("status_rooted_back", this.getSpriteOffset("status_rooted"));
		this.getSprite("status_rooted_back").Scale = this.getSprite("status_rooted").Scale;
		this.setDiscovered(true);
	}

	function onUpdateInjuryLayer()
	{
		if (!this.hasSprite("injury"))
		{
			return;
		}

		local injury = this.getSprite("injury");
		local p = this.getHitpointsPct();

		if (p > 0.5)
		{
			if (injury.Visible)
			{
				injury.Visible = false;

				if (this.hasSprite("injury_skin"))
				{
					this.getSprite("injury_skin").Visible = false;
				}

				if (this.hasSprite("injury_body"))
				{
					this.getSprite("injury_body").Visible = false;
				}

				this.setDirty(true);
			}
		}
		else if (!injury.Visible)
		{
			injury.Visible = true;

			if (this.hasSprite("injury_skin"))
			{
				this.getSprite("injury_skin").Visible = true;
			}

			if (this.hasSprite("injury_body"))
			{
				this.getSprite("injury_body").Visible = true;
			}

			this.setDirty(true);
		}
	}

	function onBeforeCombatResult()
	{
		if (this.Math.rand(1, 100) <= 25)
		{
			this.getItems().dropAll(null, null, false);
		}
		
		this.killSilently();
	}

	function onResurrected( _info )
	{
		this.setFaction(_info.Faction);
		this.getItems().clear();
		
		if (_info.Items != null)
		{
			_info.Items.transferTo(this.getItems());
		}

		if (_info.Name.len() != 0)
		{
			this.m.Name = _info.Name;
		}

		if (_info.Description.len() != 0)
		{
			this.m.Description = _info.Description;
		}

		this.m.Hitpoints = this.getHitpointsMax() * _info.Hitpoints;
		this.m.XP = this.Math.floor(this.m.XP * _info.Hitpoints);
		this.m.BaseProperties.Armor = _info.Armor;
		this.onUpdateInjuryLayer();
	}
	
	function getPercentOnKillOtherActorModifier()
	{
		return 1.0;
	}
	
	function getFlatOnKillOtherActorModifier()
	{
		return 1.0;
	}

	function modTacticalTooltip( _targetedWithSkill = null )
	{
		if (!this.isPlacedOnMap() || !this.isAlive() || this.isDying())
		{
			return [];
		}

		local turnsToGo = this.Tactical.TurnSequenceBar.getTurnsUntilActive(this.getID());
		local tooltip = [
			{
				id = 1,
				type = "title",
				text = this.getName(),
				icon = "ui/tooltips/height_" + this.getTile().Level + ".png"
			}
		];

		if (!this.isPlayerControlled() && _targetedWithSkill != null && this.isKindOf(_targetedWithSkill, "skill"))
		{
			local tile = this.getTile();

			if (tile.IsVisibleForEntity && _targetedWithSkill.isUsableOn(this.getTile()))
			{
				tooltip.push({
					id = 3,
					type = "headerText",
					icon = "ui/icons/hitchance.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]" + _targetedWithSkill.getHitchance(this) + "%[/color] chance to hit",
					children = _targetedWithSkill.getHitFactors(tile)
				});
			}
		}

		tooltip.extend([
			{
				id = 2,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = this.Tactical.TurnSequenceBar.getActiveEntity() == this ? "Acting right now!" : this.m.IsTurnDone || turnsToGo == null ? "Turn done" : "Acts in " + turnsToGo + (turnsToGo > 1 ? " turns" : " turn")
			},
			{
				id = 3,
				type = "progressbar",
				icon = "ui/icons/armor_head.png",
				value = this.getArmor(this.Const.BodyPart.Head),
				valueMax = this.getArmorMax(this.Const.BodyPart.Head),
				text = "" + this.getArmor(this.Const.BodyPart.Head) + " / " + this.getArmorMax(this.Const.BodyPart.Head) + "",
				style = "armor-head-slim"
			},
			{
				id = 4,
				type = "progressbar",
				icon = "ui/icons/armor_body.png",
				value = this.getArmor(this.Const.BodyPart.Body),
				valueMax = this.getArmorMax(this.Const.BodyPart.Body),
				text = "" + this.getArmor(this.Const.BodyPart.Body) + " / " + this.getArmorMax(this.Const.BodyPart.Body) + "",
				style = "armor-body-slim"
			},
			{
				id = 5,
				type = "progressbar",
				icon = "ui/icons/health.png",
				value = this.getHitpoints(),
				valueMax = this.getHitpointsMax(),
				text = "" + this.getHitpoints() + " / " + this.getHitpointsMax() + "",
				style = "hitpoints-slim"
			},
			{
				id = 6,
				type = "progressbar",
				icon = "ui/icons/morale.png",
				value = this.getMoraleState(),
				valueMax = this.Const.MoraleState.COUNT - 1,
				text = this.Const.MoraleStateName[this.getMoraleState()],
				style = "morale-slim"
			},
			{
				id = 7,
				type = "progressbar",
				icon = "ui/icons/fatigue.png",
				value = this.getFatigue(),
				valueMax = this.getFatigueMax(),
				text = "" + this.getFatigue() + " / " + this.getFatigueMax() + "",
				style = "fatigue-slim"
			}
		]);
		local result = [];
		local statusEffects = this.getSkills().query(this.Const.SkillType.StatusEffect | this.Const.SkillType.TemporaryInjury, false, true);

		foreach( i, statusEffect in statusEffects )
		{
			tooltip.push({
				id = 100 + i,
				type = "text",
				icon = statusEffect.getIcon(),
				text = statusEffect.getName()
			});
		}

		return tooltip;
	}

	function getTooltip( _targetedWithSkill = null )
	{
		local tooltip = this.modTacticalTooltip(_targetedWithSkill);

		if (!this.isPlayerControlled() && !this.LegendsMod.Configs().EnemeyTooltips())
		{
			return tooltip;
		}

		if (tooltip.len() < 3)
		{
			return tooltip;
		}

		local shownPerks = {};
		local stackEffects = function ( effects )
		{
			local stacks = {};

			foreach( _, effect in effects )
			{
				local name = effect.getName();

				if (name in stacks)
				{
					stacks[name] += 1;
				}
				else
				{
					stacks[name] <- 1;
				}
			}

			return stacks;
		};
		local pushSectionName = function ( items, title, startID )
		{
			if (items.len() && title)
			{
				tooltip.push({
					id = startID,
					type = "text",
					text = "[u][size=14]" + title + "[/size][/u]"
				});
			}
		};
		local isPerk = function ( _, item )
		{
			return item.getIcon().len() > 8 && item.getIcon().slice(0, 8) == "ui/perks";
		};
		local isInjury = function ( _, injury )
		{
			return injury.m.Order == this.Const.SkillOrder.TemporaryInjury;
		};
		local isTextRow = function ( _, row )
		{
			return ("type" in row) && row.type == "text";
		};
		local pushSection = function ( items, title, startID, filter = 0, prependIcon = "", stackInOneLine = false )
		{
			if (!items)
			{
				return;
			}

			if (filter == 1)
			{
				items = items.filter(isPerk);
			}
			else if (filter == 2)
			{
				items = items.filter(function ( i, item )
				{
					return !isPerk(i, item);
				});
			}

			local stacks = {};

			if (stackInOneLine)
			{
				stacks = stackEffects(items);
				local newItems = [];
				local added = {};

				foreach( i, item in items )
				{
					local name = item.getName();

					if (!(name in added))
					{
						newItems.push(item);
						added[name] <- 1;
					}
				}

				items = newItems;
			}

			pushSectionName(items, title, startID);
			startID = startID + 1;

			foreach( i, item in items )
			{
				local name = item.getName();
				local text = name;

				if (filter != 0)
				{
					shownPerks[name] <- 1;
				}

				if (stackInOneLine && stacks[name] > 1)
				{
					text = text + (" [color=" + this.Const.UI.Color.NegativeValue + "]" + "x" + stacks[name] + "[/color]");
				}

				tooltip.push({
					id = startID + i,
					type = "text",
					icon = prependIcon + item.getIcon(),
					text = text
				});
			}
		};
		local removeDuplicates = function ( items )
		{
			if (!items)
			{
				return items;
			}

			return items.filter(function ( i, item )
			{
				return !(item.getName() in shownPerks);
			});
		};
		local getPlural = function ( items )
		{
			if (!items)
			{
				return "";
			}

			return items.len() > 1 ? "s" : "";
		};
		local patchedPerkIcons = {};
		patchedPerkIcons[this.Const.Strings.PerkName.BatteringRam] <- "ui/settlement_status/settlement_effect_13.png";
		local getRealPerkIcon = function ( perk )
		{
			local realPerk = this.Const.Perks.findById(perk.getID());

			if (realPerk)
			{
				return realPerk.Icon;
			}

			local name = perk.getName();

			if (name in patchedPerkIcons)
			{
				return patchedPerkIcons[name];
			}

			return perk.getIcon();
		};

		local _type = "progressbar";

		foreach( i, row in tooltip )
		{
			if (("type" in row) && row.type == _type && ("id" in row) && "icon" in row)
			{
				if (row.id == 5 && row.icon == "ui/icons/armor_head.png")
				{
					row.text <- "" + this.getArmor(this.Const.BodyPart.Head) + " / " + this.getArmorMax(this.Const.BodyPart.Head) + "";
				}
				else if (row.id == 6 && row.icon == "ui/icons/armor_body.png")
				{
					row.text <- "" + this.getArmor(this.Const.BodyPart.Body) + " / " + this.getArmorMax(this.Const.BodyPart.Body) + "";
				}
				else if (row.id == 7 && row.icon == "ui/icons/health.png")
				{
					row.text <- "" + this.getHitpoints() + " / " + this.getHitpointsMax() + "";
				}
				else if (row.id == 9 && row.icon == "ui/icons/fatigue.png")
				{
					row.text <- "" + this.getFatigue() + " / " + this.getFatigueMax() + "";
				}
			}
		}

		if (_targetedWithSkill != null && this.isKindOf(_targetedWithSkill, "skill"))
		{
			local tile = this.getTile();

			if (tile.IsVisibleForEntity && _targetedWithSkill.isUsableOn(tile))
			{
				tooltip.push({
					id = 2048,
					type = "hint",
					icon = "ui/icons/mouse_right_button.png",
					text = "Expand tooltip"
				});
				return tooltip;
			}
		}

		local statusEffects = this.getSkills().query(this.Const.SkillType.StatusEffect | this.Const.SkillType.TemporaryInjury, false, true);
		local count = tooltip.len() - statusEffects.len();

		if (statusEffects.len() && count > 0)
		{
			if (tooltip[count].text == statusEffects[0].getName())
			{
				tooltip.resize(count);
				statusEffects = statusEffects.filter(function ( _, item )
				{
					return !isInjury(_, item);
				});
				statusEffects = removeDuplicates(statusEffects);
				pushSection(statusEffects, null, 100, 2, "", true);
				local injuries = this.getSkills().query(this.Const.SkillType.TemporaryInjury, false, true);

				foreach( i, injury in injuries )
				{
					local children = injury.getTooltip().filter(function ( _, row )
					{
						return isTextRow(_, row);
					});
					local addedTooltipHints = [];
					injury.addTooltipHint(addedTooltipHints);
					addedTooltipHints = addedTooltipHints.filter(function ( _, row )
					{
						return isTextRow(_, row);
					});
					local added_count = addedTooltipHints.len();

					if (added_count)
					{
						children.resize(children.len() - added_count);
					}

					local isUnderIronWill = function ()
					{
						local pattern = this.regexp("Iron Will");

						foreach( _, row in addedTooltipHints )
						{
							if (("text" in row) && pattern.search(row.text))
							{
								return true;
							}
						}

						return false;
					}();
					local injuryRow = {
						id = 133 + i,
						type = "text",
						icon = injury.getIcon(),
						text = injury.getName()
					};

					if (!isUnderIronWill)
					{
						injuryRow.children <- children;
					}
					else
					{
						injuryRow.text += "[color=" + this.Const.UI.Color.PositiveValue + "]" + " (Iron Will)[/color]";
					}

					tooltip.push(injuryRow);
					  // [310]  OP_CLOSE          0     20    0    0
				}

				statusEffects = removeDuplicates(statusEffects);
				pushSection(statusEffects, "Status perks", 150, 1);
			}
			else
			{
				foreach( _, row in tooltip )
				{
					if (("type" in row) && row.type == "text" && "text" in row)
					{
						shownPerks[row.text] <- 1;
					}
				}
			}
		}

		local activePerks = this.getSkills().query(this.Const.SkillType.Active, false, true);
		activePerks = removeDuplicates(activePerks);
		pushSection(activePerks, "Usable perks", 200, 1);
		local thresholdToCompact = 7;
		local perks = this.getSkills().query(this.Const.SkillType.Perk, false, true);
		perks = removeDuplicates(perks);
		pushSectionName(perks, "Perks", 300);

		if (perks.len() < thresholdToCompact)
		{
			foreach( i, perk in perks )
			{
				tooltip.push({
					id = 301 + i,
					type = "text",
					icon = getRealPerkIcon(perk),
					text = perk.getName()
				});
			}
		}
		else
		{
			local texts = "";

			foreach( _, perk in perks )
			{
				local name = perk.getName();

				if (name && name.len() > 1)
				{
					texts = texts + ("[color=" + this.Const.UI.Color.NegativeValue + "]" + name.slice(0, 1) + "[/color]" + name.slice(1) + ", ");
				}
			}

			if (texts.len() > 2)
			{
				texts = texts.slice(0, -2);
			}

			tooltip.push({
				id = 301,
				type = "text",
				icon = "ui/perks/selection_frame.png",
				text = texts
			});
		}

		local accessories = this.getItems().getAllItemsAtSlot(this.Const.ItemSlot.Accessory);
		pushSection(accessories, "Accessory", 400, 0, "ui/items/");
		local ammos = this.getItems().getAllItemsAtSlot(this.Const.ItemSlot.Ammo);
		pushSection(ammos, "Ammo", 500, 0, "ui/items/");
		local items = this.getItems().getAllItemsAtSlot(this.Const.ItemSlot.Bag);
		local itemsTitle = "Item" + getPlural(items) + " in bags";
		pushSection(items, itemsTitle, 600, 0, "ui/items/", true);
		local itemsOnGround = this.getTile().Items;
		pushSection(itemsOnGround, "Item" + getPlural(itemsOnGround) + " on ground", 700, 0, "ui/items/", true);
		return tooltip;
	}
	
	function getRosterTooltip()
	{
		local tooltip = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			}
		];
		
		return tooltip;
	}

});

