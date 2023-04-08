this.nggh_mod_alp_player <- ::inherit("scripts/entity/tactical/nggh_mod_player_beast", {
	m = {
		Size = 1,
		ScaleStartTime = 0
	},
	function isDemonAlp()
	{
		return this.getFlags().get("Type") == ::Const.EntityType.LegendDemonAlp;
	} 
	
	function getStrengthMult()
	{
		return this.isDemonAlp() ? 1.55 : 1.25;
	}

	function getHitpointsPerVeteranLevel()
	{
		return ::Math.rand(1, 2);
	}
	
	function getSize()
	{
		return this.m.Size;
	}
	
	function create()
	{
		this.nggh_mod_player_beast.create();
		this.m.BloodType = ::Const.BloodType.Dark;
		this.m.BloodSplatterOffset = ::createVec(0, 0);
		this.m.DecapitateSplatterOffset = ::createVec(20, -20);
		this.m.DecapitateBloodAmount = 1.0;
		this.m.IsFlashingOnHit = false;
		this.m.ExcludedTraits = ::Const.Nggh_ExcludedTraits.Alp;
		this.m.AttributesLevelUp = ::Const.Nggh_AttributesLevelUp.Alp;
		this.m.BonusHealthRecoverMult = 0.67;
		this.m.AttributesMax = {
			Hitpoints = 400,
			Bravery = 250,
			Fatigue = 200,
			Initiative = 200,
			MeleeSkill = 120,
			RangedSkill = 120,
			MeleeDefense = 100,
			RangedDefense = 100,
		};
		this.m.Sound[::Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/dlc2/alp_idle_01.wav",
			"sounds/enemies/dlc2/alp_idle_02.wav",
			"sounds/enemies/dlc2/alp_idle_03.wav",
		];
		this.m.Sound[::Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/dlc2/alp_hurt_01.wav",
			"sounds/enemies/dlc2/alp_hurt_02.wav",
			"sounds/enemies/dlc2/alp_hurt_03.wav",
			"sounds/enemies/dlc2/alp_hurt_04.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/dlc2/alp_flee_01.wav",
			"sounds/enemies/dlc2/alp_flee_02.wav",
			"sounds/enemies/dlc2/alp_flee_03.wav",
			"sounds/enemies/dlc2/alp_flee_04.wav",
			"sounds/enemies/dlc2/alp_flee_05.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/dlc2/alp_idle_04.wav",
			"sounds/enemies/dlc2/alp_idle_05.wav",
			"sounds/enemies/dlc2/alp_idle_13.wav",
			"sounds/enemies/dlc2/alp_idle_14.wav",
			"sounds/enemies/dlc2/alp_idle_15.wav",
		];
		this.m.Sound[::Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/dlc2/alp_death_01.wav",
			"sounds/enemies/dlc2/alp_death_02.wav",
			"sounds/enemies/dlc2/alp_death_03.wav",
			"sounds/enemies/dlc2/alp_death_04.wav",
			"sounds/enemies/dlc2/alp_death_05.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/dlc2/alp_idle_06.wav",
			"sounds/enemies/dlc2/alp_idle_07.wav",
			"sounds/enemies/dlc2/alp_idle_08.wav",
			"sounds/enemies/dlc2/alp_idle_09.wav",
			"sounds/enemies/dlc2/alp_idle_10.wav",
			"sounds/enemies/dlc2/alp_idle_11.wav",
			"sounds/enemies/dlc2/alp_idle_12.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Other1] = [
			"sounds/enemies/dlc2/alp_idle_16.wav",
			"sounds/enemies/dlc2/alp_idle_17.wav",
			"sounds/enemies/dlc2/alp_idle_18.wav",
			"sounds/enemies/dlc2/alp_idle_19.wav",
			"sounds/enemies/dlc2/alp_idle_20.wav",
			"sounds/enemies/dlc2/alp_idle_21.wav",
			"sounds/enemies/dlc2/alp_idle_22.wav",
			"sounds/enemies/dlc2/alp_idle_23.wav"
		];
		this.m.SoundPitch = ::Math.rand(90, 110) * 0.01;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Idle] = 2.0;
		this.m.SoundVolume[::Const.Sound.ActorEvent.Other1] = 1.0;
		this.m.Flags.add("alp");

		// can't not wear body armor
		this.m.Items.getData()[::Const.ItemSlot.Body][0] = -1;
	}
	
	function playIdleSound()
	{
		if (::Math.rand(1, 100) <= 50)
		{
			this.playSound(::Const.Sound.ActorEvent.Other1, ::Const.Sound.Volume.Actor * ::Const.Sound.Volume.ActorIdle * this.m.SoundVolume[::Const.Sound.ActorEvent.Other1] * this.m.SoundVolumeOverall * (::Math.rand(50, 90) * 0.01) * (this.isHiddenToPlayer ? 0.5 : 1.0), this.m.SoundPitch * (::Math.rand(50, 100) * 0.01));
		}
		else
		{
			this.playSound(::Const.Sound.ActorEvent.Idle, ::Const.Sound.Volume.Actor * ::Const.Sound.Volume.ActorIdle * this.m.SoundVolume[::Const.Sound.ActorEvent.Idle] * this.m.SoundVolumeOverall * (::Math.rand(50, 100) * 0.01) * (this.isHiddenToPlayer ? 0.5 : 1.0), this.m.SoundPitch * (::Math.rand(60, 105) * 0.01));
		}
	}

	function onCombatStart()
	{
		// alps are like vampire, they don't like the sun OwO
		if (::World.getTime().IsDaytime)
		{
			this.m.Skills.add(::new("scripts/skills/special/nggh_mod_day_effect"));
		}

		this.nggh_mod_player_beast.onCombatStart();
	}
	
	function loadResources()
	{
		this.nggh_mod_player_beast.loadResources();

		local r3 = [
			"sounds/enemies/dlc2/alp_nightmare_01.wav",
			"sounds/enemies/dlc2/alp_nightmare_02.wav",
			"sounds/enemies/dlc2/alp_nightmare_03.wav",
			"sounds/enemies/dlc2/alp_nightmare_04.wav",
			"sounds/enemies/dlc2/alp_nightmare_05.wav",
			"sounds/enemies/dlc2/alp_nightmare_06.wav"
		];
		local r4 = [
			"sounds/enemies/ghost_death_01.wav",
			"sounds/enemies/ghost_death_02.wav"
		];

		foreach( r in r3 )
		{
			::Tactical.addResource(r);
		}

		foreach( r in r4 )
		{
			::Tactical.addResource(r);
		}
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.nggh_mod_player_beast.onDeath(_killer, _skill, _tile, _fatalityType);
		local flip = this.m.IsCorpseFlipped;
		local isResurrectable = _fatalityType != ::Const.FatalityType.Decapitated;
		local sprite_body = this.getSprite("body");
		local sprite_head = this.getSprite("head");

		if (_tile != null)
		{
			local skin = this.getSprite("body");
			skin.Alpha = 255;
			local decal = _tile.spawnDetail("bust_alp_body_01_dead", ::Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = skin.Color;
			decal.Saturation = skin.Saturation;
			decal.Scale = 0.9;
			decal.setBrightness(0.9);

			if (_fatalityType == ::Const.FatalityType.Decapitated)
			{
				local layers = [
					sprite_head.getBrush().Name + "_dead"
				];
				local decap = ::Tactical.spawnHeadEffect(this.getTile(), layers, ::createVec(-45, 30), 180.0, sprite_head.getBrush().Name + "_bloodpool");

				foreach( sprite in decap )
				{
					sprite.Color = skin.Color;
					sprite.Saturation = skin.Saturation;
					sprite.Scale = 0.9;
					sprite.setBrightness(0.9);
				}
			}
			else
			{
				decal = _tile.spawnDetail(sprite_head.getBrush().Name + "_dead", ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Color = skin.Color;
				decal.Saturation = skin.Saturation;
				decal.Scale = 0.9;
				decal.setBrightness(0.9);
			}

			if (_fatalityType == ::Const.FatalityType.Disemboweled)
			{
				decal = _tile.spawnDetail("bust_alp_guts", ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9;
				decal.setBrightness(0.9);
			}
			else if (_fatalityType == ::Const.FatalityType.Smashed)
			{
				decal = _tile.spawnDetail("bust_alp_skull", ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9;
				decal.setBrightness(0.9);
			}
			else if (_skill && _skill.getProjectileType() == ::Const.ProjectileType.Arrow)
			{
				decal = _tile.spawnDetail("bust_alp_body_01_dead_arrows", ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9;
				decal.setBrightness(0.9);
			}
			else if (_skill && _skill.getProjectileType() == ::Const.ProjectileType.Javelin)
			{
				decal = _tile.spawnDetail("bust_alp_body_01_dead_javelin", ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9;
				decal.setBrightness(0.9);
			}

			this.spawnTerrainDropdownEffect(_tile);
			this.spawnFlies(_tile);
			local corpse = clone ::Const.Corpse;
			corpse.CorpseName = this.getName();
			corpse.IsResurrectable = false;
			corpse.IsConsumable = false;
			corpse.IsHeadAttached = _fatalityType != ::Const.FatalityType.Decapitated;
			corpse.Items = _fatalityType != ::Const.FatalityType.Unconscious ? this.getItems() : null;
			corpse.Tile = _tile;
			corpse.Value = 10.0;
			corpse.IsPlayer = true;
			_tile.Properties.set("Corpse", corpse);
			::Tactical.Entities.addCorpse(_tile);

			if (_fatalityType != ::Const.FatalityType.Unconscious)
			{
				local n = 1 + (::Math.rand(1, 100) <= ::World.Assets.getExtraLootChance() ? 1 : 0);
				if (this.isDemonAlp())
				{
					local r = ::Math.rand(1, 100);
					local loot;

					if (r <= 50)
					{
						loot = ::new("scripts/items/misc/legend_demon_alp_skin_item");
					}
					else
					{
						loot = ::new("scripts/items/misc/legend_demon_third_eye_item");
					}
					
					loot.drop(_tile);
				}

				for( local i = 0; i < n; i = ++i )
				{
					local r = ::Math.rand(1, 100);
					local loot;

					if (r <= 40)
					{
						loot = ::new("scripts/items/misc/parched_skin_item");
					}
					else if (r <= 80)
					{
						loot = ::new("scripts/items/misc/third_eye_item");
					}
					else
					{
						loot = ::new("scripts/items/misc/petrified_scream_item");
					}

					loot.drop(_tile);
				}
			}

			::new("scripts/items/loot/soul_splinter_item").drop(_tile);
		}
		
		// remove the summoned shadow alps, cleaning up the shadow boi UwU
		foreach( ally in ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.PlayerAnimals) )
		{
			if (ally.getFlags().has("alp_shadow") && ally.getFlags().get("Source") == this.getID())
			{
				ally.killSilently();
			}
		}
	}

	function onAfterFactionChanged()
	{
		local flip = this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("head").setHorizontalFlipping(flip);
		this.getSprite("injury").setHorizontalFlipping(flip);
		this.getSprite("background").setHorizontalFlipping(!flip);
		this.getSprite("quiver").setHorizontalFlipping(flip);
		this.getSprite("shaft").setHorizontalFlipping(!flip);
		this.getSprite("accessory").setHorizontalFlipping(!flip);
		this.getSprite("accessory_special").setHorizontalFlipping(!flip);
		this.getSprite("dirt").setHorizontalFlipping(!flip);
		this.getSprite("bandage_1").setHorizontalFlipping(!flip);
		this.getSprite("bandage_2").setHorizontalFlipping(!flip);
		this.getSprite("bandage_3").setHorizontalFlipping(!flip);
		this.getSprite("accessory").setHorizontalFlipping(!flip);
		this.getSprite("accessory_special").setHorizontalFlipping(!flip);

		this.nggh_mod_player_beast.onAfterFactionChanged();
	}

	function onInit()
	{
		this.nggh_mod_player_beast.onInit();
		local b = this.m.BaseProperties;
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToDisarm = true;
		b.IsImmuneToKnockBackAndGrab = true;
		b.DailyFood = 1;
		
		this.m.ActionPoints = b.ActionPoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = ::Const.DefaultMovementAPCost;
		this.m.FatigueCosts = ::Const.DefaultMovementFatigueCost;
		this.removeSprite("body");

		this.addSprite("quiver");
		this.addSprite("body");
		this.addSprite("accessory");
		this.addSprite("accessory_special");
		local bandage2 = this.addSprite("bandage_2");
		bandage2.Visible = false;
		bandage2.setBrush("bandage_clean_02");
		local bandage3 = this.addSprite("bandage_3");
		bandage3.Visible = false;
		bandage3.setBrush("bandage_clean_03");
		
		this.addSprite("shaft");
		this.addSprite("head");
		local injury = this.addSprite("injury");
		injury.setBrush("bust_alp_01_injured");
		injury.Visible = false;

		foreach( a in ::Const.CharacterSprites.Helmets )
		{
			this.addSprite(a);
		}

		local bandage1 = this.addSprite("bandage_1");
		bandage1.Visible = false;
		bandage1.setBrush("bandage_clean_01");
		
		this.addDefaultStatusSprites();
		local body_dirt = this.getSprite("dirt");
		body_dirt.setBrush("bust_body_dirt_02");
		body_dirt.Visible = false;
		this.getSprite("status_rooted").Scale = 0.55;
		this.setSpriteOffset("status_rooted", ::createVec(0, 10));
	}
	
	function onAfterInit()
	{
		this.nggh_mod_player_beast.onAfterInit();
		this.m.Skills.add(::new("scripts/skills/racial/alp_racial"));
	}
	
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		// i prefer to give them a more unique quiver, why not? OwO!!!
		_appearance.Quiver = "bust_goblin_quiver";
		_appearance.HelmetDamage = "";
		_appearance.Helmet = "";
		this.nggh_mod_player_beast.onAppearanceChanged(_appearance, _setDirty);
		this.onAdjustingSprite(_appearance);
	}
	
	function onAdjustingSprite( _appearance )
	{
		local v = ::createVec(5, 0)

		foreach( a in ::Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.setSpriteOffset(a, v);
		}

		this.setAlwaysApplySpriteOffset(true);
	}

	function setStartValuesEx( _isElite = false , _isDemonAlp = false , _assignEquipment = 3 )
	{
		local b = this.m.BaseProperties;
		local type = _isDemonAlp ? ::Const.EntityType.LegendDemonAlp : ::Const.EntityType.Alp;
		local body = this.getSprite("body");
		local head = this.getSprite("head");
		local injury = this.getSprite("injury");

		if (_isDemonAlp)
		{
			b.setValues(::Const.Tactical.Actor.LegendDemonAlp);
			body.setBrush("bust_demonalp_body_01");
			head.setBrush("demon_alp_head");
			injury.setBrush("demon_alp_wounds");
		}
		else
		{
			b.setValues(::Const.Tactical.Actor.Alp);
			// a huge randomized range of initiative like the what the wild alps have
			b.Initiative += ::Math.rand(0, 55);
			this.m.Variant = ::Math.rand(1, 3);
			body.setBrush("bust_alp_body_01");
			head.setBrush("bust_alp_head_0" + this.m.Variant);
			injury.setBrush("bust_alp_01_injured");
		}
		
		// update the properties
		this.m.CurrentProperties = clone b;
		
		body.varySaturation(0.2);
		head.Saturation = body.Saturation;
		injury.Visible = false;
		
		this.getSprite("status_rooted").Scale = 0.55;
		this.setSpriteOffset("status_rooted", ::createVec(0, 10));
		this.addDefaultBackground(type);

		if (_assignEquipment > 2)
		{
			_assignEquipment = ::Math.rand(0, 2);
		}

		if (_assignEquipment == 1)
		{
			this.assignMeleeEquipment();
		}
		else if (_assignEquipment == 2)
		{
			this.assignRangedEquipment();
		}

		this.setScenarioValues(type, _isElite);
	}

	function setScenarioValues( _type, _isElite = false, _randomizedTalents = false, _setName = false )
	{
		this.nggh_mod_player_beast.setScenarioValues(_type, _isElite, _randomizedTalents, _setName);

		if (!::Nggh_MagicConcept.IsOPMode && _type == ::Const.EntityType.LegendDemonAlp && this.getBaseProperties().Initiative > 900)
		{
			this.getBaseProperties().Initiative -= 925;
		}
	}
	
	function assignMeleeEquipment()
	{
		if (this.m.Items.getItemAtSlot(::Const.ItemSlot.Mainhand) == null)
		{
			local weapons = [
				"military_pick",
				"ancient/falx",
				"barbarians/thorned_whip",
				"greenskins/goblin_falchion",
				"greenskins/goblin_spear",
				"oriental/light_southern_mace",
				"oriental/saif",
			];

			if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Offhand))
			{
				weapons.extend([
					"barbarians/heavy_rusty_axe",
					"barbarians/two_handed_spiked_mace",
					"greenskins/goblin_pike",
				]);
			}

			this.m.Items.equip(::new("scripts/items/weapons/" + ::MSU.Array.rand(weapons)));
		}

		if (this.m.Items.getItemAtSlot(::Const.ItemSlot.Offhand) == null && ::Math.rand(1, 2) == 1)
		{
			this.m.Items.equip(::new("scripts/items/shields/greenskins/goblin_heavy_shield"));
		}
	}

	function assignRangedEquipment()
	{
		if (this.m.Items.getItemAtSlot(::Const.ItemSlot.Mainhand) == null)
		{
			this.m.Items.equip(::new("scripts/items/weapons/" + (::Math.rand(1, 2) == 1 ? "greenskins/goblin_heavy_bow" : "oriental/composite_bow")));
		}

		this.m.Items.equip(::new("scripts/items/ammo/quiver_of_arrows"));
		this.m.Items.addToBag(::new("scripts/items/weapons/greenskins/goblin_notched_blade"));
	}

	function getPossibleSprites( _layer )
	{
		switch (_layer) 
		{
	    case "body":
	       	return [
	        	"bust_alp_body_01",
	        	"bust_demonalp_body_01"
	        ];

	    case "head":
	       	return [
	        	"bust_alp_head_01",
	        	"bust_alp_head_02",
	        	"bust_alp_head_03",
	        	"demon_alp_head",
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

		if (this.isDemonAlp())
		{
			this.m.BaseProperties.InitiativeForTurnOrderAdditional = 900;

			if (!::Nggh_MagicConcept.IsOPMode && this.m.BaseProperties.Initiative > 900)
			{
				this.m.BaseProperties.Initiative -= 925;
			}
		}
	}

	function updateInjuryVisuals( _setDirty = true )
	{
		this.player.updateInjuryVisuals(_setDirty);
	}

	function grow( _parameter = false )
	{
		// do nothing UwU
	}

});

