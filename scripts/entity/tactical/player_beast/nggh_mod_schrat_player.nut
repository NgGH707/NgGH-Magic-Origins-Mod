this.nggh_mod_schrat_player <- ::inherit("scripts/entity/tactical/nggh_mod_player_beast", {
	m = {},
	function isGreenWood()
	{
		return this.getFlags().get("Type") == ::Const.EntityType.LegendGreenwoodSchrat;
	}

	function getStrengthMult()
	{
		return this.isGreenWood() ? 5.0 : 2.1;
	}

	function getHitpointsPerVeteranLevel()
	{
		return ::Math.rand(1, 3);
	}
	
	function create()
	{
		this.nggh_mod_player_beast.create();
		this.m.BloodType = ::Const.BloodType.Wood;
		this.m.BloodSplatterOffset = ::createVec(0, 0);
		this.m.DecapitateSplatterOffset = ::createVec(-10, -25);
		this.m.DecapitateBloodAmount = 1.0;
		this.m.SignaturePerks = ["Pathfinder"];
		this.m.ExcludedTraits = ::Const.Nggh_ExcludedTraits.Schrat;
		this.m.AttributesLevelUp = ::Const.Nggh_AttributesLevelUp.Schrat;
		this.m.BonusHealthRecoverMult = 3.5;
		this.m.AttributesMax = {
			Hitpoints = 1000,
			Bravery = 400,
			Fatigue = 500,
			Initiative = 150,
			MeleeSkill = 150,
			RangedSkill = 50,
			MeleeDefense = 85,
			RangedDefense = 85,
		};
		this.m.Sound[::Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/ambience/terrain/forest_branch_crack_00.wav",
			"sounds/ambience/terrain/forest_branch_crack_01.wav",
			"sounds/ambience/terrain/forest_branch_crack_02.wav",
		];
		this.m.Sound[::Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/dlc2/schrat_shield_damage_01.wav",
			"sounds/enemies/dlc2/schrat_shield_damage_02.wav",
			"sounds/enemies/dlc2/schrat_shield_damage_03.wav",
			"sounds/enemies/dlc2/schrat_shield_damage_04.wav",
			"sounds/enemies/dlc2/schrat_shield_damage_05.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Fatigue] = [
			"sounds/ambience/terrain/forest_branch_crack_00.wav",
			"sounds/ambience/terrain/forest_branch_crack_01.wav",
			"sounds/ambience/terrain/forest_branch_crack_02.wav",
			"sounds/ambience/terrain/forest_branch_crack_03.wav",
			"sounds/ambience/terrain/forest_branch_crack_04.wav",
			"sounds/ambience/terrain/forest_branch_crack_05.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/dlc2/schrat_death_01.wav",
			"sounds/enemies/dlc2/schrat_death_02.wav",
			"sounds/enemies/dlc2/schrat_death_03.wav",
			"sounds/enemies/dlc2/schrat_death_04.wav",
			"sounds/enemies/dlc2/schrat_death_05.wav",
			"sounds/enemies/dlc2/schrat_death_06.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/dlc2/schrat_death_01.wav",
			"sounds/enemies/dlc2/schrat_death_02.wav",
			"sounds/enemies/dlc2/schrat_death_03.wav",
			"sounds/enemies/dlc2/schrat_death_04.wav",
			"sounds/enemies/dlc2/schrat_death_05.wav",
			"sounds/enemies/dlc2/schrat_death_06.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/dlc2/schrat_idle_01.wav",
			"sounds/enemies/dlc2/schrat_idle_02.wav",
			"sounds/enemies/dlc2/schrat_idle_03.wav",
			"sounds/enemies/dlc2/schrat_idle_04.wav",
			"sounds/enemies/dlc2/schrat_idle_05.wav",
			"sounds/enemies/dlc2/schrat_idle_06.wav",
			"sounds/enemies/dlc2/schrat_idle_07.wav",
			"sounds/enemies/dlc2/schrat_idle_08.wav",
			"sounds/enemies/dlc2/schrat_idle_09.wav",
			"sounds/ambience/terrain/forest_branch_crack_00.wav",
			"sounds/ambience/terrain/forest_branch_crack_01.wav",
			"sounds/ambience/terrain/forest_branch_crack_02.wav",
			"sounds/ambience/terrain/forest_branch_crack_03.wav",
			"sounds/ambience/terrain/forest_branch_crack_04.wav",
			"sounds/ambience/terrain/forest_branch_crack_05.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Other1] = [
			"sounds/enemies/dlc2/schrat_hurt_shield_down_01.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_down_02.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_down_03.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_down_04.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_down_05.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_down_06.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Other2] = [
			"sounds/enemies/dlc2/schrat_hurt_shield_up_01.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_up_02.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_up_03.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_up_04.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_up_05.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_up_06.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Move] = this.m.Sound[::Const.Sound.ActorEvent.Idle];
		this.m.SoundVolume[::Const.Sound.ActorEvent.DamageReceived] = 5.0;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Other1] = 5.0;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Other2] = 5.0;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Death] = 5.0;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Idle] = 2.0;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Move] = 2.0;
		this.m.SoundPitch = ::Math.rand(95, 105) * 0.01;
		this.m.Flags.add("schrat");

		// can't equip most things
		local items = this.getItems(); 
		items.getData()[::Const.ItemSlot.Mainhand][0] = -1;
		items.getData()[::Const.ItemSlot.Body][0] = -1;
		items.getData()[::Const.ItemSlot.Ammo][0] = -1;
	}

	function playSound( _type, _volume, _pitch = 1.0 )
	{
		if (_type == ::Const.Sound.ActorEvent.DamageReceived && !this.isArmedWithShield())
		{
			_type = ::Const.Sound.ActorEvent.Other1;
		}

		this.nggh_mod_player_beast.playSound(_type, _volume, _pitch);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.nggh_mod_player_beast.onDeath(_killer, _skill, _tile, _fatalityType);
		local flip = this.m.IsCorpseFlipped;

		if (_tile != null)
		{
			local body = this.getSprite("body");
			local head = this.getSprite("head");
			local decal = _tile.spawnDetail(body.getBrush().Name + "_dead", ::Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = body.Color;
			decal.Saturation = body.Saturation;
			decal.Scale = 0.95;
			decal = _tile.spawnDetail(head.getBrush().Name + "_dead", ::Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = head.Color;
			decal.Saturation = head.Saturation;
			decal.Scale = 0.95;

			if (_skill && _skill.getProjectileType() == ::Const.ProjectileType.Arrow)
			{
				decal = _tile.spawnDetail(body.getBrush().Name + "_dead_arrows", ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.95;
			}
			else if (_skill && _skill.getProjectileType() == ::Const.ProjectileType.Javelin)
			{
				decal = _tile.spawnDetail(body.getBrush().Name + "_dead_javelin", ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.95;
			}

			this.spawnTerrainDropdownEffect(_tile);
			local corpse = clone ::Const.Corpse;
			corpse.CorpseName = this.getName();
			corpse.IsResurrectable = false;
			corpse.IsConsumable = false;
			corpse.IsHeadAttached = true;
			corpse.Items = _fatalityType != ::Const.FatalityType.Unconscious ? this.getItems() : null;
			corpse.Tile = _tile;
			corpse.Value = 10.0;
			corpse.IsPlayer = true;
			_tile.Properties.set("Corpse", corpse);
			::Tactical.Entities.addCorpse(_tile);

			if (_fatalityType != ::Const.FatalityType.Unconscious)
			{
				local n = 1 + (::Math.rand(1, 100) <= ::World.Assets.getExtraLootChance() ? 1 : 0);

				for( local i = 0; i < n; ++i )
				{
					if (::Math.rand(1, 100) <= 40)
					{
						::new("scripts/items/misc/" + (this.isGreenWood() ? "legend_ancient_green_wood_item" : "ancient_wood_item")).drop(_tile);
					}
					else if (r <= 80)
					{
						::new("scripts/items/misc/glowing_resin_item").drop(_tile);
					}
					else
					{
						::new("scripts/items/misc/heart_of_the_forest_item").drop(_tile);
					}
				}
			}

			::new("scripts/items/misc/ancient_amber_item").drop(_tile);

			if (::Math.rand(1, 100) <= 5)
			{
				::new("scripts/items/misc/" + (this.isGreenWood() ? "legend_ancient_green_wood_item" : "ancient_wood_item")).drop(_tile);
			}
		}
	}

	function onCombatStart()
	{
		this.nggh_mod_player_beast.onCombatStart();

		if (!this.isArmedWithShield())
		{
			if (this.getHitpointsPct() >= 0.5 && ::Math.rand(1, 100) <= 50)
			{
				return;
			}
			
			if (this.isGreenWood())
			{
				this.getItems().equip(::new("scripts/items/shields/beasts/legend_greenwood_schrat_shield"));
			}
			else 
			{
			 	this.getItems().equip(::new("scripts/items/shields/beasts/schrat_shield"));
			}
		}

		this.changeWeather();
	}

	function changeWeather()
	{
		if (::Tactical.Entities.getFlags().get("WeatherIsChanged"))
		{
			return;
		}

		local clouds = ::Tactical.getWeather().createCloudSettings();
		clouds.Type = this.getconsttable().CloudType.Fog;
		clouds.MinClouds = 20;
		clouds.MaxClouds = 20;
		clouds.MinVelocity = 3.0;
		clouds.MaxVelocity = 9.0;
		clouds.MinAlpha = 0.35;
		clouds.MaxAlpha = 0.45;
		clouds.MinScale = 2.0;
		clouds.MaxScale = 3.0;
		::Tactical.getWeather().buildCloudCover(clouds);
		::Tactical.Entities.getFlags().set("WeatherIsChanged", true);
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
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToRoot = true;
		b.IsImmuneToDisarm = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsIgnoringArmorOnAttack = true;
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;

		this.m.ActionPoints = b.ActionPoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = ::Const.DefaultMovementAPCost;
		this.m.FatigueCosts = ::Const.DefaultMovementFatigueCost;
		
		//this.addSprite("body");
		this.addSprite("accessory");
		this.addSprite("accessory_special");
		this.addSprite("head");
		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_schrat_01_injured");

		foreach( a in ::Const.CharacterSprites.Helmets )
		{
			this.addSprite(a);
		}

		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.54;
		this.setSpriteOffset("status_rooted", ::createVec(0, 0));
		this.setSpriteOffset("status_stunned", ::createVec(0, 10));
		this.setSpriteOffset("arrow", ::createVec(0, 10));
	}
	
	function onAfterInit()
	{
		this.nggh_mod_player_beast.onAfterInit();
		this.m.Skills.add(::new("scripts/skills/actives/uproot_skill"));
		this.m.Skills.add(::new("scripts/skills/actives/uproot_zoc_skill"));
	}

	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.nggh_mod_player_beast.onAppearanceChanged(_appearance, _setDirty);
		this.onAdjustingSprite(_appearance);
	}
	
	function onAdjustingSprite( _appearance )
	{
		local v = ::createVec(14, 0);

		foreach( a in ::Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.setSpriteOffset(a, v);
			this.getSprite(a).Scale = 1.05;
		}

		this.setSpriteOffset("accessory", ::createVec(5, 8));
		this.setSpriteOffset("accessory_special", ::createVec(5, 8));
		this.setAlwaysApplySpriteOffset(true);
	}
	
	function setStartValuesEx( _isElite = false, _isGreenWood = false , _parameter_1 = null, _parameter_2 = null )
	{
		local b = this.m.BaseProperties;
		local type = _isGreenWood ? ::Const.EntityType.LegendGreenwoodSchrat : ::Const.EntityType.Schrat;
		local body = this.getSprite("body");
		local head = this.getSprite("head");
		local injury = this.getSprite("injury");

		switch (true) 
		{
		case _isGreenWood:
		    b.setValues(::Const.Tactical.Actor.LegendGreenwoodSchrat);
			body.setBrush("bust_schrat_green_body_01");
			head.setBrush("bust_schrat_green_head_0" + ::Math.rand(1, 2));
			injury.setBrush("bust_schrat_green_01_injured");
		    break;
		
		default:
			b.setValues(::Const.Tactical.Actor.Schrat);
			body.setBrush("bust_schrat_body_01");
			head.setBrush("bust_schrat_head_0" + ::Math.rand(1, 2));
			injury.setBrush("bust_schrat_01_injured");
		}

		// update the properties
		this.m.CurrentProperties = clone b;
		
		body.varySaturation(0.2);
		body.varyColor(0.05, 0.05, 0.05);
		this.m.BloodColor = body.Color;
		head.Color = body.Color;
		head.Saturation = body.Saturation;
		injury.Visible = false;

		this.getSprite("status_rooted").Scale = 0.54;
		this.setSpriteOffset("status_rooted", ::createVec(0, 0));
		this.setSpriteOffset("status_stunned", ::createVec(0, 10));
		this.setSpriteOffset("arrow", ::createVec(0, 10));
		this.addDefaultBackground(type);

		this.setScenarioValues(type, _isElite);
	}
	
	
	////
	function canEquipThis( _item )
	{
		if (_item.getSlotType() == ::Const.ItemSlot.Offhand)
		{
			return _item.isItemType(::Const.Items.ItemType.Shield);
		}

		return true;
	}
	////


	function getPossibleSprites( _layer )
	{
		switch (_layer) 
		{
	    case "body":
	        return [
	        	"bust_schrat_body_01",
	        	"bust_schrat_green_body_01",
	        ];

	    case "head":
	        return [
	        	"bust_schrat_head_01",
	        	"bust_schrat_head_02",
	        	"bust_schrat_green_head_01",
	        	"bust_schrat_green_head_02",
	        ];
		}

		return [];
	}

	function updateVariant()
	{
		local app = this.getItems().getAppearance();
		local brush = this.getSprite("body").getBrush().Name;
		app.Body = brush;
		app.Corpse = brush + "_dead";

		local b = this.m.BaseProperties;
		b.DailyFood = this.isGreenWood() ? 10 : 6; // very hungry boi UwU
	}

	function onDeserialize( _in )
	{
		this.nggh_mod_player_beast.onDeserialize(_in);
		this.m.BloodColor = this.getSprite("body").Color;
	}

});

