this.siege_golem <- this.inherit("scripts/entity/tactical/minion", {
	m = {
		Size = 1,
		SummonerStrength = 100,
		Variant = 1,
		ScaleStartTime = 0,
		IsShrinking = false
	},
	
	function getSize()
	{
		return this.m.Size;
	}
	
	function setStrenght( _value )
	{
		this.m.SummonerStrength = this.Math.max(1, _value);
		
		if (_value > 1)
		{
			this.resetStats();
		}
	}

	function getIdealRange()
	{
		if (this.m.Size == 1)
		{
			return 1;
		}
		else
		{
			return 5;
		}
	}

	function create()
	{
		this.m.Type = this.Const.EntityType.SandGolem;
		this.m.Name = "Siege Golem";
		this.m.BloodType = this.Const.BloodType.Sand;
		this.m.XP = this.Const.Tactical.Actor.SandGolem.XP;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.m.BloodSplatterOffset = this.createVec(0, 15);
		this.minion.create();
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/dlc6/sand_golem_hurt_01.wav",
			"sounds/enemies/dlc6/sand_golem_hurt_02.wav",
			"sounds/enemies/dlc6/sand_golem_hurt_03.wav",
			"sounds/enemies/dlc6/sand_golem_hurt_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/dlc6/sand_golem_death_01.wav",
			"sounds/enemies/dlc6/sand_golem_death_02.wav",
			"sounds/enemies/dlc6/sand_golem_death_03.wav",
			"sounds/enemies/dlc6/sand_golem_death_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/dlc6/sand_golem_idle_01.wav",
			"sounds/enemies/dlc6/sand_golem_idle_02.wav",
			"sounds/enemies/dlc6/sand_golem_idle_03.wav",
			"sounds/enemies/dlc6/sand_golem_idle_04.wav",
			"sounds/enemies/dlc6/sand_golem_idle_05.wav",
			"sounds/enemies/dlc6/sand_golem_idle_06.wav",
		
		"sounds/enemies/dlc6/sand_golem_idle_07.wav",
			"sounds/enemies/dlc6/sand_golem_idle_08.wav",
			"sounds/enemies/dlc6/sand_golem_idle_09.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Other1] = [
			"sounds/enemies/dlc6/sand_golem_assemble_01.wav",
			"sounds/enemies/dlc6/sand_golem_assemble_02.wav",
			"sounds/enemies/dlc6/sand_golem_assemble_03.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Other2] = [
			"sounds/enemies/dlc6/sand_golem_disassemble_01.wav",
			"sounds/enemies/dlc6/sand_golem_disassemble_02.wav",
			"sounds/enemies/dlc6/sand_golem_disassemble_03.wav",
			"sounds/enemies/dlc6/sand_golem_disassemble_04.wav"
		];
		this.m.SoundPitch = 1.1;
		local onArmorHitSounds = this.getItems().getAppearance().ImpactSound;
		onArmorHitSounds[this.Const.BodyPart.Body] = this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived];
		onArmorHitSounds[this.Const.BodyPart.Head] = this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived];
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/donkey_agent");
		this.m.AIAgent.setActor(this);
	}

	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		_hitInfo.BodyPart = this.Const.BodyPart.Body;
		return this.minion.onDamageReceived(_attacker, _skill, _hitInfo);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (!this.Tactical.State.isScenarioMode() && _killer != null && _killer.isPlayerControlled())
		{
			this.updateAchievement("StoneMason", 1, 1);
		}

		local flip = this.Math.rand(0, 100) < 50;
		local sprite_body = this.getSprite("body");

		if (_tile != null)
		{
			local decal;
			local skin = this.getSprite("body");
			this.m.IsCorpseFlipped = flip;
			decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = skin.Color;
			decal.Saturation = skin.Saturation;
			decal.Scale = 0.9;
			decal.setBrightness(0.9);
			this.spawnTerrainDropdownEffect(_tile);
			local corpse = clone this.Const.Corpse;
			corpse.CorpseName = "An " + this.getName();
			corpse.Tile = _tile;
			corpse.Value = 2.0;
			corpse.IsResurrectable = false;
			corpse.IsConsumable = false;
			corpse.Armor = this.m.BaseProperties.Armor;
			corpse.IsHeadAttached = true;
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);

			if ((_killer == null || _killer.getFaction() == this.Const.Faction.Player || _killer.getFaction() == this.Const.Faction.PlayerAnimals) && this.Math.rand(1, 100) <= 40)
			{
				local n = 0 + this.Math.rand(0, 1) + (!this.Tactical.State.isScenarioMode() && this.Math.rand(1, 100) <= this.World.Assets.getExtraLootChance() ? 1 : 0);

				for( local i = 0; i < n; i = ++i )
				{
					local loot = this.new("scripts/items/misc/sulfurous_rocks_item");
					loot.drop(_tile);
				}

				if (this.Math.rand(1, 100) <= 10)
				{
					local loot = this.new("scripts/items/loot/glittering_rock_item");
					loot.drop(_tile);
				}
			}

			this.minion.onDeath(_killer, _skill, _tile, _fatalityType);
		}
	}

	function onFactionChanged()
	{
		this.minion.onFactionChanged();
		local flip = !this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(!flip);
		this.getSprite("status_rage").setHorizontalFlipping(!flip);
	}

	function onInit()
	{
		this.minion.onInit();
		local b = this.m.BaseProperties;
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToDisarm = true;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToFire = true;
		b.IsImmuneToOverwhelm = true;
		b.IsImmuneToRoot = true;
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToSurrounding = true;
		b.FatigueDealtPerHitMult = 3.0;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.m.Variant = this.Math.rand(1, 2);
		this.addSprite("socket").setBrush("bust_base_player");
		local body = this.addSprite("body");
		body.setBrush("bust_golem_body_0" + this.m.Variant + "_small");
		body.varySaturation(0.2);
		body.varyColor(0.06, 0.06, 0.06);
		local rage = this.addSprite("status_rage");
		rage.setHorizontalFlipping(true);
		rage.Visible = false;
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.45;
		this.setSpriteOffset("status_rooted", this.createVec(-4, 7));
		this.m.Skills.add(this.new("scripts/skills/racial/skeleton_racial"));
		this.m.Skills.add(this.new("scripts/skills/racial/berserker_rage_racial"));
		this.m.Skills.add(this.new("scripts/skills/racial/siege_golem_racial"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_crippling_strikes"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_hold_out"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_bullseye"));
		this.m.Skills.add(this.new("scripts/skills/actives/punch_mod"));
		this.m.Skills.add(this.new("scripts/skills/actives/sweep_mod"));
		this.m.Skills.add(this.new("scripts/skills/actives/throw_rock_mod"));
		this.m.Skills.add(this.new("scripts/skills/actives/unstoppable_charge_mod"));
		this.m.Skills.add(this.new("scripts/skills/actives/fling_back_mod"));
		this.m.Skills.add(this.new("scripts/skills/actives/grab_and_smack_mod"));
		this.m.Skills.add(this.new("scripts/skills/actives/stomp_mod"));
		this.grow(true);
	}
	
	function resetStats()
	{
		local b = this.m.BaseProperties;
		b.setValues(this.calculatedStat());
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToDisarm = true;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToFire = true;
		b.IsImmuneToOverwhelm = true;
		b.IsImmuneToRoot = true;
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToSurrounding = true;
		b.FatigueDealtPerHitMult = 3.0;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
	}
	
	function calculatedStat()
	{
		local ret = {
			XP = 500,
			ActionPoints = 9,
			Hitpoints = 440,
			Bravery = 50,
			Stamina = 400,
			MeleeSkill = 60,
			RangedSkill = 60,
			MeleeDefense = -75,
			RangedDefense = -50,
			Initiative = this.Math.rand(50, 70),
			FatigueEffectMult = 0.0,
			MoraleEffectMult = 0.0,
			FatigueRecoveryRate = 200,
			Armor = [
				150,
				0
			]
		};
		
		return ret;
	}

	function grow( _instant = false )
	{
		if (this.m.Size == 3)
		{
			return;
		}

		if (!_instant && this.m.Sound[this.Const.Sound.ActorEvent.Other1].len() != 0)
		{
			this.Sound.play(this.m.Sound[this.Const.Sound.ActorEvent.Other1][this.Math.rand(0, this.m.Sound[this.Const.Sound.ActorEvent.Other1].len() - 1)], this.Const.Sound.Volume.Actor, this.getPos());
		}

		this.m.Size = this.Math.min(3, this.m.Size + 1);
		this.m.IsShrinking = false;
		local b = this.m.BaseProperties;

		if (this.m.Size == 2)
		{
			this.getSprite("body").setBrush("bust_golem_body_0" + this.m.Variant + "_medium");

			if (!_instant)
			{
				this.setRenderCallbackEnabled(true);
				this.m.ScaleStartTime = this.Time.getVirtualTimeF();
			}

			this.getSprite("status_rooted").Scale = 0.5;
			this.getSprite("status_rooted_back").Scale = 0.5;
			this.setSpriteOffset("status_rooted", this.createVec(-4, 10));
			this.setSpriteOffset("status_rooted_back", this.createVec(-4, 10));
		}
		else if (this.m.Size == 3)
		{
			this.getSprite("body").setBrush("bust_golem_body_0" + this.m.Variant + "_big");

			if (!_instant)
			{
				this.setRenderCallbackEnabled(true);
				this.m.ScaleStartTime = this.Time.getVirtualTimeF();
			}

			this.getSprite("status_rooted").Scale = 0.6;
			this.getSprite("status_rooted_back").Scale = 0.6;
			this.setSpriteOffset("status_rooted", this.createVec(-7, 14));
			this.setSpriteOffset("status_rooted_back", this.createVec(-7, 14));
			b.IsImmuneToKnockBackAndGrab = true;
		}

		this.m.SoundPitch = 1.2 - this.m.Size * 0.1;
		this.m.Skills.update();
		this.setDirty(true);
	}

	function shrink( _instant = false )
	{
		if (this.m.Size == 1)
		{
			return;
		}

		if (!_instant && this.m.Sound[this.Const.Sound.ActorEvent.Other2].len() != 0)
		{
			this.Sound.play(this.m.Sound[this.Const.Sound.ActorEvent.Other2][this.Math.rand(0, this.m.Sound[this.Const.Sound.ActorEvent.Other2].len() - 1)], this.Const.Sound.Volume.Actor, this.getPos());
		}

		this.m.Size = this.Math.max(1, this.m.Size - 1);
		this.m.IsShrinking = true;
		local b = this.m.BaseProperties;

		if (this.m.Size == 2)
		{
			this.getSprite("body").setBrush("bust_golem_body_0" + this.m.Variant + "_medium");

			if (!_instant)
			{
				this.setRenderCallbackEnabled(true);
				this.m.ScaleStartTime = this.Time.getVirtualTimeF();
			}

			this.getSprite("status_rooted").Scale = 0.5;
			this.getSprite("status_rooted_back").Scale = 0.5;
			this.setSpriteOffset("status_rooted", this.createVec(-4, 10));
			this.setSpriteOffset("status_rooted_back", this.createVec(-4, 10));
		}
		else if (this.m.Size == 1)
		{
			this.getSprite("body").setBrush("bust_golem_body_0" + this.m.Variant + "_small");

			if (!_instant)
			{
				this.setRenderCallbackEnabled(true);
				this.m.ScaleStartTime = this.Time.getVirtualTimeF();
			}

			this.getSprite("status_rooted").Scale = 0.6;
			this.getSprite("status_rooted_back").Scale = 0.6;
			this.setSpriteOffset("status_rooted", this.createVec(-7, 14));
			this.setSpriteOffset("status_rooted_back", this.createVec(-7, 14));
		}

		this.m.SoundPitch = 1.2 - this.m.Size * 0.1;
		this.m.Skills.update();
		this.setDirty(true);
	}

	function onRender()
	{
		this.minion.onRender();

		if (this.m.IsShrinking)
		{
			if (this.m.Size == 2)
			{
				this.getSprite("body").Scale = this.Math.maxf(1.0, 1.04 - 0.04 * ((this.Time.getVirtualTimeF() - this.m.ScaleStartTime) / 0.3));

				if (this.moveSpriteOffset("body", this.createVec(0, 1), this.createVec(0, 0), 0.3, this.m.ScaleStartTime))
				{
					this.setRenderCallbackEnabled(false);
				}
			}
			else if (this.m.Size == 1)
			{
				this.getSprite("body").Scale = this.Math.maxf(1.0, 1.04 - 0.04 * ((this.Time.getVirtualTimeF() - this.m.ScaleStartTime) / 0.3));

				if (this.moveSpriteOffset("body", this.createVec(0, 1), this.createVec(0, 0), 0.3, this.m.ScaleStartTime))
				{
					this.setRenderCallbackEnabled(false);
				}
			}
		}
		else if (this.m.Size == 2)
		{
			this.getSprite("body").Scale = this.Math.minf(1.0, 0.96 + 0.04 * ((this.Time.getVirtualTimeF() - this.m.ScaleStartTime) / 0.3));

			if (this.moveSpriteOffset("body", this.createVec(0, -1), this.createVec(0, 0), 0.3, this.m.ScaleStartTime))
			{
				this.setRenderCallbackEnabled(false);
			}
		}
		else if (this.m.Size == 3)
		{
			this.getSprite("body").Scale = this.Math.minf(1.0, 0.94 + 0.06 * ((this.Time.getVirtualTimeF() - this.m.ScaleStartTime) / 0.3));

			if (this.moveSpriteOffset("body", this.createVec(0, -1), this.createVec(0, 0), 0.3, this.m.ScaleStartTime))
			{
				this.setRenderCallbackEnabled(false);
			}
		}
	}

	function onMovementStep( _tile, _levelDifference )
	{
		for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, _tile, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity * 0.15 * this.m.Size, this.Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.15 * this.m.Size, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages);
		}

		return this.minion.onMovementStep(_tile, _levelDifference);
	}
	
	function updatePowerLevelVisuals( _powerLevel )
	{
		local status_rage = this.getSprite("status_rage");

		if (_powerLevel <= 1)
		{
			status_rage.setBrush("golem_rage_4_" + this.m.Variant);
		}
		else
		{
			status_rage.setBrush("golem_rage_5_" + this.m.Variant);
		}
		
		this.m.Skills.update();
		this.setDirty(true);
	}
	
	function onActive()
	{
		this.setZoneOfControl(this.getTile(), true);
		this.m.IsActingEachTurn = true;
		this.m.AIAgent = this.new("scripts/ai/tactical/player_agent");
		this.m.AIAgent.setActor(this);
		this.setFaction(1);
		this.Tactical.TurnSequenceBar.removeEntity(this);
		this.m.IsActingImmediately = true;
		this.m.IsTurnDone = false;
		this.m.IsWaitActionSpent = false;
		this.Tactical.TurnSequenceBar.insertEntity(this);
		
		local _powerLevel = this.m.Skills.getSkillByID("racial.siege_golem");
		
		if (_powerLevel != null)
		{
			_powerLevel = _powerLevel.getPowerLevel();
		}
		else
		{
			_powerLevel = 1;
		}
		
		local sprite = this.getSprite("status_rage");
		sprite.Visible = true;
		
		if (_powerLevel <= 1)
		{
			sprite.setBrush("golem_rage_4_" + this.m.Variant);
		}
		else
		{
			sprite.setBrush("golem_rage_5_" + this.m.Variant);
		}
		
		sprite.Alpha = 0;
		sprite.fadeIn(1500);
		
		this.m.Skills.update();
		this.setDirty(true);
	}
	
	function onInactive()
	{
		this.setZoneOfControl(this.getTile(), false);
		this.Tactical.TurnSequenceBar.removeEntity(this);
		this.m.IsTurnDone = true;
		this.m.IsActingEachTurn = false;
		this.getContainer().getActor().setFaction(2);
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/donkey_agent");
		this.m.AIAgent.setActor(this);
		local sprite = this.getSprite("status_rage");
		sprite.fadeOutAndHide(1500);

		this.m.Skills.update();
		this.setDirty(true);
	}
	
	function onPlacedOnMap()
	{
		this.minion.onPlacedOnMap();
		this.registerRageEvent();
	}

	function registerRageEvent()
	{
		local self = this;
		
		this.Time.scheduleEvent(this.TimeUnit.Rounds, 1, this.onLosingRage.bindenv(this), self);
	}

	function onLosingRage( _actor )
	{
		if (typeof _actor == "instance" && _actor.isNull() || !_actor.isAlive() || _actor.isDying())
		{
			return;
		}
		
		local rage = _actor.getSkills().getSkillByID("racial.berserker_rage");
		
		if (rage == null)
		{
			return;
		}
		
		local r = this.Math.rand(1, 3);
		
		if (r == 3)
		{
			r = this.Math.rand(1, 3);
		}
		
		rage.addRage(-r);
		
		this.registerRageEvent();
	}

});

