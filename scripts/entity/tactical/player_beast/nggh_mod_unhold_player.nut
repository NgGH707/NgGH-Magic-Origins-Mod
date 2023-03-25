this.nggh_mod_unhold_player <- ::inherit("scripts/entity/tactical/nggh_mod_player_beast", {
	m = {},
	function isRockUnhold()
	{
		return this.getFlags().get("Type") == ::Const.EntityType.LegendRockUnhold;
	}

	function isFrostUnhold()
	{
		return this.getFlags().get("Type") == ::Const.EntityType.UnholdFrost;
	}

	function isBear()
	{
		return this.getFlags().get("Type") == ::Const.EntityType.LegendBear;
	}
	
	function getStrengthMult()
	{
		if (this.isBear())
		{
			return 1.75;
		}
		
		if (this.isRockUnhold())
		{
			return 7.0;
		}
		
		return 2.67;
	}

	function getHitpointsPerVeteranLevel()
	{
		return this.isBear() ? ::Math.rand(1, 2) : ::Math.rand(1, 3);
	}

	function getBonusHealthRecoverMult()
	{
		return this.isBear() ? this.m.BonusHealthRecoverMult : this.m.BonusHealthRecoverMult * 5;
	}

	function restoreArmor()
	{
		if (this.isBear())
		{
			this.nggh_mod_player_beast.restoreArmor();
			return;
		}

		local b = this.getBaseProperties();
		local c = this.getCurrentProperties();
		
		for ( local i = 0; i < 2; i = i + 1 )
		{
			local add = ::Math.min(50, b.ArmorMax[i] - b.Armor[i]);
			
			if (add == 0)
			{
				continue;
			}
			
			b.Armor[i] += add;
			c.Armor[i] += add;
		}
	}
	
	function create()
	{
		this.nggh_mod_player_beast.create();
		this.m.BloodType = ::Const.BloodType.Red;
		this.m.BloodSplatterOffset = ::createVec(0, 0);
		this.m.DecapitateSplatterOffset = ::createVec(40, -20);
		this.m.DecapitateBloodAmount = 3.0;
		this.m.SignaturePerks = ["Stalwart", "LegendComposure"];
		this.m.ExcludedTraits = ::Const.Nggh_ExcludedTraits.Unhold;
		this.m.AttributesLevelUp = ::Const.Nggh_AttributesLevelUp.Unhold;
		this.m.BonusHealthRecoverMult = 4.0;
		this.m.AttributesMax = {
			Hitpoints = 1300,
			Bravery = 250,
			Fatigue = 800,
			Initiative = 150,
			MeleeSkill = 150,
			RangedSkill = 50,
			MeleeDefense = 125,
			RangedDefense = 125,
		};
		this.m.Sound[::Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/unhold_confused_01.wav",
			"sounds/enemies/unhold_confused_02.wav",
			"sounds/enemies/unhold_confused_03.wav",
			"sounds/enemies/unhold_confused_04.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/unhold_hurt_01.wav",
			"sounds/enemies/unhold_hurt_02.wav",
			"sounds/enemies/unhold_hurt_03.wav",
			"sounds/enemies/unhold_hurt_04.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/unhold_idle_01.wav",
			"sounds/enemies/unhold_idle_02.wav",
			"sounds/enemies/unhold_idle_03.wav",
			"sounds/enemies/unhold_idle_04.wav",
			"sounds/enemies/unhold_idle_05.wav",
			"sounds/enemies/unhold_idle_06.wav",
			"sounds/enemies/unhold_idle_07.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/unhold_flee_01.wav",
			"sounds/enemies/unhold_flee_02.wav",
			"sounds/enemies/unhold_flee_03.wav",
			"sounds/enemies/unhold_flee_04.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/unhold_death_01.wav",
			"sounds/enemies/unhold_death_02.wav",
			"sounds/enemies/unhold_death_03.wav",
			"sounds/enemies/unhold_death_04.wav",
			"sounds/enemies/unhold_death_05.wav",
			"sounds/enemies/unhold_death_06.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/unhold_idle_01.wav",
			"sounds/enemies/unhold_idle_02.wav",
			"sounds/enemies/unhold_idle_03.wav",
			"sounds/enemies/unhold_idle_04.wav",
			"sounds/enemies/unhold_idle_05.wav",
			"sounds/enemies/unhold_idle_06.wav",
			"sounds/enemies/unhold_idle_07.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Other1] = [
			"sounds/enemies/unhold_confused_01.wav",
			"sounds/enemies/unhold_confused_02.wav",
			"sounds/enemies/unhold_confused_03.wav",
			"sounds/enemies/unhold_confused_04.wav"
		];
		this.m.SoundPitch = ::Math.rand(0.9, 1.1);
		this.m.SoundVolumeOverall = 1.25;

		// can't equip most things
		local items = this.getItems(); 
		items.getData()[::Const.ItemSlot.Offhand][0] = -1;
		items.getData()[::Const.ItemSlot.Mainhand][0] = -1;
		items.getData()[::Const.ItemSlot.Ammo][0] = -1;
	}

	function playSound( _type, _volume, _pitch = 1.0 )
	{
		if (_type == ::Const.Sound.ActorEvent.Move && ::Math.rand(1, 100) <= 50)
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
			this.spawnBloodPool(_tile, 1);
			local appearance = this.getItems().getAppearance();
			local sprite_body = this.getSprite("body");
			local sprite_head = this.getSprite("head");
			local decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead", ::Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = sprite_body.Color;
			decal.Saturation = sprite_body.Saturation;
			decal.Scale = 0.9;
			decal.setBrightness(0.9);

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
					decal.Color = sprite_head.Color;
					decal.Saturation = sprite_head.Saturation;
					decal.Scale = 0.9;
					decal.setBrightness(0.9);
				}

				if (appearance.HelmetCorpse.len() != 0)
				{
					decal = _tile.spawnDetail(appearance.HelmetCorpse, ::Const.Tactical.DetailFlag.Corpse, flip);
					decal.Scale = 0.9;
					decal.setBrightness(0.9);
				}
			}
			else if (_fatalityType == ::Const.FatalityType.Decapitated)
			{
				local layers = [];

				if (!appearance.HideCorpseHead)
				{
					layers.push(sprite_head.getBrush().Name + "_dead");
				}

				if (appearance.HelmetCorpse.len() != 0)
				{
					layers.push(appearance.HelmetCorpse);
				}

				local decap = ::Tactical.spawnHeadEffect(this.getTile(), layers, ::createVec(-75, 50), 90.0, sprite_head.getBrush().Name + "_dead_bloodpool");
				local idx = 0;

				if (!appearance.HideCorpseHead)
				{
					decap[idx].Color = sprite_head.Color;
					decap[idx].Saturation = sprite_head.Saturation;
					decap[idx].Scale = 0.9;
					decap[idx].setBrightness(0.9);
					++idx;
				}

				if (appearance.HelmetCorpse.len() != 0)
				{
					decap[idx].Scale = 0.9;
					decap[idx].setBrightness(0.9);
					++idx;
				}
			}

			if (_fatalityType == ::Const.FatalityType.Disemboweled)
			{
				decal = _tile.spawnDetail("bust_unhold_guts", ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9;
			}
			else if (_skill && _skill.getProjectileType() == ::Const.ProjectileType.Arrow)
			{
				decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead_arrows", ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9;
			}
			else if (_skill && _skill.getProjectileType() == ::Const.ProjectileType.Javelin)
			{
				decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead_javelin", ::Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9;
			}

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
			::Tactical.Entities.addCorpse(_tile);

			if (_fatalityType != ::Const.FatalityType.Unconscious)
			{
				return;
			}

			local isBear = this.isBear();
			local isRockUnhold = this.isRockUnhold();
			local isFrostUnhold = this.isFrostUnhold();
			local n = 1 + (::Math.rand(1, 100) <= ::World.Assets.getExtraLootChance() ? 1 : 0);

			for( local i = 0; i < n; ++i )
			{
				::new("scripts/items/supplies/strange_meat_item").drop(_tile);

				if (isBear)
				{
					::new("scripts/items/trade/furs_item").drop(_tile);
					continue;
				}

				local r = ::Math.rand(1, 100);

				if (r <= 20)
				{
					::new("scripts/items/misc/unhold_heart_item").drop(_tile);
				}
				else if (r <= 60)
				{
					::new("scripts/items/misc/" + (isRockUnhold ? "legend_rock_unhold_bones_item" : "unhold_bones_item")).drop(_tile);
				}
				else
				{
					switch(true)
					{
					case isRockUnhold:
						::new("scripts/items/misc/legend_rock_unhold_bones_item").drop(_tile);
						break;

					case isFrostUnhold:
						::new("scripts/items/misc/frost_unhold_fur_item").drop(_tile);
						break;

					default:
						::new("scripts/items/misc/unhold_hide_item").drop(_tile);
					}
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
		this.getSprite("armor").setHorizontalFlipping(flip);
		this.getSprite("helmet").setHorizontalFlipping(flip);
		this.getSprite("accessory").setHorizontalFlipping(!flip);
		this.getSprite("accessory_special").setHorizontalFlipping(!flip);

		foreach( a in ::Const.CharacterSprites.Helmets )
		{
			if (a == "helmet")
			{
				continue;
			}

			this.getSprite(a).setHorizontalFlipping(!flip);
		}
	}

	function onInit()
	{
		this.nggh_mod_player_beast.onInit();
		local b = this.m.BaseProperties;
		b.setValues(::Const.Tactical.Actor.Unhold);
		b.IsImmuneToStun = true;
		b.IsImmuneToDisarm = true;
		b.IsImmuneToRotation = true;
		b.IsImmuneToKnockBackAndGrab = true;

		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = ::Const.DefaultMovementAPCost;
		this.m.FatigueCosts = ::Const.DefaultMovementFatigueCost;
		
		//this.addSprite("body");
		local injury_body = this.addSprite("injury");
		injury_body.Visible = false;
		this.addSprite("armor");
		this.addSprite("accessory");
		this.addSprite("accessory_special");
		this.addSprite("head");

		foreach( a in ::Const.CharacterSprites.Helmets )
		{
			this.addSprite(a);
		}

		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.65;
		this.setSpriteOffset("status_rooted", ::createVec(-10, 16));
		this.setSpriteOffset("status_stunned", ::createVec(0, 10));
		this.setSpriteOffset("arrow", ::createVec(0, 10));
	}
	
	function onAfterInit()
	{
		this.nggh_mod_player_beast.onAfterInit();
		this.m.Skills.add(::new("scripts/skills/actives/unstoppable_charge_skill"));
	}
	
	function setStartValuesEx( _isElite = false , _isBear = false , _isRockUnhold = false, _variant = 0 )
	{
		local type;
		local b = this.m.BaseProperties;
		local body = this.getSprite("body");
		local head = this.getSprite("head");
		local injury_body = this.getSprite("injury");

		switch (true) 
		{
	    case _isBear:
	        this.m.Variant = 4;
	        this.m.Flags.add("bear");
	        this.m.Flags.add("regen_armor");
	       	type = ::Const.EntityType.LegendBear;
	       	b.setValues(::Const.Tactical.Actor.LegendBear);
	       	body.setBrush("bear_01");
			head.setBrush("bear_head_01");
			injury_body.Visible = false;
			injury_body.setBrush("bear_01_injured");
	        break;

	    case _isRockUnhold:
	       	this.m.Variant = 4;
	       	this.m.Flags.add("unhold");
	       	this.m.Flags.add("regen_armor");
	       	type = ::Const.EntityType.LegendRockUnhold;
			b.setValues(::Const.Tactical.Actor.LegendRockUnhold);
			b.DamageTotalMult += 0.15;
			body.setBrush("bust_unhold_rock_body_02");
			head.setBrush("bust_unhold_rock_head_02");
			injury_body.Visible = false;
			injury_body.setBrush("bust_unhold_rock_02_injured");
	        break;
		
		default:
			this.m.Flags.add("unhold");
			this.m.Variant = _variant != 0 ? _variant : ::Math.rand(1, 3);
			body.setBrush("bust_unhold_body_0" + this.m.Variant);
			head.setBrush("bust_unhold_head_0" + this.m.Variant);

		    switch (this.m.Variant)
			{
			case 1:
				type = ::Const.EntityType.UnholdFrost;
				b.setValues(::Const.Tactical.Actor.UnholdFrost);
				b.DamageTotalMult += 0.15;
				this.m.Flags.add("regen_armor");
				if (::Math.rand(1, 100) <= 15) head.setBrush("bust_unhold_head_06");
				break;
				
			case 2:
				type = ::Const.EntityType.Unhold;
				b.setValues(::Const.Tactical.Actor.Unhold);
				if (::Math.rand(1, 100) <= 15) body.setBrush("bust_unhold_body_04");
				if (::Math.rand(1, 100) <= 15) head.setBrush("bust_unhold_head_04");
				break;
				
			case 3:
				type = ::Const.EntityType.UnholdBog;
				b.setValues(::Const.Tactical.Actor.UnholdBog);
				if (::Math.rand(1, 100) <= 15) head.setBrush("bust_unhold_head_05");
				break;
			}

			injury_body.Visible = false;
			injury_body.setBrush("bust_unhold_0" + this.m.Variant + "_injured");
		}

		// update the properties
		this.m.CurrentProperties = clone b;

		body.varySaturation(0.1);
		body.varyColor(0.09, 0.09, 0.09);
		head.Saturation = body.Saturation;
		head.Color = body.Color;

		this.getSprite("status_rooted").Scale = 0.65;
		this.setSpriteOffset("status_rooted", ::createVec(-10, 16));
		this.setSpriteOffset("status_stunned", ::createVec(0, 10));
		this.setSpriteOffset("arrow", ::createVec(0, 10));
		this.addDefaultBackground(type);
		
		this.setScenarioValues(type, _isElite);
	}

	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		local helmet = this.m.Items.getItemAtSlot(::Const.ItemSlot.Head);

		if (_appearance.Helmet != "bust_armored_unhold_head_01" && _appearance.Helmet != "bust_armored_unhold_head_02" && helmet != null && ::isKindOf(helmet, "legend_helmet"))
		{
			_appearance.HelmetDamage = "";
			_appearance.Helmet = "";
		}

		this.player.onAppearanceChanged(_appearance, _setDirty);
		this.onAdjustingSprite(_appearance);
	}
	
	function onAdjustingSprite( _appearance )
	{
		local s = 1.05;
		local v = ::createVec(30, 20);
		local offset = ::createVec(20, 10);

		if (this.isBear())
		{
			s = 1.3;
			v = ::createVec(0, -4);
			offset = ::createVec(0, 0);
		}

		foreach( a in ::Const.CharacterSprites.Helmets )
		{
			if (a == "helmet")
			{
				continue;
			}

			this.setSpriteOffset(a, v);
			this.getSprite(a).Scale = s;
		}

		this.setSpriteOffset("accessory", offset);
		this.setSpriteOffset("accessory_special", offset);
		this.getSprite("accessory").Scale = 1.05;
		this.getSprite("accessory_special").Scale = 1.05;
		this.setAlwaysApplySpriteOffset(true);
	}

	function isAbleToEquip( _item )
	{
		local isBear = this.isBear();

		if (_item.isItemType(::Const.Items.ItemType.Armor))
		{
			return [
				"armor.body.unhold_armor_heavy",
				"armor.body.unhold_armor_light",
			].find(_item.getID()) != null && !isBear;
		}
		else if (!isBear && _item.isItemType(::Const.Items.ItemType.Helmet))
		{
			return ::Const.Items.NotForUnholdHelmetList.find(_item.getID()) == null;
		}

		return this.nggh_mod_player_beast.isAbleToEquip(_item);
	}

	function canEnterBarber()
	{
		return !this.isBear();
	}

	function getPossibleSprites( _layer )
	{
		switch (_layer) 
		{
	    case "body":
	        return [
	        	"bust_unhold_body_01",
	        	"bust_unhold_body_02",
	        	"bust_unhold_body_03",
	        	"bust_unhold_body_04",
	        	"bust_unhold_rock_body_02",
	        	//"bear_01",
	        ];

	    case "head":
	        return [
	        	"bust_unhold_head_01",
	        	"bust_unhold_head_02",
	        	"bust_unhold_head_03",
	        	"bust_unhold_head_04",
	        	"bust_unhold_head_05",
	        	"bust_unhold_head_06",
	        	"bust_unhold_rock_head_02",
	        	//"bear_head_01",
	        ];
		}

		return [];
	}

	function changeBearSounds()
	{
		this.m.Sound[::Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/bear_idle1.wav",
			"sounds/enemies/bear_idle2.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/bear_hit1.wav",
			"sounds/enemies/bear_hit2.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/bear_dead.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/bear_idle1.wav",
			"sounds/enemies/bear_idle2.wav"
		];
	}

	function updateVariant()
	{
		local app = this.getItems().getAppearance();
		local brush = this.getSprite("body").getBrush().Name;
		app.Body = brush;
		app.Corpse = brush + "_dead";

		local b = this.m.BaseProperties;

		switch(this.getFlags().get("Type"))
		{
		case ::Const.EntityType.LegendBear:
			b.DamageRegularMin = 30;
			b.DamageRegularMax = 60;
			b.DailyFood = 7;
			break;

		case ::Const.EntityType.LegendRockUnhold:
			b.DailyFood = 18;
			break;

		case ::Const.EntityType.UnholdFrost:
			b.DailyFood = 12;
			break;

		default:
			b.DailyFood = 10;
		}

		if (this.isBear())
		{	
			this.changeBearSounds();
			this.getItems().getData()[::Const.ItemSlot.Body][0] = -1;
			this.getItems().updateAppearance();
		}
		else
		{
			// can use armor for protection
			this.m.Skills.removeByID("special.cosmetic");
		}
	}

});

