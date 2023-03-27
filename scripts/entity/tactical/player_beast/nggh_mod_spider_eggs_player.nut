this.nggh_mod_spider_eggs_player <- ::inherit("scripts/entity/tactical/nggh_mod_player_beast", {
	m = {
		DistortTargetA = null,
		DistortTargetPrevA = ::createVec(0, 0),
		DistortTargetHelmet = null,
		DistortTargetPrevHelmet = ::createVec(0, 0),
		DistortAnimationStartTimeA = 0,

		IsFlipping = false,
		HelmetOffset = [0, 0],
		BodyOffset = [0, 0]

		Mount = null,
		Mode = null,
		Size = 1.0,
		Count = 0,
		Head = 0,
	},
	function setMode( _m )
	{
		if (_m == null)
		{
			this.m.Mode = null;
		}
		else if (typeof _m == "instance")
		{
			this.m.Mode = _m;
		}
		else 
		{
			this.m.Mode = ::WeakTableRef(_m);			    
		}
	}

	function getMode()
	{
		return this.m.Mode;
	}

	function isNonCombatant()
	{
		if (this.isMounted())
		{
			return false;
		}

		return this.m.IsNonCombatant;
	}

	function isAbleToMount()
	{
		return this.getSkills().hasSkill("perk.attach_egg");
	}

	function isMounted()
	{
		return this.m.Mount.isMounted();
	}

	function getMount()
	{
		return this.m.Mount;
	}

	function getSize()
	{
		return this.m.Size;
	}

	function setSize( _s )
	{
		this.m.Size = _s;
		this.getSprite("body").Scale = _s;
		//this.getItems().updateAppearance();
	}

	function getStrengthMult()
	{
		return this.isMounted() ? 1.5 : 1.25;
	}

	function getHitpointsPerVeteranLevel()
	{
		return ::Math.rand(1, 4) != 3 ? ::Math.rand(1, 2) : 3;
	}

	function create()
	{
		this.nggh_mod_player_beast.create();
		this.m.BloodType = ::Const.BloodType.None;
		this.m.MoraleState = ::Const.MoraleState.Ignore;
		this.m.BloodSplatterOffset = ::createVec(0, 0);
		this.m.AttributesLevelUp = ::Const.Nggh_AttributesLevelUp.SpiderEggs;
		this.m.ExcludedTraits = ::Const.Nggh_ExcludedTraits.SpiderEggs;
		this.m.BonusHealthRecoverMult = 0.25;
		this.m.IsNonCombatant = true;
		this.m.AttributesMax = {
			Hitpoints = 500,
			Bravery = 200,
			Fatigue = 200,
			Initiative = 100,
			MeleeSkill = 50,
			RangedSkill = 50,
			MeleeDefense = 50,
			RangedDefense = 50,
		};
		this.m.Sound[::Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/dlc2/giant_spider_idle_01.wav",
			"sounds/enemies/dlc2/giant_spider_idle_02.wav",
			"sounds/enemies/dlc2/giant_spider_idle_03.wav",
			"sounds/enemies/dlc2/giant_spider_idle_04.wav",
			"sounds/enemies/dlc2/giant_spider_idle_05.wav",
		];
		this.m.Sound[::Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/dlc2/giant_spider_idle_01.wav",
			"sounds/enemies/dlc2/giant_spider_idle_02.wav",
			"sounds/enemies/dlc2/giant_spider_idle_03.wav",
			"sounds/enemies/dlc2/giant_spider_idle_04.wav",
			"sounds/enemies/dlc2/giant_spider_idle_05.wav",
		];
		this.m.Sound[::Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/dlc2/giant_spider_egg_spawn_01.wav",
			"sounds/enemies/dlc2/giant_spider_egg_spawn_02.wav",
			"sounds/enemies/dlc2/giant_spider_egg_spawn_03.wav",
			"sounds/enemies/dlc2/giant_spider_egg_spawn_04.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/dlc2/giant_spider_idle_01.wav",
			"sounds/enemies/dlc2/giant_spider_idle_02.wav",
			"sounds/enemies/dlc2/giant_spider_idle_03.wav",
			"sounds/enemies/dlc2/giant_spider_idle_04.wav",
			"sounds/enemies/dlc2/giant_spider_idle_05.wav",
			"sounds/enemies/dlc2/giant_spider_idle_06.wav",
			"sounds/enemies/dlc2/giant_spider_idle_07.wav",
			"sounds/enemies/dlc2/giant_spider_idle_08.wav",
			"sounds/enemies/dlc2/giant_spider_idle_09.wav",
			"sounds/enemies/dlc2/giant_spider_idle_10.wav",
			"sounds/enemies/dlc2/giant_spider_idle_11.wav",
			"sounds/enemies/dlc2/giant_spider_idle_12.wav",
			"sounds/enemies/dlc2/giant_spider_idle_13.wav",
			"sounds/enemies/dlc2/giant_spider_idle_14.wav",
			"sounds/enemies/dlc2/giant_spider_idle_15.wav",
			"sounds/enemies/dlc2/giant_spider_idle_16.wav"
		];
		this.m.SoundVolume[::Const.Sound.ActorEvent.Idle] = 2.0;
		this.m.SoundPitch = ::Math.rand(95, 105) * 0.01;
		this.m.AIAgent = ::new("scripts/ai/tactical/nggh_mod_spider_egg_player_agent");
		this.m.AIAgent.setActor(this);
		this.m.Mount = ::new("scripts/mods/mount_manager");
		this.m.Mount.setActor(this);
		this.m.Flags.add("regen_armor");
		this.m.Flags.add("egg");

		// can't equip most things
		local items = this.getItems(); 
		items.getData()[::Const.ItemSlot.Offhand][0] = -1;
		items.getData()[::Const.ItemSlot.Mainhand][0] = -1;
		items.getData()[::Const.ItemSlot.Body][0] = -1;
		items.getData()[::Const.ItemSlot.Ammo][0] = -1;

		// set up a new shake layers
		this.m.ShakeLayers = [];
		for (local i = 0; i < 3; ++i)
		{
			this.m.ShakeLayers.push([
				"body",
				"helmet_vanity_lower",
				"helmet_vanity_lower_2",
				"helmet",
				"helmet_damage",
				"helmet_helm",
				"helmet_top",
				"helmet_vanity",
				"helmet_vanity_2",
			]);
		}
	}

	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		if (this.isMounted() && ::Math.rand(1, 100) <= ::Const.ChanceToHitMount)
		{
			return this.m.Mount.onDamageReceived(_attacker, _skill, _hitInfo);
		}

		_hitInfo.BodyPart = ::Const.BodyPart.Body;
		return this.nggh_mod_player_beast.onDamageReceived(_attacker, _skill, _hitInfo);
	}

	function isReallyKilled( _fatalityType )
	{
		// so salvation for thee
		return true;
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (!::Tactical.State.isScenarioMode() && _killer != null && _killer.isPlayerControlled())
		{
			::updateAchievement("ScrambledEggs", 1, 1);
		}

		this.nggh_mod_player_beast.onDeath(_killer, _skill, _tile, _fatalityType);

		if (_tile != null)
		{
			_tile.spawnDetail("nest_01_dead", ::Const.Tactical.DetailFlag.Corpse, this.m.IsCorpseFlipped);

			this.spawnTerrainDropdownEffect(_tile);
			this.spawnFlies(_tile);
			local corpse = clone ::Const.Corpse;
			corpse.CorpseName = this.getName();
			corpse.IsResurrectable = false;
			corpse.IsConsumable = false;
			corpse.IsHeadAttached = false;
			corpse.Items = _fatalityType != ::Const.FatalityType.Unconscious ? this.getItems() : null;
			corpse.Tile = _tile;
			corpse.Value = 10.0;
			corpse.IsPlayer = true;
			_tile.Properties.set("Corpse", corpse);
			::Tactical.Entities.addCorpse(_tile);
		}
	}

	function onUpdateInjuryLayer()
	{
		this.actor.onUpdateInjuryLayer();

		if (this.isMounted())
		{
			this.m.Mount.updateInjuryLayer();
		}
	}

	function onBeforeCombatStarted()
	{
		this.m.Count = 0;
		this.setRenderCallbackEnabled(true);
	}

	/*
	function onCombatStart()
	{
		this.nggh_mod_player_beast.onCombatStart();
	}
	*/

	function onCombatFinished()
	{
		this.m.Count = 0;
		this.m.DistortTargetA = null;
		this.m.DistortTargetPrevA = ::createVec(0, 0);
		this.m.DistortTargetHelmet = null;
		this.m.DistortTargetPrevHelmet = ::createVec(0, 0);
		this.m.DistortAnimationStartTimeA = 0;
		this.m.IsFlipping = false;
		this.setRenderCallbackEnabled(false);
		this.nggh_mod_player_beast.onCombatFinished();
	}

	function onAfterFactionChanged()
	{
		local flip = this.isAlliedWithPlayer();
		//this.m.IsFlipping = !flip;
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("accessory").setHorizontalFlipping(!flip);
		this.getSprite("accessory_special").setHorizontalFlipping(!flip);

		this.nggh_mod_player_beast.onAfterFactionChanged();
	}

	function onInit()
	{
		this.nggh_mod_player_beast.onInit();
		local b = this.m.BaseProperties;
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToDaze = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToRoot = true;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToDisarm = true;
		b.IsImmuneToOverwhelm = true;
		//b.IsImmuneToZoneOfControl = true;
		//b.IsImmuneToSurrounding = true;
		//b.IsImmuneToDamageReflection = true;
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsRooted = true;
		b.MoraleCheckBraveryMult[::Const.MoraleCheckType.MentalAttack] = 10000.0;
		b.DamageReceivedTotalMult = 0.9;
		b.DailyFood = 0;
		
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = ::Const.DefaultMovementAPCost;
		this.m.FatigueCosts = ::Const.DefaultMovementFatigueCost;

		this.removeSprite("body");
		
		//mount sprites
		this.addSprite("mount_extra1"); //spider legs_back
		this.addSprite("mount_extra2"); //spider body

		local body = this.addSprite("body");
		body.setBrush("nest_01");

		this.addSprite("accessory");
		this.addSprite("accessory_special");

		foreach( a in ::Const.CharacterSprites.Helmets )
		{
			this.addSprite(a);
		}

		//mount sprites
		this.addSprite("mount"); //spider legs_front
		this.addSprite("mount_armor");
		this.addSprite("mount_head"); //spider head
		this.addSprite("mount_extra");
		this.addSprite("mount_injury");
		this.addSprite("mount_restrain");
		this.addDefaultStatusSprites();
		
		local rider = ::new("scripts/skills/eggs/nggh_mod_egg_rider");
		rider.setManager(this.m.Mount);
		this.m.Mount.setRiderSkill(rider);
		this.m.Skills.add(rider);

		local mode = ::new("scripts/skills/eggs/nggh_mod_auto_mode_spawned_spider");
		this.setMode(mode);
		this.m.Skills.add(mode);

		this.m.Skills.add(::new("scripts/skills/racial/skeleton_racial"));
		this.m.Skills.add(::new("scripts/skills/eggs/nggh_mod_add_egg"));
		this.m.Skills.add(::new("scripts/skills/eggs/nggh_mod_spawn_spider"));
		this.m.Skills.add(::new("scripts/skills/eggs/nggh_mod_spawn_more_spiders"));
	}

	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.nggh_mod_player_beast.onAppearanceChanged(_appearance, _setDirty);
		this.m.Mount.updateAppearance();
		this.onAdjustingSprite(_appearance, this.isMounted());
	}
	
	function onAdjustingSprite( _appearance , _isMounted = false )
	{
		// modifier the size
		local mount_type = this.getMount().getMountType();
		local size = !_isMounted ? 1.0 : (mount_type == ::Const.GoblinRider.Mounts.Spider ? 0.65 : 0.75);
		this.setSize(size);

		local offset = ::Const.EggSpriteOffsets[this.m.Head];
		local adjust_x = !_isMounted ? 0 : ::Const.GoblinRiderMounts[mount_type].Sprite[0][0];
		local adjust_y = !_isMounted ? 0 : ::Const.GoblinRiderMounts[mount_type].Sprite[0][1];
		local x = offset[0];
		local y = offset[1];

		this.m.HelmetOffset = [x + adjust_x, y + adjust_y];
		this.m.BodyOffset = [adjust_x, adjust_y];

		local v = ::createVec(this.m.HelmetOffset[0] * this.m.Size, this.m.HelmetOffset[1] * this.m.Size);
		foreach( a in ::Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.setSpriteOffset(a, v);
			this.getSprite(a).Scale = 0.85 * this.m.Size;
		}

		v = ::createVec(this.m.BodyOffset[0] * this.m.Size, this.m.BodyOffset[1] * this.m.Size);
		this.setSpriteOffset("body", v);
		this.getSprite("accessory").Scale = 0.7 * this.m.Size;
		this.setSpriteOffset("accessory", v);
		this.getSprite("accessory_special").Scale = 0.7 * this.m.Size;
		this.setSpriteOffset("accessory_special", v);
		this.setAlwaysApplySpriteOffset(true);
		this.setDirty(true);
	}

	function getTooltip( _targetedWithSkill = null )
	{
		local tooltip = this.nggh_mod_player_beast.getTooltip(_targetedWithSkill);

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

	function setStartValuesEx( _isElite = false, _parameter_1 = null , _parameter_2 = null, _parameter_3 = null )
	{
		local b = this.m.BaseProperties;
		b.setValues(::Const.Tactical.Actor.SpiderEggs);
		b.FatigueRecoveryRate = 10;
		b.ActionPoints = 9;
		b.Hitpoints = 50;
		b.Stamina = 50;
		b.Bravery = 25;
		
		local body = this.getSprite("body");
		body.varyColor(0.15, 0.15, 0.15);
		body.varyBrightness(0.1);
		body.varySaturation(0.3);

		// update the properties
		this.m.CurrentProperties = clone b;
		this.m.Head = ::Math.rand(0, 2);

		local background = ::new("scripts/skills/backgrounds/nggh_mod_spider_eggs_background");
		this.m.Skills.add(background);
		background.buildDescription();

		this.setScenarioValues(::Const.EntityType.SpiderEggs, _isElite, false, true);
	}

	function onRender()
	{
		this.actor.onRender();

		if (this.m.DistortTargetA == null)
		{
			this.m.DistortTargetA = this.m.IsFlipping ? ::createVec(this.m.BodyOffset[0] * this.m.Size, (this.m.BodyOffset[1] + 1.0) * this.m.Size) : ::createVec(this.m.BodyOffset[0] * this.m.Size, (this.m.BodyOffset[1] - 1.0) * this.m.Size);
			this.m.DistortTargetHelmet = this.m.IsFlipping ? ::createVec(this.m.HelmetOffset[0] * this.m.Size, (this.m.HelmetOffset[1] + 1.0) * this.m.Size) : ::createVec(this.m.HelmetOffset[0] * this.m.Size, (this.m.HelmetOffset[1] - 1.0) * this.m.Size);
			this.m.DistortAnimationStartTimeA = ::Time.getVirtualTimeF() - ::Math.rand(10, 100) * 0.01;
		}

		foreach( a in ::Const.CharacterSprites.Helmets )
		{
			if (this.getSprite(a).HasBrush && this.getSprite(a).Visible)
			{
				this.moveSpriteOffset(a, this.m.DistortTargetPrevHelmet, this.m.DistortTargetHelmet, 1.0, this.m.DistortAnimationStartTimeA);
			}
		}

		if (this.moveSpriteOffset("body", this.m.DistortTargetPrevA, this.m.DistortTargetA, 1.0, this.m.DistortAnimationStartTimeA))
		{
			this.m.DistortAnimationStartTimeA = ::Time.getVirtualTimeF();
			this.m.DistortTargetPrevA = this.m.DistortTargetA;
			this.m.DistortTargetA = this.m.IsFlipping ? ::createVec(this.m.BodyOffset[0] * this.m.Size, (this.m.BodyOffset[1] + 1.0) * this.m.Size) : ::createVec(this.m.BodyOffset[0] * this.m.Size, (this.m.BodyOffset[1] - 1.0) * this.m.Size);
			this.m.DistortTargetPrevHelmet = this.m.DistortTargetHelmet;	
			this.m.DistortTargetHelmet = this.m.IsFlipping ? ::createVec(this.m.HelmetOffset[0] * this.m.Size, (this.m.HelmetOffset[1] + 1.0) * this.m.Size) : ::createVec(this.m.HelmetOffset[0] * this.m.Size, (this.m.HelmetOffset[1] - 1.0) * this.m.Size);
			this.m.IsFlipping = !this.m.IsFlipping;
		}
	}

	function fillTalentValues( _num, _force = false )
	{
		this.player.fillTalentValues(_num, _force);
	}

	function onRetreating()
	{
		if (!this.isPlacedOnMap())
		{
			return;
		}

		this.getMode().switchMode(true);
	}

	function onSpawn( _tile )
	{
		if (_tile == null)
		{
			local myTile = this.getTile();
			
			for( local i = 0; i < 6; i = ++i )
			{
				if (!myTile.hasNextTile(i))
				{
				}
				else
				{
					local nextTile = myTile.getNextTile(i);

					if (!nextTile.IsEmpty || ::Math.abs(nextTile.Level - myTile.Level) > 1)
					{
					}
					else
					{
						_tile = nextTile;
						break;
					}
				}
			}
		}

		if (_tile == null)
		{
			::Tactical.EventLog.log("Fails to spawn Webknecht due to insufficient space");
			return null;
		}

		local spawn = ::Tactical.spawnEntity("scripts/entity/tactical/minions/nggh_mod_spider_minion", _tile.Coords);
		spawn.setSize(::Math.rand(60, 75) * 0.01);
		spawn.setFaction(::Const.Faction.PlayerAnimals);
		spawn.getFlags().set("Source", this.getID());
		spawn.setMaster(this);

		foreach( a in ::Tactical.Entities.getInstancesOfFaction(this.getFaction()) )
		{
			if (a.getFlags().has("Hexe"))
			{
				spawn.getSkills().add(::new("scripts/skills/effects/fake_charmed_effect"));
				break;
			}
		}

		this.getMode().onChangeAI(spawn);
		this.modifyStats(spawn, this.getSkills().hasSkill("perk.natural_selection"));
		
		if (this.getSkills().hasSkill("perk.inherit"))
		{
			this.givePerk(spawn);
		}

		if (!this.getSkills().hasSkill("perk.attach_egg"))
		{
			spawn.getFlags().add("attack_mode");
		}

		spawn.getSkills().update();
		spawn.setHitpointsPct(1.0);
		::Tactical.EventLog.log("A Webknecht hatches from an egg");
		++this.m.Count;
		return spawn;
	}
	
	function modifyStats( _spiderling , _isGettingStronger = false )
	{
		local b = _spiderling.getBaseProperties();
		local lv = this.getLevel();

		if (_isGettingStronger && this.m.Count > 0)
		{
			local count = ::Math.min(9, this.m.Count);
			local mult = ::Math.pow(1.038, count);
			b.HitpointsMult *= mult;
			b.BraveryMult *= mult;
			b.StaminaMult *= mult;
			b.MeleeSkillMult *= mult;
			b.RangedSkillMult *= mult;
			b.MeleeDefenseMult *= mult;
			b.RangedDefenseMult *= mult;
			b.InitiativeForTurnOrderMult *= mult;
			b.ArmorMult = [mult, mult];

			if (::Math.rand(1, 100) <= 10)
			{
				b.ActionPoints += 1;
			}
		}
		
		local mod = lv > 11 ? 11 + (lv - 11) * 0.33 : lv;
		b.Hitpoints += ::Math.ceil(3 * mod);
		b.Bravery += ::Math.ceil(2 * mod);
		b.Stamina += ::Math.ceil(3 * mod);
		b.MeleeSkill += ::Math.ceil(3 * mod);
		//b.RangedSkill += 0;
		b.MeleeDefense += ::Math.floor(2 * mod);
		b.RangedDefense += ::Math.floor(2.5 * mod);
		b.Initiative += ::Math.ceil(4 * mod);
		b.Armor = [
			20 + ::Math.ceil(mod * 1.5),
			20 + ::Math.ceil(mod * 1.5)
		];
		b.ArmorMax = [
			20 + ::Math.ceil(mod * 1.5), 
			20 + ::Math.ceil(mod * 1.5)
		];
		
		// update the current action points
		_spiderling.m.ActionPoints = b.ActionPoints;
	}
	
	function givePerk( _spiderling )
	{
		foreach ( p in this.getSkills().query(::Const.SkillType.Perk, true) )
		{
			if (!p.isSerialized())
			{
				continue;
			}
			
			if (::Const.NoCopyPerks.find(p.getID()) != null)
			{
				continue;
			}

			/* a bit reduntant 
			if (this.getSkills().hasSkill(p.getID()))
			{
				continue;
			}
			*/

			local script = ::Nggh_MagicConcept.findPerkScriptByID(p.getID());

			if (script == null)
			{
				continue;
			}
			
			local perk = this.new(script);
			_spiderling.getSkills().add(perk);
			perk.onCombatStarted();
		}
	}

	function setAttributeLevelUpValues( _v )
	{
		// free max armor upon leveling up
		local b = this.getBaseProperties();
		local value = this.getLevel() > 11 ? this.getHitpointsPerVeteranLevel() : 10;
		b.Armor[0] += value;
		b.ArmorMax[0] += value;
		b.Armor[1] += value;
		b.ArmorMax[1] += value;
		
		this.player.setAttributeLevelUpValues(_v);
	}

	function isAbleToEquip( _item )
	{
		if (_item.getSlotType() == ::Const.ItemSlot.Head)
		{
			this.m.Head = ::Math.rand(0, 2);
		}

		return this.nggh_mod_player_beast.isAbleToEquip(_item);
	}

	function onAfterEquip( _item )
	{
		if (_item.getSlotType() == ::Const.ItemSlot.Accessory)
		{
			this.m.Mount.onAccessoryEquip(_item);
		}
	}

	function onAfterUnequip( _item )
	{
		if (_item.getSlotType() == ::Const.ItemSlot.Accessory)
		{
			this.m.Mount.onAccessoryUnequip();
		}
	}

	function canEnterBarber()
	{
		return false;
	}

});

