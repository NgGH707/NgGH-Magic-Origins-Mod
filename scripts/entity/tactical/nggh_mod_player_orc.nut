this.nggh_mod_player_orc <- ::inherit("scripts/entity/tactical/nggh_mod_inhuman_player", {
	m = {
		IsWearingOrcArmor = false,
		IsWearingOrcHelmet = false,
	},
	function isBehemoth()
	{
		return this.getFlags().get("Type") == ::Const.EntityType.LegendOrcBehemoth;
	}

	function isWarlord()
	{
		return this.getFlags().get("Type") == ::Const.EntityType.OrcWarlord;
	}

	function getStrengthMult()
	{
		switch(this.getFlags().get("Type"))
		{
		case ::Const.EntityType.LegendOrcBehemoth:
			return 7.0;

		case ::Const.EntityType.LegendOrcElite:
			return 2.75;

		case ::Const.EntityType.OrcWarlord:
			return 3.0;

		case ::Const.EntityType.OrcWarrior:
		case ::Const.EntityType.OrcBerserker:
			return 2.0;
		}

		return 1.2;
	}

	function getImageOffsetY()
	{
		if (this.m.Variant == 3)
		{
			return -5;
		}
		
		return 0;
	}

	function create()
	{
		this.nggh_mod_inhuman_player.create();
		this.m.BloodType = ::Const.BloodType.Red;
		this.m.BloodSplatterOffset = ::createVec(0, 0);
		this.m.DecapitateSplatterOffset = ::createVec(20, -20);
		this.m.DecapitateBloodAmount = 3.0;
		this.m.ExcludedTraits = ::Const.Nggh_ExcludedTraits.Orc;
		this.m.AttributesLevelUp = ::Const.Nggh_AttributesLevelUp.Orc;
		this.m.Sound[::Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/orc_idle_01.wav",
			"sounds/enemies/orc_idle_02.wav",
			"sounds/enemies/orc_idle_03.wav",
			"sounds/enemies/orc_idle_04.wav",
			"sounds/enemies/orc_idle_05.wav",
			"sounds/enemies/orc_idle_06.wav",
			"sounds/enemies/orc_idle_07.wav",
			"sounds/enemies/orc_idle_08.wav",
			"sounds/enemies/orc_idle_09.wav",
			"sounds/enemies/orc_idle_10.wav",
		];
		this.m.Sound[::Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/orc_hurt_01.wav",
			"sounds/enemies/orc_hurt_02.wav",
			"sounds/enemies/orc_hurt_03.wav",
			"sounds/enemies/orc_hurt_04.wav",
			"sounds/enemies/orc_hurt_05.wav",
			"sounds/enemies/orc_hurt_06.wav",
			"sounds/enemies/orc_hurt_07.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/orc_fatigue_01.wav",
			"sounds/enemies/orc_fatigue_02.wav",
			"sounds/enemies/orc_fatigue_03.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/orc_flee_01.wav",
			"sounds/enemies/orc_flee_02.wav",
			"sounds/enemies/orc_flee_03.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/orc_death_01.wav",
			"sounds/enemies/orc_death_02.wav",
			"sounds/enemies/orc_death_03.wav",
			"sounds/enemies/orc_death_04.wav",
			"sounds/enemies/orc_death_05.wav",
			"sounds/enemies/orc_death_06.wav",
			"sounds/enemies/orc_death_07.wav",
			"sounds/enemies/orc_death_08.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/orc_idle_11.wav",
			"sounds/enemies/orc_idle_12.wav",
			"sounds/enemies/orc_idle_13.wav",
			"sounds/enemies/orc_idle_14.wav",
			"sounds/enemies/orc_idle_15.wav",
			"sounds/enemies/orc_idle_16.wav",
			"sounds/enemies/orc_idle_17.wav",
			"sounds/enemies/orc_idle_18.wav",
			"sounds/enemies/orc_idle_19.wav",
			"sounds/enemies/orc_idle_20.wav",
			"sounds/enemies/orc_idle_21.wav",
			"sounds/enemies/orc_idle_22.wav",
			"sounds/enemies/orc_idle_23.wav",
			"sounds/enemies/orc_idle_24.wav",
			"sounds/enemies/orc_idle_25.wav",
			"sounds/enemies/orc_idle_26.wav",
			"sounds/enemies/orc_idle_27.wav",
			"sounds/enemies/orc_idle_28.wav",
			"sounds/enemies/orc_idle_29.wav",
		];
		this.m.Sound[::Const.Sound.ActorEvent.Move] = [
			"sounds/enemies/orc_fatigue_01.wav",
			"sounds/enemies/orc_fatigue_02.wav",
			"sounds/enemies/orc_fatigue_03.wav"
		];
		// important flags for many crucial mechanisms
		this.m.Flags.add("bonus_regen");
		this.m.Flags.add("orc");
	}

	function playSound( _type, _volume, _pitch = 1.0 )
	{
		if (_type == ::Const.Sound.ActorEvent.Move && ::Math.rand(1, 100) <= 50)
		{
			return;
		}

		this.nggh_mod_inhuman_player.playSound(_type, _volume, _pitch);
	}

	function updateRageVisuals( _rage )
	{
		local body_rage = this.getSprite("body_rage");

		if (_rage <= 6)
		{
			body_rage.Visible = false;
			return;
		}

		if (_rage <= 12)
		{
			body_rage.setBrush("bust_orc_02_body_bloodied_00");
		}
		else if (_rage <= 18)
		{
			body_rage.setBrush("bust_orc_02_body_bloodied_01");
		}
		else if (_rage <= 24)
		{
			body_rage.setBrush("bust_orc_02_body_bloodied_02");
		}
		else
		{
			body_rage.setBrush("bust_orc_02_body_bloodied_03");
		}

		body_rage.Visible = true;
		this.setDirty(true);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		local flip = ::Math.rand(0, 100) < 50;
		this.m.IsCorpseFlipped = flip;
		local isResurrectable = false;
		local appearance = this.getItems().getAppearance();
		local sprite_body = this.getSprite("body");
		local sprite_head = this.getSprite("head");
		local sprite_accessory = this.getSprite("accessory");

		if (!this.isGuest())
		{
			local stub = ::Tactical.getCasualtyRoster().create("scripts/entity/tactical/player_corpse_stub");
			stub.setCommander(this.isCommander());
			stub.setOriginalID(this.getID());
			stub.setName(this.getNameOnly());
			stub.setTitle(this.getTitle());
			stub.setCombatStats(this.m.CombatStats);
			stub.setLifetimeStats(this.m.LifetimeStats);
			stub.m.DaysWithCompany = this.getDaysWithCompany();
			stub.m.Level = this.getLevel();
			stub.m.DailyCost = this.getDailyCost();
			stub.addSprite("blood_1").setBrush(::MSU.Array.rand(::Const.BloodPoolDecals[::Const.BloodType.Red]));
			stub.addSprite("blood_2").setBrush(::MSU.Array.rand(::Const.BloodDecals[::Const.BloodType.Red]));
			stub.setSpriteOffset("blood_1", ::createVec(0, -15));
			stub.setSpriteOffset("blood_2", ::createVec(0, -30));

			if (_fatalityType == ::Const.FatalityType.Devoured)
			{
				for( local i = 0; i != ::Const.CorpsePart.len(); ++i )
				{
					stub.addSprite("stuff_" + i).setBrush(::Const.CorpsePart[i]);
				}
			}
			else
			{
				local decal = stub.addSprite("body");
				decal.setBrush(sprite_body.getBrush().Name + "_dead");
				decal.Color = sprite_head.Color;
				decal.Saturation = sprite_head.Saturation;

				if (appearance.CorpseArmor != "")
				{
					decal = stub.addSprite("armor");
					decal.setBrush(appearance.CorpseArmor);
				}

				if (appearance.CorpseArmorUpgradeBack != "")
				{
					decal = stub.addSprite("upgrade_back");
					decal.setBrush(appearance.CorpseArmorUpgradeBack);
				}

				if (sprite_accessory.HasBrush)
				{
					decal = stub.addSprite("accessory");
					decal.setBrush(sprite_accessory.getBrush().Name + "_dead");
				}

				if (_skill && _skill.getProjectileType() == ::Const.ProjectileType.Arrow)
				{
					if (appearance.CorpseArmor != "")
					{
						stub.addSprite("arrows").setBrush(appearance.CorpseArmor + "_arrows");
					}
					else
					{
						stub.addSprite("arrows").setBrush(appearance.Corpse + "_arrows");
					}
				}
				else if (_skill && _skill.getProjectileType() == ::Const.ProjectileType.Javelin)
				{
					if (appearance.CorpseArmor != "")
					{
						stub.addSprite("arrows").setBrush(appearance.CorpseArmor + "_javelin");
					}
					else
					{
						stub.addSprite("arrows").setBrush(appearance.Corpse + "_javelin");
					}
				}

				if (_fatalityType != ::Const.FatalityType.Decapitated)
				{
					if (sprite_head.HasBrush)
					{
						if (!appearance.HideCorpseHead)
						{
							decal = stub.addSprite("head");
							decal.setBrush(sprite_head.getBrush().Name + "_dead");
							decal.Color = sprite_head.Color;
							decal.Saturation = sprite_head.Saturation;
						}
					}
					
					if (appearance.HelmetCorpse != "")
					{
						decal = stub.addSprite("helmet");
						decal.setBrush(this.getItems().getAppearance().HelmetCorpse);
					}
				}

				if (appearance.CorpseArmorUpgradeFront != "")
				{
					decal = stub.addSprite("upgrade_front");
					decal.setBrush(appearance.CorpseArmorUpgradeFront);
				}
			}
		}	

		if (_tile != null)
		{
			this.spawnBloodPool(_tile, 1);
			local tattoo_head = this.getSprite("tattoo_head");
			local tattoo_body = this.getSprite("tattoo_body");
			local decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead", ::Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = sprite_body.Color;
			decal.Saturation = sprite_body.Saturation;
			decal.Scale = 0.9;
			decal.setBrightness(0.9);

			if (tattoo_body.HasBrush)
			{
				decal = _tile.spawnDetail(tattoo_body.getBrush().Name + "_dead", ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Color = tattoo_body.Color;
				decal.Saturation = tattoo_body.Saturation;
				decal.Scale = 0.9;
				decal.setBrightness(0.9);
			}

			if (this.getItems().getAppearance().CorpseArmor != "")
			{
				decal = _tile.spawnDetail(appearance.CorpseArmor, ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9;
				decal.setBrightness(0.9);
			}

			if (_fatalityType != ::Const.FatalityType.Decapitated)
			{
				if (!appearance.HideCorpseHead)
				{
					decal = _tile.spawnDetail(sprite_head.getBrush().Name + "_dead", ::Const.Tactical.DetailFlag.Corpse, flip);
					decal.Color = sprite_head.Color;
					decal.Saturation = sprite_head.Saturation;
					decal.Scale = 0.9;
					decal.setBrightness(0.9);

					if (tattoo_head.HasBrush)
					{
						decal = _tile.spawnDetail(tattoo_head.getBrush().Name + "_dead", ::Const.Tactical.DetailFlag.Corpse, flip);
						decal.Color = tattoo_head.Color;
						decal.Saturation = tattoo_head.Saturation;
						decal.Scale = 0.9;
						decal.setBrightness(0.9);
					}
				}

				if (appearance.HelmetCorpse != "")
				{
					decal = _tile.spawnDetail(appearance.HelmetCorpse, ::Const.Tactical.DetailFlag.Corpse, flip);
					decal.Scale = 0.9;
					decal.setBrightness(0.9);
				}
			}
			else if (_fatalityType == ::Const.FatalityType.Decapitated)
			{
				local layers = [];

				if (!appearance.HideCorpseHead)
				{
					layers.push(sprite_head.getBrush().Name + "_dead");
				}

				if (!appearance.HideCorpseHead && tattoo_head.HasBrush)
				{
					layers.push(tattoo_head.getBrush().Name + "_dead");
				}

				if (appearance.HelmetCorpse.len() != 0)
				{
					layers.push(appearance.HelmetCorpse);
				}

				local decap = ::Tactical.spawnHeadEffect(this.getTile(), layers, ::createVec(-50, 30), 180.0, sprite_head.getBrush().Name + "_dead_bloodpool");
				local idx = 0;

				if (!appearance.HideCorpseHead)
				{
					decap[idx].Color = sprite_head.Color;
					decap[idx].Saturation = sprite_head.Saturation;
					decap[idx].Scale = 0.9;
					decap[idx].setBrightness(0.9);
					++idx;
				}

				if (!appearance.HideCorpseHead && tattoo_head.HasBrush)
				{
					decap[idx].Color = tattoo_head.Color;
					decap[idx].Saturation = tattoo_head.Saturation;
					decap[idx].Scale = 0.9;
					decap[idx].setBrightness(0.9);
					++idx;
				}

				if (appearance.HelmetCorpse.len() != 0)
				{
					decap[idx].Scale = 0.9;
					decap[idx].setBrightness(0.9);
					++idx;
				}
			}

			if (_fatalityType == ::Const.FatalityType.Disemboweled)
			{
				if (appearance.CorpseArmor != "" && ::doesBrushExist(appearance.CorpseArmor + "_guts"))
				{
					decal = _tile.spawnDetail(appearance.CorpseArmor + "_guts", ::Const.Tactical.DetailFlag.Corpse, flip);
					decal.Scale = 0.9;
				}
				else if (::doesBrushExist(sprite_body.getBrush().Name + "_dead_guts"))
				{
					decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead_guts", ::Const.Tactical.DetailFlag.Corpse, flip);
					decal.Scale = 0.9;
				}
			}
			else if (_skill && _skill.getProjectileType() == ::Const.ProjectileType.Arrow)
			{
				if (appearance.CorpseArmor != "")
				{
					decal = _tile.spawnDetail(appearance.CorpseArmor + "_arrows", ::Const.Tactical.DetailFlag.Corpse, flip);
				}
				else
				{
					decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead_arrows", ::Const.Tactical.DetailFlag.Corpse, flip);
				}

				decal.Scale = 0.9;
			}
			else if (_skill && _skill.getProjectileType() == ::Const.ProjectileType.Javelin)
			{
				if (appearance.CorpseArmor != "")
				{
					decal = _tile.spawnDetail(appearance.CorpseArmor + "_javelin", ::Const.Tactical.DetailFlag.Corpse, flip);
				}
				else
				{
					decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead_javelin", ::Const.Tactical.DetailFlag.Corpse, flip);
				}

				decal.Scale = 0.9;
			}

			this.spawnTerrainDropdownEffect(_tile);
			local corpse = clone ::Const.Corpse;
			corpse.CorpseName = this.getName();
			corpse.IsResurrectable = false;
			corpse.IsConsumable = _fatalityType != ::Const.FatalityType.Unconscious;
			corpse.IsHeadAttached = _fatalityType != ::Const.FatalityType.Decapitated;
			corpse.Items = _fatalityType != ::Const.FatalityType.Unconscious ? this.getItems() : null;
			corpse.Tile = _tile;
			corpse.Value = 10.0;
			corpse.IsPlayer = true;
			_tile.Properties.set("Corpse", corpse);
			::Tactical.Entities.addCorpse(_tile);
		}
		
		this.nggh_mod_inhuman_player.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function onAfterFactionChanged()
	{
		local flip = this.isAlliedWithPlayer();
		this.getSprite("background").setHorizontalFlipping(!flip);
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("tattoo_body").setHorizontalFlipping(flip);
		this.getSprite("injury_body").setHorizontalFlipping(flip);
		this.getSprite("shaft").setHorizontalFlipping(!flip);
		this.getSprite("head").setHorizontalFlipping(flip);
		this.getSprite("tattoo_head").setHorizontalFlipping(flip);
		this.getSprite("injury").setHorizontalFlipping(flip);
		this.getSprite("body_blood").setHorizontalFlipping(flip);
		this.getSprite("body_rage").setHorizontalFlipping(flip);
		this.getSprite("accessory").setHorizontalFlipping(!flip);
		this.getSprite("accessory_special").setHorizontalFlipping(!flip);
		
		foreach( a in ::Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.getSprite(a).setHorizontalFlipping(this.m.IsWearingOrcHelmet && a == "helmet" ? flip : !flip);
		}

		this.getSprite("armor").setHorizontalFlipping(this.m.IsWearingOrcArmor ? flip : !flip);
		this.getSprite("armor_layer_chain").setHorizontalFlipping(!flip);
		this.getSprite("armor_layer_plate").setHorizontalFlipping(!flip);
		this.getSprite("armor_layer_tabbard").setHorizontalFlipping(!flip);
		this.getSprite("armor_layer_cloak").setHorizontalFlipping(!flip);
		this.getSprite("armor_upgrade_back").setHorizontalFlipping(!flip);
		this.getSprite("armor_upgrade_front").setHorizontalFlipping(!flip);
	}

	function onInit()
	{
		this.nggh_mod_inhuman_player.onInit();
		local b = this.m.BaseProperties;
		b.FatigueOnSkillUse -= 2;
		this.m.ActionPoints = b.ActionPoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = ::Const.DefaultMovementAPCost;
		this.m.FatigueCosts = ::Const.DefaultMovementFatigueCost;
		
		// remove all unwanted sprite layers
		::Const.CharmedUtilities.removeAllHumanSprites(this, ::Const.CharmedUtilities.SpritesToIgnoreOrc, true);
		
		// add or re-add these sprite layers
		local body_rage = this.addSprite("body_rage");
		body_rage.Visible = false;
		body_rage.Alpha = 220;
		
		this.addSprite("accessory");
		this.addSprite("accessory_special");
		
		local body_dirt = this.addSprite("dirt");
		body_dirt.setBrush("bust_body_dirt_02");
		body_dirt.Visible = false;
		
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.6;

		// small hooks to  change the "pucnh" skill to deal more damage
		local hand_to_hand = this.m.Skills.getSkillByID("actives.hand_to_hand");
		hand_to_hand.m.DirectDamageMult = 0.35;
		hand_to_hand.onUpdate = function( _properties )
		{
			if (this.isUsable())
			{
				_properties.DamageRegularMin += 7;
				_properties.DamageRegularMax += 15;
			}
		};
	}

	function onAfterInit()
	{
		this.nggh_mod_inhuman_player.onAfterInit();
		// signature trait of all orcs
		this.getSkills().add(::new("scripts/skills/traits/iron_jaw_trait"));
	}
	
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.nggh_mod_inhuman_player.onAppearanceChanged(_appearance, _setDirty);
		this.onAdjustingSprite(_appearance);
	}

	function onAdjustingSprite( _appearance )
	{
		foreach ( a in ::Const.CharmedUtilities.Armor )
		{
			if (a == "armor" && this.m.IsWearingOrcArmor)
			{
				this.getSprite(a).Scale = 1.0;
				continue;
			}

			this.getSprite(a).Scale = ::Const.Orc.ArmorScale[this.m.Variant];
		}

		foreach( h in ::Const.CharacterSprites.Helmets )
		{
			if (h == "helmet" && this.m.IsWearingOrcHelmet)
			{
				this.setSpriteOffset(h, ::createVec(0, 0));
				continue;
			}

			this.setSpriteOffset(h, ::createVec(::Const.Orc.HelmetSpriteOffset[this.m.Variant][0], ::Const.Orc.HelmetSpriteOffset[this.m.Variant][1]));
		}

		this.setAlwaysApplySpriteOffset(true);
	}

	function onAdjustingArmorSprites()
	{
		local flip = this.isAlliedWithPlayer();
		this.getSprite("armor").setHorizontalFlipping(this.m.IsWearingOrcArmor ? flip : !flip);
		this.getSprite("helmet").setHorizontalFlipping(this.m.IsWearingOrcHelmet ? flip : !flip);
	}

	function resetRenderEffects()
	{
		this.nggh_mod_inhuman_player.resetRenderEffects();

		if (this.isWarlord())
		{
			this.setSpriteOffset("arms_icon", ::createVec(-8, 0));
			this.setSpriteOffset("shield_icon", ::createVec(-5, 0));
		}
	}

	function setScenarioValues( _type, _isElite = false, _randomizedTalents = false, _setName = true )
	{
		local c = this.m.CurrentProperties;
		this.m.ActionPoints = c.ActionPoints;
		this.m.Hitpoints = c.Hitpoints;
		this.m.Talents = [];
		this.m.Attributes = [];

		//if (_randomizedTalents)
		{
			this.player.fillTalentValues(3);
		}
		/*else
		{
			this.fillModsTalentValues(9, true);
		}
		*/
		
		this.fillAttributeLevelUpValues(::Const.XP.MaxLevelWithPerkpoints - 1);

		if (_setName)
		{
			this.setName(::Const.Strings.EntityName[_type]);
		}

		if (_isElite || (!_randomizedTalents && ::Math.rand(1, 100) == 1))
		{
			this.m.Skills.add(::new("scripts/skills/racial/champion_racial"));
		}
		else if (::Math.rand(1, 100) <= 1)
		{
			this.getBackground().addPerk(::Const.Perks.PerkDefs.NggHMiscChampion, 6);
		}

		if (::Math.rand(1, 100) <= 5)
		{
			this.getBackground().addPerk(::Const.Perks.PerkDefs.NggHMiscFairGame, 2);
		}

		if (!this.m.Skills.hasSkill("trait.intensive_training_trait"))
		{
			this.m.Skills.add(::new("scripts/skills/traits/intensive_training_trait"));
		}

		this.getFlags().set("Type", _type);
		this.updateVariant();
	}

	function setStartValuesEx( _isElite = false, _variant = -1, _pickRandom = true, _addUniqueTrait = false )
	{
		local type;

		if (_variant >= 0 && _variant < ::Const.Orc.Variants.len())
		{
			type = ::Const.Orc.Variants[_variant];
			this.m.Variant = _variant;
		}
		else if (_pickRandom)
		{
			type = ::MSU.Class.WeightedContainer(::Const.Orc.VariantRolls).roll();
			this.m.Variant = ::Const.Orc.Variants.find(type);
		}
		else
		{
			type = ::Const.Orc.Variants[0];
			this.m.Variant = 0;
		}

		switch(type)
		{
		case ::Const.EntityType.LegendOrcBehemoth:
			this.setAsOrcBehemoth();
			break;

		case ::Const.EntityType.LegendOrcElite:
			this.setAsOrcElite();
			break;

		case ::Const.EntityType.OrcWarlord:
			this.setAsOrcWarLord()
			break;

		case ::Const.EntityType.OrcWarrior:
			this.setAsOrcWarrior();
			break;

		case ::Const.EntityType.OrcBerserker:
			this.setAsOrcBerserker();
			break;

		default:
			this.setAsOrcYoung();
		}

		// update the properties
		this.m.CurrentProperties = clone this.m.BaseProperties;
		this.addDefaultBackground(type);

		if (_addUniqueTrait)
		{
			this.m.Skills.add(::new("scripts/traits/nggh_mod_born_to_fight_trait"));
		}

		this.setScenarioValues(type, _isElite);
		this.assignRandomEquipment();
	}

	function updateVariant()
	{
		local appearance = this.getItems().getAppearance();

		switch(this.m.Variant)
		{
		case 5:
			appearance.Body = "legend_orc_behemoth_body_01";
			this.setSpriteOffset("status_rooted", ::reateVec(0, 5));
			this.getSprite("status_rooted").Scale = 0.8;
			break;

		case 4:
			appearance.Body = "bust_orc_03_body";
			this.setSpriteOffset("status_rooted", ::createVec(0, 5));
			this.getSprite("status_rooted").Scale = 0.6;
			break;

		case 3:
			appearance.Body = "bust_orc_04_body";
			this.setSpriteOffset("arms_icon", ::createVec(-8, 0));
			this.setSpriteOffset("shield_icon", ::createVec(-5, 0));
			this.setSpriteOffset("stunned", ::createVec(0, 10));
			this.setSpriteOffset("status_stunned", ::createVec(-5, 30));
			this.setSpriteOffset("arrow", ::createVec(-5, 30));
			this.setSpriteOffset("status_rooted", ::createVec(0, 16));
			this.getSprite("status_rooted").Scale = 0.65;
			break;

		case 2:
			appearance.Body = "bust_orc_03_body";
			this.setSpriteOffset("status_rooted", ::createVec(0, 5));
			this.getSprite("status_rooted").Scale = 0.6;
			break;

		case 1:
			appearance.Body = "bust_orc_02_body";
			this.getSprite("status_rooted").Scale = 0.6;
			break;

		default:
			appearance.Body = "bust_orc_01_body";
			this.getSprite("status_rooted").Scale = 0.55;
		}

		this.setSpriteOffset("status_rooted_back", this.getSpriteOffset("status_rooted"));
		this.getSprite("status_rooted_back").Scale = this.getSprite("status_rooted").Scale;

		switch(this.getFlags().get("Type"))
		{
		case ::Const.EntityType.LegendOrcBehemoth:
			this.applyOrcBehemothSettings();
			break;

		case ::Const.EntityType.LegendOrcElite:
			this.applyOrcEliteSettings();
			break;

		case ::Const.EntityType.OrcWarlord:
			this.applyOrcWarlordSettings();
			break;

		case ::Const.EntityType.OrcWarrior:
			this.applyOrcWarriorSettings();
			break;

		case ::Const.EntityType.OrcBerserker:
			this.applyOrcBerserkerSettings();
			break;

		default:
			this.applyOrcYoungSettings();
		}
	}

	function setAsOrcBehemoth()
	{
		local b = this.m.BaseProperties;
		b.setValues(::Const.Tactical.Actor.LegendOrcBehemoth);
		b.MeleeSkill += 5;
		b.DamageTotalMult += 0.1;
		
		local body = this.getSprite("body");
		body.setBrush("legend_orc_behemoth_body_01");
		body.varyColor(0.1, 0.1, 0.1);
		
		local injury_body = this.getSprite("injury_body");
		injury_body.Visible = false;
		injury_body.setBrush("legend_orc_behemoth_body_01_bloodied");
		
		local head = this.getSprite("head");
		head.setBrush("legend_orc_behemoth_head_01");
		head.Saturation = body.Saturation;
		head.Color = body.Color;
		
		local injury = this.getSprite("injury");
		injury.Visible = false;
		injury.setBrush("legend_orc_behemoth_head_01_bloodied");
		
		local body_blood = this.getSprite("body_blood");
		body_blood.setBrush("bust_orc_03_body_bloodied");
		body_blood.Visible = false;
	}

	function applyOrcBehemothSettings()
	{
		this.m.Sound[::Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/orcgiant_idle_01.wav",
			"sounds/enemies/orcgiant_idle_02.wav",
			"sounds/enemies/orcgiant_idle_03.wav",
			"sounds/enemies/orcgiant_idle_04.wav",
			"sounds/enemies/orcgiant_idle_05.wav",
		];
		this.m.Sound[::Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/orcgiant_hurt_01.wav",
			"sounds/enemies/orcgiant_hurt_02.wav",
			"sounds/enemies/orcgiant_hurt_03.wav",
			"sounds/enemies/orcgiant_hurt_04.wav",
			"sounds/enemies/orcgiant_hurt_05.wav",
			"sounds/enemies/orcgiant_hurt_06.wav",
			"sounds/enemies/orcgiant_hurt_07.wav",
			"sounds/enemies/orcgiant_hurt_08.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/orc_fatigue_01.wav",
			"sounds/enemies/orc_fatigue_02.wav",
			"sounds/enemies/orc_fatigue_03.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/orcgiant_flee_01.wav",
			"sounds/enemies/orcgiant_flee_02.wav",
			"sounds/enemies/orcgiant_flee_03.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/orcgiant_death_01.wav",
			"sounds/enemies/orcgiant_death_02.wav",
			"sounds/enemies/orcgiant_death_03.wav",
			"sounds/enemies/orcgiant_death_04.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/orcgiant_idle_06.wav",
			"sounds/enemies/orcgiant_idle_07.wav",
			"sounds/enemies/orcgiant_idle_08.wav",
			"sounds/enemies/orcgiant_idle_09.wav",
			"sounds/enemies/orcgiant_idle_10.wav",
			"sounds/enemies/orcgiant_idle_11.wav",
			"sounds/enemies/orcgiant_idle_12.wav",
			"sounds/enemies/orcgiant_idle_13.wav",
			"sounds/enemies/orcgiant_idle_14.wav",
			"sounds/enemies/orcgiant_idle_15.wav",
			"sounds/enemies/orcgiant_idle_16.wav",
			"sounds/enemies/orcgiant_idle_17.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Move] = [
			"sounds/enemies/orc_fatigue_01.wav",
			"sounds/enemies/orc_fatigue_02.wav",
			"sounds/enemies/orc_fatigue_03.wav"
		];
		this.m.SoundPitch = 0.6;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Idle] = 1.25;
		this.m.SoundVolume[::Const.Sound.ActorEvent.DamageReceived] = 1.0;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Move] = 0.75;
		this.m.AttributesLevelUp = ::Const.AttributesLevelUp;
		this.m.BaseProperties.DailyFood = 10;
	}

	function setAsOrcElite()
	{
		local b = this.m.BaseProperties;
		b.setValues(::Const.Tactical.Actor.LegendOrcElite);
		b.MeleeSkill += 10;
		b.DamageTotalMult += 0.1;
		
		local body = this.getSprite("body");
		body.setBrush("bust_orc_03_body");
		body.varyColor(0.09, 0.09, 0.09);
		
		local injury_body = this.getSprite("injury_body");
		injury_body.Visible = false;
		injury_body.setBrush("bust_orc_03_body_injured");
		
		local head = this.getSprite("head");
		head.setBrush("bust_orc_03_head_0" + ::Math.rand(1, 3));
		head.Saturation = body.Saturation;
		head.Color = body.Color;
		
		local injury = this.getSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_orc_03_head_injured");
		
		local body_blood = this.getSprite("body_blood");
		body_blood.setBrush("bust_orc_03_body_bloodied");
		body_blood.Visible = false;
	}

	function applyOrcEliteSettings()
	{
		this.applyOrcWarriorSettings();
		this.m.BaseProperties.DailyFood = 6;
	}
	
	function setAsOrcWarLord()
	{
		local b = this.m.BaseProperties;
		b.setValues(::Const.Tactical.Actor.OrcWarlord);
		b.MeleeSkill += 5;
		b.DamageTotalMult += 0.1;
		
		local body = this.getSprite("body");
		body.setBrush("bust_orc_04_body");
		body.varyColor(0.1, 0.1, 0.1);
		
		local injury_body = this.getSprite("injury_body");
		injury_body.Visible = false;
		injury_body.setBrush("bust_orc_04_body_injured");
		
		local head = this.getSprite("head");
		head.setBrush("bust_orc_04_head_01");
		head.Saturation = body.Saturation;
		head.Color = body.Color;
		
		local injury = this.getSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_orc_04_head_injured");
		
		local body_blood = this.getSprite("body_blood");
		body_blood.setBrush("bust_orc_04_body_bloodied");
		body_blood.Visible = false;
	}

	function applyOrcWarlordSettings()
	{
		this.m.SoundPitch = 0.8;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Idle] = 1.25;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Move] = 0.75;
		this.m.BaseProperties.DailyFood = 7;
	}
	
	function setAsOrcWarrior()
	{
		local b = this.m.BaseProperties;
		b.setValues(::Const.Tactical.Actor.OrcWarrior);
		b.MeleeSkill += 5;
		b.DamageTotalMult += 0.1;
		
		local body = this.getSprite("body");
		body.setBrush("bust_orc_03_body");
		body.varyColor(0.09, 0.09, 0.09);
		
		local injury_body = this.getSprite("injury_body");
		injury_body.Visible = false;
		injury_body.setBrush("bust_orc_03_body_injured");
		
		local head = this.getSprite("head");
		head.setBrush("bust_orc_03_head_0" + ::Math.rand(1, 3));
		head.Saturation = body.Saturation;
		head.Color = body.Color;
		
		local injury = this.getSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_orc_03_head_injured");
		
		local body_blood = this.getSprite("body_blood");
		body_blood.setBrush("bust_orc_03_body_bloodied");
		body_blood.Visible = false;
	}

	function applyOrcWarriorSettings()
	{
		this.m.SoundPitch = 0.9;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Idle] = 1.25;
		this.m.SoundVolume[::Const.Sound.ActorEvent.DamageReceived] = 1.0;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Move] = 0.75;
		this.m.BaseProperties.DailyFood = 5;
	}

	function setAsOrcBerserker()
	{
		local b = this.m.BaseProperties;
		b.setValues(::Const.Tactical.Actor.OrcBerserker);
		b.MeleeSkill += 5;
		b.Bravery += 5;
		b.DamageTotalMult += 0.1;
		
		local body = this.getSprite("body");
		body.setBrush("bust_orc_02_body");
		body.varySaturation(0.1);
		body.varyColor(0.08, 0.08, 0.08);
		
		if (::Math.rand(1, 100) <= 67)
		{
			local tattoo_body = this.getSprite("tattoo_body");
			tattoo_body.setBrush("bust_orc_02_body_paint_0" + ::Math.rand(1, 3));
		}

		local injury_body = this.getSprite("injury_body");
		injury_body.Visible = false;
		injury_body.setBrush("bust_orc_02_body_injured");
	
		local head = this.getSprite("head");
		head.setBrush("bust_orc_02_head_0" + ::Math.rand(1, 3));
		head.Saturation = body.Saturation;
		head.Color = body.Color;
		
		if (::Math.rand(1, 100) <= 67)
		{
			local tattoo_head = this.getSprite("tattoo_head");
			tattoo_head.setBrush("bust_orc_02_head_paint_0" + ::Math.rand(1, 3));
		}

		local injury = this.getSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_orc_02_head_injured");
	}

	function applyOrcBerserkerSettings()
	{
		this.m.SoundPitch = 0.95;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Idle] = 1.25;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Move] = 0.75;
		this.m.DecapitateSplatterOffset = ::createVec(20, -20);
		this.m.DecapitateBloodAmount = 1.25;
		this.m.BaseProperties.DailyFood = 5;
	}
	
	function setAsOrcYoung()
	{
		local b = this.m.BaseProperties;
		b.setValues(::Const.Tactical.Actor.OrcYoung);
		b.RangedSkill += 5;
		
		local body = this.getSprite("body");
		body.setBrush("bust_orc_01_body");
		body.varySaturation(0.05);
		body.varyColor(0.07, 0.07, 0.07);
		
		local injury_body = this.getSprite("injury_body");
		injury_body.Visible = false;
		injury_body.setBrush("bust_orc_01_body_injured");
		
		local head = this.getSprite("head");
		head.setBrush("bust_orc_01_head_0" + ::Math.rand(1, 3));
		head.Saturation = body.Saturation;
		head.Color = body.Color;
		
		local injury = this.getSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_orc_01_head_injured");
		
		local body_blood = this.getSprite("body_blood");
		body_blood.setBrush("bust_orc_01_body_bloodied");
		body_blood.Visible = false;
	}

	function applyOrcYoungSettings()
	{
		this.m.SoundPitch = 1.0;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Death] = 0.9;
		this.m.SoundVolume[::Const.Sound.ActorEvent.DamageReceived] = 0.9;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Idle] = 1.25;
		this.m.DecapitateSplatterOffset = ::createVec(25, -25);
		this.m.DecapitateBloodAmount = 1.0;
		this.m.BaseProperties.DailyFood = 3;
	}

	function assignOrcBehemothEquipment()
	{
		local weapons = [
			"legend_limb_lopper",
			"legend_bough",
			"legend_man_mangler",
			"legend_skullbreaker",
		];

		// assign weapon
		this.m.Items.equip(::new("scripts/items/weapons/greenskins/" + ::MSU.Array.rand(weapons)));
		this.m.Items.equip(::new("scripts/items/legend_armor/greenskins/nggh_mod_legend_orc_behemoth_armor"));
		this.m.Items.equip(::new("scripts/items/legend_helmets/greenskins/nggh_mod_legend_orc_behemoth_helmet"));
	}

	function assignOrcEliteEquipment()
	{
		local weapons = [];

		if (::Math.rand(1, 100) <= 25)
		{
			weapons.extend([
				"greenskins/orc_axe",
				"greenskins/orc_cleaver",
			]);
		}
		else
		{
			weapons.extend([
				"greenskins/legend_skullsmasher",
				"greenskins/legend_skin_flayer",
			]);
		}

		// assign weapon
		this.m.Items.equip(::new("scripts/items/weapons/" + ::MSU.Array.rand(weapons)));
		
		// assign shield
		if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Offhand))
		{
			if (::Math.rand(1, 100) <= 2)
			{
				this.m.Items.equip(::new("scripts/items/shields/named/named_orc_heavy_shield"));
			}
			else
			{
				this.m.Items.equip(::new("scripts/items/shields/greenskins/orc_heavy_shield"));
			}
		}

		this.m.Items.equip(::new("scripts/items/legend_armor/greenskins/nggh_mod_orc_elite_heavy_armor"));
		this.m.Items.equip(::new("scripts/items/legend_helmets/greenskins/nggh_mod_orc_elite_heavy_helmet"));
	}

	function assignOrcWarlordEquipment()
	{
		local weapons = [
			"orc_axe",
			"orc_cleaver",
			"orc_axe_2h",
			"orc_axe_2h"
		];

		this.m.Items.equip(::new("scripts/items/weapons/greenskins/" + ::MSU.Array.rand(weapons)));
		this.m.Items.equip(::new("scripts/items/legend_armor/greenskins/nggh_mod_orc_warlord_armor"));
		this.m.Items.equip(::new("scripts/items/legend_helmets/greenskins/nggh_mod_orc_warlord_helmet"));
	}

	function assignOrcWarriorEquipment()
	{
		local weapons = [
			"orc_axe",
			"orc_cleaver"
		];

		this.m.Items.equip(::new("scripts/items/weapons/greenskins/" + ::MSU.Array.rand(weapons)));

		if (this.m.Items.getItemAtSlot(::Const.ItemSlot.Offhand) == null)
		{
			this.m.Items.equip(::new("scripts/items/shields/greenskins/orc_heavy_shield"));
		}

		local armors = [
			"orc_warrior_light_armor",
			"orc_warrior_medium_armor",
			"orc_warrior_heavy_armor",
			"orc_warrior_heavy_armor"
		];

		this.m.Items.equip(::new("scripts/items/legend_armor/greenskins/nggh_mod_" + ::MSU.Array.rand(armors)));
		
		local helmets = [
			"orc_warrior_light_helmet",
			"orc_warrior_medium_helmet",
			"orc_warrior_heavy_helmet"
		];

		this.m.Items.equip(::new("scripts/items/legend_helmets/greenskins/nggh_mod_" +::MSU.Array.rand(helmets)));
	}

	function assignOrcBerserkerEquipment()
	{
		local weapons = [
			"orc_axe",
			"orc_cleaver",
			"orc_flail_2h",
			"orc_axe_2h"
		];

		// assign weapon
		this.m.Items.equip(::new("scripts/items/weapons/greenskins/" + ::MSU.Array.rand(weapons)));

		local armors = [
			"orc_berserker_light_armor",
			"orc_berserker_medium_armor"
		];

		// assign armor
		this.m.Items.equip(::new("scripts/items/legend_armor/greenskins/nggh_mod_" + ::MSU.Array.rand(armors)));

		// assign helmet
		if (::Math.rand(1, 100) <= 33)
		{
			this.m.Items.equip(::new("scripts/items/legend_helmets/greenskins/nggh_mod_orc_berserker_helmet"));
		}

		if (this.Math.rand(1, 100) <= 10)
		{
			this.m.Items.addToBag(::new("scripts/items/accessory/berserker_mushrooms_item"));
		}
	}

	function assignOrcYoungEquipment()
	{
		local weapons = [];

		if (::Math.rand(1, 100) <= 25)
		{
			this.m.Items.addToBag(::new("scripts/items/weapons/greenskins/orc_javelin"));
		}

		if (::Math.rand(1, 100) <= 75)
		{
			weapons.extend([
				"greenskins/orc_axe",
				"greenskins/orc_cleaver",
				"greenskins/orc_wooden_club",
				"greenskins/orc_metal_club"
			]);
		}
		else
		{
			weapons.extend([
				"greenskins/goblin_falchion",
				"hatchet",
				"morning_star",
			]);
		}

		// assign weapon
		this.m.Items.equip(::new("scripts/items/weapons/" + ::MSU.Array.rand(weapons)));
		
		// assign shield
		if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Offhand) && ::Math.rand(1, 100) <= 50)
		{
			this.m.Items.equip(::new("scripts/items/shields/greenskins/orc_light_shield"));
		}

		local armors = [
			"orc_young_very_light_armor",
			"orc_young_light_armor",
			"orc_young_medium_armor",
			"orc_young_heavy_armor",
		];

		// assign helmet
		this.m.Items.equip(::new("scripts/items/legend_armor/greenskins/nggh_mod_" + ::MSU.Array.rand(armors)));

		local helmets = [
			"orc_young_light_helmet",
			"orc_young_medium_helmet",
			"orc_young_heavy_helmet",
		];

		// assign armor
		this.m.Items.equip(::new("scripts/items/legend_helmets/greenskins/nggh_mod_" + ::MSU.Array.rand(helmets)));
	}
	
	function assignRandomEquipment()
	{
		switch(this.getFlags().get("Type"))
		{
		case ::Const.EntityType.LegendOrcBehemoth:
			this.assignOrcBehemothEquipment();
			break;

		case ::Const.EntityType.LegendOrcElite:
			this.assignOrcEliteEquipment();
			break;

		case ::Const.EntityType.OrcWarlord:
			this.assignOrcWarlordEquipment();
			break;

		case ::Const.EntityType.OrcWarrior:
			this.assignOrcWarriorEquipment();
			break;

		case ::Const.EntityType.OrcBerserker:
			this.assignOrcBerserkerEquipment();
			break;

		default:
			this.assignOrcYoungEquipment();
		}
	}
	
	function fillModsTalentValues( _stars = 0 , _force = false )
	{
		if (this.getBackground() != null && ("Custom" in this.getBackground().m.TempData))
		{
			::Nggh_MagicConcept.TalentFiller.fillModdedTalentValues(this , this.getBackground().m.TempData.Custom.Talents , _stars , _force);
		}
	}

	function fillTalentValues( _num = null , _force = false )
	{
		local stars = 0;
		
		if (_num == null)
		{
			stars = this.Math.rand(1, 9);
		}
		else
		{
			_num = this.Math.max(1, this.Math.min(_num, 3));
			stars = this.Math.rand(_num, _num * 3);
		}
		
		this.m.Talents.resize(::Const.Attributes.COUNT, 0);
		this.fillModsTalentValues(stars, _force);
	}

	function isAbleToEquip( _item )
	{
		if (_item.isItemType(::Const.Items.ItemType.Armor))
		{
			if (this.isBehemoth())
			{
				return _item.getID() == "armor.body.legend_orc_behemoth_armor";
			}

			if (this.isWarlord())
			{
				return _item.getID() == "armor.body.orc_warlord_armor";
			}

			return ::Const.Items.NotForOrcArmorList.find(_item.getID()) == null;
		}
		else if (::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue() && _item.isItemType(::Const.Items.ItemType.Helmet))
		{
			return ::Const.Items.NotForOrcHelmetList.find(_item.getID()) == null;
		}

		return true;
	}

	function onAfterEquip( _item )
	{
		local update = false;

		if (_item.isItemType(this.Const.Items.ItemType.Armor))
		{
			this.m.IsWearingOrcArmor = ::Const.Items.NotForHumanArmorList.find(_item.getID()) != null;
			update = true;
		}
		else if (_item.isItemType(::Const.Items.ItemType.Helmet))
		{
			this.m.IsWearingOrcHelmet = ::Const.Items.NotForHumanHelmetList.find(_item.getID()) != null;
			update = true;
		}

		if (update)
		{
			this.onAdjustingArmorSprites();
		}
	}

	function canEnterBarber()
	{
		return !this.isWarlord() && !this.isBehemoth();
	}

	function getPossibleSprites( _type )
	{
		if (_type == "body")
		{
			switch(this.getFlags().get("Type"))
			{
			case ::Const.EntityType.LegendOrcElite:
			case ::Const.EntityType.OrcWarrior:
			case ::Const.EntityType.OrcBerserker:
		        return [
		        	"bust_orc_02_body",
		        	"bust_orc_03_body",
		        ];

			case ::Const.EntityType.OrcYoung:
		        return [
		        	"bust_orc_01_body",
		        ];
			}

			return [];
		}

		if (_type == "head")
		{
			switch(this.getFlags().get("Type"))
			{
			case ::Const.EntityType.LegendOrcElite:
			case ::Const.EntityType.OrcWarrior:
			case ::Const.EntityType.OrcBerserker:
		        return [
		        	"bust_orc_02_head_01",
		        	"bust_orc_02_head_02",
		        	"bust_orc_02_head_03",
		        	"bust_orc_03_head_01",
		        	"bust_orc_03_head_02",
		        	"bust_orc_03_head_03",
		        ];

			case ::Const.EntityType.OrcYoung:
		        return [
		        	"bust_orc_01_head_01",
		        	"bust_orc_01_head_02",
		        	"bust_orc_01_head_03",
		        ];
			}

			return [];
		}

		return [];
	}

});

