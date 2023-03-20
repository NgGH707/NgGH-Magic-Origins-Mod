this.nggh_mod_trickster_god_player <- ::inherit("scripts/entity/tactical/nggh_mod_player_beast", {
	m = {},
	function getStrengthMult()
	{
		return 15.0;
	}

	function getHitpointsPerVeteranLevel()
	{
		return ::Math.rand(2, 5);
	}
	
	function create()
	{
		this.nggh_mod_player_beast.create();
		this.m.BloodType = ::Const.BloodType.Red;
		this.m.BloodSplatterOffset = ::createVec(0, 0);
		this.m.DecapitateSplatterOffset = ::createVec(40, -20);
		this.m.DecapitateBloodAmount = 3.0;
		this.m.SignaturePerks = ["Stalwart", "LegendComposure", "LegendPoisonImmunity", "SteelBrow", "HoldOut"];
		this.m.ExcludedTraits = ::Const.Nggh_ExcludedTraits.TricksterGod;
		this.m.AttributesLevelUp = ::Const.Nggh_AttributesLevelUp.TricksterGod;
		this.m.BonusHealthRecoverMult = 11.5;
		this.m.AttributesMax = {
			Hitpoints = 3000,
			Bravery = 1000,
			Fatigue = 600,
			Initiative = 200,
			MeleeSkill = 150,
			RangedSkill = 50,
			MeleeDefense = 125,
			RangedDefense = 125,
		};
		this.m.Sound[::Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/dlc4/thing_idle_01.wav",
			"sounds/enemies/dlc4/thing_idle_02.wav",
			"sounds/enemies/dlc4/thing_idle_03.wav",
			"sounds/enemies/dlc4/thing_idle_04.wav",
		];
		this.m.Sound[::Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/dlc4/thing_hurt_01.wav",
			"sounds/enemies/dlc4/thing_hurt_02.wav",
			"sounds/enemies/dlc4/thing_hurt_03.wav",
			"sounds/enemies/dlc4/thing_hurt_04.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/dlc4/thing_idle_05.wav",
			"sounds/enemies/dlc4/thing_idle_06.wav",
			"sounds/enemies/dlc4/thing_idle_07.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/dlc4/thing_death_01.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Idle] = [
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
		this.m.Flags.add("boss", ::Const.EntityType.TricksterGod);
		this.m.Flags.add("regen_armor");

		// can't equip most things
		local items = this.getItems(); 
		items.getData()[::Const.ItemSlot.Offhand][0] = -1;
		items.getData()[::Const.ItemSlot.Mainhand][0] = -1;
		items.getData()[::Const.ItemSlot.Body][0] = -1;
		items.getData()[::Const.ItemSlot.Ammo][0] = -1;
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.nggh_mod_player_beast.onDeath(_killer, _skill, _tile, _fatalityType);
		local flip = this.m.IsCorpseFlipped;

		if (_tile != null)
		{
			this.spawnBloodPool(_tile, 1);
			local sprite_body = this.getSprite("body");
			local sprite_head = this.getSprite("head");
			local decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead", ::Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = sprite_body.Color;
			decal.Saturation = sprite_body.Saturation;
			decal.Scale = 0.9;
			decal.setBrightness(0.9);
			decal = _tile.spawnDetail("bust_trickster_god_head_01_dead", ::Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = sprite_head.Color;
			decal.Saturation = sprite_head.Saturation;
			decal.Scale = 0.9;
			decal.setBrightness(0.9);

			this.spawnTerrainDropdownEffect(_tile);
			local corpse = clone ::Const.Corpse;
			corpse.CorpseName = this.getName();
			corpse.IsResurrectable = false;
			corpse.IsConsumable = _fatalityType != ::Const.FatalityType.Unconscious;
			corpse.IsHeadAttached = _fatalityType != ::Const.FatalityType.Decapitated;
			corpse.Items = _fatalityType != ::Const.FatalityType.Unconscious ? this.getItems() : null;
			corpse.Armor = this.m.BaseProperties.Armor;
			corpse.Tile = _tile;
			corpse.Value = 10.0;
			corpse.IsPlayer = true;
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
						ColorMin = ::createColor("ffffff5f"),
						ColorMax = ::createColor("ffffff5f"),
						ScaleMin = 1.0,
						ScaleMax = 1.0,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = ::createVec(-1.0, -1.0),
						DirectionMax = ::createVec(1.0, 1.0),
						SpawnOffsetMin = ::createVec(-10, -10),
						SpawnOffsetMax = ::createVec(10, 10),
						ForceMin = ::createVec(0, 0),
						ForceMax = ::createVec(0, 0)
					},
					{
						LifeTimeMin = 1.0,
						LifeTimeMax = 1.0,
						ColorMin = ::createColor("ffffff2f"),
						ColorMax = ::createColor("ffffff2f"),
						ScaleMin = 0.9,
						ScaleMax = 0.9,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = ::createVec(-1.0, -1.0),
						DirectionMax = ::createVec(1.0, 1.0),
						ForceMin = ::createVec(0, 0),
						ForceMax = ::createVec(0, 0)
					},
					{
						LifeTimeMin = 0.1,
						LifeTimeMax = 0.1,
						ColorMin = ::createColor("ffffff00"),
						ColorMax = ::createColor("ffffff00"),
						ScaleMin = 0.1,
						ScaleMax = 0.1,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = ::createVec(-1.0, -1.0),
						DirectionMax = ::createVec(1.0, 1.0),
						ForceMin = ::createVec(0, 0),
						ForceMax = ::createVec(0, 0)
					}
				]
			};

			::Tactical.spawnParticleEffect(false, effect.Brushes, _tile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, ::createVec(0, 40));
		}
	}

	function onCombatFinished()
	{
		this.getSprite("head").setBrush("bust_trickster_god_head_01");
		this.nggh_mod_player_beast.onCombatFinished();
	}

	function onAfterFactionChanged()
	{
		local flip = this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("head").setHorizontalFlipping(flip);
		this.getSprite("injury").setHorizontalFlipping(flip);
		this.getSprite("accessory").setHorizontalFlipping(!flip);
		this.getSprite("accessory_special").setHorizontalFlipping(!flip);

		this.nggh_mod_player_beast.onAfterFactionChanged();
	}

	function onInit()
	{
		this.nggh_mod_player_beast.onInit();
		local b = this.m.BaseProperties;
		b.IsImmuneToPoison = true;
		b.IsImmuneToDisarm = true;
		b.IsImmuneToRoot = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsAffectedByRain = false;
		b.DailyFood = 20;
		
		this.m.ActionPoints = b.ActionPoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = ::Const.DefaultMovementAPCost;
		this.m.FatigueCosts = ::Const.DefaultMovementFatigueCost;
		this.m.MaxTraversibleLevels = 3;
		
		local body = this.getSprite("body");
		body.setBrush("bust_trickster_god_body_01");
		local injury_body = this.addSprite("injury");
		injury_body.Visible = false;
		injury_body.setBrush("bust_trickster_god_01_injured");
		this.addSprite("accessory");
		this.addSprite("accessory_special");
		local head = this.addSprite("head");
		head.setBrush("bust_trickster_god_head_01");

		foreach( a in ::Const.CharacterSprites.Helmets )
		{
			this.addSprite(a);
		}

		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.65;
		this.setSpriteOffset("status_rooted", ::createVec(-10, 16));
		this.setSpriteOffset("status_stunned", ::createVec(-32, 30));
		this.setSpriteOffset("arrow", ::createVec(0, 10));
	}

	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.nggh_mod_player_beast.onAppearanceChanged(_appearance, _setDirty);
		this.onAdjustingSprite(_appearance);
	}
	
	function onAdjustingSprite( _appearance )
	{
		local v = ::createVec(23, 0);

		foreach( a in ::Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.setSpriteOffset(a, v);
			this.getSprite(a).Scale = 1.2;
		}

		this.setSpriteOffset("accessory", ::createVec(15, 5));
		this.setSpriteOffset("accessory_special", ::createVec(15, 5));
		this.setAlwaysApplySpriteOffset(true);
	}
	
	function onAfterInit()
	{
		this.nggh_mod_player_beast.onAfterInit();
		this.m.Skills.add(::new("scripts/skills/racial/trickster_god_racial"));
		this.m.Skills.add(::new("scripts/skills/actives/teleport_skill"));
		this.m.Skills.add(::new("scripts/skills/actives/gore_skill"));
	}

	function setStartValuesEx( _isElite = false , _parameter_1 = null , _parameter_2 = null , _parameter_3 = null )
	{
		local b = this.m.BaseProperties;
		local type = ::Const.EntityType.TricksterGod;
		b.setValues(::Const.Tactical.Actor.TricksterGod);
		this.addDefaultBackground(type);
		
		this.setScenarioValues(type, _isElite);
	}

	function updateVariant()
	{
		local app = this.getItems().getAppearance();
		local brush = this.getSprite("body").getBrush().Name;
		app.Body = brush;
		app.Corpse = brush + "_dead";
	}

	function canEnterBarber()
	{
		return false;
	}

});

