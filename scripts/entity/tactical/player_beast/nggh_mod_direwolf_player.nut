this.nggh_mod_direwolf_player <- ::inherit("scripts/entity/tactical/nggh_mod_player_beast", {
	m = {},
	function isHigh()
	{
		return this.getFlags().has("frenzy");
	}

	function isWhiteWolf()
	{
		return this.getFlags().get("Type") == ::Const.EntityType.LegendWhiteDirewolf;
	} 

	function getStrengthMult()
	{
		return this.isWhiteWolf() ? 3.5 : 1.2;
	}

	function getHitpointsPerVeteranLevel()
	{
		return ::Math.rand(1, 2);
	}
	
	function create()
	{
		this.nggh_mod_player_beast.create();
		this.m.BloodType = ::Const.BloodType.Red;
		this.m.BloodSplatterOffset = ::createVec(0, 0);
		this.m.DecapitateSplatterOffset = ::createVec(-10, -25);
		this.m.DecapitateBloodAmount = 1.0;
		this.m.SignaturePerks = ["Pathfinder"];
		this.m.ExcludedTraits = ::Const.Nggh_ExcludedTraits.Direwolf;
		this.m.AttributesLevelUp = ::Const.Nggh_AttributesLevelUp.Direwolf;
		this.m.BonusHealthRecoverMult = 1.0;
		this.m.AttributesMax = {
			Hitpoints = 350,
			Bravery = 250,
			Fatigue = 350,
			Initiative = 350,
			MeleeSkill = 135,
			RangedSkill = 50,
			MeleeDefense = 125,
			RangedDefense = 125,
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
			"sounds/enemies/werewolf_idle_01.wav",
			"sounds/enemies/werewolf_idle_02.wav",
			"sounds/enemies/werewolf_idle_03.wav",
			"sounds/enemies/werewolf_idle_04.wav",
			"sounds/enemies/werewolf_idle_05.wav",
		];
		this.m.Sound[::Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/werewolf_hurt_01.wav",
			"sounds/enemies/werewolf_hurt_02.wav",
			"sounds/enemies/werewolf_hurt_03.wav",
			"sounds/enemies/werewolf_hurt_04.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/werewolf_fatigue_01.wav",
			"sounds/enemies/werewolf_fatigue_02.wav",
			"sounds/enemies/werewolf_fatigue_03.wav",
		];
		this.m.Sound[::Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/werewolf_flee_01.wav",
			"sounds/enemies/werewolf_flee_02.wav",
			"sounds/enemies/werewolf_flee_03.wav",
			"sounds/enemies/werewolf_flee_04.wav",
			"sounds/enemies/werewolf_flee_05.wav",
			"sounds/enemies/werewolf_flee_06.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/werewolf_death_01.wav",
			"sounds/enemies/werewolf_death_02.wav",
			"sounds/enemies/werewolf_death_03.wav",
			"sounds/enemies/werewolf_death_04.wav",
			"sounds/enemies/werewolf_death_05.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/werewolf_idle_06.wav",
			"sounds/enemies/werewolf_idle_07.wav",
			"sounds/enemies/werewolf_idle_08.wav",
			"sounds/enemies/werewolf_idle_09.wav",
			"sounds/enemies/werewolf_idle_10.wav",
			"sounds/enemies/werewolf_idle_11.wav",
			"sounds/enemies/werewolf_idle_12.wav",
			"sounds/enemies/werewolf_idle_13.wav",
			"sounds/enemies/werewolf_idle_14.wav",
			"sounds/enemies/werewolf_idle_15.wav",
			"sounds/enemies/werewolf_idle_16.wav",
			"sounds/enemies/werewolf_idle_17.wav",
			"sounds/enemies/werewolf_idle_18.wav",
			"sounds/enemies/werewolf_idle_19.wav",
			"sounds/enemies/werewolf_idle_20.wav",
			"sounds/enemies/werewolf_idle_21.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Attack] = [
			"sounds/enemies/werewolf_idle_01.wav",
			"sounds/enemies/werewolf_idle_02.wav",
			"sounds/enemies/werewolf_idle_03.wav",
			"sounds/enemies/werewolf_idle_05.wav",
			"sounds/enemies/werewolf_idle_06.wav",
			"sounds/enemies/werewolf_idle_07.wav",
			"sounds/enemies/werewolf_idle_08.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Move] = [
			"sounds/enemies/werewolf_fatigue_01.wav",
			"sounds/enemies/werewolf_fatigue_02.wav",
			"sounds/enemies/werewolf_fatigue_03.wav",
			"sounds/enemies/werewolf_fatigue_04.wav",
			"sounds/enemies/werewolf_fatigue_05.wav",
			"sounds/enemies/werewolf_fatigue_06.wav",
			"sounds/enemies/werewolf_fatigue_07.wav"
		];
		this.m.SoundVolume[::Const.Sound.ActorEvent.Attack] = 0.8;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Move] = 0.7;
		this.m.SoundPitch = ::Math.rand(95, 105) * 0.01;
		this.m.Flags.add("regen_armor");
		this.m.Flags.add("wolf");

		// can't equip most things
		local items = this.getItems(); 
		items.getData()[::Const.ItemSlot.Offhand][0] = -1;
		items.getData()[::Const.ItemSlot.Mainhand][0] = -1;
		items.getData()[::Const.ItemSlot.Body][0] = -1;
		items.getData()[::Const.ItemSlot.Ammo][0] = -1;
	}

	function playAttackSound()
	{
		if (::Math.rand(1, 100) <= 50)
		{
			this.playSound(::Const.Sound.ActorEvent.Attack, ::Const.Sound.Volume.Actor * this.m.SoundVolume[::Const.Sound.ActorEvent.Attack] * (::Math.rand(75, 100) * 0.01), this.m.SoundPitch * 1.15);
		}
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.nggh_mod_player_beast.onDeath(_killer, _skill, _tile, _fatalityType);
		local flip = this.m.IsCorpseFlipped;

		if (_tile != null)
		{
			local body = this.getSprite("body");
			local head = this.getSprite("head");
			local head_frenzy = this.getSprite("head_frenzy");
			local decal = _tile.spawnDetail("bust_direwolf_01_body_dead", ::Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = body.Color;
			decal.Saturation = body.Saturation;
			decal.Scale = 0.95;

			if (_fatalityType != ::Const.FatalityType.Decapitated)
			{
				decal = _tile.spawnDetail(head.getBrush().Name + "_dead", ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Color = head.Color;
				decal.Saturation = head.Saturation;
				decal.Scale = 0.95;

				if (head_frenzy.HasBrush)
				{
					decal = _tile.spawnDetail(head_frenzy.getBrush().Name + "_dead", ::Const.Tactical.DetailFlag.Corpse, flip);
					decal.Scale = 0.95;
				}
			}
			else if (_fatalityType == ::Const.FatalityType.Decapitated)
			{
				local layers = [
					head.getBrush().Name + "_dead"
				];

				if (head_frenzy.HasBrush)
				{
					layers.push(head_frenzy.getBrush().Name + "_dead");
				}

				local decap = ::Tactical.spawnHeadEffect(this.getTile(), layers, ::createVec(0, 0), 0.0, "bust_direwolf_head_bloodpool");
				decap[0].Color = head.Color;
				decap[0].Saturation = head.Saturation;
				decap[0].Scale = 0.95;

				if (head_frenzy.HasBrush)
				{
					decap[1].Scale = 0.95;
				}
			}

			if (_skill && _skill.getProjectileType() == ::Const.ProjectileType.Arrow)
			{
				decal = _tile.spawnDetail("bust_direwolf_01_body_dead_arrows", ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.95;
			}
			else if (_skill && _skill.getProjectileType() == ::Const.ProjectileType.Javelin)
			{
				decal = _tile.spawnDetail("bust_direwolf_01_body_dead_javelin", ::Const.Tactical.DetailFlag.Corpse, flip);
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
			corpse.Armor = this.m.BaseProperties.Armor;
			corpse.Tile = _tile;
			corpse.Value = 10.0;
			corpse.IsPlayer = true;
			_tile.Properties.set("Corpse", corpse);
			::Tactical.Entities.addCorpse(_tile);

			if (this.isHigh())
			{
				::new("scripts/items/loot/sabertooth_item").drop(_tile);
			}

			if (_fatalityType == ::Const.FatalityType.Unconscious)
			{
				return;
			}

			local n = 1 + (::Math.rand(1, 100) <= ::World.Assets.getExtraLootChance() ? 1 : 0);

			for( local i = 0; i < n; ++i )
			{
				if (::Math.rand(1, 100) <= 50)
				{
					if (::Math.rand(1, 100) <= 70)
					{
						::new("scripts/items/misc/" + (this.isWhiteWolf() ? "legend_white_wolf_pelt_item" : "werewolf_pelt_item")).drop(_tile);
					}
					else
					{
						::new("scripts/items/misc/adrenaline_gland_item").drop(_tile);
					}
				}
				else
				{
					::new("scripts/items/supplies/strange_meat_item").drop(_tile);
				}
			}
		}
	}

	function onAfterFactionChanged()
	{
		local flip = this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("head").setHorizontalFlipping(flip);
		this.getSprite("injury").setHorizontalFlipping(flip);
		this.getSprite("head_frenzy").setHorizontalFlipping(flip);
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
		
		this.m.ActionPoints = b.ActionPoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = ::Const.DefaultMovementAPCost;
		this.m.FatigueCosts = ::Const.DefaultMovementFatigueCost;
		
		this.addSprite("accessory");
		this.addSprite("accessory_special");
		this.addSprite("head");
		this.addSprite("head_frenzy");
		this.addSprite("injury");

		foreach( a in ::Const.CharacterSprites.Helmets )
		{
			this.addSprite(a);
		}

		local body_blood = this.addSprite("body_blood");
		body_blood.Visible = false;
		
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.54;
		this.setSpriteOffset("status_rooted", ::createVec(0, 0));
	}
	
	function onAfterInit()
	{
		this.nggh_mod_player_beast.onAfterInit();
		this.m.Skills.add(::new("scripts/skills/actives/werewolf_bite"));
	}
	
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.nggh_mod_player_beast.onAppearanceChanged(_appearance, _setDirty);
		this.onAdjustingSprite(_appearance);
	}
	
	function onAdjustingSprite( _appearance )
	{
		local v = ::createVec(17, -15);

		foreach( a in ::Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.setSpriteOffset(a, v);
			this.getSprite(a).Scale = 1.05;
		}

		local special = _appearance != null && _appearance.Accessory == "sergeant_trophy";
		local offSet = special ? ::createVec(4, 5) : ::createVec(10, 0);
		this.setSpriteOffset("accessory", offSet);
		this.setSpriteOffset("accessory_special", offSet);
		this.getSprite("accessory").Scale = 0.95;
		this.getSprite("accessory_special").Scale = 0.95;
		this.setAlwaysApplySpriteOffset(true);
	}
	
	function setStartValuesEx( _isElite = false , _isWhiteWolf = false , _isFrenzied = false , _FrenzyChance = 25 )
	{
		local b = this.m.BaseProperties;
		local type = _isWhiteWolf ? ::Const.EntityType.LegendWhiteDirewolf : ::Const.EntityType.Direwolf;
		local body = this.getSprite("body");
		local head = this.getSprite("head");
		local head_frenzy = this.getSprite("head_frenzy");
		local injury = this.getSprite("injury");
		local body_blood = this.getSprite("body_blood");

		if (!_isFrenzied && !_isWhiteWolf && ::Math.rand(1, 100) <= _FrenzyChance)
		{
			_isFrenzied = true;
		}

		switch (true) 
		{
		case _isWhiteWolf:
		    b.setValues(::Const.Tactical.Actor.LegendWhiteDirewolf);
			body.setBrush("bust_direwolf_white_01_body");
			head.setBrush("bust_direwolf_white_01_head");
			injury.setBrush("bust_direwolf_white_injured");
		    break;

		case _isFrenzied:
		    b.setValues(::Const.Tactical.Actor.FrenziedDirewolf);
		    b.DamageTotalMult = 1.25;
		    body.setBrush("bust_direwolf_0" + ::Math.rand(1, 3));
			head.setBrush("bust_direwolf_0" + ::Math.rand(1, 3) + "_head");
		    head_frenzy.setBrush(this.getSprite("head").getBrush().Name + "_frenzy");
		    injury.setBrush("bust_direwolf_injured");
			this.getFlags().add("frenzy");
		    break;
		
		default:
			b.setValues(::Const.Tactical.Actor.Direwolf);
			body.setBrush("bust_direwolf_0" + ::Math.rand(1, 3));
			head.setBrush("bust_direwolf_0" + ::Math.rand(1, 3) + "_head");
			injury.setBrush("bust_direwolf_injured");
		}

		// update the properties
		this.m.CurrentProperties = clone b;
		
		if (::Math.rand(0, 100) < 90)
		{
			body.varySaturation(0.2);
		}

		if (::Math.rand(0, 100) < 90)
		{
			body.varyColor(0.05, 0.05, 0.05);
		}

		head.Color = body.Color;
		head.Saturation = body.Saturation;
		injury.Visible = false;
		body_blood.Visible = false;

		this.getSprite("status_rooted").Scale = 0.54;
		this.setSpriteOffset("status_rooted", ::createVec(0, 0));
		this.addDefaultBackground(type);

		if (!_isWhiteWolf && !_isFrenzied)
		{
			this.getBackground().addPerk(::Const.Perks.PerkDefs.NggHWolfRabies, 6);
		}

		this.setScenarioValues(type, _isElite);
	}

	function getBarberSpriteChange()
	{
		return [
			"body",
			"head",
			"head_frenzy",
		];
	}

	function getPossibleSprites( _layer )
	{
		switch (_layer) 
		{
	    case "body":
	        return [
	        	"bust_direwolf_01",
	        	"bust_direwolf_02",
	        	"bust_direwolf_03",
	        	"bust_direwolf_white_01_body",
	        ];

	    case "head":
	        return [
	        	"bust_direwolf_01_head",
	        	"bust_direwolf_02_head",
	        	"bust_direwolf_03_head",
	        	"bust_direwolf_white_01_head",
	        ];
		}

		return [];
	}

	function updateVariant()
	{
		local app = this.getItems().getAppearance();
		app.Body = this.getSprite("body").getBrush().Name;
		app.Corpse = "bust_direwolf_01_body_dead";

		local b = this.m.BaseProperties;
		b.DailyFood = this.isWhiteWolf() ? 5 : 3;
		b.DailyFood = this.isHigh() ? b.DailyFood + 1 : b.DailyFood;
	}

});

