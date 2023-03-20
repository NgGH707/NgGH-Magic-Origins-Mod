this.nggh_mod_serpent_player <- ::inherit("scripts/entity/tactical/nggh_mod_player_beast", {
	m = {},
	function getStrengthMult()
	{
		return this.getLevel() >= 5 ? 1.23 : 1.0;
	}
	
	function setVariants( _v )
	{
		this.m.Variant = _v != 1 ? 2 : 1;
	}
	
	function create()
	{
		this.nggh_mod_player_beast.create();
		this.m.BloodType = ::Const.BloodType.Red;
		this.m.BloodSplatterOffset = ::createVec(0, 5);
		this.m.DecapitateSplatterOffset = ::createVec(15, -26);
		this.m.DecapitateBloodAmount = 1.0;
		this.m.SignaturePerks = ["Pathfinder"];
		this.m.ExcludedTraits = ::Const.Nggh_ExcludedTraits.Serpent;
		this.m.AttributesLevelUp = ::Const.Nggh_AttributesLevelUp.Serpent;
		this.m.BonusHealthRecoverMult = 2.0;
		this.m.HitpointsPerVeteranLevel = 2;
		this.m.AttributesMax = {
			Hitpoints = 400,
			Bravery = 250,
			Fatigue = 300,
			Initiative = 250,
			MeleeSkill = 120,
			RangedSkill = 50,
			MeleeDefense = 120,
			RangedDefense = 120,
		};
		this.m.ExcludedInjuries = [
			"injury.fractured_hand",
			"injury.crushed_finger",
			"injury.fractured_elbow",
			"injury.sprained_ankle",
			"injury.bruised_leg",
			"injury.smashed_hand",
			"injury.broken_arm",
			"injury.broken_leg",
			"injury.cut_arm_sinew",
			"injury.cut_arm",
			"injury.cut_achilles_tendon",
			"injury.split_hand",
			"injury.injured_shoulder",
			"injury.pierced_hand",
			"injury.pierced_arm_muscles",
			"injury.injured_knee_cap",
			"injury.burnt_legs",
			"injury.burnt_hands"
		];
		this.m.Sound[::Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/dlc6/snake_idle_01.wav",
			"sounds/enemies/dlc6/snake_idle_02.wav",
			"sounds/enemies/dlc6/snake_idle_03.wav",
			"sounds/enemies/dlc6/snake_idle_04.wav",
		];
		this.m.Sound[::Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/dlc6/snake_hurt_01.wav",
			"sounds/enemies/dlc6/snake_hurt_02.wav",
			"sounds/enemies/dlc6/snake_hurt_03.wav",
			"sounds/enemies/dlc6/snake_hurt_04.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/dlc6/snake_idle_10.wav",
			"sounds/enemies/dlc6/snake_idle_11.wav",
			"sounds/enemies/dlc6/snake_idle_12.wav",
			"sounds/enemies/dlc6/snake_idle_13.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/dlc6/snake_death_01.wav",
			"sounds/enemies/dlc6/snake_death_02.wav",
			"sounds/enemies/dlc6/snake_death_03.wav",
			"sounds/enemies/dlc6/snake_death_04.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/dlc6/snake_death_01.wav",
			"sounds/enemies/dlc6/snake_death_02.wav",
			"sounds/enemies/dlc6/snake_death_03.wav",
			"sounds/enemies/dlc6/snake_death_04.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/dlc6/snake_idle_01.wav",
			"sounds/enemies/dlc6/snake_idle_02.wav",
			"sounds/enemies/dlc6/snake_idle_03.wav",
			"sounds/enemies/dlc6/snake_idle_04.wav",
			"sounds/enemies/dlc6/snake_idle_05.wav",
			"sounds/enemies/dlc6/snake_idle_06.wav",
			"sounds/enemies/dlc6/snake_idle_07.wav",
			"sounds/enemies/dlc6/snake_idle_08.wav",
			"sounds/enemies/dlc6/snake_idle_09.wav",
		];
		this.m.Sound[::Const.Sound.ActorEvent.Move] = this.m.Sound[::Const.Sound.ActorEvent.Idle];
		this.m.SoundVolume[::Const.Sound.ActorEvent.Move] = 0.7;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Idle] = 2.0;
		this.m.SoundPitch = ::Math.rand(95, 105) * 0.01;
		this.m.Flags.add("regen_armor");
		this.m.Flags.add("serpent");

		// can't equip most things
		local items = this.getItems(); 
		items.getData()[::Const.ItemSlot.Offhand][0] = -1;
		items.getData()[::Const.ItemSlot.Mainhand][0] = -1;
		items.getData()[::Const.ItemSlot.Body][0] = -1;
		items.getData()[::Const.ItemSlot.Ammo][0] = -1;
	}

	function playSound( _type, _volume, _pitch = 1.0 )
	{
		if (_type == ::Const.Sound.ActorEvent.Move && ::Math.rand(1, 100) <= 33)
		{
			return;
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
			local decal = _tile.spawnDetail("bust_snake_body_0" + this.m.Variant + "_dead", ::Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = body.Color;
			decal.Saturation = body.Saturation;
			decal.Scale = 0.9;

			if (_fatalityType != ::Const.FatalityType.Decapitated)
			{
				decal = _tile.spawnDetail("bust_snake_body_0" + this.m.Variant + "_head_dead", ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Color = body.Color;
				decal.Saturation = body.Saturation;
				decal.Scale = 0.9;
			}
			else if (_fatalityType == ::Const.FatalityType.Decapitated)
			{
				local layers = [
					"bust_snake_body_0" + this.m.Variant + "_head_dead"
				];
				local decap = ::Tactical.spawnHeadEffect(this.getTile(), layers, ::createVec(-50, 20), 0.0, "bust_snake_body_head_dead_bloodpool");
				decap[0].Color = body.Color;
				decap[0].Saturation = body.Saturation;
				decap[0].Scale = 0.9;
			}

			this.spawnTerrainDropdownEffect(_tile);
			this.spawnFlies(_tile);
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
			::Tactical.Entities.addCorpse(_tile);

			if (_fatalityType != ::Const.FatalityType.Unconscious)
			{
				local n = 1 + (::Math.rand(1, 100) <= ::World.Assets.getExtraLootChance() ? 1 : 0);

				for( local i = 0; i < n; ++i )
				{
					if (::Math.rand(1, 100) <= 60)
					{
						::new("scripts/items/misc/serpent_skin_item").drop(_tile);
					}
					else
					{
						::new("scripts/items/misc/glistening_scales_item").drop(_tile);
					}
				}
			}

			::new("scripts/items/loot/rainbow_scale_item").drop(_tile);
		}

		//::Tactical.getTemporaryRoster().remove(this);
	}
	
	/*
	function onCombatStart()
	{
		this.nggh_mod_player_beast.onCombatStart();
		this.Tactical.getTemporaryRoster().add(this);
	}

	function onCombatFinished()
	{
		this.nggh_mod_player_beast.onCombatFinished();
		this.Tactical.getTemporaryRoster().remove(this);
	}
	*/

	function onAfterFactionChanged()
	{
		local flip = this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("injury").setHorizontalFlipping(flip);
		this.getSprite("accessory").setHorizontalFlipping(!flip);
		this.getSprite("accessory_special").setHorizontalFlipping(!flip);

		this.nggh_mod_player_beast.onAfterFactionChanged();
	}

	function onInit()
	{
		this.nggh_mod_player_beast.onInit();
		local b = this.m.BaseProperties;
		b.IsAffectedByNight = false;
		b.IsImmuneToDisarm = true;
		b.DailyFood = 3;

		this.m.ActionPoints = b.ActionPoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = ::Const.DefaultMovementAPCost;
		this.m.FatigueCosts = ::Const.DefaultMovementFatigueCost;
		
		//this.addSprite("body");
		this.addSprite("accessory");
		this.addSprite("accessory_special");
		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_snake_injury");

		foreach( a in ::Const.CharacterSprites.Helmets )
		{
			this.addSprite(a);
		}

		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.65;
		this.setSpriteOffset("status_rooted", ::createVec(-10, 20));
		this.setSpriteOffset("status_stunned", ::createVec(-35, 20));
		this.setSpriteOffset("arrow", ::createVec(0, 20));
	}
	
	function onAfterInit()
	{
		this.nggh_mod_player_beast.onAfterInit();
		this.m.Skills.add(::new("scripts/skills/racial/serpent_racial"));
		this.m.Skills.add(::new("scripts/skills/actives/serpent_hook_skill"));
		this.m.Skills.add(::new("scripts/skills/actives/serpent_bite_skill"));
	}

	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.nggh_mod_player_beast.onAppearanceChanged(_appearance, _setDirty);
		this.onAdjustingSprite(_appearance);
	}
	
	function onAdjustingSprite( _appearance )
	{
		local v = ::createVec(48, 38);

		foreach( a in ::Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.setSpriteOffset(a, v);
			this.getSprite(a).Scale = 0.7;
		}

		this.setSpriteOffset("accessory", ::createVec(10, 25));
		this.setSpriteOffset("accessory_special", ::createVec(10, 25));
		this.getSprite("accessory").Scale = 0.6;
		this.getSprite("accessory_special").Scale = 0.6;
		this.setAlwaysApplySpriteOffset(true);
	}
	
	function setStartValuesEx( _isElite = false , _parameter_1 = null, _parameter_2 = null , _parameter_3 = null )
	{
		local b = this.m.BaseProperties;
		local type = ::Const.EntityType.Serpent;
		local body = this.getSprite("body");
		b.setValues(::Const.Tactical.Actor.Serpent);
		b.Initiative += ::Math.rand(0, 50);
		body.setBrush("bust_snake_0" + this.m.Variant + "_head_0" + ::Math.rand(1, 2));

		// update the properties
		this.m.CurrentProperties = clone b;
		this.m.Variant = ::Math.rand(1, 2);
		
		if (this.m.Variant == 2 && ::Math.rand(0, 100) < 90)
		{
			body.varySaturation(0.1);
		}

		if (this.Math.rand(0, 100) < 90)
		{
			body.varyColor(0.1, 0.1, 0.1);
		}

		if (this.Math.rand(0, 100) < 90)
		{
			body.varyBrightness(0.1);
		}

		local injury = this.getSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_snake_injury");
		this.getSprite("status_rooted").Scale = 0.65;
		this.setSpriteOffset("status_rooted", ::createVec(-10, 20));
		this.setSpriteOffset("status_stunned", ::createVec(-35, 20));
		this.setSpriteOffset("arrow", ::createVec(0, 20));
		this.addDefaultBackground(type);

		this.setScenarioValues(type, _isElite);
	}

	function setScenarioValues( _type, _isElite = false, _randomizedTalents = false, _setName = false )
	{
		this.nggh_mod_player_beast.setScenarioValues(_type, _isElite, _randomizedTalents, _setName);

		if (this.m.Skills.hasSkill("racial.champion"))
		{
			this.m.BaseProperties.ActionPoints = 10;
		}
	}

	function getBarberSpriteChange()
	{
		return [
			"body",
		];
	}

	function getPossibleSprites( _layer = "body" )
	{
		return [
			"bust_snake_01_head_01",
	        "bust_snake_02_head_01",
	        "bust_snake_02_head_02",
	        "bust_snake_01_head_02"
		];
	}

});

