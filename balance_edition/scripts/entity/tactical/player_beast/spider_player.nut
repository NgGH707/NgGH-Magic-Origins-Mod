this.spider_player <- this.inherit("scripts/entity/tactical/player_beast", {
	m = {
		Size = 1.0,
		DistortTargetA = null,
		DistortTargetPrevA = this.createVec(0, 0),
		DistortTargetB = null,
		DistortTargetPrevB = this.createVec(0, 0),
		DistortTargetC = null,
		DistortTargetPrevC = this.createVec(0, 0),
		DistortTargetHelmet = null,
		DistortTargetPrevHelmet = this.createVec(0, 0),
		DistortAnimationStartTimeA = 0,
		IsFlipping = false,
		HelmetOffset = [2, -42]
	},

	function getSize()
	{
		return this.m.Size;
	}
	
	function getStrength()
	{
		return this.getType(true) == this.Const.EntityType.LegendRedbackSpider ? 2.5 : 1.1;
	}
	
	function create()
	{
		this.player_beast.create();
		this.m.Type = this.Const.EntityType.Player;
		this.m.BloodType = this.Const.BloodType.Green;
		this.m.XP = this.Const.Tactical.Actor.Spider.XP;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.DecapitateSplatterOffset = this.createVec(20, -15);
		this.m.DecapitateBloodAmount = 1.0;
		this.m.hitpointsMax = 400;
		this.m.braveryMax = 150;
		this.m.fatigueMax = 200;
		this.m.initiativeMax = 300;
		this.m.meleeSkillMax = 120;
		this.m.rangeSkillMax = 50;
		this.m.meleeDefenseMax = 120;
		this.m.rangeDefenseMax = 120;
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
			"sounds/enemies/dlc2/giant_spider_idle_12.wav",
			"sounds/enemies/dlc2/giant_spider_idle_13.wav",
			"sounds/enemies/dlc2/giant_spider_idle_14.wav",
			"sounds/enemies/dlc2/giant_spider_idle_15.wav",
			"sounds/enemies/dlc2/giant_spider_idle_16.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/dlc2/giant_spider_hurt_01.wav",
			"sounds/enemies/dlc2/giant_spider_hurt_02.wav",
			"sounds/enemies/dlc2/giant_spider_hurt_03.wav",
			"sounds/enemies/dlc2/giant_spider_hurt_04.wav",
			"sounds/enemies/dlc2/giant_spider_hurt_05.wav",
			"sounds/enemies/dlc2/giant_spider_hurt_06.wav",
			"sounds/enemies/dlc2/giant_spider_hurt_07.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/dlc2/giant_spider_idle_04.wav",
			"sounds/enemies/dlc2/giant_spider_idle_05.wav",
			"sounds/enemies/dlc2/giant_spider_idle_06.wav",
			"sounds/enemies/dlc2/giant_spider_idle_07.wav",
			"sounds/enemies/dlc2/giant_spider_idle_08.wav",
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/dlc2/giant_spider_flee_01.wav",
			"sounds/enemies/dlc2/giant_spider_flee_02.wav",
			"sounds/enemies/dlc2/giant_spider_flee_03.wav",
			"sounds/enemies/dlc2/giant_spider_flee_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/dlc2/giant_spider_death_01.wav",
			"sounds/enemies/dlc2/giant_spider_death_02.wav",
			"sounds/enemies/dlc2/giant_spider_death_03.wav",
			"sounds/enemies/dlc2/giant_spider_death_04.wav",
			"sounds/enemies/dlc2/giant_spider_death_05.wav",
			"sounds/enemies/dlc2/giant_spider_death_06.wav",
			"sounds/enemies/dlc2/giant_spider_death_07.wav",
			"sounds/enemies/dlc2/giant_spider_death_08.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
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
		this.m.Sound[this.Const.Sound.ActorEvent.Move] = this.m.Sound[this.Const.Sound.ActorEvent.Idle];
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Move] = 0.7;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Idle] = 2.0;
		this.m.SoundPitch = this.Math.rand(95, 105) * 0.01;
		this.m.Items.blockAllSlots();
		this.m.Items.m.LockedSlots[this.Const.ItemSlot.Accessory] = false;
		this.m.Items.m.LockedSlots[this.Const.ItemSlot.Head] = false;
		this.m.SignaturePerks = ["Pathfinder", "FastAdaption", "Footwork", "LegendPoisonImmunity"];
		this.m.Flags.add("spider");
	}
	
	function getHealthRecoverMult()
	{
		return 1.66;
	}

	function playSound( _type, _volume, _pitch = 1.0 )
	{
		if (_type == this.Const.Sound.ActorEvent.Move && this.Math.rand(1, 100) <= 33)
		{
			return;
		}

		this.actor.playSound(_type, _volume, _pitch);
	}

	function onRender()
	{
		this.actor.onRender();

		if (this.m.DistortTargetA == null)
		{
			this.m.DistortTargetA = this.m.IsFlipping ? this.createVec(0, 1.0 * this.m.Size) : this.createVec(0, -1.0 * this.m.Size);
			this.m.DistortTargetB = !this.m.IsFlipping ? this.createVec(-0.5 * this.m.Size, 0) : this.createVec(0.5 * this.m.Size, 0);
			this.m.DistortTargetC = !this.m.IsFlipping ? this.createVec(0.5 * this.m.Size, 0) : this.createVec(-0.5 * this.m.Size, 0);
			this.m.DistortTargetHelmet = this.m.IsFlipping ? this.createVec(this.m.HelmetOffset[0] * this.m.Size, (this.m.HelmetOffset[1] + 1.0) * this.m.Size) : this.createVec(this.m.HelmetOffset[0] * this.m.Size, (this.m.HelmetOffset[1] - 1.0) * this.m.Size);
			this.m.DistortAnimationStartTimeA = this.Time.getVirtualTimeF() - this.Math.rand(10, 100) * 0.01;
		}

		this.moveSpriteOffset("legs_back", this.m.DistortTargetPrevB, this.m.DistortTargetB, 1.0, this.m.DistortAnimationStartTimeA);
		this.moveSpriteOffset("legs_front", this.m.DistortTargetPrevC, this.m.DistortTargetC, 1.0, this.m.DistortAnimationStartTimeA);
		this.moveSpriteOffset("body", this.m.DistortTargetPrevA, this.m.DistortTargetA, 1.0, this.m.DistortAnimationStartTimeA);
		this.moveSpriteOffset("injury", this.m.DistortTargetPrevA, this.m.DistortTargetA, 1.0, this.m.DistortAnimationStartTimeA);

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			if (this.getSprite(a).HasBrush && this.getSprite(a).Visible)
			{
				this.moveSpriteOffset(a, this.m.DistortTargetPrevHelmet, this.m.DistortTargetHelmet, 1.0, this.m.DistortAnimationStartTimeA);
			}
		}

		if (this.moveSpriteOffset("head", this.m.DistortTargetPrevA, this.m.DistortTargetA, 1.0, this.m.DistortAnimationStartTimeA))
		{
			this.m.DistortAnimationStartTimeA = this.Time.getVirtualTimeF();
			this.m.DistortTargetPrevA = this.m.DistortTargetA;
			this.m.DistortTargetA = this.m.IsFlipping ? this.createVec(0, 1.0 * this.m.Size) : this.createVec(0, -1.0 * this.m.Size);
			this.m.DistortTargetPrevB = this.m.DistortTargetB;
			this.m.DistortTargetB = !this.m.IsFlipping ? this.createVec(-0.5 * this.m.Size, 0) : this.createVec(0.5 * this.m.Size, 0);
			this.m.DistortTargetPrevC = this.m.DistortTargetC;
			this.m.DistortTargetC = !this.m.IsFlipping ? this.createVec(0.5 * this.m.Size, 0) : this.createVec(-0.5 * this.m.Size, 0);
			this.m.DistortTargetPrevHelmet = this.m.DistortTargetHelmet;	
			this.m.DistortTargetHelmet = this.m.IsFlipping ? this.createVec(this.m.HelmetOffset[0] * this.m.Size, (this.m.HelmetOffset[1] + 1.0) * this.m.Size) : this.createVec(this.m.HelmetOffset[0] * this.m.Size, (this.m.HelmetOffset[1] - 1.0) * this.m.Size);
			this.m.IsFlipping = !this.m.IsFlipping;
		}
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.player_beast.onDeath(_killer, _skill, _tile, _fatalityType);
		
		if (_tile != null)
		{
			local flip = this.Math.rand(0, 100) < 50;
			local decal;
			local body_decal;
			local head_decal;
			this.m.IsCorpseFlipped = flip;
			local body = this.getSprite("body");
			local head = this.getSprite("head");
			decal = _tile.spawnDetail("bust_spider_body_01_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = body.Color;
			decal.Saturation = body.Saturation;
			decal.Scale = 0.9 * this.m.Size;
			body_decal = decal;

			if (_fatalityType != this.Const.FatalityType.Decapitated)
			{
				decal = _tile.spawnDetail("bust_spider_head_01_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Color = head.Color;
				decal.Saturation = head.Saturation;
				decal.Scale = 0.9 * this.m.Size;
				head_decal = decal;

				if (_fatalityType == this.Const.FatalityType.None)
				{
					local corpse_data = {
						Body = body_decal,
						Head = head_decal,
						Start = this.Time.getRealTimeF(),
						Vector = this.createVec(0.0, -1.0),
						Iterations = 0,
						function onCorpseEffect( _data )
						{
							if (this.Time.getRealTimeF() - _data.Start > 0.2)
							{
								if (++_data.Iterations > 5)
								{
									return;
								}

								_data.Vector = this.createVec(this.Math.rand(-100, 100) * 0.01, this.Math.rand(-100, 100) * 0.01);
								_data.Start = this.Time.getRealTimeF();
							}

							local f = (this.Time.getRealTimeF() - _data.Start) / 0.2;
							_data.Body.setOffset(this.createVec(0.0 + 0.5 * _data.Vector.X * f, 30.0 + 1.0 * _data.Vector.Y * f));
							_data.Head.setOffset(this.createVec(0.0 + 0.5 * _data.Vector.X * f, 30.0 + 1.0 * _data.Vector.Y * f));
							this.Time.scheduleEvent(this.TimeUnit.Real, 10, _data.onCorpseEffect, _data);
						}

					};
					this.Time.scheduleEvent(this.TimeUnit.Real, 10, corpse_data.onCorpseEffect, corpse_data);
				}
			}
			else if (_fatalityType == this.Const.FatalityType.Decapitated)
			{
				local layers = [
					"bust_spider_head_01_dead"
				];
				local decap = this.Tactical.spawnHeadEffect(this.getTile(), layers, this.createVec(-50, -10), 0.0, "bust_spider_head_01_dead_bloodpool");
				decap[0].Color = head.Color;
				decap[0].Saturation = head.Saturation;
				decap[0].Scale = 0.9 * this.m.Size;
			}

			if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Arrow)
			{
				decal = _tile.spawnDetail("bust_spider_body_01_dead_arrows", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9 * this.m.Size;
			}

			if (_fatalityType == this.Const.FatalityType.Disemboweled)
			{
				decal = _tile.spawnDetail("bust_spider_gut", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9 * this.m.Size;
			}
			else if (_fatalityType == this.Const.FatalityType.Smashed)
			{
				decal = _tile.spawnDetail("bust_spider_skull", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9 * this.m.Size;
			}

			this.spawnTerrainDropdownEffect(_tile);
			this.spawnFlies(_tile);
			local corpse = clone this.Const.Corpse;
			corpse.CorpseName = "A Webknecht";
			corpse.IsHeadAttached = _fatalityType != this.Const.FatalityType.Decapitated;
			corpse.IsConsumable = false;
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);

			local n = 1 + (!this.Tactical.State.isScenarioMode() && this.Math.rand(1, 100) <= this.World.Assets.getExtraLootChance() ? 1 : 0);

			for( local i = 0; i < n; i = ++i )
			{
				local r = this.Math.rand(1, 100);
				local loot;

				if (r <= 60)
				{
					loot = this.new("scripts/items/misc/spider_silk_item");
				}
				else
				{
					loot = this.new("scripts/items/misc/poison_gland_item");
				}

				loot.drop(_tile);
			}
			
			if (this.getFlags().has("isRedBack"))
			{
				for( local i = 0; i < n; i = i )
				{
					local loot;
					loot = this.new("scripts/items/misc/legend_redback_poison_gland_item");
					loot.drop(_tile);
					i = ++i;
				}
			}
		}

		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function onFactionChanged()
	{
		this.actor.onFactionChanged();
		local flip = !this.isAlliedWithPlayer();
		this.m.IsFlipping = !flip;
		this.getSprite("legs_back").setHorizontalFlipping(!flip);
		this.getSprite("body").setHorizontalFlipping(!flip);
		this.getSprite("legs_front").setHorizontalFlipping(!flip);
		this.getSprite("head").setHorizontalFlipping(!flip);
		this.getSprite("injury").setHorizontalFlipping(!flip);

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.getSprite(a).setHorizontalFlipping(flip);
		}
	}
	
	function onInit()
	{
		this.player_beast.onInit();
		this.setRenderCallbackEnabled(true);
		local b = this.getBaseProperties();
		b.IsAffectedByNight = false;
		b.IsImmuneToPoison = true;
		b.IsImmuneToDisarm = true;
		b.DamageDirectAdd += 0.1;
		
		this.m.CurrentProperties = clone b;
		this.m.MaxTraversibleLevels = 3;
		
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

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			this.addSprite(a);
		}
		
		this.actor.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.65;
		this.setSpriteOffset("status_rooted", this.createVec(7, 10));
		this.setSpriteOffset("status_stunned", this.createVec(0, -20));
		this.setSpriteOffset("arrow", this.createVec(0, -20));
	}
	
	function onAfterInit()
	{
		this.player_beast.onAfterInit();
		this.m.Skills.add(this.new("scripts/skills/actives/web_skill"));
		this.m.Skills.removeByID("effects.ptr_direct_damage_limiter");
	}

	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		_appearance.Accessory = "";
		this.player_beast.onAppearanceChanged(_appearance, _setDirty);
		this.onAdjustingSprite(_appearance);
	}
	
	function onAdjustingSprite( _appearance )
	{
		local v = -42;
		local v2 = 2;
		local s = this.m.Size;

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			if (!this.hasSprite(a))
			{
				continue;
			}

			this.setSpriteOffset(a, this.createVec(this.m.HelmetOffset[0] * s, this.m.HelmetOffset[1] * s));
			this.getSprite(a).Scale = 0.9 * s;
		}

		this.setAlwaysApplySpriteOffset(true);
		this.setDirty(true);
	}

	function setSize( _s )
	{
		this.m.Size = _s;
		this.m.DecapitateBloodAmount = _s * 0.75;
		this.getSprite("body").Scale = _s;
		this.getSprite("head").Scale = _s;
		this.getSprite("injury").Scale = _s;
		this.getSprite("status_rooted").Scale = _s * 0.65;
		this.getSprite("status_rooted_back").Scale = _s * 0.65;
		this.getSprite("legs_back").Scale = _s;
		this.getSprite("legs_front").Scale = _s;
		local offset = this.createVec(0, -10.0 * (1.0 - _s));
		this.setSpriteOffset("body", offset);
		this.setSpriteOffset("head", offset);
		this.setSpriteOffset("injury", offset);
		this.setSpriteOffset("status_rooted", this.createVec(7, 10 - 10.0 * (1.0 - _s)));
		this.setSpriteOffset("status_rooted_back", this.createVec(7, 10 - 10.0 * (1.0 - _s)));
		this.setSpriteOffset("legs_back", offset);
		this.setSpriteOffset("legs_front", offset);
	}
	
	function setScenarioValues( _isElite = false , _isRedBack = false, _Dub = false, _Dub_two = false )
	{
		local b = this.m.BaseProperties;
		local type = this.Const.EntityType.Spider;
		local legs_back = this.getSprite("legs_back");
		local body = this.getSprite("body");
		local legs_front = this.getSprite("legs_front");
		local head = this.getSprite("head");
		local injury = this.getSprite("injury");

		switch (true) 
		{
		case _isRedBack:
		    type = this.Const.EntityType.LegendRedbackSpider;
		    b.setValues(this.Const.Tactical.Actor.LegendRedbackSpider);
		    legs_back.setBrush("bust_spider_redback_legs_back");
		    body.setBrush("bust_spider_redback_body_0" + this.Math.rand(1, 4));
		    legs_front.setBrush("bust_spider_redback_legs_front");
		    head.setBrush("bust_spider_redback_head_01");
		    injury.setBrush("bust_spider_01_injured");
		    this.setSize(this.Math.rand(90, 100) * 0.01);
		    break;
		
		default:
			b.setValues(this.Const.Tactical.Actor.Spider);
		    legs_back.setBrush("bust_spider_legs_back");
		    body.setBrush("bust_spider_body_0" + this.Math.rand(1, 4));
		    legs_front.setBrush("bust_spider_legs_front");
		    head.setBrush("bust_spider_head_01");
		    injury.setBrush("bust_spider_01_injured");
		    this.setSize(this.Math.rand(75, 95) * 0.01);
		}
		
		b.MeleeDefense += 5;
		b.RangedDefense += 5;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.m.MaxTraversibleLevels = 3;
		
		if (this.Math.rand(0, 100) < 90)
		{
			body.varySaturation(0.3);
		}
		if (this.Math.rand(0, 100) < 90)
		{
			body.varyColor(0.1, 0.1, 0.1);
		}
		if (this.Math.rand(0, 100) < 90)
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
		this.setSpriteOffset("status_rooted", this.createVec(7, 10));
		this.setSpriteOffset("status_stunned", this.createVec(0, -20));
		this.setSpriteOffset("arrow", this.createVec(0, -20));

		if (this.Math.rand(1, 100) == 100 || _isElite)
		{
			this.getFlags().add("elite_spider");
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
	
	function fillAttributeLevelUpValues( _amount, _maxOnly = false, _minOnly = false )
	{
		local AttributesLevelUp = [
			{
				Min = 3,
				Max = 4
			},
			{
				Min = 2,
				Max = 3
			},
			{
				Min = 2,
				Max = 4
			},
			{
				Min = 4,
				Max = 6
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
				Min = 1,
				Max = 3
			},
			{
				Min = 3,
				Max = 4
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
	}

	function resetRenderEffects()
	{
		this.m.IsRaising = false;
		this.m.IsSinking = false;
		this.m.IsRaisingShield = false;
		this.m.IsLoweringShield = false;
		this.m.IsRaisingWeapon = false;
		this.m.IsLoweringWeapon = false;
		this.setSpriteOffset("shield_icon", this.createVec(0, 0));
		this.setSpriteOffset("arms_icon", this.createVec(0, 0));
		this.getSprite("arms_icon").Rotation = 0;
		this.getSprite("status_rooted").Visible = false;
		this.getSprite("status_rooted_back").Visible = false;
	}
	
	function getExcludeTraits()
	{
		return [
			"trait.bright",
			"trait.drunkard",
			"trait.dastard",
			"trait.superstitious",
			"trait.greedy",
			"trait.spartan",
			"trait.brute",
			"trait.irrational",
			"trait.loyal",
			"trait.disloyal",
			"trait.survivor",
			"trait.night_blind",
			"trait.steady_hands",
			"trait.gift_of_people",
			"trait.double_tongued",
			"trait.seductive",
		];
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

	function getPossibleSprites( _type )
	{
		local ret = [];

		switch (_type) 
		{
	    case "body":
	        ret = [
	        	"bust_spider_body_01",
	        	"bust_spider_body_02",
	        	"bust_spider_body_03",
	        	"bust_spider_body_04",
	        	"bust_spider_redback_body_01",
	        	"bust_spider_redback_body_02",
	        	"bust_spider_redback_body_03",
	        	"bust_spider_redback_body_04",
	        ];
	        break;

	    case "head":
	        ret = [
	        	"bust_spider_head_01",
	        	"bust_spider_redback_head_01",
	        ];
	        break;

	    case "legs_back":
	    	ret = [
	    		"bust_spider_legs_back",
	    		"bust_spider_redback_legs_back",
	    	];
	    	break;

	    case "legs_front":
	    	ret = [
	    		"bust_spider_legs_front",
	    		"bust_spider_redback_legs_front",
	    	];
		}

		return ret;
	}
	
	function onSerialize( _out )
	{
		this.player_beast.onSerialize(_out);
		_out.writeF32(this.m.Size);
	}
	
	function onDeserialize( _in )
	{
		this.player_beast.onDeserialize(_in);
		this.m.Size = _in.readF32();
		this.setSize(this.m.Size);
	}

});

