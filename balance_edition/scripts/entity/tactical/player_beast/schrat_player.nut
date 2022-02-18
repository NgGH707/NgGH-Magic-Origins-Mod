this.schrat_player <- this.inherit("scripts/entity/tactical/player_beast", {
	m = {},
	
	function getStrength()
	{
		return this.getType(true) == this.Const.EntityType.LegendGreenwoodSchrat ? 5.0 : 2.1;
	}
	
	function create()
	{
		this.player_beast.create();
		this.m.Type = this.Const.EntityType.Player;
		this.m.BloodType = this.Const.BloodType.Wood;
		this.m.XP = this.Const.Tactical.Actor.Schrat.XP;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.DecapitateSplatterOffset = this.createVec(-10, -25);
		this.m.DecapitateBloodAmount = 1.0;
		this.m.hitpointsMax = 1000;
		this.m.braveryMax = 400;
		this.m.fatigueMax = 600;
		this.m.initiativeMax = 250;
		this.m.meleeSkillMax = 150;
		this.m.rangeSkillMax = 50;
		this.m.meleeDefenseMax = 85;
		this.m.rangeDefenseMax = 85;
		this.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/ambience/terrain/forest_branch_crack_00.wav",
			"sounds/ambience/terrain/forest_branch_crack_01.wav",
			"sounds/ambience/terrain/forest_branch_crack_02.wav",
		];
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/dlc2/schrat_shield_damage_01.wav",
			"sounds/enemies/dlc2/schrat_shield_damage_02.wav",
			"sounds/enemies/dlc2/schrat_shield_damage_03.wav",
			"sounds/enemies/dlc2/schrat_shield_damage_04.wav",
			"sounds/enemies/dlc2/schrat_shield_damage_05.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = [
			"sounds/ambience/terrain/forest_branch_crack_00.wav",
			"sounds/ambience/terrain/forest_branch_crack_01.wav",
			"sounds/ambience/terrain/forest_branch_crack_02.wav",
			"sounds/ambience/terrain/forest_branch_crack_03.wav",
			"sounds/ambience/terrain/forest_branch_crack_04.wav",
			"sounds/ambience/terrain/forest_branch_crack_05.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/dlc2/schrat_death_01.wav",
			"sounds/enemies/dlc2/schrat_death_02.wav",
			"sounds/enemies/dlc2/schrat_death_03.wav",
			"sounds/enemies/dlc2/schrat_death_04.wav",
			"sounds/enemies/dlc2/schrat_death_05.wav",
			"sounds/enemies/dlc2/schrat_death_06.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/dlc2/schrat_death_01.wav",
			"sounds/enemies/dlc2/schrat_death_02.wav",
			"sounds/enemies/dlc2/schrat_death_03.wav",
			"sounds/enemies/dlc2/schrat_death_04.wav",
			"sounds/enemies/dlc2/schrat_death_05.wav",
			"sounds/enemies/dlc2/schrat_death_06.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
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
		this.m.Sound[this.Const.Sound.ActorEvent.Other1] = [
			"sounds/enemies/dlc2/schrat_hurt_shield_down_01.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_down_02.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_down_03.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_down_04.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_down_05.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_down_06.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Other2] = [
			"sounds/enemies/dlc2/schrat_hurt_shield_up_01.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_up_02.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_up_03.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_up_04.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_up_05.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_up_06.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Move] = this.m.Sound[this.Const.Sound.ActorEvent.Idle];
		this.m.SoundVolume[this.Const.Sound.ActorEvent.DamageReceived] = 5.0;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Other1] = 5.0;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Other2] = 5.0;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Death] = 5.0;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Idle] = 2.0;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Move] = 2.0;
		this.m.SoundPitch = this.Math.rand(95, 105) * 0.01;
		this.m.Items.blockAllSlots();
		this.m.Items.m.LockedSlots[this.Const.ItemSlot.Offhand] = false;
		this.m.Items.m.LockedSlots[this.Const.ItemSlot.Accessory] = false;
		this.m.Items.m.LockedSlots[this.Const.ItemSlot.Head] = false;
		this.m.SignaturePerks = ["Pathfinder"];
		this.getFlags().add("isSchrat");
	}
	
	function getHealthRecoverMult()
	{
		return 5.0;
	}

	function onCombatStart()
	{
		this.player_beast.onCombatStart();

		if (!this.isArmedWithShield())
		{
			if (this.Math.rand(1, 10) <= 5)
			{
				return;
			}
			
			if (this.getType(true) == this.Const.EntityType.LegendGreenwoodSchrat)
			{
				this.getItems().equip(this.new("scripts/items/shields/beasts/legend_greenwood_schrat_shield"));
			}
			else 
			{
			 	this.getItems().equip(this.new("scripts/items/shields/beasts/schrat_shield"));
			}
		}
	}

	function playSound( _type, _volume, _pitch = 1.0 )
	{
		if (_type == this.Const.Sound.ActorEvent.DamageReceived)
		{
			if (!this.isArmedWithShield())
			{
				_type = this.Const.Sound.ActorEvent.Other1;
			}
		}

		this.actor.playSound(_type, _volume, _pitch);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.player_beast.onDeath(_killer, _skill, _tile, _fatalityType);

		if (_tile != null)
		{
			local flip = this.Math.rand(0, 100) < 50;
			local decal;
			this.m.IsCorpseFlipped = flip;
			local body = this.getSprite("body");
			local head = this.getSprite("head");
			decal = _tile.spawnDetail("bust_schrat_body_01_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = body.Color;
			decal.Saturation = body.Saturation;
			decal.Scale = 0.95;
			decal = _tile.spawnDetail(head.getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = head.Color;
			decal.Saturation = head.Saturation;
			decal.Scale = 0.95;

			if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Arrow)
			{
				decal = _tile.spawnDetail("bust_schrat_body_01_dead_arrows", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.95;
			}
			else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Javelin)
			{
				decal = _tile.spawnDetail("bust_schrat_body_01_dead_javelin", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.95;
			}

			this.spawnTerrainDropdownEffect(_tile);
			local corpse = clone this.Const.Corpse;
			corpse.CorpseName = this.getName();
			corpse.IsHeadAttached = true;
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);

			local n = 1 + (!this.Tactical.State.isScenarioMode() && this.Math.rand(1, 100) <= this.World.Assets.getExtraLootChance() ? 1 : 0);
			
			if (this.getFlags().has("isGreenSchrat"))
			{
				local loot;
				loot = this.new("scripts/items/misc/legend_ancient_green_wood_item");

				loot.drop(_tile);
			}
			
			for( local i = 0; i < n; i = ++i )
			{
				local r = this.Math.rand(1, 100);
				local loot;

				if (r <= 40)
				{
					loot = this.new("scripts/items/misc/ancient_wood_item");
				}
				else if (r <= 80)
				{
					loot = this.new("scripts/items/misc/glowing_resin_item");
				}
				else
				{
					loot = this.new("scripts/items/misc/heart_of_the_forest_item");
				}

				loot.drop(_tile);
			}

			local loot = this.new("scripts/items/loot/ancient_amber_item");
			loot.drop(_tile);
		}

		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function onInit()
	{
		this.player_beast.onInit();
		local b = this.m.BaseProperties;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToRoot = true;
		b.IsIgnoringArmorOnAttack = true;
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToDisarm = true;
		b.DailyFood = this.Math.rand(6, 8);

		this.m.ActionPoints = b.ActionPoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		
		this.addSprite("body");
		this.addSprite("accessory");
		this.addSprite("accessory_special");
		this.addSprite("head");
		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_schrat_01_injured");

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			this.addSprite(a);
		}

		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.54;
		this.setSpriteOffset("status_rooted", this.createVec(0, 0));
		this.setSpriteOffset("status_stunned", this.createVec(0, 10));
		this.setSpriteOffset("arrow", this.createVec(0, 10));
	}
	
	function onAfterInit()
	{
		this.player_beast.onAfterInit();
		this.m.Skills.add(this.new("scripts/skills/actives/uproot_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/uproot_zoc_skill"));
	}

	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.player_beast.onAppearanceChanged(_appearance, _setDirty);
		this.onAdjustingSprite(_appearance);
	}
	
	function onAdjustingSprite( _appearance )
	{
		local v = 0;
		local v2 = 14;

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.setSpriteOffset(a, this.createVec(v2, v));
			this.getSprite(a).Scale = 1.05;
		}

		this.setSpriteOffset("accessory", this.createVec(5, 8));
		this.setSpriteOffset("accessory_special", this.createVec(5, 8));
		this.setAlwaysApplySpriteOffset(true);
	}
	
	function setScenarioValues( _isElite = false, _isGreenWood = false , _Dub = false, _Dub_two = false )
	{
		local b = this.m.BaseProperties;
		local type = this.Const.EntityType.Schrat;
		local body = this.getSprite("body");
		local head = this.getSprite("head");
		local injury = this.getSprite("injury");

		switch (true) 
		{
		case _isGreenWood:
			type = this.Const.EntityType.LegendGreenwoodSchrat;
		    b.setValues(this.Const.Tactical.Actor.LegendGreenwoodSchrat);
			body.setBrush("bust_schrat_green_body_01");
			head.setBrush("bust_schrat_green_head_0" + this.Math.rand(1, 2));
			injury.setBrush("bust_schrat_green_01_injured");
		    break;
		
		default:
			b.setValues(this.Const.Tactical.Actor.Schrat);
			body.setBrush("bust_schrat_body_01");
			head.setBrush("bust_schrat_head_0" + this.Math.rand(1, 2));
			injury.setBrush("bust_schrat_01_injured");
		}

		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		
		body.varySaturation(0.2);
		body.varyColor(0.05, 0.05, 0.05);
		this.m.BloodColor = body.Color;
		head.Color = body.Color;
		head.Saturation = body.Saturation;
		injury.Visible = false;

		this.getSprite("status_rooted").Scale = 0.54;
		this.setSpriteOffset("status_rooted", this.createVec(0, 0));
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
		this.fillBeastTalentValues(this.Math.rand(4, 9), true);
		this.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
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
	
	function fillAttributeLevelUpValues( _amount, _maxOnly = false, _minOnly = false )
	{
		local AttributesLevelUp = [
			{
				Min = 4,
				Max = 6
			},
			{
				Min = 1,
				Max = 2
			},
			{
				Min = 2,
				Max = 3
			},
			{
				Min = 3,
				Max = 4
			},
			{
				Min = 2,
				Max = 4
			},
			{
				Min = 1,
				Max = 1
			},
			{
				Min = 2,
				Max = 3
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
					this.m.Attributes[i].insert(0, this.Math.rand(AttributesLevelUp[i].Min + (this.m.Talents[i] == 3 ? 2 : this.m.Talents[i]), AttributesLevelUp[i].Max + (this.m.Talents[i] == 3 ? 1 : 0)));
				}
			}
		}
	}
	
	function getExcludeTraits()
	{
		return [
			"trait.tiny",
			"trait.fat",
			"trait.drunkard",
			"trait.fainthearted",
			"trait.bleeder",
			"trait.ailing",
			"trait.superstitious",
			"trait.iron_lungs",
			"trait.greedy",
			"trait.spartan",
			"trait.athletic",
			"trait.irrational",
			"trait.loyal",
			"trait.disloyal",
			"trait.survivor",
			"trait.swift",
			"trait.fear_beasts",
			"trait.weasel",
			"trait.light",
			"trait.gift_of_people",
			"trait.double_tongued",
		];
	}

	function canEquipThis( _item )
	{
		if (_item.getSlotType() == this.Const.ItemSlot.Offhand)
		{
			return _item.isItemType(this.Const.Items.ItemType.Shield);
		}

		return true;
	}

	function getPossibleSprites( _type )
	{
		local ret = [];

		switch (_type) 
		{
	    case "body":
	        ret = [
	        	"bust_schrat_body_01",
	        	"bust_schrat_green_body_01",
	        ];
	        break;

	    case "head":
	        ret = [
	        	"bust_schrat_head_01",
	        	"bust_schrat_head_02",
	        	"bust_schrat_green_head_01",
	        	"bust_schrat_green_head_02",
	        ];
	        break;
		}

		return ret;
	}

	function onDeserialize( _in )
	{
		this.player_beast.onDeserialize(_in);
		this.m.BloodColor = this.getSprite("body").Color;
	}

});

