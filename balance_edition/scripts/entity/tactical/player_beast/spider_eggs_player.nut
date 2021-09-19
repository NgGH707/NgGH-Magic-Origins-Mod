this.spider_eggs_player <- this.inherit("scripts/entity/tactical/player_beast", {
	m = {
		Mount = null,
		ExcludedMount = [],
		Head = 0,
		Count = 0,
		Size = 1.0,
		DistortTargetA = null,
		DistortTargetPrevA = this.createVec(0, 0),
		DistortTargetHelmet = null,
		DistortTargetPrevHelmet = this.createVec(0, 0),
		DistortAnimationStartTimeA = 0,
		IsFlipping = false,
		HelmetOffset = [0, 0],
		BodyOffset = [0, 0]
	},
	function getExcludedMount()
	{
		return this.m.ExcludedMount;
	}

	function getMountType()
	{
		return this.m.Mount.getMountType();
	}

	function isMounted()
	{
		return this.m.Mount.isMounted();
	}

	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		if (this.isMounted() && this.Math.rand(1, 100) <= this.Const.ChanceToHitMount)
		{
			return this.m.Mount.onDamageReceived(_attacker, _skill, _hitInfo);
		}

		_hitInfo.BodyPart = this.Const.BodyPart.Body;
		return this.actor.onDamageReceived(_attacker, _skill, _hitInfo);
	}

	function onUpdateInjuryLayer()
	{
		this.actor.onUpdateInjuryLayer();

		if (this.isMounted())
		{
			this.m.Mount.updateInjuryLayer();
		}
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

	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.player_beast.onAppearanceChanged(_appearance, _setDirty);
		this.m.Mount.updateAppearance();
		this.onAdjustingSprite(_appearance, this.isMounted());
	}
	
	function onAdjustingSprite( _appearance , _isMounted = false )
	{
		local size = 1.0;
		if (_isMounted) size = this.getMountType() == this.Const.GoblinRider.Mounts.Spider ? 0.65 : 0.75;
		this.setSize(size);
		local offset = this.Const.EggSpriteOffsets[this.m.Head];
		local x = offset[0];
		local y = offset[1];
		local adjust_x = 0;
		local adjust_y = 0;

		if (_isMounted)
		{
			adjust_x = this.Const.GoblinRiderMounts[this.getMountType()].Sprite[0][0];
			adjust_y = this.Const.GoblinRiderMounts[this.getMountType()].Sprite[0][1];
		}

		this.m.HelmetOffset = [x + adjust_x, y + adjust_y];
		this.m.BodyOffset = [adjust_x, adjust_y];

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			local offsetX = this.m.HelmetOffset[0] * this.m.Size;
			local offsetY = this.m.HelmetOffset[1] * this.m.Size;
			this.setSpriteOffset(a, this.createVec(offsetX, offsetY));
			this.getSprite(a).Scale = 0.85 * this.m.Size;
		}

		this.setSpriteOffset("body", this.createVec(this.m.BodyOffset[0] * this.m.Size, this.m.BodyOffset[1] * this.m.Size));
		this.getSprite("accessory").Scale = 0.7 * this.m.Size;
		this.setSpriteOffset("accessory", this.createVec(this.m.BodyOffset[0] * this.m.Size, this.m.BodyOffset[1] * this.m.Size));
		this.getSprite("accessory_special").Scale = 0.7 * this.m.Size;
		this.setSpriteOffset("accessory_special", this.createVec(this.m.BodyOffset[0] * this.m.Size, this.m.BodyOffset[1] * this.m.Size));
		this.setAlwaysApplySpriteOffset(true);
		this.setDirty(true);
	}

	function isNonCombatant()
	{
		if (this.isMounted())
		{
			return false;
		}

		return this.m.IsNonCombatant;
	}

	function getStrength()
	{
		return 1.25;
	}

	function getHealthRecoverMult()
	{
		return 1.25;
	}
	
	function create()
	{
		this.player_beast.create();
		this.m.IsNonCombatant = true;
		this.m.ShakeLayers = [
			[
				"body",
				"helmet_vanity_lower",
				"helmet_vanity_lower_2",
				"helmet",
				"helmet_damage",
				"helmet_helm",
				"helmet_top",
				"helmet_vanity",
				"helmet_vanity_2",
			],
			[
				"body",
				"helmet_vanity_lower",
				"helmet_vanity_lower_2",
				"helmet",
				"helmet_damage",
				"helmet_helm",
				"helmet_top",
				"helmet_vanity",
				"helmet_vanity_2",
			],
			[
				"body",
				"helmet_vanity_lower",
				"helmet_vanity_lower_2",
				"helmet",
				"helmet_damage",
				"helmet_helm",
				"helmet_top",
				"helmet_vanity",
				"helmet_vanity_2",
			]
		];
		this.m.BloodType = this.Const.BloodType.None;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.m.XP = this.Const.Tactical.Actor.SpiderEggs.XP;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/dlc2/giant_spider_idle_01.wav",
			"sounds/enemies/dlc2/giant_spider_idle_02.wav",
			"sounds/enemies/dlc2/giant_spider_idle_03.wav",
			"sounds/enemies/dlc2/giant_spider_idle_04.wav",
			"sounds/enemies/dlc2/giant_spider_idle_05.wav",
		];
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/dlc2/giant_spider_idle_01.wav",
			"sounds/enemies/dlc2/giant_spider_idle_02.wav",
			"sounds/enemies/dlc2/giant_spider_idle_03.wav",
			"sounds/enemies/dlc2/giant_spider_idle_04.wav",
			"sounds/enemies/dlc2/giant_spider_idle_05.wav",
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/dlc2/giant_spider_egg_spawn_01.wav",
			"sounds/enemies/dlc2/giant_spider_egg_spawn_02.wav",
			"sounds/enemies/dlc2/giant_spider_egg_spawn_03.wav",
			"sounds/enemies/dlc2/giant_spider_egg_spawn_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
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
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Idle] = 2.0;
		this.m.SoundPitch = this.Math.rand(95, 105) * 0.01;
		this.m.Items.blockAllSlots();
		this.m.Items.m.LockedSlots[this.Const.ItemSlot.Accessory] = false;
		this.m.Items.m.LockedSlots[this.Const.ItemSlot.Head] = false;
		this.m.Mount = this.new("scripts/mods/mount_manager");
		this.m.Mount.setActor(this);
		this.m.AIAgent = this.new("scripts/ai/tactical/spider_egg_player_agent");
		this.m.AIAgent.setActor(this);
		this.m.Flags.add("egg");
	}

	function onRender()
	{
		this.actor.onRender();

		if (this.m.DistortTargetA == null)
		{
			this.m.DistortTargetA = this.m.IsFlipping ? this.createVec(this.m.BodyOffset[0] * this.m.Size, (this.m.BodyOffset[1] + 1.0) * this.m.Size) : this.createVec(this.m.BodyOffset[0] * this.m.Size, (this.m.BodyOffset[1] - 1.0) * this.m.Size);
			this.m.DistortTargetHelmet = this.m.IsFlipping ? this.createVec(this.m.HelmetOffset[0] * this.m.Size, (this.m.HelmetOffset[1] + 1.0) * this.m.Size) : this.createVec(this.m.HelmetOffset[0] * this.m.Size, (this.m.HelmetOffset[1] - 1.0) * this.m.Size);
			this.m.DistortAnimationStartTimeA = this.Time.getVirtualTimeF() - this.Math.rand(10, 100) * 0.01;
		}

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			if (this.getSprite(a).HasBrush && this.getSprite(a).Visible)
			{
				this.moveSpriteOffset(a, this.m.DistortTargetPrevHelmet, this.m.DistortTargetHelmet, 1.0, this.m.DistortAnimationStartTimeA);
			}
		}

		if (this.moveSpriteOffset("body", this.m.DistortTargetPrevA, this.m.DistortTargetA, 1.0, this.m.DistortAnimationStartTimeA))
		{
			this.m.DistortAnimationStartTimeA = this.Time.getVirtualTimeF();
			this.m.DistortTargetPrevA = this.m.DistortTargetA;
			this.m.DistortTargetA = this.m.IsFlipping ? this.createVec(this.m.BodyOffset[0] * this.m.Size, (this.m.BodyOffset[1] + 1.0) * this.m.Size) : this.createVec(this.m.BodyOffset[0] * this.m.Size, (this.m.BodyOffset[1] - 1.0) * this.m.Size);
			this.m.DistortTargetPrevHelmet = this.m.DistortTargetHelmet;	
			this.m.DistortTargetHelmet = this.m.IsFlipping ? this.createVec(this.m.HelmetOffset[0] * this.m.Size, (this.m.HelmetOffset[1] + 1.0) * this.m.Size) : this.createVec(this.m.HelmetOffset[0] * this.m.Size, (this.m.HelmetOffset[1] - 1.0) * this.m.Size);
			this.m.IsFlipping = !this.m.IsFlipping;
		}
	}

	function onCombatStart()
	{
		this.player_beast.onCombatStart();
		this.m.Count = 0;
	}

	function onCombatFinished()
	{
		this.player_beast.onCombatFinished();
		this.m.Count = 0;
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (!this.Tactical.State.isScenarioMode() && _killer != null && _killer.isPlayerControlled())
		{
			this.updateAchievement("ScrambledEggs", 1, 1);
		}

		local flip = this.Math.rand(0, 100) < 50;

		if (_tile != null)
		{
			_tile.spawnDetail("nest_01_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			this.spawnTerrainDropdownEffect(_tile);
		}

		this.player_beast.onDeath(_killer, _skill, _tile, _fatalityType);
	}
	
	function onFactionChanged()
	{
		this.actor.onFactionChanged();
		local flip = !this.isAlliedWithPlayer();
		this.m.IsFlipping = !flip;
		this.getSprite("body").setHorizontalFlipping(!flip);
		this.getSprite("accessory").setHorizontalFlipping(flip);
		this.getSprite("accessory_special").setHorizontalFlipping(flip);

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.getSprite(a).setHorizontalFlipping(flip);
		}
	}

	function onInit()
	{
		this.player_beast.onInit();
		this.setRenderCallbackEnabled(true);
		local b = this.m.BaseProperties;
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToRoot = true;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToDisarm = true;
		b.IsImmuneToOverwhelm = true;
		b.IsImmuneToZoneOfControl = true;
		b.IsImmuneToSurrounding = true;
		b.IsImmuneToDamageReflection = true;
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsRooted = true;
		b.DailyFood = 0;
		b.MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] = 10000.0;
		b.DamageReceivedTotalMult = 0.9;
		
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		
		//mount sprites
		this.addSprite("mount_extra1"); //spider legs_back
		this.addSprite("mount_extra2"); //spider body

		this.addSprite("body");
		this.addSprite("accessory");
		this.addSprite("accessory_special");

		foreach( a in this.Const.CharacterSprites.Helmets )
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

		local rider = this.new("scripts/skills/special/egg_rider");
		rider.setManager(this.m.Mount);
		this.m.Mount.setRiderSkill(rider);
		this.m.Skills.add(rider);

		this.m.Skills.add(this.new("scripts/skills/racial/skeleton_racial"));
		this.m.Skills.add(this.new("scripts/skills/eggs_actives/add_egg"));
		this.m.Skills.add(this.new("scripts/skills/eggs_actives/spawn_more_spider"));
		this.m.Skills.add(this.new("scripts/skills/eggs_actives/spawn_spider"));
		this.m.Skills.add(this.new("scripts/skills/eggs_actives/auto_mode_spawned_spider"));
	}
	
	function setScenarioValues( _isElite = false, _Dub_two = false , _Dub_three = false, _Dub_four = false )
	{
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.SpiderEggs);
		b.Hitpoints = 50;
		b.ActionPoints = 9;
		b.Bravery = 25;
		b.Stamina = 50;
		b.FatigueRecoveryRate = 10;
		
		local r = this.Math.rand(0, 2);
		this.getFlags().set("head", r);
		this.m.Head = r;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		
		local flip = this.Math.rand(0, 1) == 1;
		local body = this.getSprite("body");
		body.setBrush("nest_01");

		if (_isElite || this.Math.rand(1, 100) == 100)
		{
			this.getSkills().add(this.new("scripts/skills/racial/champion_racial"));
		}
		
		this.setName("Webknecht Hive");
		local background = this.new("scripts/skills/backgrounds/spider_eggs_background");
		this.m.Skills.add(background);
		background.buildDescription();
		background.buildAttributes();
		
		local c = this.m.CurrentProperties;
		this.m.ActionPoints = c.ActionPoints;
		this.m.Hitpoints = c.Hitpoints;
		this.m.Talents = [];
		this.fillTalentValues(3);
		this.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
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

		local autoMode = this.getSkills().getSkillByID("actives.auto_mode_spawned_spider");
		autoMode.switchMode(true);
	}

	function onSpawn( _tile )
	{
		if (_tile != null)
		{
		}
		else
		{
			local _tile = this.getTile();
			
			for( local i = 0; i < 6; i = ++i )
			{
				if (!_tile.hasNextTile(i))
				{
				}
				else
				{
					local nextTile = _tile.getNextTile(i);

					if (!nextTile.IsEmpty || this.Math.abs(nextTile.Level - _tile.Level) > 1)
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

		if (_tile != null)
		{
			local autoMode = this.getSkills().getSkillByID("actives.auto_mode_spawned_spider");
			local spawn = this.Tactical.spawnEntity("scripts/entity/tactical/minions/special/spider_minion", _tile.Coords);
			spawn.setSize(this.Math.rand(60, 75) * 0.01);
			spawn.setMaster(this);
			spawn.m.IsControlledByPlayer = !autoMode.getMode();
			spawn.setFaction(this.Const.Faction.PlayerAnimals);
			spawn.getFlags().set("creator", this.getID());
			spawn.m.XP = spawn.m.XP / 2;
			local allies = this.Tactical.Entities.getInstancesOfFaction(this.getFaction());

			foreach( a in allies )
			{
				if (a.getFlags().has("Hexe"))
				{
					spawn.getSkills().add(this.new("scripts/skills/effects/fake_charmed_effect"));
					break;
				}
			}

			this.improveStats(spawn, this.getSkills().hasSkill("perk.natural_selection"));
			
			if (this.getSkills().hasSkill("perk.inherit"))
			{
				this.givePerk(spawn);
			}

			if (!this.getSkills().hasSkill("perk.attach_egg"))
			{
				spawn.getFlags().add("attack_mode");
			}

			spawn.getSkills().update();
			spawn.setHitpointsPct(1);
			this.Tactical.EventLog.log("A Webknecht emerges from the hive");
			++this.m.Count;
			return spawn;
		}
		
		this.Tactical.EventLog.log("Fails to spawn Webknecht due to insufficient space");
		return null;
	}
	
	function improveStats( _spiderling , _isGettingStronger = false )
	{
		local b = _spiderling.getBaseProperties();
		local lv = this.getLevel();
		local mult = 0;

		if (_isGettingStronger && this.m.Count > 0)
		{
			local count = this.Math.min(9, this.m.Count);
			local m = this.Math.pow(1.038, count);
			b.HitpointsMult *= m;
			b.BraveryMult *= m;
			b.StaminaMult *= m;
			b.MeleeSkillMult *= m;
			b.RangedSkillMult *= m;
			b.MeleeDefenseMult *= m;
			b.RangedDefenseMult *= m;
			b.InitiativeForTurnOrderMult *= m;
			b.ArmorMult = [m, m];

			if (this.Math.rand(1, 100) <= 10)
			{
				b.ActionPoints += 1;
			}
		}

		if (lv > 11)
		{
			mult = 11 + (lv - 11) * 0.33;
		}
		else 
		{
			mult = lv;
		}

		b.Hitpoints += this.Math.ceil(3 * mult);
		b.Bravery += this.Math.ceil(2 * mult);
		b.Stamina += this.Math.ceil(3 * mult);
		b.MeleeSkill += this.Math.ceil(3 * mult);
		b.RangedSkill += 0;
		b.MeleeDefense += this.Math.floor(2 * mult);
		b.RangedDefense += this.Math.floor(2.5 * mult);
		b.Initiative += this.Math.ceil(4 * mult);
		b.Armor = [
			20 + this.Math.ceil(mult * 1.5),
			20 + this.Math.ceil(mult * 1.5)
		];
		b.ArmorMax = [
			20 + this.Math.ceil(mult * 1.5), 
			20 + this.Math.ceil(mult * 1.5)
		];
		
		_spiderling.m.ActionPoints = b.ActionPoints;
	}
	
	function givePerk( _spiderling )
	{
		local perks = this.getSkills().query(this.Const.SkillType.Perk, true);
		local exclude = [
			"perk.inherit",
			"perk.breeding_machine",
			"perk.natural_selection",
			"perk.gifted",
			"perk.attach_egg",
		];
		
		foreach ( p in perks )
		{
			if (!p.isSerialized())
			{
				continue;
			}
			
			if (exclude.find(p.getID()) != null)
			{
				continue;
			}

			local script = this.findPerkInConst(p.getID());

			if (script == null)
			{
				continue;
			}
			
			local perk = this.new(script);
			_spiderling.getSkills().add(perk);
			perk.onCombatStarted();
		}
	}

	function findPerkInConst( _id )
	{
		foreach ( Def in this.Const.Perks.PerkDefObjects )
		{
			if (Def.ID == _id)
			{
				return Def.Script;
			}
		}

		return null;
	}
	
	function fillAttributeLevelUpValues( _amount, _maxOnly = false, _minOnly = false )
	{
		local AttributesLevelUp = [
			{
				Min = 5,
				Max = 10
			},
			{
				Min = 5,
				Max = 5
			},
			{
				Min = 5,
				Max = 5
			},
			{
				Min = 3,
				Max = 5
			},
			{
				Min = 1,
				Max = 3
			},
			{
				Min = 1,
				Max = 3
			},
			{
				Min = 1,
				Max = 3
			},
			{
				Min = 1,
				Max = 3
			}
		];
		
		if (this.m.Attributes.len() == 0)
		{
			this.m.Attributes.resize(this.Const.Attributes.COUNT);

			for( local i = 0; i != this.Const.Attributes.COUNT; i = ++i )
			{
				this.m.Attributes[i] = [];
			}
		}

		for( local i = 0; i != this.Const.Attributes.COUNT; i = ++i )
		{
			local isHP = i == 0;
			local isCombatStats = i >= 4;
			
			for( local j = 0; j < _amount; j = ++j )
			{
				if (_minOnly)
				{
					local add = 2;
					add = isHP ? 5 : add;
					add = isCombatStats ? 1 : add;
					
					this.m.Attributes[i].insert(0, add);
				}
				else if (_maxOnly)
				{
					this.m.Attributes[i].insert(0, AttributesLevelUp[i].Max);
				}
				else
				{
					if (!isCombatStats)
					{
						this.m.Attributes[i].insert(0, this.Math.rand(AttributesLevelUp[i].Min + (this.m.Talents[i] == 3 ? 2 : this.m.Talents[i]), AttributesLevelUp[i].Max + (this.m.Talents[i] == 3 ? 2 : 0)));
					}
					else
					{
						this.m.Attributes[i].insert(0, 1);
					}
				}
			}
		}
	}
	
	function getAttributeLevelUpValues()
	{
		local b = this.getBaseProperties();

		if (this.m.Attributes[0].len() == 0)
		{
			for( local i = 0; i != this.Const.Attributes.COUNT; i = ++i )
			{
				this.m.Attributes[i].push(1);
			}
		}

		local ret = {
			hitpoints = b.Hitpoints,
			hitpointsMax = 500,
			hitpointsIncrease = this.m.Attributes[this.Const.Attributes.Hitpoints][0],
			bravery = b.Bravery,
			braveryMax = 250,
			braveryIncrease = this.m.Attributes[this.Const.Attributes.Bravery][0],
			fatigue = b.Stamina,
			fatigueMax = 200,
			fatigueIncrease = this.m.Attributes[this.Const.Attributes.Fatigue][0],
			initiative = b.Initiative,
			initiativeMax = 100,
			initiativeIncrease = this.m.Attributes[this.Const.Attributes.Initiative][0],
			meleeSkill = b.MeleeSkill,
			meleeSkillMax = 50,
			meleeSkillIncrease = this.m.Attributes[this.Const.Attributes.MeleeSkill][0],
			rangeSkill = b.RangedSkill,
			rangeSkillMax = 50,
			rangeSkillIncrease = this.m.Attributes[this.Const.Attributes.RangedSkill][0],
			meleeDefense = b.MeleeDefense,
			meleeDefenseMax = 50,
			meleeDefenseIncrease = this.m.Attributes[this.Const.Attributes.MeleeDefense][0],
			rangeDefense = b.RangedDefense,
			rangeDefenseMax = 50,
			rangeDefenseIncrease = this.m.Attributes[this.Const.Attributes.RangedDefense][0]
		};
		return ret;
	}

	function setAttributeLevelUpValues( _v )
	{
		local value = this.getLevel() > 11 ? 5 : 10;
		local b = this.getBaseProperties();
		b.Hitpoints += _v.hitpointsIncrease;
		this.m.Hitpoints += _v.hitpointsIncrease;
		b.Stamina += _v.maxFatigueIncrease;
		b.Bravery += _v.braveryIncrease;
		b.MeleeSkill += _v.meleeSkillIncrease;
		b.RangedSkill += _v.rangeSkillIncrease;
		b.MeleeDefense += _v.meleeDefenseIncrease;
		b.RangedDefense += _v.rangeDefenseIncrease;
		b.Initiative += _v.initiativeIncrease;
		b.Armor[0] += value;
		b.ArmorMax[0] += value;
		b.Armor[1] += value;
		b.ArmorMax[1] += value;
		this.m.LevelUps = this.Math.max(0, this.m.LevelUps - 1);

		for( local i = 0; i != this.Const.Attributes.COUNT; i = ++i )
		{
			this.m.Attributes[i].remove(0);
		}
		
		this.m.CurrentProperties = clone b;
		this.getSkills().update();
		this.setDirty(true);
	}

	function onActorEquip( _item )
	{
		if (_item.getSlotType() == this.Const.ItemSlot.Head)
		{
			this.m.Head = this.Math.rand(0, 2);
		}

		if (_item.getSlotType() == this.Const.ItemSlot.Accessory && this.getSkills().hasSkill("perk.attach_egg"))
		{
			this.m.Mount.onAccessoryEquip(_item);
		}
	}

	function onActorUnequip( _item )
	{
		if (_item.getSlotType() == this.Const.ItemSlot.Accessory)
		{
			this.m.Mount.onAccessoryUnequip();
		}
	}

	function onDeserialize( _in )
	{
		this.player_beast.onDeserialize(_in);

		/*if (this.getFlags().has("head"))
		{
			this.m.Head = this.getFlags().getAsInt("head");
			this.m.Items.updateAppearance();
		}*/
	}

});

