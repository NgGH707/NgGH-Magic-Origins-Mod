this.hyena_player <- this.inherit("scripts/entity/tactical/player_beast", {
	m = {
		IsHigh = false
	},
	function isHigh()
	{
		return this.m.IsHigh;
	}
	
	function getStrength()
	{
		return this.isHigh() ? 1.2 : 1.1;
	}

	function create()
	{
		this.player_beast.create();
		this.m.Type = this.Const.EntityType.Player;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.Hyena.XP;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.DecapitateSplatterOffset = this.createVec(-10, -25);
		this.m.DecapitateBloodAmount = 1.0;
		this.m.hitpointsMax = 350;
		this.m.braveryMax = 250;
		this.m.fatigueMax = 350;
		this.m.initiativeMax = 350;
		this.m.meleeSkillMax = 135;
		this.m.rangeSkillMax = 50;
		this.m.meleeDefenseMax = 125;
		this.m.rangeDefenseMax = 125;
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
		this.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/dlc6/hyena_idle_16.wav",
			"sounds/enemies/dlc6/hyena_idle_17.wav",
			"sounds/enemies/dlc6/hyena_idle_18.wav",
			"sounds/enemies/dlc6/hyena_idle_19.wav",
			"sounds/enemies/dlc6/hyena_idle_20.wav",
			"sounds/enemies/dlc6/hyena_idle_21.wav",
			"sounds/enemies/werewolf_idle_01.wav",
			"sounds/enemies/werewolf_idle_02.wav",
			"sounds/enemies/werewolf_idle_21.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/dlc6/hyena_hurt_01.wav",
			"sounds/enemies/dlc6/hyena_hurt_02.wav",
			"sounds/enemies/dlc6/hyena_hurt_03.wav",
			"sounds/enemies/dlc6/hyena_hurt_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/werewolf_fatigue_01.wav",
			"sounds/enemies/werewolf_fatigue_02.wav",
			"sounds/enemies/werewolf_fatigue_03.wav",
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/dlc6/hyena_death_01.wav",
			"sounds/enemies/dlc6/hyena_death_02.wav",
			"sounds/enemies/dlc6/hyena_death_03.wav",
			"sounds/enemies/dlc6/hyena_death_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/dlc6/hyena_flee_01.wav",
			"sounds/enemies/dlc6/hyena_flee_02.wav",
			"sounds/enemies/dlc6/hyena_flee_03.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/dlc6/hyena_idle_01.wav",
			"sounds/enemies/dlc6/hyena_idle_02.wav",
			"sounds/enemies/dlc6/hyena_idle_03.wav",
			"sounds/enemies/dlc6/hyena_idle_04.wav",
			"sounds/enemies/dlc6/hyena_idle_05.wav",
			"sounds/enemies/dlc6/hyena_idle_06.wav",
			"sounds/enemies/dlc6/hyena_idle_07.wav",
			"sounds/enemies/dlc6/hyena_idle_08.wav",
			"sounds/enemies/dlc6/hyena_idle_09.wav",
			"sounds/enemies/dlc6/hyena_idle_10.wav",
			"sounds/enemies/dlc6/hyena_idle_11.wav",
			"sounds/enemies/dlc6/hyena_idle_12.wav",
			"sounds/enemies/dlc6/hyena_idle_13.wav",
			"sounds/enemies/dlc6/hyena_idle_14.wav",
			"sounds/enemies/dlc6/hyena_idle_15.wav",
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Attack] = [
			"sounds/enemies/werewolf_idle_01.wav",
			"sounds/enemies/werewolf_idle_02.wav",
			"sounds/enemies/werewolf_idle_03.wav",
			"sounds/enemies/werewolf_idle_05.wav",
			"sounds/enemies/werewolf_idle_06.wav",
			"sounds/enemies/werewolf_idle_07.wav",
			"sounds/enemies/werewolf_idle_08.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Move] = [
			"sounds/enemies/werewolf_fatigue_01.wav",
			"sounds/enemies/werewolf_fatigue_02.wav",
			"sounds/enemies/werewolf_fatigue_03.wav",
			"sounds/enemies/werewolf_fatigue_04.wav",
			"sounds/enemies/werewolf_fatigue_05.wav",
			"sounds/enemies/werewolf_fatigue_06.wav",
			"sounds/enemies/werewolf_fatigue_07.wav"
		];
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Attack] = 0.6;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Move] = 0.6;
		this.m.SoundPitch = this.Math.rand(95, 110) * 0.01;
		this.m.Items.blockAllSlots();
		this.m.Items.m.LockedSlots[this.Const.ItemSlot.Accessory] = false;
		this.m.Items.m.LockedSlots[this.Const.ItemSlot.Head] = false;
		this.m.SignaturePerks = ["Pathfinder"];
	}

	function playAttackSound()
	{
		if (this.Math.rand(1, 100) <= 50)
		{
			this.playSound(this.Const.Sound.ActorEvent.Attack, this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.Attack] * (this.Math.rand(75, 100) * 0.01), this.m.SoundPitch * 1.15);
		}
	}
	
	function getHealthRecoverMult()
	{
		return 2.0;
	}

	function playSound( _type, _volume, _pitch = 1.0 )
	{
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
			decal = _tile.spawnDetail("bust_hyena_01_body_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = body.Color;
			decal.Saturation = body.Saturation;
			decal.Scale = 0.95;

			if (_fatalityType != this.Const.FatalityType.Decapitated)
			{
				decal = _tile.spawnDetail(head.getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Color = head.Color;
				decal.Saturation = head.Saturation;
				decal.Scale = 0.95;
			}
			else if (_fatalityType == this.Const.FatalityType.Decapitated)
			{
				local layers = [
					head.getBrush().Name + "_dead"
				];
				local decap = this.Tactical.spawnHeadEffect(this.getTile(), layers, this.createVec(0, 0), 0.0, "bust_hyena_head_bloodpool");
				decap[0].Color = head.Color;
				decap[0].Saturation = head.Saturation;
				decap[0].Scale = 0.95;
			}

			if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Arrow)
			{
				decal = _tile.spawnDetail("bust_hyena_01_body_dead_arrows", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.95;
			}
			else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Javelin)
			{
				decal = _tile.spawnDetail("bust_hyena_01_body_dead_javelin", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.95;
			}

			this.spawnTerrainDropdownEffect(_tile);
			this.spawnFlies(_tile);
			local corpse = clone this.Const.Corpse;
			corpse.CorpseName = this.getName();
			corpse.IsHeadAttached = _fatalityType != this.Const.FatalityType.Decapitated;
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);

			local n = 1 + (!this.Tactical.State.isScenarioMode() && this.Math.rand(1, 100) <= this.World.Assets.getExtraLootChance() ? 1 : 0);

			for( local i = 0; i < n; i = ++i )
			{
				if (this.Math.rand(1, 100) <= 50)
				{
					local r = this.Math.rand(1, 100);
					local loot;

					if (r <= 60)
					{
						loot = this.new("scripts/items/misc/hyena_fur_item");
					}
					else
					{
						loot = this.new("scripts/items/misc/acidic_saliva_item");
					}

					loot.drop(_tile);
				}
				else
				{
					local loot = this.new("scripts/items/supplies/strange_meat_item");
					loot.drop(_tile);
				}
			}

			if (this.m.IsHigh)
			{
				local loot = this.new("scripts/items/loot/sabertooth_item");
				loot.drop(_tile);
			}
		}

		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function onInit()
	{
		this.player_beast.onInit();
		local b = this.m.BaseProperties;
		b.IsAffectedByNight = false;
		b.IsImmuneToDisarm = true;
		b.DailyFood = this.Math.rand(3, 4);
		
		this.m.ActionPoints = b.ActionPoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		
		this.addSprite("body");
		this.addSprite("accessory");
		this.addSprite("accessory_special");
		this.addSprite("head");
		this.addSprite("injury");

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			this.addSprite(a);
		}

		local body_blood = this.addSprite("body_blood");
		body_blood.Visible = false;
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.54;
		this.setSpriteOffset("status_rooted", this.createVec(0, 0));
	}
	
	function onAfterInit()
	{
		this.player_beast.onAfterInit();
		this.m.Skills.add(this.new("scripts/skills/actives/hyena_bite_skill"));
	}

	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.player_beast.onAppearanceChanged(_appearance, _setDirty);
		this.onAdjustingSprite(_appearance);
	}
	
	function onAdjustingSprite( _appearance )
	{
		local v = -14;
		local v2 = 21;

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.setSpriteOffset(a, this.createVec(v2, v));
			this.getSprite(a).Scale = 0.95;
		}

		this.setSpriteOffset("accessory", this.createVec(10, 5));
		this.setSpriteOffset("accessory_special", this.createVec(10, 5));
		this.getSprite("accessory").Scale = 0.95;
		this.getSprite("accessory_special").Scale = 0.95;
		this.setAlwaysApplySpriteOffset(true);
	}
	
	function setScenarioValues( _isElite = false, _isHigh = false , _Dub = false, _Dub_two = false )
	{
		local b = this.m.BaseProperties;
		local type = this.Const.EntityType.Hyena;
		local body = this.getSprite("body");
		local head = this.getSprite("head");
		local injury = this.getSprite("injury");
		local body_blood = this.getSprite("body_blood");

		if (!_isHigh && this.Math.rand(1, 100) <= 20)
		{
			_isHigh = true;
		}

		switch (true) 
		{
		case _isHigh:
		    b.setValues(this.Const.Tactical.Actor.FrenziedHyena);
		    b.DamageTotalMult = 1.25;
			this.m.IsHigh = true;
			body.setBrush("bust_hyena_0" + this.Math.rand(4, 6));
			head.setBrush("bust_hyena_0" + this.Math.rand(4, 6) + "_head");
		    break;
		
		default:
			b.setValues(this.Const.Tactical.Actor.Hyena);
			body.setBrush("bust_hyena_0" + this.Math.rand(1, 3));
			head.setBrush("bust_hyena_0" + this.Math.rand(1, 3) + "_head");
		}

		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		
		if (this.Math.rand(0, 100) < 90)
		{
			body.varySaturation(0.2);
		}
		if (this.Math.rand(0, 100) < 90)
		{
			body.varyColor(0.05, 0.05, 0.05);
		}
		
		head.Color = body.Color;
		head.Saturation = body.Saturation;
		injury.Visible = false;
		injury.setBrush("bust_hyena_injured");
		body_blood.Visible = false;
		this.getSprite("status_rooted").Scale = 0.54;
		this.setSpriteOffset("status_rooted", this.createVec(0, 0));

		if (_isElite || this.Math.rand(1, 100) == 100)
		{
			this.getSkills().add(this.new("scripts/skills/racial/champion_racial"));
		}
		
		local background = this.new("scripts/skills/backgrounds/charmed_beast_background");
		background.setTo(type);
		this.m.Skills.add(background);
		background.onSetUp();
		background.buildDescription();
		if (!_isHigh)
		{
			background.addPerk(this.Const.Perks.PerkDefs.Rabies, 6);
		}
		
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
				Min = 3,
				Max = 5
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
				Min = 4,
				Max = 6
			},
			{
				Min = 3,
				Max = 4
			},
			{
				Min = 1,
				Max = 1
			},
			{
				Min = 1,
				Max = 3
			},
			{
				Min = 2,
				Max = 3
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
	
	function setAttributeLevelUpValues( _v )
	{
		local value = this.getLevel() <= 11 ? this.Math.rand(2, 4) * 2 : this.Math.rand(1, 2);
		local b = this.getBaseProperties();
		b.Hitpoints += _v.hitpointsIncrease;
		this.m.Hitpoints += _v.hitpointsIncrease;
		b.Stamina += _v.maxFatigueIncrease;
		b.Bravery += _v.braveryIncrease;
		b.MeleeSkill += _v.meleeSkillIncrease;
		b.RangedSkill += _v.rangeSkillIncrease;
		b.MeleeDefense += _v.meleeDefenseIncrease;
		b.RangedDefense += _v.rangeDefenseIncrease;
		b.Initiative += _v.initiativeIncrease;
		b.Armor[0] += value;
		b.ArmorMax[0] += value;
		b.Armor[1] += value;
		b.ArmorMax[1] += value;
		this.m.LevelUps = this.Math.max(0, this.m.LevelUps - 1);

		for( local i = 0; i != this.Const.Attributes.COUNT; i = ++i )
		{
			this.m.Attributes[i].remove(0);
		}
		
		this.m.CurrentProperties = clone b;
		
		this.getSkills().update();
		this.setDirty(true);

		if (b.MeleeSkill >= 90)
		{
			this.updateAchievement("Swordmaster", 1, 1);
		}

		if (b.RangedSkill >= 90)
		{
			this.updateAchievement("Deadeye", 1, 1);
		}
	}
	
	function getExcludeTraits()
	{
		return [
			"trait.cocky",
			"trait.drunkard",
			"trait.fainthearted",
			"trait.deathwish",
			"trait.superstitious",
			"trait.craven",
			"trait.greedy",
			"trait.irrational",
			"trait.loyal",
			"trait.disloyal",
			"trait.survivor",
			"trait.night_blind",
			"trait.paranoid",
			"trait.steady_hands",
			"trait.gift_of_people",
			"trait.double_tongued",
			"trait.seductive",
		];
	}

	function getPossibleSprites( _type )
	{
		local ret = [];

		if (!this.m.IsHigh)
		{
			switch (_type) 
			{
		    case "body":
		        ret = [
		        	"bust_hyena_01",
		        	"bust_hyena_02",
		        	"bust_hyena_03",
		        	"bust_hyena_04",
		        	"bust_hyena_05",
		        	"bust_hyena_06",
		        ];
		        break;

		    case "head":
		        ret = [
		        	"bust_hyena_01_head",
		        	"bust_hyena_02_head",
		        	"bust_hyena_03_head",
		        ];
		        break;
			}
		}
		else 
		{
		    switch (_type) 
			{
		    case "body":
		        ret = [
		        	"bust_hyena_01",
		        	"bust_hyena_02",
		        	"bust_hyena_03",
		        	"bust_hyena_04",
		        	"bust_hyena_05",
		        	"bust_hyena_06",
		        ];
		        break;

		    case "head":
		        ret = [
		        	"bust_hyena_04_head",
		        	"bust_hyena_05_head",
		        	"bust_hyena_06_head",
		        ];
		        break;
			}
		}

		return ret;
	}
	
	function onSerialize( _out )
	{
		this.player_beast.onSerialize(_out);
		_out.writeBool(this.m.IsHigh);
	}
	
	function onDeserialize( _in )
	{
		this.player_beast.onDeserialize(_in);
		this.m.IsHigh = _in.readBool();
	}

});

