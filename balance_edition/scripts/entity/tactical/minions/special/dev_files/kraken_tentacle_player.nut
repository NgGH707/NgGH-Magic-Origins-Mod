this.kraken_tentacle_player <- this.inherit("scripts/entity/tactical/player_beast", {
	m = {
		Parent = null,
		Mode = 0
	},
	function spawnBloodPool( _a, _b ) {}
	function setParent( _p )
	{
		if (_p == null)
		{
			this.m.Parent = null;
		}
		else
		{
			this.m.Parent = this.WeakTableRef(_p);
		}
	}

	function getParent()
	{
		return this.m.Parent;
	}

	function getBackground()
	{
		return this.m.Parent != null ? this.m.Parent.getBackground() : null;
	}

	function getTalents()
	{
		return this.m.Parent != null ? this.m.Parent.getTalents() : [0, 0, 0, 0, 0, 0, 0, 0];
	}

	function setMode( _m )
	{
		this.m.Mode = _m;

		if (this.isPlacedOnMap())
		{
			if (this.m.Mode == 0 && _m == 1)
			{
				this.m.IsUsingZoneOfControl = true;
				this.setZoneOfControl(this.getTile(), true);
			}

			this.onUpdateInjuryLayer();
		}
	}

	function getMode()
	{
		return this.m.Mode;
	}

	function getImageOffsetY()
	{
		return 20;
	}

	function create()
	{
		this.player_beast.create();
		this.m.IsControlledByPlayer = true;
		this.m.Type = this.Const.EntityType.KrakenTentacle;
		this.m.XP = this.Const.Tactical.Actor.KrakenTentacle.XP;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.m.IsUsingZoneOfControl = false;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.DecapitateSplatterOffset = this.createVec(15, -26);
		this.m.DecapitateBloodAmount = 1.0;
		this.m.DeathBloodAmount = 0.0;
		this.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/dlc2/krake_choke_01.wav",
			"sounds/enemies/dlc2/krake_choke_02.wav",
			"sounds/enemies/dlc2/krake_choke_03.wav",
			"sounds/enemies/dlc2/krake_choke_04.wav",
			"sounds/enemies/dlc2/krake_choke_05.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/dlc2/tentacle_death_01.wav",
			"sounds/enemies/dlc2/tentacle_death_02.wav",
			"sounds/enemies/dlc2/tentacle_death_03.wav",
			"sounds/enemies/dlc2/tentacle_death_04.wav",
			"sounds/enemies/dlc2/tentacle_death_05.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/dlc2/krake_idle_01.wav",
			"sounds/enemies/dlc2/krake_idle_02.wav",
			"sounds/enemies/dlc2/krake_idle_03.wav",
			"sounds/enemies/dlc2/krake_idle_04.wav",
			"sounds/enemies/dlc2/krake_idle_05.wav",
		];
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/dlc2/tentacle_hurt_01.wav",
			"sounds/enemies/dlc2/tentacle_hurt_02.wav",
			"sounds/enemies/dlc2/tentacle_hurt_03.wav",
			"sounds/enemies/dlc2/tentacle_hurt_04.wav",
			"sounds/enemies/dlc2/tentacle_hurt_05.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/dlc2/krake_idle_10.wav",
			"sounds/enemies/dlc2/krake_idle_11.wav",
			"sounds/enemies/dlc2/krake_idle_12.wav",
			"sounds/enemies/dlc2/krake_idle_13.wav",
			"sounds/enemies/dlc2/krake_idle_14.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Other1] = [
			"sounds/enemies/dlc2/krake_choke_01.wav",
			"sounds/enemies/dlc2/krake_choke_02.wav",
			"sounds/enemies/dlc2/krake_choke_03.wav",
			"sounds/enemies/dlc2/krake_choke_04.wav",
			"sounds/enemies/dlc2/krake_choke_05.wav"
		];
		this.m.SoundVolume[this.Const.Sound.ActorEvent.DamageReceived] = 2.0;
		this.m.Flags.add("kraken_tentacle");
		this.m.Items.blockAllSlots();
		this.setGuest(true);
		this.setName("Irrlicht");
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		_tile = this.getTile();
		local decal_body = _tile.spawnDetail(this.getMode() == 0 ? "bust_kraken_tentacle_01_injured" : "bust_kraken_tentacle_02_injured", this.Const.Tactical.DetailFlag.Corpse, false);
		local corpse_data = {
			Body = decal_body,
			Start = this.Time.getRealTimeF(),
			Vector = this.createVec(0.0, -150.0),
			Tile = _tile,
			function onCorpseEffect( _data )
			{
				if (this.Time.getRealTimeF() - _data.Start >= 0.75)
				{
					_tile.clear(this.Const.Tactical.DetailFlag.Corpse);
					return;
				}

				local f = (this.Time.getRealTimeF() - _data.Start) / 0.75;
				_data.Body.setOffset(this.createVec(0.0, 0.0 + _data.Vector.Y * f));
				this.Time.scheduleEvent(this.TimeUnit.Real, 10, _data.onCorpseEffect, _data);
			}

		};
		this.Time.scheduleEvent(this.TimeUnit.Real, 10, corpse_data.onCorpseEffect, corpse_data);

		if (this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype].len() != 0)
		{
			for( local i = 0; i < this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype].len(); i = i )
			{
				if (this.Tactical.getWeather().IsRaining && !this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].ApplyOnRain)
				{
				}
				else
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].Brushes, _tile, this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].Delay, this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].Quantity, this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].LifeTimeQuantity, this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].SpawnRate, this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].Stages);
				}

				i = ++i;
			}
		}
		else if (this.Const.Tactical.RaiseFromGroundParticles.len() != 0)
		{
			for( local i = 0; i < this.Const.Tactical.RaiseFromGroundParticles.len(); i = i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.RaiseFromGroundParticles[i].Brushes, _tile, this.Const.Tactical.RaiseFromGroundParticles[i].Delay, this.Const.Tactical.RaiseFromGroundParticles[i].Quantity, this.Const.Tactical.RaiseFromGroundParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseFromGroundParticles[i].SpawnRate, this.Const.Tactical.RaiseFromGroundParticles[i].Stages);
				i = ++i;
			}
		}

		if (this.m.Parent != null && !this.m.Parent.isNull() && this.m.Parent.isAlive() && !this.m.Parent.isDying())
		{
			this.m.Parent.onTentacleDestroyed();
		}

		this.Tactical.getTemporaryRoster().remove(this);
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.KrakenTentacle);
		b.IsAffectedByNight = false;
		b.IsMovable = false;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToDisarm = true;
		b.IsAffectedByRain = false;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.addSprite("socket").setBrush("bust_base_player");
		local body = this.addSprite("body");
		body.setBrush("bust_kraken_tentacle_01");
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.68;
		this.setSpriteOffset("status_rooted", this.createVec(5, 25));
		this.setSpriteOffset("arrow", this.createVec(0, 25));
		this.setSpriteOffset("status_stunned", this.createVec(0, 25));
		
		this.m.Skills.add(this.new("scripts/skills/actives/mod_kraken_bite_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/mod_kraken_move_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/mod_kraken_ensnare_skill"));

		this.Tactical.getTemporaryRoster().add(this);
	}

	function onFactionChanged()
	{
		this.actor.onFactionChanged();
		local flip = this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
	}

	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		_hitInfo.BodyPart = this.Const.BodyPart.Body;
		return this.actor.onDamageReceived(_attacker, _skill, _hitInfo);
	}

	function onUpdateInjuryLayer()
	{
		local body = this.getSprite("body");
		local p = this.getHitpointsPct();

		if (p > 0.5)
		{
			if (this.m.Mode == 0)
			{
				body.setBrush("bust_kraken_tentacle_01");
			}
			else
			{
				body.setBrush("bust_kraken_tentacle_02");
			}
		}
		else if (this.m.Mode == 0)
		{
			body.setBrush("bust_kraken_tentacle_01_injured");
		}
		else
		{
			body.setBrush("bust_kraken_tentacle_02_injured");
		}

		this.setDirty(true);
	}

	function onPlacedOnMap()
	{
		this.actor.onPlacedOnMap();
		this.onUpdateInjuryLayer();
	}

	function onActorKilled( _actor, _tile, _skill )
	{
		if (this.m.Parent != null && !this.m.Parent.isNull() && this.m.Parent.isAlive() && !this.m.Parent.isDying())
		{
			this.m.Parent.onActorKilled(_actor, _tile, _skill);

			if (!this.m.IsAlive || this.m.IsDying)
			{
				return;
			}

			this.m.Skills.onTargetKilled(_actor, _skill);
		}
		else
		{
			this.player_beast.onActorKilled(_actor, _tile, _skill);
		}
	}

	function addXP( _xp, _scale = true )
	{
		if (this.m.Parent != null && !this.m.Parent.isNull() && this.m.Parent.isAlive() && !this.m.Parent.isDying())
		{
			this.m.Parent.addXP(_xp, _scale);
		}
	}

	function onTurnStart()
	{
		this.updateMode();
		this.player_beast.onTurnStart();
	}

	function onTurnResumed()
	{
		this.updateMode();
		this.player_beast.onTurnResumed();
	}

	function updateMode()
	{
		if (this.m.Mode == 1)
		{
			this.m.IsUsingZoneOfControl = true;
			this.setZoneOfControl(this.getTile(), true);
		}

		this.onUpdateInjuryLayer();
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

		if (_targetedWithSkill != null && this.isKindOf(_targetedWithSkill, "skill"))
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

});

