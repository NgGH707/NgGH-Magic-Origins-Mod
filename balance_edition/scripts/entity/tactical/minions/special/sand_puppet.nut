this.sand_puppet <- this.inherit("scripts/entity/tactical/minion", {
	m = {
		Size = 1,
		Variant = 1,
		ScaleStartTime = 0,
		IsAcitve = false,
		IsShrinking = false
	},
	
	function getSize()
	{
		return this.m.Size;
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
		this.m.Name = "Earthen Puppet";
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
		this.getFlags().add("puppet");
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

			if (this.Math.rand(1, 100) <= 40)
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
		local stats = {
			XP = 500,
			ActionPoints = 9,
			Hitpoints = 200,
			Bravery = 100,
			Stamina = 400,
			MeleeSkill = this.Math.rand(45, 55),
			RangedSkill = this.Math.rand(45, 55),
			MeleeDefense = -50,
			RangedDefense = -50,
			Initiative = 25,
			FatigueEffectMult = 0.0,
			MoraleEffectMult = 0.0,
			FatigueRecoveryRate = 200,
			Armor = [
				150,
				150
			]
		};
		b.setValues(stats);
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
		//b.DamageReceivedArmorMult = 0.75;
		b.FatigueDealtPerHitMult = 1.5;
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
		local morale = this.addSprite("morale");
		morale.Visible = false;
		this.getSprite("status_rooted").Scale = 0.45;
		this.setSpriteOffset("status_rooted", this.createVec(-4, 7));
		this.m.Skills.add(this.new("scripts/skills/racial/sand_puppet_racial"));
		this.m.Skills.add(this.new("scripts/skills/racial/berserker_rage_racial"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_crippling_strikes"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_hold_out"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_bullseye"));
		this.m.Skills.add(this.new("scripts/skills/actives/mod_punch"));
		this.m.Skills.add(this.new("scripts/skills/actives/mod_sweep"));
		this.m.Skills.add(this.new("scripts/skills/actives/mod_throw_rock"));
		this.m.Skills.add(this.new("scripts/skills/actives/mod_unstoppable_charge"));
		this.m.Skills.add(this.new("scripts/skills/actives/mod_fling_back"));
		this.m.Skills.add(this.new("scripts/skills/actives/mod_grab_and_smack"));
		this.m.Skills.add(this.new("scripts/skills/actives/mod_stomp"));
		this.grow(true);
	}

	function setNewStats( _mult )
	{
		local b = this.m.BaseProperties;
		b.HitpointsMult *= _mult * (1.0 + this.Math.rand(0, 15) * 0.01);
		b.MeleeSkillMult *= _mult;
		b.RangedSkillMult *= _mult;
		b.ArmorMult[0] *= _mult;
		b.ArmorMult[1] *= _mult;

		if (_mult > 1.25)
		{
			b.DamageTotalMult *= 1.2;
		}

		if (_mult > 1.35)
		{
			b.HitpointsMult *= 1.2;
		}

		if (_mult > 1.5)
		{
			this.m.Skills.add(this.new("scripts/skills/perks/perk_battle_forged"));
		}

		this.m.Skills.update();
		this.setHitpointsPct(1.0);
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
			status_rage.setBrush("golem_rage_1_" + this.m.Variant);
		}
		else if (_powerLevel <= 2)
		{
			status_rage.setBrush("golem_rage_2_" + this.m.Variant);
		}
		else if (_powerLevel <= 3)
		{
			status_rage.setBrush("golem_rage_3_" + this.m.Variant);
		}
		else if (_powerLevel <= 4)
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
	
	function onActive( _master )
	{
		this.setZoneOfControl(this.getTile(), true);
		this.setMaster(_master);
		this.m.IsActingEachTurn = true;
		this.m.AIAgent = this.new("scripts/ai/tactical/player_agent");
		this.m.AIAgent.setActor(this);
		
		local _powerLevel = this.m.Skills.getSkillByID("effects.mc_powering");
		
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
			sprite.setBrush("golem_rage_1_" + this.m.Variant);
		}
		else if (_powerLevel <= 2)
		{
			sprite.setBrush("golem_rage_2_" + this.m.Variant);
		}
		else if (_powerLevel <= 3)
		{
			sprite.setBrush("golem_rage_3_" + this.m.Variant);
		}
		else if (_powerLevel <= 4)
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
		this.setMaster(null);
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
		this.Time.scheduleEvent(this.TimeUnit.Rounds, 1, function( _actorID )
		{
			local _actor = this.Tactical.getEntityByID(_actorID);

			if (_actor == null || !_actor.isAlive() || _actor.isDying())
			{
				return;
			}
			
			local rage = _actor.getSkills().getSkillByID("racial.berserker_rage");
			
			if (rage == null)
			{
				return;
			}
			
			local r = this.Math.rand(1, 2);
			rage.addRage(-r);
			_actor.registerRageEvent();
		}, this.getID());
	}
	
	function modTacticalTooltip( _targetedWithSkill = null )
	{
		if (!this.isPlacedOnMap() || !this.isAlive() || this.isDying())
		{
			return [];
		}

		local turnsToGo = this.Tactical.TurnSequenceBar.getTurnsUntilActive(this.getID());
		local tooltip = [
			{
				id = 1,
				type = "title",
				text = this.getName(),
				icon = "ui/tooltips/height_" + this.getTile().Level + ".png"
			}
		];

		if (!this.isPlayerControlled() && _targetedWithSkill != null && this.isKindOf(_targetedWithSkill, "skill"))
		{
			local tile = this.getTile();

			if (tile.IsVisibleForEntity && _targetedWithSkill.isUsableOn(this.getTile()))
			{
				tooltip.push({
					id = 3,
					type = "headerText",
					icon = "ui/icons/hitchance.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]" + _targetedWithSkill.getHitchance(this) + "%[/color] chance to hit",
					children = _targetedWithSkill.getHitFactors(tile)
				});
			}
		}

		tooltip.extend([
			{
				id = 2,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = this.Tactical.TurnSequenceBar.getActiveEntity() == this ? "Acting right now!" : this.m.IsTurnDone || turnsToGo == null ? "Turn done" : "Acts in " + turnsToGo + (turnsToGo > 1 ? " turns" : " turn")
			},
			{
				id = 3,
				type = "progressbar",
				icon = "ui/icons/armor_head.png",
				value = this.getArmor(this.Const.BodyPart.Head),
				valueMax = this.getArmorMax(this.Const.BodyPart.Head),
				text = "" + this.getArmor(this.Const.BodyPart.Head) + " / " + this.getArmorMax(this.Const.BodyPart.Head) + "",
				style = "armor-head-slim"
			},
			{
				id = 4,
				type = "progressbar",
				icon = "ui/icons/armor_body.png",
				value = this.getArmor(this.Const.BodyPart.Body),
				valueMax = this.getArmorMax(this.Const.BodyPart.Body),
				text = "" + this.getArmor(this.Const.BodyPart.Body) + " / " + this.getArmorMax(this.Const.BodyPart.Body) + "",
				style = "armor-body-slim"
			},
			{
				id = 5,
				type = "progressbar",
				icon = "ui/icons/health.png",
				value = this.getHitpoints(),
				valueMax = this.getHitpointsMax(),
				text = "" + this.getHitpoints() + " / " + this.getHitpointsMax() + "",
				style = "hitpoints-slim"
			}
		]);

		tooltip.push({
			id = 8,
			type = "progressbar",
			icon = "ui/icons/morale.png",
			value = this.getMoraleState(),
			valueMax = this.Const.MoraleState.COUNT - 1,
			text = this.Const.MoraleStateName[this.getMoraleState()],
			style = "morale-slim"
		});
		
		local battery = this.m.Skills.getSkillByID("effects.mc_powering");
		local current_power = 0;
		local max_power = 5;

		if (battery != null)
		{
			current_power = battery.m.TurnLefts;
		}

		tooltip.push({
			id = 8,
			type = "progressbar",
			icon = "ui/icons/asset_business_reputation.png",
			value = current_power,
			valueMax = max_power,
			text = "" + current_power + " / " + max_power + "",
			style = "fatigue-slim"
		});

		local result = [];
		local statusEffects = this.getSkills().query(this.Const.SkillType.StatusEffect | this.Const.SkillType.TemporaryInjury, false, true);

		foreach( i, statusEffect in statusEffects )
		{
			tooltip.push({
				id = 100 + i,
				type = "text",
				icon = statusEffect.getIcon(),
				text = statusEffect.getName()
			});
		}

		return tooltip;
	}

});

