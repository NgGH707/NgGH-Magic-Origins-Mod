this.nggh_mod_player_goblin <- ::inherit("scripts/entity/tactical/nggh_mod_inhuman_player", {
	m = {
		Mount = null,

		// to tweak certain sprite layers
		IsWearingGoblinArmor = false,
		IsWearingGoblinHelmet = false,
		IsWearingSmallShield = false,
	},
	function isAbleToMount()
	{
		return this.getSkills().hasSkill("perk.mount_training");
	}
	
	function isMounted()
	{
		return this.m.Mount.isMounted();
	}

	function getMount()
	{
		return this.m.Mount;
	}

	function getStrengthMult()
	{
		return this.isMounted() ? this.m.Mount.getStrengthMult() : 1.0;
	}

	function create()
	{
		this.nggh_mod_inhuman_player.create();
		this.m.BloodType = ::Const.BloodType.Red;
		this.m.BloodSplatterOffset = ::createVec(-10, 15);
		this.m.DecapitateSplatterOffset = ::createVec(20, -20);
		this.m.SignaturePerks = ["QuickHands", "Pathfinder"];
		this.m.Sound[::Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/goblin_idle_03.wav",
			"sounds/enemies/goblin_idle_04.wav",
			"sounds/enemies/goblin_idle_05.wav",
		];
		this.m.Sound[::Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/goblin_hurt_00.wav",
			"sounds/enemies/goblin_hurt_01.wav",
			"sounds/enemies/goblin_hurt_02.wav",
			"sounds/enemies/goblin_hurt_03.wav",
			"sounds/enemies/goblin_hurt_04.wav",
			"sounds/enemies/goblin_hurt_05.wav",
			"sounds/enemies/goblin_hurt_06.wav",
			"sounds/enemies/goblin_hurt_07.wav",
			"sounds/enemies/goblin_hurt_08.wav",
			"sounds/enemies/goblin_hurt_09.wav",
			"sounds/enemies/goblin_hurt_10.wav",
			"sounds/enemies/goblin_hurt_11.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/goblin_idle_00.wav",
			"sounds/enemies/goblin_idle_01.wav",
			"sounds/enemies/goblin_idle_02.wav",
		];
		this.m.Sound[::Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/goblin_flee_00.wav",
			"sounds/enemies/goblin_flee_01.wav",
			"sounds/enemies/goblin_flee_02.wav",
			"sounds/enemies/goblin_flee_03.wav",
			"sounds/enemies/goblin_flee_04.wav",
			"sounds/enemies/goblin_flee_05.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/goblin_death_00.wav",
			"sounds/enemies/goblin_death_01.wav",
			"sounds/enemies/goblin_death_02.wav",
			"sounds/enemies/goblin_death_03.wav",
			"sounds/enemies/goblin_death_04.wav",
			"sounds/enemies/goblin_death_05.wav",
			"sounds/enemies/goblin_death_06.wav",
			"sounds/enemies/goblin_death_07.wav",
			"sounds/enemies/goblin_death_08.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/goblin_idle_06.wav",
			"sounds/enemies/goblin_idle_07.wav",
			"sounds/enemies/goblin_idle_08.wav",
			"sounds/enemies/goblin_idle_09.wav",
			"sounds/enemies/goblin_idle_10.wav",
			"sounds/enemies/goblin_idle_11.wav",
			"sounds/enemies/goblin_idle_12.wav",
			"sounds/enemies/goblin_idle_13.wav",
			"sounds/enemies/goblin_idle_14.wav"
		];
		this.m.SoundVolume[::Const.Sound.ActorEvent.Death] = 0.9;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Flee] = 1.0;
		this.m.SoundVolume[::Const.Sound.ActorEvent.DamageReceived] = 0.5;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Idle] = 1.15;
		this.m.SoundPitch = ::Math.rand(95, 110) * 0.01;
		this.m.Mount = ::new("scripts/mods/mount_manager");
		this.m.Mount.setActor(this);
		this.m.Mount.addExcludedMount("accessory.spider");
		this.m.Mount.addExcludedMount("accessory.tempo_spider");
		this.m.Flags.add("goblin");
	}

	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		if (this.isMounted() && ::Math.rand(1, 100) <= ::Const.ChanceToHitMount)
		{
			return this.m.Mount.onDamageReceived(_attacker, _skill, _hitInfo);
		}

		return this.nggh_mod_inhuman_player.onDamageReceived(_attacker, _skill, _hitInfo);
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
				decal.setBrush("bust_goblin_body_dead");
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
						decal.setBrush(appearance.HelmetCorpse);
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
			local decal = _tile.spawnDetail("bust_goblin_body_dead", ::Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = sprite_body.Color;
			decal.Saturation = sprite_body.Saturation;
			decal.setBrightness(0.9);
			decal.Scale = 0.95;

			if (appearance.CorpseArmor != "")
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
					decal.Color = sprite_body.Color;
					decal.Saturation = sprite_body.Saturation;
					decal.setBrightness(0.9);
					decal.Scale = 0.95;
				}

				if (appearance.HelmetCorpse != "")
				{
					decal = _tile.spawnDetail(appearance.HelmetCorpse, ::Const.Tactical.DetailFlag.Corpse, flip);
					decal.setBrightness(0.9);
					decal.Scale = 0.95;
				}
			}
			else if (_fatalityType == ::Const.FatalityType.Decapitated)
			{
				local layers = [
					sprite_head.getBrush().Name + "_dead",
					appearance.HelmetCorpse
				];
				local decap = ::Tactical.spawnHeadEffect(this.getTile(), layers, ::createVec(-50, 30), 180.0, sprite_head.getBrush().Name + "_dead_bloodpool");
				decap[0].Color = sprite_body.Color;
				decap[0].Saturation = sprite_body.Saturation;
				decap[0].setBrightness(0.9);
				decap[0].Scale = 0.95;

				if (decap.len() >= 2)
				{
					decap[1].setBrightness(0.9);
				}
			}

			if (_fatalityType == ::Const.FatalityType.Disemboweled)
			{
				local decal = _tile.spawnDetail("bust_goblin_body_dead_guts", ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.95;
			}
			else if (_skill && _skill.getProjectileType() == ::Const.ProjectileType.Arrow)
			{
				decal = _tile.spawnDetail(appearance.CorpseArmor + "_arrows", ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.95;
			}
			else if (_skill && _skill.getProjectileType() == ::Const.ProjectileType.Javelin)
			{
				decal = _tile.spawnDetail(appearance.CorpseArmor + "_javelin", ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.95;
			}

			this.spawnTerrainDropdownEffect(_tile);
			this.spawnFlies(_tile);
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

	function onUpdateInjuryLayer()
	{
		this.actor.onUpdateInjuryLayer();

		if (this.isMounted())
		{
			this.m.Mount.updateInjuryLayer();
		}
	}

	function onAfterFactionChanged()
	{
		local flip = !this.isAlliedWithPlayer();
		this.getSprite("background").setHorizontalFlipping(flip);
		this.getSprite("quiver").setHorizontalFlipping(!flip);
		this.getSprite("body").setHorizontalFlipping(!flip);
		this.getSprite("injury_body").setHorizontalFlipping(!flip);
		this.getSprite("shaft").setHorizontalFlipping(flip);
		this.getSprite("head").setHorizontalFlipping(!flip);
		this.getSprite("injury").setHorizontalFlipping(!flip);
		this.getSprite("body_blood").setHorizontalFlipping(flip);
		this.getSprite("accessory").setHorizontalFlipping(flip);
		this.getSprite("accessory_special").setHorizontalFlipping(flip);

		foreach( a in ::Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.getSprite(a).setHorizontalFlipping(a == "helmet" && this.m.IsWearingGoblinHelmet ? !flip : flip);
		}
	
		this.getSprite("armor").setHorizontalFlipping(this.m.IsWearingGoblinArmor ? !flip : flip);
		this.getSprite("armor_layer_chain").setHorizontalFlipping(flip);
		this.getSprite("armor_layer_plate").setHorizontalFlipping(flip);
		this.getSprite("armor_layer_tabbard").setHorizontalFlipping(flip);
		this.getSprite("armor_layer_cloak").setHorizontalFlipping(flip);
		this.getSprite("armor_upgrade_back").setHorizontalFlipping(flip);
		this.getSprite("armor_upgrade_front").setHorizontalFlipping(flip);
	}

	function onInit()
	{
		this.nggh_mod_inhuman_player.onInit();
		local b = this.m.BaseProperties;
		b.IsFleetfooted = true;
		b.DamageDirectMult = 1.25;

		this.m.ActionPoints = b.ActionPoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = ::Const.DefaultMovementAPCost;
		this.m.FatigueCosts = ::Const.DefaultMovementFatigueCost;
		this.m.Items.getAppearance().Body = "bust_goblin_01_body";

		::Const.CharmedUtilities.removeAllHumanSprites(this, null, true);
		this.removeSprite("body");
		this.addSprite("miniboss");

		//mount sprites
		this.addSprite("mount_extra1"); //spider legs_back
		this.addSprite("mount_extra2"); //spider body

		local quiver = this.addSprite("quiver");
		quiver.Visible = false;
		
		local body = this.addSprite("body");
		body.setBrush("bust_goblin_01_body");

		local injury_body = this.addSprite("injury_body");
		injury_body.Visible = false;
		injury_body.setBrush("bust_goblin_01_body_injured");

		this.addSprite("armor");
		this.addSprite("armor_layer_chain");
		this.addSprite("armor_layer_plate");
		this.addSprite("armor_layer_tabbard");
		this.addSprite("surcoat");
		this.addSprite("armor_layer_cloak");
		this.addSprite("armor_upgrade_back");
		this.addSprite("shaft");
		
		local accessory = this.addSprite("accessory");
		accessory.Scale = 0.85;
		local accessoryS = this.addSprite("accessory_special");
		accessoryS.Scale = 0.85;
		
		this.addSprite("head");
		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_goblin_01_head_injured");
		
		foreach( a in ::Const.CharacterSprites.Helmets )
		{
			this.addSprite(a);
		}

		this.addSprite("armor_upgrade_front");

		local body_blood = this.addSprite("body_blood");
		body_blood.Visible = false;
		local shield_icon = this.addSprite("shield_icon");
		shield_icon.Visible = false;
		
		//mount sprites
		this.addSprite("mount");
		this.addSprite("mount_armor");
		this.addSprite("mount_head");
		this.addSprite("mount_extra");
		this.addSprite("mount_injury");
		this.addSprite("mount_restrain");
		
		this.addSprite("dirt");
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.47;
		this.setSpriteOffset("status_rooted", ::createVec(0, -5));

		// racial penalty
		this.m.Skills.add(::new("scripts/skills/special/nggh_mod_goblin_armor_penalty"));

		// skill that support the goblin mounting system
		local rider = ::new("scripts/skills/special/nggh_mod_goblin_rider");
		rider.setManager(this.m.Mount);
		this.m.Mount.setRiderSkill(rider);
		this.m.Skills.add(rider);
	}
	
	function onAfterInit()
	{
		this.nggh_mod_inhuman_player.onAfterInit();

		if (::Is_PTR_Exist)
		{
			local racial = ::new("scripts/skills/racial/ptr_goblin_racial");
			racial.m.IsSerialized = false;
			this.getSkills().add(racial);
		}
	}

	function addDefaultStatusSprites()
	{
		local hex = this.addSprite("status_hex");
		hex.Visible = false;
		local sweat = this.addSprite("status_sweat");
		local stunned = this.addSprite("status_stunned");
		stunned.setBrush(this.Const.Combat.StunnedBrush);
		stunned.Visible = false;
		local arms_icon = this.addSprite("arms_icon");
		arms_icon.Visible = false;
		local rooted = this.addSprite("status_rooted");
		rooted.Visible = false;
		rooted.Scale = this.getSprite("status_rooted_back").Scale;
		local morale = this.addSprite("morale");
		morale.Visible = false;
	}
	
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		_appearance.Quiver = "bust_goblin_quiver";
		this.nggh_mod_inhuman_player.onAppearanceChanged(_appearance, _setDirty);
		this.m.Mount.updateAppearance();
		local offset;
		
		if (this.isMounted())
		{
		    offset = ::createVec(::Const.GoblinRiderMounts[this.m.Mount.getMountType()].Sprite[0][0], ::Const.GoblinRiderMounts[this.m.Mount.getMountType()].Sprite[0][1]);
		}
		else
		{
			offset = ::createVec(0, 0);
		}
		
		this.setSpriteOffset("background", offset);
		this.setSpriteOffset("quiver", offset);
		this.setSpriteOffset("body", offset);
		this.setSpriteOffset("shaft", offset);
		this.setSpriteOffset("head", offset);
		this.setSpriteOffset("injury", offset);
		this.setSpriteOffset("accessory", offset);
		this.setSpriteOffset("accessory_special", offset);
		this.setSpriteOffset("body_blood", offset);
		
		foreach( h in ::Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(h))
			{
				continue;
			}
			
			this.setSpriteOffset(h, offset);
			this.getSprite(h).Scale = 0.85;

			if (h == "helmet")
			{
				this.getSprite(h).Scale = !this.m.IsWearingGoblinHelmet ? 0.85 : 1.0;
			}
		}
		
		foreach( a in ::Const.CharmedUtilities.Armor )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.setSpriteOffset(a, offset);
			this.getSprite(a).Scale = 0.85;

			if (a == "armor")
			{
				this.getSprite(a).Scale = !this.m.IsWearingGoblinArmor ? 0.85 : 1.0;
			}
		}

		this.setSpriteOffset("shield_icon", offset);
		this.getSprite("shield_icon").Scale = this.m.IsWearingSmallShield ? 0.85 : 1.0;
		this.setSpriteOffset("arms_icon", offset);
		this.setAlwaysApplySpriteOffset(true);
	}

	function onAdjustingArmorSprites()
	{
		local flip = this.isAlliedWithPlayer();
		this.getSprite("armor").setHorizontalFlipping(this.m.IsWearingGoblinArmor ? flip : !flip);
		this.getSprite("helmet").setHorizontalFlipping(this.m.IsWearingGoblinHelmet ? flip : !flip);
	}

	function resetRenderEffects()
	{
		this.nggh_mod_inhuman_player.resetRenderEffects();

		if (this.isMounted())
		{
		    local offset = ::createVec(::Const.GoblinRiderMounts[this.m.Mount.getMountType()].Sprite[0][0], ::Const.GoblinRiderMounts[this.m.Mount.getMountType()].Sprite[0][1]);
			this.setSpriteOffset("shield_icon", offset);
			this.setSpriteOffset("arms_icon", offset);
		}
	}

	function getTooltip( _targetedWithSkill = null )
	{
		local tooltip = this.nggh_mod_inhuman_player.getTooltip(_targetedWithSkill);

		// insert additional stat bars to the tooltip
		if (this.isMounted())
		{
			local find;
			foreach (i, t in tooltip)
			{
				if (t.id == 3 && t.type == "progressbar")
				{
					find = i;
					break;
				}
			}

			if (find != null)
			{
				local toAdd = [];
				toAdd.push({
					id = 3,
					type = "text",
					text = "[u][size=14]Mount[/size][/u]"
				});
				toAdd.extend(this.m.Mount.getMountTooltip());
				toAdd.push({
					id = 3,
					type = "text",
					text = "[u][size=14]Rider[/size][/u]"
				});

				foreach(i, t in toAdd)
				{
					tooltip.insert(find + i, t);
				}
			}
		}

		return tooltip;
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

		this.getBackground().addPerk(::Const.Perks.PerkDefs.BoondockBlade, 0);

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

		if (_variant >= 0 && _variant < ::Const.Goblin.Variants.len())
		{
			type = ::Const.Goblin.Variants[_variant];
		}
		else if (_pickRandom)
		{
			type = ::MSU.Class.WeightedContainer(::Const.Goblin.VariantRolls).roll();
		}
		else
		{
			type = ::Const.Goblin.Variants[0]
		}

		local body = this.getSprite("body");
		body.varySaturation(0.1);
		body.varyColor(0.07, 0.07, 0.09);

		switch(type)
		{
		case ::Const.EntityType.GoblinShaman:
			this.setAsGoblinShaman();
			break;

		case ::Const.EntityType.GoblinLeader:
			this.setAsGoblinLeader();
			break;

		case ::Const.EntityType.GoblinWolfrider:
			this.setAsGoblinWolfrider();
			break;

		case ::Const.EntityType.GoblinAmbusher:
			this.setAsGoblinAmbusher();
			break;

		default:
			this.setAsGoblinFighter();
		}

		// update the properties
		this.m.CurrentProperties = clone this.m.BaseProperties;
		this.addDefaultBackground(type);

		if (type == ::Const.EntityType.GoblinWolfrider)
		{ 
			::World.Assets.getOrigin().addScenarioPerk(this.getBackground(), ::Const.Perks.PerkDefs.NggHGoblinMountTraining, 2);
		}
		
		if (_addUniqueTrait)
		{
			//this.m.Skills.add(::new("scripts/traits/nggh_mod_born_to_hunt_trait"));
		}

		this.setScenarioValues(type, _isElite);
		this.assignRandomEquipment();
	}
	
	function setAsGoblinShaman()
	{
		local b = this.m.BaseProperties;
		b.setValues(::Const.Tactical.Actor.GoblinShaman);
		b.Vision = 8;
		
		local head = this.getSprite("head");
		head.setBrush("bust_goblin_02_head_01");
		head.Saturation = this.getSprite("body").Saturation;
		head.Color = this.getSprite("body").Color;
	}
	
	function setAsGoblinLeader()
	{
		local b = this.m.BaseProperties;
		b.setValues(::Const.Tactical.Actor.GoblinLeader);
		b.DamageDirectMult = 1.1;
		
		local head = this.getSprite("head");
		head.setBrush("bust_goblin_03_head_01");
		head.Saturation = this.getSprite("body").Saturation;
		head.Color = this.getSprite("body").Color;
	}

	function setAsGoblinWolfrider()
	{
		local b = this.m.BaseProperties;
		b.setValues(::Const.Tactical.Actor.GoblinWolfrider);
		
		local head = this.getSprite("head");
		head.setBrush("bust_goblin_01_head_0" + ::Math.rand(1, 3));
		head.Saturation = this.getSprite("body").Saturation;
		head.Color = this.getSprite("body").Color;
	}
	
	function setAsGoblinAmbusher()
	{
		local b = this.m.BaseProperties;
		b.setValues(::Const.Tactical.Actor.GoblinAmbusher);
		
		local head = this.getSprite("head");
		head.setBrush("bust_goblin_01_head_0" + ::Math.rand(1, 3));
		head.Saturation = this.getSprite("body").Saturation;
		head.Color = this.getSprite("body").Color;
	}
	
	function setAsGoblinFighter()
	{
		local b = this.m.BaseProperties;
		b.setValues(::Const.Tactical.Actor.GoblinFighter);
		
		local head = this.getSprite("head");
		head.setBrush("bust_goblin_01_head_0" + ::Math.rand(1, 3));
		head.Saturation = this.getSprite("body").Saturation;
		head.Color = this.getSprite("body").Color;
	}

	function assignGoblinShamanEquipment()
	{
		this.m.Items.equip(::new("scripts/items/weapons/greenskins/goblin_staff"));

		if (::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
		{
			this.m.Items.equip(::new("scripts/items/armor/greenskins/goblin_shaman_armor"));
			this.m.Items.equip(::new("scripts/items/helmets/greenskins/goblin_shaman_helmet"));
		}
		else 
		{
		    this.m.Items.equip(::new("scripts/items/legend_armor/greenskins/nggh_mod_goblin_shaman_armor"));
			this.m.Items.equip(::new("scripts/items/legend_helmets/greenskins/nggh_mod_goblin_shaman_helmet"));
		}

		// a shaman after all, so they should have stuffs a shaman or witch doctor should have
		// a random potion
		this.m.Items.addToBag(::new("scripts/items/" + ::MSU.Array.rand([
			"accessory/night_vision_elixir_item",
			"accessory/night_vision_elixir_item",
			"accessory/lionheart_potion_item",
			"accessory/recovery_potion_item",
			"accessory/cat_potion_item",
			"tools/acid_flask_item",
		])));

		// a random first aid item
		this.m.Items.addToBag(::new("scripts/items/" + ::MSU.Array.rand([
			"accessory/antidote_item",
			"accessory/bandage_item",
		])));
	}

	function assignGoblinLeaderEquipment()
	{
		this.m.Items.equip(::new("scripts/items/ammo/quiver_of_bolts"));
		this.m.Items.equip(::new("scripts/items/weapons/greenskins/goblin_crossbow"));
		this.m.Items.addToBag(::new("scripts/items/weapons/greenskins/goblin_falchion"));
		
		if (::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
		{
			this.m.Items.equip(::new("scripts/items/armor/greenskins/goblin_leader_armor"));
			this.m.Items.equip(::new("scripts/items/helmets/greenskins/goblin_leader_helmet"));
		}
		else 
		{
		    this.m.Items.equip(::new("scripts/items/legend_armor/greenskins/nggh_mod_goblin_leader_armor"));
			this.m.Items.equip(::new("scripts/items/legend_helmets/greenskins/nggh_mod_goblin_leader_helmet"));
		}
	}

	function assignGoblinWolfriderEquipment()
	{
		local weapons = [
			"goblin_spear",
			"goblin_falchion"
		];
		::MSU.Array.shuffle(weapons);
		this.m.Items.equip(::new("scripts/items/weapons/greenskins/" + weapons[0]));
		this.m.Items.addToBag(::new("scripts/items/weapons/greenskins/" + weapons[1]));
		this.m.Items.addToBag(::new("scripts/items/weapons/greenskins/goblin_spiked_balls"));

		if (this.m.Items.getItemAtSlot(::Const.ItemSlot.Offhand) == null)
		{
			this.m.Items.equip(::new("scripts/items/" + ::MSU.Array.rand([
				"shields/greenskins/goblin_light_shield",
				"shields/greenskins/goblin_heavy_shield"
			])));
		}

		if (::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
		{
			this.m.Items.equip(::new("scripts/items/armor/greenskins/" + ::MSU.Array.rand([
				"goblin_medium_armor",
				"goblin_heavy_armor"
			])));
			
			if (::Math.rand(1, 100) <= 50)
			{
				local h = ::new("scripts/items/helmets/greenskins/goblin_light_helmet");
				h.m.Variant = 1;
				h.updateVariant();
				this.m.Items.equip(h);
			}
			else
			{
				this.m.Items.equip(::new("scripts/items/helmets/greenskins/goblin_heavy_helmet"));
			}
		}
		else 
		{
			this.m.Items.equip(::new("scripts/items/legend_armor/greenskins/nggh_mod_" + ::MSU.Array.rand([
				"goblin_medium_armor",
				"goblin_heavy_armor"
			])));

			if (::Math.rand(1, 100) <= 50)
			{
				local h = ::new("scripts/items/legend_helmets/greenskins/nggh_mod_goblin_light_helmet");
				h.m.Variant = 1;
				h.updateVariant();
				this.m.Items.equip(h);
			}
			else
			{
				this.m.Items.equip(::new("scripts/items/legend_helmets/greenskins/nggh_mod_goblin_heavy_helmet"));
			} 
		}

		// here is the mount, very good boi OwO too :head_pet:
		this.getItems().equip(::new("scripts/items/accessory/wolf_item"));
	}

	function assignGoblinAmbusherEquipment()
	{
		this.m.Items.equip(::new("scripts/items/weapons/greenskins/" + ::MSU.Array.rand([
			"goblin_bow",
			"goblin_heavy_bow"
		])));
		this.m.Items.equip(::new("scripts/items/ammo/quiver_of_arrows"));
		this.m.Items.addToBag(::new("scripts/items/weapons/greenskins/goblin_notched_blade"));

		if (::Math.rand(1, 100) <= 40)
		{
			this.m.Items.addToBag(::new("scripts/items/accessory/poison_item"));
		}

		if (::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
		{
			this.m.Items.equip(::new("scripts/items/armor/greenskins/goblin_skirmisher_armor"));
			this.m.Items.equip(::new("scripts/items/helmets/greenskins/goblin_skirmisher_helmet"));
		}
		else
		{
			this.m.Items.equip(::new("scripts/items/legend_armor/greenskins/nggh_mod_goblin_skirmisher_armor"));
			this.m.Items.equip(::new("scripts/items/legend_helmets/greenskins/nggh_mod_goblin_skirmisher_helmet"));
		}
	}

	function assignGoblinFighterEquipment()
	{
		this.m.Items.equip(::new("scripts/items/weapons/" + ::MSU.Array.rand([
			"greenskins/goblin_falchion",
			"greenskins/goblin_spear",
			"greenskins/goblin_pike"
			"legend_chain"
		])));

		// pick side arm
		if (this.m.Items.getItemAtSlot(::Const.ItemSlot.Mainhand).getID() == "weapon.goblin_falchion")
		{
			this.m.Items.addToBag(::new("scripts/items/weapons/greenskins/goblin_spiked_balls"));
		}
		else
		{
			this.m.Items.addToBag(::new("scripts/items/weapons/greenskins/goblin_notched_blade"));
		}

		if (this.m.Items.getItemAtSlot(::Const.ItemSlot.Offhand) == null)
		{
			if (::Math.rand(1, 100) <= 50)
			{
				// a bit bias for net thrower
				::World.Assets.getOrigin().addScenarioPerk(this.getBackground(), ::Const.Perks.PerkDefs.LegendNetRepair, 1);
				this.m.Items.equip(::new("scripts/items/tools/throwing_net"));
			}
			else
			{
				this.m.Items.equip(::new("scripts/items/" + ::MSU.Array.rand([
					"shields/greenskins/goblin_light_shield",
					"shields/greenskins/goblin_heavy_shield"
				])));
			}
		}

		if (::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
		{
			this.m.Items.equip(::new("scripts/items/armor/greenskins/" + ::MSU.Array.rand([
				"goblin_medium_armor",
				"goblin_heavy_armor"
			])));
			
			if (::Math.rand(1, 100) <= 50)
			{
				local h = ::new("scripts/items/helmets/greenskins/goblin_light_helmet");
				h.m.Variant = 1;
				h.updateVariant();
				this.m.Items.equip(h);
			}
			else
			{
				this.m.Items.equip(::new("scripts/items/helmets/greenskins/goblin_heavy_helmet"));
			}
		}
		else 
		{
			this.m.Items.equip(::new("scripts/items/legend_armor/greenskins/nggh_mod_" + ::MSU.Array.rand([
				"goblin_medium_armor",
				"goblin_heavy_armor"
			])));

			if (::Math.rand(1, 100) <= 50)
			{
				local h = ::new("scripts/items/legend_helmets/greenskins/nggh_mod_goblin_light_helmet");
				h.m.Variant = 1;
				h.updateVariant();
				this.m.Items.equip(h);
			}
			else
			{
				this.m.Items.equip(::new("scripts/items/legend_helmets/greenskins/nggh_mod_goblin_heavy_helmet"));
			} 
		}
	}

	function assignRandomEquipment()
	{
		switch(this.getFlags().get("Type"))
		{
		case ::Const.EntityType.GoblinShaman:
			this.assignGoblinShamanEquipment();
			break;

		case ::Const.EntityType.GoblinLeader:
			this.assignGoblinLeaderEquipment();
			break;

		case ::Const.EntityType.GoblinWolfrider:
			this.assignGoblinWolfriderEquipment();
			break;

		case ::Const.EntityType.GoblinAmbusher:
			this.assignGoblinAmbusherEquipment();
			break;

		default:
			this.assignGoblinFighterEquipment();
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
			return ::Const.Items.NotForGoblinArmorList.find(_item.getID()) == null;
		}
		else if (_item.isItemType(::Const.Items.ItemType.Helmet))
		{
			return ::Const.Items.NotForGoblinHelmetList.find(_item.getID()) == null;
		}

		return true;
	}

	function onAfterEquip( _item )
	{
		local update = false;

		if (_item.isItemType(::Const.Items.ItemType.Helmet))
		{
			this.m.IsWearingGoblinHelmet = [
				"armor.head.goblin_heavy_helmet",
				"armor.head.goblin_leader_helmet",
				"armor.head.goblin_light_helmet",
				"armor.head.goblin_shaman_helmet",
				"armor.head.goblin_skirmisher_helmet",
			].find(_item.getID()) != null;
			update = true;
		}
		else if (_item.isItemType(::Const.Items.ItemType.Armor))
		{
			this.m.IsWearingGoblinArmor = [
				"armor.body.goblin_heavy_armor",
				"armor.body.goblin_leader_armor",
				"armor.body.goblin_light_armor",
				"armor.body.goblin_medium_armor",
				"armor.body.goblin_shaman_armor",
				"armor.body.goblin_skirmisher_armor",
			].find(_item.getID()) != null;
			update = true;
		}
		else if (_item.isItemType(::Const.Items.ItemType.Shield))
		{
			this.m.IsWearingSmallShield = [
				"shield.goblin_heavy_shield",
				"shield.goblin_light_shield",
				"shield.buckler",
				"shield.auxiliary_shield",
			].find(_item.getID()) != null;
		}
		else if (_item.getSlotType() == ::Const.ItemSlot.Accessory)
		{
			this.m.Mount.onAccessoryEquip(_item);
		}

		if (update)
		{
			this.onAdjustingArmorSprites();
		}
	}

	function onAfterUnequip( _item )
	{
		if (_item.getSlotType() == ::Const.ItemSlot.Accessory)
		{
			this.m.Mount.onAccessoryUnequip();
		}
		else if (_item.isItemType(::Const.Items.ItemType.Helmet))
		{
			this.m.IsWearingGoblinHelmet = false;
		}
		else if (_item.isItemType(::Const.Items.ItemType.Armor))
		{
			this.m.IsWearingGoblinArmor = false;
		}
	}

	function getPossibleSprites( _type )
	{
		switch (_type) 
		{
	    case "body":
	        return [
	        	"bust_goblin_01_body",
	        ];

	    case "head":
	        return [
	        	"bust_goblin_01_head_01",
	        	"bust_goblin_01_head_02",
	        	"bust_goblin_01_head_03",
	        	"bust_goblin_02_head_01",
	        	"bust_goblin_03_head_01",
	        ];
		}

		return [];
	}

	function updateVariant()
	{
		local b = this.m.BaseProperties;

		switch(this.getFlags().get("Type"))
		{
		case ::Const.EntityType.GoblinShaman:
			b.IsAffectedByNight = false;
			b.TargetAttractionMult = 1.5;
			break;

		case ::Const.EntityType.GoblinAmbusher:
			b.TargetAttractionMult = 1.15;
			break;

		case ::Const.EntityType.GoblinLeader:
			b.TargetAttractionMult = 1.1;
			break;
		}
	}

});

