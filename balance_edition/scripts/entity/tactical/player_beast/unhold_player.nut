this.unhold_player <- this.inherit("scripts/entity/tactical/player_beast", {
	m = {
		Variant = 2,
		IsBear = false,
	},
	
	function getStrength()
	{
		local type = this.getType(true);
		
		if (type == this.Const.EntityType.LegendBear)
		{
			return 1.75;
		}
		
		if (type == this.Const.EntityType.LegendRockUnhold)
		{
			return 7.0;
		}
		
		return 2.67;
	}
	
	function create()
	{
		this.player_beast.create();
		this.m.Type = this.Const.EntityType.Player;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.Unhold.XP;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.DecapitateSplatterOffset = this.createVec(40, -20);
		this.m.DecapitateBloodAmount = 3.0;
		this.m.hitpointsMax = 1300;
		this.m.braveryMax = 250;
		this.m.fatigueMax = 800;
		this.m.initiativeMax = 150;
		this.m.meleeSkillMax = 150;
		this.m.rangeSkillMax = 50;
		this.m.meleeDefenseMax = 125;
		this.m.rangeDefenseMax = 125;
		this.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/unhold_confused_01.wav",
			"sounds/enemies/unhold_confused_02.wav",
			"sounds/enemies/unhold_confused_03.wav",
			"sounds/enemies/unhold_confused_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/unhold_hurt_01.wav",
			"sounds/enemies/unhold_hurt_02.wav",
			"sounds/enemies/unhold_hurt_03.wav",
			"sounds/enemies/unhold_hurt_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/unhold_idle_01.wav",
			"sounds/enemies/unhold_idle_02.wav",
			"sounds/enemies/unhold_idle_03.wav",
			"sounds/enemies/unhold_idle_04.wav",
			"sounds/enemies/unhold_idle_05.wav",
			"sounds/enemies/unhold_idle_06.wav",
			"sounds/enemies/unhold_idle_07.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/unhold_flee_01.wav",
			"sounds/enemies/unhold_flee_02.wav",
			"sounds/enemies/unhold_flee_03.wav",
			"sounds/enemies/unhold_flee_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/unhold_death_01.wav",
			"sounds/enemies/unhold_death_02.wav",
			"sounds/enemies/unhold_death_03.wav",
			"sounds/enemies/unhold_death_04.wav",
			"sounds/enemies/unhold_death_05.wav",
			"sounds/enemies/unhold_death_06.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/unhold_idle_01.wav",
			"sounds/enemies/unhold_idle_02.wav",
			"sounds/enemies/unhold_idle_03.wav",
			"sounds/enemies/unhold_idle_04.wav",
			"sounds/enemies/unhold_idle_05.wav",
			"sounds/enemies/unhold_idle_06.wav",
			"sounds/enemies/unhold_idle_07.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Other1] = [
			"sounds/enemies/unhold_confused_01.wav",
			"sounds/enemies/unhold_confused_02.wav",
			"sounds/enemies/unhold_confused_03.wav",
			"sounds/enemies/unhold_confused_04.wav"
		];
		this.m.SoundPitch = this.Math.rand(0.9, 1.1);
		this.m.SoundVolumeOverall = 1.25;
		this.m.Items.m.LockedSlots[this.Const.ItemSlot.Mainhand] = true;
		this.m.Items.m.LockedSlots[this.Const.ItemSlot.Offhand] = true;
		this.m.Items.m.LockedSlots[this.Const.ItemSlot.Ammo] = true;
		this.m.SignaturePerks = ["Stalwart", "LegendComposure"];
		this.getFlags().add("isUnhold");
	}
	
	function getHealthRecoverMult()
	{
		return 20.0;
	}
	
	function restoreArmor()
	{
		local b = this.getBaseProperties();
		local c = this.getCurrentProperties();
		
		for ( local i = 0; i < 2; i = i + 1 )
		{
			local add = this.Math.min(50, b.ArmorMax[i] - b.Armor[i]);
			
			if (add == 0)
			{
				continue;
			}
			
			b.Armor[i] += add;
			c.Armor[i] += add;
		}
	}

	function playSound( _type, _volume, _pitch = 1.0 )
	{
		if (_type == this.Const.Sound.ActorEvent.Move && this.Math.rand(1, 100) <= 50)
		{
			return;
		}

		this.actor.playSound(_type, _volume, _pitch);
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

			if (appearance.CorpseArmor != "")
			{
				decal = _tile.spawnDetail(appearance.CorpseArmor, this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9;
				decal.setBrightness(0.9);
			}

			if (_fatalityType != this.Const.FatalityType.Decapitated)
			{
				if (!appearance.HideCorpseHead)
				{
					decal = _tile.spawnDetail(sprite_head.getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
					decal.Color = sprite_head.Color;
					decal.Saturation = sprite_head.Saturation;
					decal.Scale = 0.9;
					decal.setBrightness(0.9);
				}

				if (appearance.HelmetCorpse.len() != 0)
				{
					decal = _tile.spawnDetail(appearance.HelmetCorpse, this.Const.Tactical.DetailFlag.Corpse, flip);
					decal.Scale = 0.9;
					decal.setBrightness(0.9);
				}
			}
			else if (_fatalityType == this.Const.FatalityType.Decapitated)
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

				local decap = this.Tactical.spawnHeadEffect(this.getTile(), layers, this.createVec(-75, 50), 90.0, sprite_head.getBrush().Name + "_dead_bloodpool");
				local idx = 0;

				if (!appearance.HideCorpseHead)
				{
					decap[idx].Color = sprite_head.Color;
					decap[idx].Saturation = sprite_head.Saturation;
					decap[idx].Scale = 0.9;
					decap[idx].setBrightness(0.9);
					idx = ++idx;
				}

				if (appearance.HelmetCorpse.len() != 0)
				{
					decap[idx].Scale = 0.9;
					decap[idx].setBrightness(0.9);
					idx = ++idx;
				}
			}

			if (_fatalityType == this.Const.FatalityType.Disemboweled)
			{
				decal = _tile.spawnDetail("bust_unhold_guts", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9;
			}
			else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Arrow)
			{
				decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead_arrows", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9;
			}
			else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Javelin)
			{
				decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead_javelin", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9;
			}

			this.spawnTerrainDropdownEffect(_tile);
			local corpse = clone this.Const.Corpse;
			corpse.CorpseName = "An " + this.getNameOnly();
			corpse.Tile = _tile;
			corpse.IsResurrectable = false;
			corpse.IsConsumable = true;
			corpse.Items = this.getItems();
			corpse.IsHeadAttached = _fatalityType != this.Const.FatalityType.Decapitated;
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);
		}

		local n = 1 + (!this.Tactical.State.isScenarioMode() && this.Math.rand(1, 100) <= this.World.Assets.getExtraLootChance() ? 1 : 0);
		local type = this.getType(true);

		if (type == this.Const.EntityType.LegendBear)
		{
			for( local i = 0; i < n; i = i )
			{
				local r = this.Math.rand(1, 100);
				local loot;

				if (r <= 40)
				{
					loot = this.new("scripts/items/trade/furs_item");
				}
				else if (r <= 80)
				{
					loot = this.new("scripts/items/loot/legend_bear_fur_item");
					loot = this.new("scripts/items/misc/furs_item");
				}

				if (loot != null)
				{
					loot.drop(_tile);
				}

				i = ++i;
			}
		}
		else
		{
			for( local i = 0; i < n; i = ++i )
			{
				local r = this.Math.rand(1, 100);
				local loot;

				if (r <= 40)
				{
					loot = this.new("scripts/items/misc/unhold_bones_item");
				}
				else if (r <= 80)
				{
					if (this.isKindOf(this, "unhold_frost"))
					{
						loot = this.new("scripts/items/misc/frost_unhold_fur_item");
					}
					else
					{
						loot = this.new("scripts/items/misc/unhold_hide_item");
					}
				}
				else
				{
					loot = this.new("scripts/items/misc/unhold_heart_item");
				}

				loot.drop(_tile);
			}
		}

		local loot = this.new("scripts/items/supplies/strange_meat_item");
		loot.drop(_tile);

		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function onInit()
	{
		this.player_beast.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Unhold);
		b.IsImmuneToDisarm = true;
		b.IsImmuneToRotation = true;
		b.DailyFood = 10;

		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		
		this.addSprite("body");
		local injury_body = this.addSprite("injury");
		injury_body.Visible = false;
		this.addSprite("armor");
		this.addSprite("accessory");
		this.addSprite("accessory_special");
		this.addSprite("head");

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			this.addSprite(a);
		}

		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.65;
		this.setSpriteOffset("status_rooted", this.createVec(-10, 16));
		this.setSpriteOffset("status_stunned", this.createVec(0, 10));
		this.setSpriteOffset("arrow", this.createVec(0, 10));
		this.m.Skills.removeByID("special.cosmetic");
	}
	
	function onAfterInit()
	{
		this.player_beast.onAfterInit();
		this.m.Skills.add(this.new("scripts/skills/actives/unstoppable_charge_skill"));

		if (::mods_getRegisteredMod("mod_legends_PTR") != null)
		{
			this.m.Skills.add(this.new("scripts/skills/effects/ptr_armor_fatigue_recovery_effect"));
		}
	}
	
	function setScenarioValues( _isElite = false , _isBear = false , _isRockUnhold = false, _Dub_two = false )
	{
		this.m.Variant = this.Math.rand(1, 3);
		local isRockUnhold = _isRockUnhold;
		local b = this.m.BaseProperties;
		local type;
		local body = this.getSprite("body");
		local head = this.getSprite("head");
		local injury_body = this.getSprite("injury");

		switch (true) 
		{
	    case _isBear:
	        this.m.Variant = 4;
	        this.m.IsBear = true;
	       	type = this.Const.EntityType.LegendBear;
	       	b.setValues(this.Const.Tactical.Actor.LegendBear);
	       	body.setBrush("bear_01");
			head.setBrush("bear_head_01");
			injury_body.Visible = false;
			injury_body.setBrush("bear_01_injured");
			this.changeBearSounds();
	        break;

	    case _isRockUnhold:
	       	this.m.Variant = 4;
	       	type = this.Const.EntityType.LegendRockUnhold;
			b.setValues(this.Const.Tactical.Actor.LegendRockUnhold);
			b.DamageTotalMult += 0.15;
			body.setBrush("bust_unhold_rock_body_02");
			head.setBrush("bust_unhold_rock_head_02");
			injury_body.Visible = false;
			injury_body.setBrush("bust_unhold_rock_02_injured");
	        break;
		
		default:
			body.setBrush("bust_unhold_body_0" + this.m.Variant);
			head.setBrush("bust_unhold_head_0" + this.m.Variant);

		    switch (this.m.Variant)
			{
			case 1:
				type = this.Const.EntityType.UnholdFrost;
				b.setValues(this.Const.Tactical.Actor.UnholdFrost);
				b.DamageTotalMult += 0.15;
				if (this.Math.rand(1, 100) <= 5) body.setBrush("bust_unhold_body_04");
				if (this.Math.rand(1, 100) <= 5) head.setBrush("bust_unhold_head_04");
				break;
				
			case 2:
				type = this.Const.EntityType.Unhold;
				b.setValues(this.Const.Tactical.Actor.Unhold);
				if (this.Math.rand(1, 100) <= 5) head.setBrush("bust_unhold_head_06");
				break;
				
			case 3:
				type = this.Const.EntityType.UnholdBog;
				b.setValues(this.Const.Tactical.Actor.UnholdBog);
				if (this.Math.rand(1, 100) <= 5) head.setBrush("bust_unhold_head_05");
				break;
			}
			injury_body.Visible = false;
			injury_body.setBrush("bust_unhold_0" + this.m.Variant + "_injured");
		}

		body.varySaturation(0.1);
		body.varyColor(0.09, 0.09, 0.09);
		head.Saturation = body.Saturation;
		head.Color = body.Color;

		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.getSprite("status_rooted").Scale = 0.65;
		this.setSpriteOffset("status_rooted", this.createVec(-10, 16));
		this.setSpriteOffset("status_stunned", this.createVec(0, 10));
		this.setSpriteOffset("arrow", this.createVec(0, 10));

		if (_isElite || this.Math.rand(1, 100) == 100)
		{
			this.getSkills().add(this.new("scripts/skills/racial/champion_racial"));
		}
		
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
		this.fillBeastTalentValues(this.Math.rand(6, 9), true);
		this.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
	}
	
	function onFactionChanged()
	{
		this.player_beast.onFactionChanged();
		local flip = this.isAlliedWithPlayer();
		this.getSprite("armor").setHorizontalFlipping(flip);
		this.getSprite("helmet").setHorizontalFlipping(flip);

		flip = !flip;
		this.getSprite("accessory").setHorizontalFlipping(flip);
		this.getSprite("accessory_special").setHorizontalFlipping(flip);

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			if (a == "helmet" || !this.hasSprite(a))
			{
				continue;
			}

			this.getSprite(a).setHorizontalFlipping(flip);
		}
	}

	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		local helmet = this.m.Items.getItemAtSlot(this.Const.ItemSlot.Head);

		if (_appearance.Helmet != "bust_armored_unhold_head_01" && _appearance.Helmet != "bust_armored_unhold_head_02")
		{
			if (helmet != null && this.isKindOf(helmet, "legend_helmet"))
			{
				_appearance.HelmetDamage = "";
				_appearance.Helmet = "";
			}
		}

		this.actor.onAppearanceChanged(_appearance, _setDirty);
		this.onAdjustingSprite(_appearance);
	}
	
	function onAdjustingSprite( _appearance )
	{
		local v = 20;
		local v2 = 30;
		local s = 1.05;
		local offset = this.createVec(20, 10);

		if (this.m.IsBear)
		{
			v = -4;
			v2 = 0;
			s = 1.3;
			offset = this.createVec(0, 0);
		}

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			if (a == "helmet" || !this.hasSprite(a))
			{
				continue;
			}

			this.setSpriteOffset(a, this.createVec(v2, v));
			this.getSprite(a).Scale = s;
		}

		this.setSpriteOffset("accessory", offset);
		this.setSpriteOffset("accessory_special", offset);
		this.getSprite("accessory").Scale = 1.05;
		this.getSprite("accessory_special").Scale = 1.05;
		this.setAlwaysApplySpriteOffset(true);
	}

	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		return this.actor.onDamageReceived(_attacker, _skill, _hitInfo)
	}
	
	function fillAttributeLevelUpValues( _amount, _maxOnly = false, _minOnly = false )
	{
		local AttributesLevelUp = [
			{
				Min = 4,
				Max = 8
			},
			{
				Min = 2,
				Max = 4
			},
			{
				Min = 4,
				Max = 5
			},
			{
				Min = 3,
				Max = 4
			},
			{
				Min = 2,
				Max = 3
			},
			{
				Min = 1,
				Max = 1
			},
			{
				Min = 1,
				Max = 2
			},
			{
				Min = 1,
				Max = 2
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
					this.m.Attributes[i].insert(0, this.Math.rand(AttributesLevelUp[i].Min + (this.m.Talents[i] == 3 ? 2 : this.m.Talents[i]), AttributesLevelUp[i].Max + (this.m.Talents[i] == 3 ? 3 : 0)));
				}
			}
		}
	}
	
	function getExcludeTraits()
	{
		return [
			"trait.quick",
			"trait.tiny",
			"trait.bright",
			"trait.deathwish",
			"trait.insecure",
			"trait.craven",
			"trait.greedy",
			"trait.spartan",
			"trait.loyal",
			"trait.disloyal",
			"trait.survivor",
			"trait.weasel",
			"trait.gift_of_people",
			"trait.double_tongued",
		];
	}

	function canEquipThis( _item )
	{
		if (_item.isItemType(this.Const.Items.ItemType.Armor))
		{
			local unhold_armors = [
				"armor.body.unhold_armor_heavy",
				"armor.body.unhold_armor_light",
			];
			
			return unhold_armors.find(_item.getID()) != null && !this.m.IsBear;
		}

		if (this.m.IsBear && _item.isItemType(this.Const.Items.ItemType.Helmet))
		{
			local unhold_helmets = [
				"armor.head.unhold_helmet_heavy",
				"armor.head.unhold_helmet_light",
			];
			
			return unhold_helmets.find(_item.getID()) == null;
		}

		return true;
	}

	function getBarberSpriteChange()
	{
		return [
			"body",
			"head",
		];
	}

	function getPossibleSprites( _type )
	{
		local ret = [];

		switch (_type) 
		{
	    case "body":
	        ret = [
	        	"bust_unhold_body_01",
	        	"bust_unhold_body_02",
	        	"bust_unhold_body_03",
	        	"bust_unhold_body_04",
	        	"bust_unhold_rock_body_02",
	        	"bear_01",
	        ];
	        break;

	    case "head":
	        ret = [
	        	"bust_unhold_head_01",
	        	"bust_unhold_head_02",
	        	"bust_unhold_head_03",
	        	"bust_unhold_head_04",
	        	"bust_unhold_head_05",
	        	"bust_unhold_head_06",
	        	"bust_unhold_rock_head_02",
	        	"bear_head_01",
	        ];
	        break;
		}

		return ret;
	}

	function changeBearSounds()
	{
		this.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/bear_idle1.wav",
			"sounds/enemies/bear_idle2.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/bear_hit1.wav",
			"sounds/enemies/bear_hit2.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/bear_dead.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/bear_idle1.wav",
			"sounds/enemies/bear_idle2.wav"
		];
	}
	
	function onSerialize( _out )
	{
		this.player_beast.onSerialize(_out);
		_out.writeF32(this.m.Variant);
	}
	
	function onDeserialize( _in )
	{
		this.player_beast.onDeserialize(_in);
		this.m.Variant = _in.readF32();

		if (this.getFlags().getAsInt("bewitched") == this.Const.EntityType.LegendBear)
		{
			this.changeBearSounds();
			this.m.IsBear = true;
			this.getItems().updateAppearance();
		}
	}

});

