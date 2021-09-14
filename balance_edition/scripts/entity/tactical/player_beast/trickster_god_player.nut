this.trickster_god_player <- this.inherit("scripts/entity/tactical/player_beast", {
	m = {},
	
	function getStrength()
	{
		return 12;
	}
	
	function getHealthRecoverMult()
	{
		return 12.0;
	}
	
	function create()
	{
		this.player_beast.create();
		this.m.Type = this.Const.EntityType.Player;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.TricksterGod.XP;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.DecapitateSplatterOffset = this.createVec(40, -20);
		this.m.DecapitateBloodAmount = 3.0;
		this.m.hitpointsMax = 3000;
		this.m.braveryMax = 1000;
		this.m.fatigueMax = 600;
		this.m.initiativeMax = 200;
		this.m.meleeSkillMax = 150;
		this.m.rangeSkillMax = 50;
		this.m.meleeDefenseMax = 125;
		this.m.rangeDefenseMax = 125;
		this.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/dlc4/thing_idle_01.wav",
			"sounds/enemies/dlc4/thing_idle_02.wav",
			"sounds/enemies/dlc4/thing_idle_03.wav",
			"sounds/enemies/dlc4/thing_idle_04.wav",
		];
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/dlc4/thing_hurt_01.wav",
			"sounds/enemies/dlc4/thing_hurt_02.wav",
			"sounds/enemies/dlc4/thing_hurt_03.wav",
			"sounds/enemies/dlc4/thing_hurt_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/dlc4/thing_idle_05.wav",
			"sounds/enemies/dlc4/thing_idle_06.wav",
			"sounds/enemies/dlc4/thing_idle_07.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/dlc4/thing_death_01.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/dlc4/thing_idle_01.wav",
			"sounds/enemies/dlc4/thing_idle_02.wav",
			"sounds/enemies/dlc4/thing_idle_03.wav",
			"sounds/enemies/dlc4/thing_idle_04.wav",
			"sounds/enemies/dlc4/thing_idle_05.wav",
			"sounds/enemies/dlc4/thing_idle_06.wav",
			"sounds/enemies/dlc4/thing_idle_07.wav"
		];
		this.m.SoundPitch = 1.0;
		this.m.SoundVolumeOverall = 1.0;
		this.m.Items.blockAllSlots();
		this.m.Items.m.LockedSlots[this.Const.ItemSlot.Accessory] = false;
		this.m.Items.m.LockedSlots[this.Const.ItemSlot.Head] = false;
		this.getFlags().add("boss");
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.player_beast.onDeath(_killer, _skill, _tile, _fatalityType);
		local flip = this.Math.rand(1, 100) < 50;

		if (_tile != null)
		{
			this.m.IsCorpseFlipped = flip;
			this.spawnBloodPool(_tile, 1);
			local decal;
			local appearance = this.getItems().getAppearance();
			local sprite_body = this.getSprite("body");
			local sprite_head = this.getSprite("head");
			decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = sprite_body.Color;
			decal.Saturation = sprite_body.Saturation;
			decal.Scale = 0.9;
			decal.setBrightness(0.9);
			decal = _tile.spawnDetail("bust_trickster_god_head_01_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = sprite_head.Color;
			decal.Saturation = sprite_head.Saturation;
			decal.Scale = 0.9;
			decal.setBrightness(0.9);
			this.spawnTerrainDropdownEffect(_tile);
			local corpse = clone this.Const.Corpse;
			corpse.CorpseName = this.getName();
			corpse.Tile = _tile;
			corpse.IsResurrectable = false;
			corpse.IsConsumable = true;
			corpse.Items = this.getItems();
			corpse.IsHeadAttached = _fatalityType != this.Const.FatalityType.Decapitated;
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);
			local effect = {
				Delay = 0,
				Quantity = 12,
				LifeTimeQuantity = 12,
				SpawnRate = 100,
				Brushes = [
					"trickster_god_effect_player"
				],
				Stages = [
					{
						LifeTimeMin = 1.0,
						LifeTimeMax = 1.0,
						ColorMin = this.createColor("ffffff5f"),
						ColorMax = this.createColor("ffffff5f"),
						ScaleMin = 1.0,
						ScaleMax = 1.0,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = this.createVec(-1.0, -1.0),
						DirectionMax = this.createVec(1.0, 1.0),
						SpawnOffsetMin = this.createVec(-10, -10),
						SpawnOffsetMax = this.createVec(10, 10),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 0)
					},
					{
						LifeTimeMin = 1.0,
						LifeTimeMax = 1.0,
						ColorMin = this.createColor("ffffff2f"),
						ColorMax = this.createColor("ffffff2f"),
						ScaleMin = 0.9,
						ScaleMax = 0.9,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = this.createVec(-1.0, -1.0),
						DirectionMax = this.createVec(1.0, 1.0),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 0)
					},
					{
						LifeTimeMin = 0.1,
						LifeTimeMax = 0.1,
						ColorMin = this.createColor("ffffff00"),
						ColorMax = this.createColor("ffffff00"),
						ScaleMin = 0.1,
						ScaleMax = 0.1,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = this.createVec(-1.0, -1.0),
						DirectionMax = this.createVec(1.0, 1.0),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 0)
					}
				]
			};
			this.Tactical.spawnParticleEffect(false, effect.Brushes, _tile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 40));
		}

		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function onInit()
	{
		this.player_beast.onInit();
		local b = this.m.BaseProperties;
		b.IsImmuneToDisarm = true;
		b.IsImmuneToRoot = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToPoison = true;
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsAffectedByRain = false;
		
		this.m.ActionPoints = b.ActionPoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.m.MaxTraversibleLevels = 3;
		
		local body = this.addSprite("body");
		body.setBrush("bust_trickster_god_body_01");
		local injury_body = this.addSprite("injury");
		injury_body.Visible = false;
		injury_body.setBrush("bust_trickster_god_01_injured");
		this.addSprite("accessory");
		this.addSprite("accessory_special");
		local head = this.addSprite("head");
		head.setBrush("bust_trickster_god_head_01");

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			this.addSprite(a);
		}

		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.65;
		this.setSpriteOffset("status_rooted", this.createVec(-10, 16));
		this.setSpriteOffset("status_stunned", this.createVec(-32, 30));
		this.setSpriteOffset("arrow", this.createVec(0, 10));
	}

	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.player_beast.onAppearanceChanged(_appearance, _setDirty);
		this.onAdjustingSprite(_appearance);
	}
	
	function onAdjustingSprite( _appearance )
	{
		local v = 0;
		local v2 = 23;

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.setSpriteOffset(a, this.createVec(v2, v));
			this.getSprite(a).Scale = 1.2;
		}

		this.setSpriteOffset("accessory", this.createVec(15, 5));
		this.setSpriteOffset("accessory_special", this.createVec(15, 5));
		this.setAlwaysApplySpriteOffset(true);
	}

	function onFactionChanged()
	{
		this.player_beast.onFactionChanged();
		local flip = !this.isAlliedWithPlayer();
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
	
	function onCombatFinished()
	{
		this.player_beast.onCombatFinished();
		this.getSprite("head").setBrush("bust_trickster_god_head_01");
	}
	
	function onAfterInit()
	{
		this.player_beast.onAfterInit();
		local perks = ["perk_crippling_strikes", "perk_steel_brow", "perk_stalwart", "perk_hold_out"];
		
		foreach ( script in perks )
		{
			local s = this.new("scripts/skills/perks/" + script);
			s.m.IsSerialized = false;
			this.m.Skills.add(s);
		}
		
		this.m.Skills.add(this.new("scripts/skills/racial/trickster_god_racial"));
		this.m.Skills.add(this.new("scripts/skills/actives/teleport_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/gore_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/gore_skill_zoc"));
		this.m.Skills.update();
	}

	function setScenarioValues( _isElite = false , _dub = false , _dub_two = false , _dub_three = false )
	{
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.TricksterGod);

		if (_isElite || this.Math.rand(1, 100) == 100)
		{
			this.getSkills().add(this.new("scripts/skills/racial/champion_racial"));
		}
		
		local type = this.Const.EntityType.TricksterGod;
		local background = this.new("scripts/skills/backgrounds/charmed_beast_background");
		background.setTo(type);
		this.m.Skills.add(background);
		background.onSetUp();
		background.buildDescription();
		
		local c = this.m.CurrentProperties;
		this.m.ActionPoints = c.ActionPoints;
		this.m.Hitpoints = c.Hitpoints;
		this.m.Talents = [];
		this.m.Attributes = [];
		this.setName(this.Const.Strings.EntityName[type]);
		this.fillBeastTalentValues(this.Math.rand(9, 9), true);
		this.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
	}
	
	function fillAttributeLevelUpValues( _amount, _maxOnly = false, _minOnly = false )
	{
		local AttributesLevelUp = [
			{
				Min = 5,
				Max = 10
			},
			{
				Min = 1,
				Max = 1
			},
			{
				Min = 3,
				Max = 5
			},
			{
				Min = 2,
				Max = 4
			},
			{
				Min = 1,
				Max = 2
			},
			{
				Min = 1,
				Max = 1
			},
			{
				Min = 1,
				Max = 1
			},
			{
				Min = 1,
				Max = 1
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
			for( local j = 0; j < _amount; j = ++j )
			{
				if (_minOnly)
				{
					this.m.Attributes[i].insert(0, this.Math.rand(1, this.Math.rand(1, 2)));
				}
				else if (_maxOnly)
				{
					this.m.Attributes[i].insert(0, AttributesLevelUp[i].Max);
				}
				else
				{
					this.m.Attributes[i].insert(0, this.Math.rand(AttributesLevelUp[i].Min + (this.m.Talents[i] == 3 ? 2 : this.m.Talents[i]), AttributesLevelUp[i].Max + (this.m.Talents[i] == 3 ? 1 : 0)));
				}
			}
		}
	}
	
	function getExcludeTraits()
	{
		return [
			"trait.eagle_eyes",
			"trait.short_sighted",
			"trait.tiny",
			"trait.dumb",
			"trait.drunkard",
			"trait.dastard",
			"trait.optimist",
			"trait.pessimist",
			"trait.superstitious",
			"trait.greedy",
			"trait.spartan",
			"trait.irrational",
			"trait.loyal",
			"trait.disloyal",
			"trait.survivor",
			"trait.night_blind",
			"trait.night_owl",
			"trait.paranoid",
			"trait.teamplayer",
			"trait.lucky",
			"trait.steady_hands",
			"trait.light",
			"trait.gift_of_people",
			"trait.double_tongued",
			"trait.seductive",
		];
	}

});

