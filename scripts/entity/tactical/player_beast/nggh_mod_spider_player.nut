this.nggh_mod_spider_player <- ::inherit("scripts/entity/tactical/nggh_mod_player_beast", {
	m = {
		DistortTargetA = null,
		DistortTargetPrevA = ::createVec(0, 0),
		DistortTargetB = null,
		DistortTargetPrevB = ::createVec(0, 0),
		DistortTargetC = null,
		DistortTargetPrevC = ::createVec(0, 0),
		DistortTargetHelmet = null,
		DistortTargetPrevHelmet = ::createVec(0, 0),
		DistortAnimationStartTimeA = 0,

		Size = 1.0,
		IsFlipping = false,
		HelmetOffset = [2, -42]
	},

	function isRedback()
	{
		return this.getFlags().get("Type") == ::Const.EntityType.LegendRedbackSpider;
	}

	function getStrengthMult()
	{
		return this.isRedback() ? 2.5 : 1.1;
	}

	function getHitpointsPerVeteranLevel()
	{
		return ::Math.rand(1, 2);
	}

	function getSize()
	{
		return this.m.Size;
	}

	function setSize( _s , _update = true )
	{
		this.m.Size = _s;
		this.m.DecapitateBloodAmount = _s * 0.75;
		this.getSprite("body").Scale = _s;
		this.getSprite("head").Scale = _s;
		this.getSprite("injury").Scale = _s;
		this.getSprite("legs_back").Scale = _s;
		this.getSprite("legs_front").Scale = _s;
		this.getSprite("status_rooted").Scale = _s * 0.65;
		this.getSprite("status_rooted_back").Scale = _s * 0.65;
		local offset = ::createVec(0, -10.0 * (1.0 - _s));
		this.setSpriteOffset("body", offset);
		this.setSpriteOffset("head", offset);
		this.setSpriteOffset("injury", offset);
		this.setSpriteOffset("legs_back", offset);
		this.setSpriteOffset("legs_front", offset);
		this.setSpriteOffset("status_rooted", ::createVec(7, 10 - 10.0 * (1.0 - _s)));
		this.setSpriteOffset("status_rooted_back", ::createVec(7, 10 - 10.0 * (1.0 - _s)));

		if (_update)
		{
			this.setDirty(true);
		}
	}
	
	function create()
	{
		this.nggh_mod_player_beast.create();
		this.m.BloodType = ::Const.BloodType.Green;
		this.m.BloodSplatterOffset = ::createVec(0, 0);
		this.m.DecapitateSplatterOffset = ::createVec(20, -15);
		this.m.DecapitateBloodAmount = 1.0;
		this.m.SignaturePerks = ["Pathfinder", "FastAdaption", "Footwork", "LegendPoisonImmunity"];
		this.m.ExcludedTraits = ::Const.Nggh_ExcludedTraits.Spider;
		this.m.AttributesLevelUp = ::Const.Nggh_AttributesLevelUp.Spider;
		this.m.BonusHealthRecoverMult = 0.75;
		this.m.AttributesMax = {
			Hitpoints = 400,
			Bravery = 150,
			Fatigue = 200,
			Initiative = 300,
			MeleeSkill = 120,
			RangedSkill = 50,
			MeleeDefense = 140,
			RangedDefense = 140,
		};
		this.m.ExcludedInjuries = [
			"injury.fractured_hand",
			"injury.crushed_finger",
			"injury.fractured_elbow",
			"injury.smashed_hand",
			"injury.broken_arm",
			"injury.cut_arm_sinew",
			"injury.cut_arm",
			"injury.split_hand",
			"injury.pierced_hand",
			"injury.pierced_arm_muscles",
			"injury.burnt_hands"
		];
		this.m.Sound[::Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/dlc2/giant_spider_idle_12.wav",
			"sounds/enemies/dlc2/giant_spider_idle_13.wav",
			"sounds/enemies/dlc2/giant_spider_idle_14.wav",
			"sounds/enemies/dlc2/giant_spider_idle_15.wav",
			"sounds/enemies/dlc2/giant_spider_idle_16.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/dlc2/giant_spider_hurt_01.wav",
			"sounds/enemies/dlc2/giant_spider_hurt_02.wav",
			"sounds/enemies/dlc2/giant_spider_hurt_03.wav",
			"sounds/enemies/dlc2/giant_spider_hurt_04.wav",
			"sounds/enemies/dlc2/giant_spider_hurt_05.wav",
			"sounds/enemies/dlc2/giant_spider_hurt_06.wav",
			"sounds/enemies/dlc2/giant_spider_hurt_07.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/dlc2/giant_spider_idle_04.wav",
			"sounds/enemies/dlc2/giant_spider_idle_05.wav",
			"sounds/enemies/dlc2/giant_spider_idle_06.wav",
			"sounds/enemies/dlc2/giant_spider_idle_07.wav",
			"sounds/enemies/dlc2/giant_spider_idle_08.wav",
		];
		this.m.Sound[::Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/dlc2/giant_spider_flee_01.wav",
			"sounds/enemies/dlc2/giant_spider_flee_02.wav",
			"sounds/enemies/dlc2/giant_spider_flee_03.wav",
			"sounds/enemies/dlc2/giant_spider_flee_04.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/dlc2/giant_spider_death_01.wav",
			"sounds/enemies/dlc2/giant_spider_death_02.wav",
			"sounds/enemies/dlc2/giant_spider_death_03.wav",
			"sounds/enemies/dlc2/giant_spider_death_04.wav",
			"sounds/enemies/dlc2/giant_spider_death_05.wav",
			"sounds/enemies/dlc2/giant_spider_death_06.wav",
			"sounds/enemies/dlc2/giant_spider_death_07.wav",
			"sounds/enemies/dlc2/giant_spider_death_08.wav"
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
		this.m.Sound[::Const.Sound.ActorEvent.Move] = this.m.Sound[::Const.Sound.ActorEvent.Idle];
		this.m.SoundVolume[::Const.Sound.ActorEvent.Move] = 0.7;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Idle] = 2.0;
		this.m.SoundPitch = ::Math.rand(95, 105) * 0.01;
		this.m.Flags.add("regen_armor");
		this.m.Flags.add("spider");

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
			local head = this.getSprite("head");
			local decal = _tile.spawnDetail(this.isRedback() ? "bust_spider_redback_body_01_dead" : "bust_spider_body_01_dead", ::Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = body.Color;
			decal.Saturation = body.Saturation;
			decal.Scale = 0.9 * this.m.Size;
			local body_decal = decal;

			if (_fatalityType != ::Const.FatalityType.Decapitated)
			{
				decal = _tile.spawnDetail(this.isRedback() ? "bust_spider_redback_head_01_dead" : "bust_spider_head_01_dead", ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Color = head.Color;
				decal.Saturation = head.Saturation;
				decal.Scale = 0.9 * this.m.Size;
				local head_decal = decal;

				if (_fatalityType == ::Const.FatalityType.None)
				{
					local corpse_data = {
						Body = body_decal,
						Head = head_decal,
						Start = ::Time.getRealTimeF(),
						Vector = ::createVec(0.0, -1.0),
						Iterations = 0,
						function onCorpseEffect( _data )
						{
							if (::Time.getRealTimeF() - _data.Start > 0.2)
							{
								if (++_data.Iterations > 5)
								{
									return;
								}

								_data.Vector = ::createVec(::Math.rand(-100, 100) * 0.01, ::Math.rand(-100, 100) * 0.01);
								_data.Start = ::Time.getRealTimeF();
							}

							local f = (::Time.getRealTimeF() - _data.Start) / 0.2;
							_data.Body.setOffset(::createVec(0.0 + 0.5 * _data.Vector.X * f, 30.0 + 1.0 * _data.Vector.Y * f));
							_data.Head.setOffset(::createVec(0.0 + 0.5 * _data.Vector.X * f, 30.0 + 1.0 * _data.Vector.Y * f));
							::Time.scheduleEvent(::TimeUnit.Real, 10, _data.onCorpseEffect, _data);
						}

					};
					::Time.scheduleEvent(::TimeUnit.Real, 10, corpse_data.onCorpseEffect, corpse_data);
				}
			}
			else if (_fatalityType == ::Const.FatalityType.Decapitated)
			{
				local layers = [
					"bust_spider_head_01_dead"
				];
				local decap = ::Tactical.spawnHeadEffect(this.getTile(), layers, ::createVec(-50, -10), 0.0, "bust_spider_head_01_dead_bloodpool");
				decap[0].Color = head.Color;
				decap[0].Saturation = head.Saturation;
				decap[0].Scale = 0.9 * this.m.Size;
			}

			if (_skill && _skill.getProjectileType() == ::Const.ProjectileType.Arrow)
			{
				decal = _tile.spawnDetail("bust_spider_body_01_dead_arrows", ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9 * this.m.Size;
			}

			if (_fatalityType == ::Const.FatalityType.Disemboweled)
			{
				decal = _tile.spawnDetail("bust_spider_gut", ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9 * this.m.Size;
			}
			else if (_fatalityType == ::Const.FatalityType.Smashed)
			{
				decal = _tile.spawnDetail("bust_spider_skull", ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9 * this.m.Size;
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
					if (::Math.rand(1, 100) <= 50)
					{
						::new("scripts/items/misc/" + (this.isRedback() ? "legend_redback_poison_gland_item" : "poison_gland_item")).drop(_tile);
					}
					else
					{
						::new("scripts/items/misc/spider_silk_item").drop(_tile);
					}
				}
			}

			::new("scripts/items/misc/spider_silk_item").drop(_tile);
		}
	}

	function onBeforeCombatStarted()
	{
		this.setRenderCallbackEnabled(true);
	}

	/*
	function onCombatStart()
	{
		this.setRenderCallbackEnabled(true);
		this.nggh_mod_player_beast.onCombatStart();
	}
	*/

	function onCombatFinished()
	{
		this.m.DistortTargetA = null;
		this.m.DistortTargetPrevA = ::createVec(0, 0);
		this.m.DistortTargetB = null;
		this.m.DistortTargetPrevB = ::createVec(0, 0);
		this.m.DistortTargetC = null;
		this.m.DistortTargetPrevC = ::createVec(0, 0);
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
		this.getSprite("legs_back").setHorizontalFlipping(flip);
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("legs_front").setHorizontalFlipping(flip);
		this.getSprite("head").setHorizontalFlipping(flip);
		this.getSprite("injury").setHorizontalFlipping(flip);

		this.nggh_mod_player_beast.onAfterFactionChanged();

		//this.m.IsFlipping = !flip;
	}
	
	function onInit()
	{
		this.nggh_mod_player_beast.onInit();
		local b = this.getBaseProperties();
		b.IsAffectedByNight = false;
		b.IsImmuneToPoison = true;
		b.IsImmuneToDisarm = true;
		b.DamageDirectAdd = 0.1;
		
		this.m.ActionPoints = b.ActionPoints;
		this.m.CurrentProperties = clone b;
		this.m.MaxTraversibleLevels = 3;
		this.m.ActionPointCosts = ::Const.DefaultMovementAPCost;
		this.m.FatigueCosts = ::Const.DefaultMovementFatigueCost;
		this.removeSprite("body");

		local legs_back = this.addSprite("legs_back");
		legs_back.setBrush("bust_spider_legs_back");
		this.addSprite("body");
		this.addSprite("accessory");
		this.addSprite("accessory_special");
		local legs_front = this.addSprite("legs_front");
		legs_front.setBrush("bust_spider_legs_front");
		this.addSprite("head");
		local injury = this.addSprite("injury");
		injury.Visible = false;

		foreach( a in ::Const.CharacterSprites.Helmets )
		{
			this.addSprite(a);
		}
		
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.65;
		this.setSpriteOffset("status_rooted", ::createVec(7, 10));
		this.setSpriteOffset("status_stunned", ::createVec(0, -20));
		this.setSpriteOffset("arrow", ::createVec(0, -20));
	}
	
	function onAfterInit()
	{
		this.nggh_mod_player_beast.onAfterInit();
		this.m.Skills.add(::new("scripts/skills/actives/web_skill"));
		this.m.Skills.removeByID("effects.ptr_direct_damage_limiter");
	}

	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		// hide accessory sprite
		_appearance.Accessory = "";
		this.nggh_mod_player_beast.onAppearanceChanged(_appearance, _setDirty);
		this.onAdjustingSprite(_appearance);
	}
	
	function onAdjustingSprite( _appearance )
	{
		local v = ::createVec(this.m.HelmetOffset[0] * this.m.Size, this.m.HelmetOffset[1] * this.m.Size);
		local s = 0.9 * this.m.Size;

		foreach( a in ::Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.setSpriteOffset(a, v);
			this.getSprite(a).Scale = s;
		}

		this.setAlwaysApplySpriteOffset(true);
		this.setDirty(true);
	}
	
	function setStartValuesEx( _isElite = false, _isRedback = false, _size = 0.0, _randomziedSize = true )
	{
		local b = this.m.BaseProperties;
		local type = _isRedback ? ::Const.EntityType.LegendRedbackSpider : ::Const.EntityType.Spider;
		local legs_back = this.getSprite("legs_back");
		local body = this.getSprite("body");
		local legs_front = this.getSprite("legs_front");
		local head = this.getSprite("head");
		local injury = this.getSprite("injury");

		if (_randomziedSize || _size == 0.0)
		{
			_size = _isRedback ? ::Math.rand(90, 100) * 0.01 : ::Math.rand(75, 95) * 0.01;
		}

		switch (true) 
		{
		case _isRedback:
		    b.setValues(::Const.Tactical.Actor.LegendRedbackSpider);
		    legs_back.setBrush("bust_spider_redback_legs_back");
		    body.setBrush("bust_spider_redback_body_0" + ::Math.rand(1, 4));
		    legs_front.setBrush("bust_spider_redback_legs_front");
		    head.setBrush("bust_spider_redback_head_01");
		    injury.setBrush("bust_spider_01_injured");
		    break;
		
		default:
			b.setValues(::Const.Tactical.Actor.Spider);
		    legs_back.setBrush("bust_spider_legs_back");
		    body.setBrush("bust_spider_body_0" + ::Math.rand(1, 4));
		    legs_front.setBrush("bust_spider_legs_front");
		    head.setBrush("bust_spider_head_01");
		    injury.setBrush("bust_spider_01_injured");
		}
		
		// small bonuses
		b.MeleeDefense += 5;
		b.RangedDefense += 5;
		// update the properties
		this.m.CurrentProperties = clone b;
		
		if (::Math.rand(0, 100) < 90)
		{
			body.varySaturation(0.3);
		}

		if (::Math.rand(0, 100) < 90)
		{
			body.varyColor(0.1, 0.1, 0.1);
		}

		if (::Math.rand(0, 100) < 90)
		{
			body.varyBrightness(0.1);
		}

		legs_front.Color = body.Color;
		legs_front.Saturation = body.Saturation;
		legs_back.Color = body.Color;
		legs_back.Saturation = body.Saturation;
		head.Color = body.Color;
		head.Saturation = body.Saturation;
		injury.Visible = false;
		
		this.getSprite("status_rooted").Scale = 0.65;
		this.setSpriteOffset("status_rooted", ::createVec(7, 10));
		this.setSpriteOffset("status_stunned", ::createVec(0, -20));
		this.setSpriteOffset("arrow", ::createVec(0, -20));
		this.addDefaultBackground(type);

		this.setSize(_size, false);
		this.setScenarioValues(type, _isElite);
	}

	function onRender()
	{
		this.nggh_mod_player_beast.onRender();

		if (this.m.DistortTargetA == null)
		{
			this.m.DistortTargetA = this.m.IsFlipping ? ::createVec(0, 1.0 * this.m.Size) : ::createVec(0, -1.0 * this.m.Size);
			this.m.DistortTargetB = !this.m.IsFlipping ? ::createVec(-0.5 * this.m.Size, 0) : ::createVec(0.5 * this.m.Size, 0);
			this.m.DistortTargetC = !this.m.IsFlipping ? ::createVec(0.5 * this.m.Size, 0) : ::createVec(-0.5 * this.m.Size, 0);
			this.m.DistortTargetHelmet = this.m.IsFlipping ? ::createVec(this.m.HelmetOffset[0] * this.m.Size, (this.m.HelmetOffset[1] + 1.0) * this.m.Size) : ::createVec(this.m.HelmetOffset[0] * this.m.Size, (this.m.HelmetOffset[1] - 1.0) * this.m.Size);
			this.m.DistortAnimationStartTimeA = ::Time.getVirtualTimeF() - ::Math.rand(10, 100) * 0.01;
		}

		this.moveSpriteOffset("legs_back", this.m.DistortTargetPrevB, this.m.DistortTargetB, 1.0, this.m.DistortAnimationStartTimeA);
		this.moveSpriteOffset("legs_front", this.m.DistortTargetPrevC, this.m.DistortTargetC, 1.0, this.m.DistortAnimationStartTimeA);
		this.moveSpriteOffset("body", this.m.DistortTargetPrevA, this.m.DistortTargetA, 1.0, this.m.DistortAnimationStartTimeA);
		this.moveSpriteOffset("injury", this.m.DistortTargetPrevA, this.m.DistortTargetA, 1.0, this.m.DistortAnimationStartTimeA);

		foreach( a in ::Const.CharacterSprites.Helmets )
		{
			if (this.getSprite(a).HasBrush && this.getSprite(a).Visible)
			{
				this.moveSpriteOffset(a, this.m.DistortTargetPrevHelmet, this.m.DistortTargetHelmet, 1.0, this.m.DistortAnimationStartTimeA);
			}
		}

		if (this.moveSpriteOffset("head", this.m.DistortTargetPrevA, this.m.DistortTargetA, 1.0, this.m.DistortAnimationStartTimeA))
		{
			this.m.DistortAnimationStartTimeA = ::Time.getVirtualTimeF();
			this.m.DistortTargetPrevA = this.m.DistortTargetA;
			this.m.DistortTargetA = this.m.IsFlipping ? ::createVec(0, 1.0 * this.m.Size) : ::createVec(0, -1.0 * this.m.Size);
			this.m.DistortTargetPrevB = this.m.DistortTargetB;
			this.m.DistortTargetB = !this.m.IsFlipping ? ::createVec(-0.5 * this.m.Size, 0) : ::createVec(0.5 * this.m.Size, 0);
			this.m.DistortTargetPrevC = this.m.DistortTargetC;
			this.m.DistortTargetC = !this.m.IsFlipping ? ::createVec(0.5 * this.m.Size, 0) : ::createVec(-0.5 * this.m.Size, 0);
			this.m.DistortTargetPrevHelmet = this.m.DistortTargetHelmet;	
			this.m.DistortTargetHelmet = this.m.IsFlipping ? ::createVec(this.m.HelmetOffset[0] * this.m.Size, (this.m.HelmetOffset[1] + 1.0) * this.m.Size) : ::createVec(this.m.HelmetOffset[0] * this.m.Size, (this.m.HelmetOffset[1] - 1.0) * this.m.Size);
			this.m.IsFlipping = !this.m.IsFlipping;
		}
	}

	function getBarberSpriteChange()
	{
		return [
			"body",
			"head",
			"legs_back",
			"legs_front",
		];
	}

	function getPossibleSprites( _layer )
	{
		switch (_layer) 
		{
	    case "body":
	        return [
	        	"bust_spider_body_01",
	        	"bust_spider_body_02",
	        	"bust_spider_body_03",
	        	"bust_spider_body_04",
	        	"bust_spider_redback_body_01",
	        	"bust_spider_redback_body_02",
	        	"bust_spider_redback_body_03",
	        	"bust_spider_redback_body_04",
	        ];

	    case "head":
	        return [
	        	"bust_spider_head_01",
	        	"bust_spider_redback_head_01",
	        ];

	    case "legs_back":
	    	return [
	    		"bust_spider_legs_back",
	    		"bust_spider_redback_legs_back",
	    	];

	    case "legs_front":
	    	return [
	    		"bust_spider_legs_front",
	    		"bust_spider_redback_legs_front",
	    	];
		}

		return [];
	}

	function updateVariant()
	{
		local app = this.getItems().getAppearance();
		app.Body = this.getSprite("body").getBrush().Name;
		app.Corpse = this.isRedback() ? "bust_spider_redback_body_01_dead" : "bust_spider_body_01_dead";

		local b = this.m.BaseProperties;
		b.DailyFood = this.isRedback() ? 4 : 2;
	}
	
	function onSerialize( _out )
	{
		this.nggh_mod_player_beast.onSerialize(_out);
		_out.writeF32(this.m.Size);
	}
	
	function onDeserialize( _in )
	{
		this.nggh_mod_player_beast.onDeserialize(_in);
		this.m.Size = _in.readF32();
		this.setSize(this.m.Size);
	}

});

