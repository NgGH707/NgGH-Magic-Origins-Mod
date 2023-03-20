this.nggh_mod_alp_nightmare_minion <- ::inherit("scripts/entity/tactical/nggh_mod_minion", {
	m = {
		Link = null,
		Bust = "bust_alp_shadow_01",
		DistortTargetA = null,
		DistortTargetPrevA = ::createVec(0, 0),
		DistortAnimationStartTimeA = 0,
		DistortTargetB = null,
		DistortTargetPrevB = ::createVec(0, 0),
		DistortAnimationStartTimeB = 0,
		DistortTargetC = null,
		DistortTargetPrevC = ::createVec(0, 0),
		DistortAnimationStartTimeC = 0,
		DistortTargetD = null,
		DistortTargetPrevD = ::createVec(0, 0),
		DistortAnimationStartTimeD = 0
	},
	function getLink()
	{
		return this.m.Link;
	}
	
	function setLink( _l )
	{
		if (_l == null)
		{
			this.m.Link = null;
		}
		else if (typeof _l == "instance")
		{
			this.m.Link = _l;
		}
		else 
		{
		 	this.m.Link = ::WeakTableRef(_l);
		}
	}

	function create()
	{
		this.m.Type = ::Const.EntityType.AlpShadow;
		this.m.BloodType = ::Const.BloodType.None;
		this.m.MoraleState = ::Const.MoraleState.Ignore;
		this.m.XP = this.Const.Tactical.Actor.AlpShadow.XP;
		this.m.IsSummoned = true;
		this.m.IsActingImmediately = true;
		this.m.IsEmittingMovementSounds = false;
		this.nggh_mod_minion.create();
		this.m.Sound[::Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/ghost_death_01.wav",
			"sounds/enemies/ghost_death_02.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.DamageReceived] = [];
		this.m.SoundPitch = ::Math.rand(90, 110) * 0.01;
		this.m.AIAgent = ::new("scripts/ai/tactical/player_agent");
		this.m.AIAgent.setActor(this);
		this.m.Flags.add("alp");
		this.m.Flags.add("shadow");
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (this.m.Link != null && !this.m.Link.isNull() && this.m.Master != null && !this.m.Master.isNull() && this.m.Master.isAlive() && !this.m.Master.isDying())
		{
			this.m.Link.removeCopy();
		}

		if (_tile != null)
		{
			this.spawnShadowEffect(_tile);
		}

		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function spawnShadowEffect( _tile = null )
	{
		if (_tile == null)
		{
			_tile = this.getTile();
		}

		local brush = this.m.Bust;

		if (this.isPlayerControlled())
		{
			brush = "mc_" + brush;
		}

		local effect = {
			Delay = 0,
			Quantity = 12,
			LifeTimeQuantity = 12,
			SpawnRate = 100,
			Brushes = [
				brush
			],
			Stages = [
				{
					LifeTimeMin = 0.5,
					LifeTimeMax = 0.5,
					ColorMin = ::createColor("0000002f"),
					ColorMax = ::createColor("0000002f"),
					ScaleMin = 1.0,
					ScaleMax = 1.0,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = ::createVec(-1.0, -1.0),
					DirectionMax = ::createVec(1.0, 1.0),
					SpawnOffsetMin = ::createVec(-10, -10),
					SpawnOffsetMax = ::createVec(10, 10),
					ForceMin = ::createVec(0, 0),
					ForceMax = ::createVec(0, 0)
				},
				{
					LifeTimeMin = 0.5,
					LifeTimeMax = 0.5,
					ColorMin = ::createColor("0000001f"),
					ColorMax = ::createColor("0000001f"),
					ScaleMin = 0.9,
					ScaleMax = 0.9,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = ::createVec(-1.0, -1.0),
					DirectionMax = ::createVec(1.0, 1.0),
					ForceMin = ::createVec(0, 0),
					ForceMax = ::createVec(0, 0)
				},
				{
					LifeTimeMin = 0.1,
					LifeTimeMax = 0.1,
					ColorMin = ::createColor("00000000"),
					ColorMax = ::createColor("00000000"),
					ScaleMin = 0.1,
					ScaleMax = 0.1,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = ::createVec(-1.0, -1.0),
					DirectionMax = ::createVec(1.0, 1.0),
					ForceMin = ::createVec(0, 0),
					ForceMax = ::createVec(0, 0)
				}
			]
		};
		::Tactical.spawnParticleEffect(false, effect.Brushes, _tile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, ::createVec(0, 40));
	}

	function onFactionChanged()
	{
		this.actor.onFactionChanged();
		local flip = this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("head").setHorizontalFlipping(flip);
		this.getSprite("blur_1").setHorizontalFlipping(flip);
		this.getSprite("blur_2").setHorizontalFlipping(flip);

		if (this.isPlayerControlled())
		{
			this.m.AIAgent = ::new("scripts/ai/tactical/player_agent");
			this.m.AIAgent.setActor(this);
		}
		else 
		{
			this.m.AIAgent = ::new("scripts/ai/tactical/agents/alp_shadow_agent");
			this.m.AIAgent.setActor(this);    
		}
	}

	function strengthen( _summoner )
	{
		local resolve = _summoner.getCurrentProperties().getBravery();

		if (resolve <= 100)
		{
			return;
		}

		local r = resolve - 100;
		local b = this.m.BaseProperties;
		b.DamageRegularMin += ::Math.max(1, ::Math.ceil(r * 0.25));
		b.DamageRegularMax += ::Math.max(1, ::Math.ceil(r * 0.5));
		b.MeleeSkill += ::Math.max(1, ::Math.ceil(r * 0.5));
		b.RangedSkill += ::Math.max(1, ::Math.ceil(r * 0.5));
		b.MeleeDefense += ::Math.max(1, ::Math.ceil(r * 0.33));
		b.RangedDefense += ::Math.max(1, ::Math.ceil(r * 0.33));

		if (::Math.rand(1, 100) <= r)
		{
			this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_alp_mind_break"));
		}

		if (::Math.rand(1, 100) <= r - 10)
		{
			this.m.Skills.add(::new("scripts/skills/perks/perk_fearsome"));
		}

		if (::Math.rand(1, 100) <= r - 25)
		{
			this.m.Skills.add(::new("scripts/skills/perks/perk_nine_lives"));
		}

		this.m.Skills.update();
		this.setHitpointsPct(1.0);
	}

	function onInit()
	{
		this.actor.onInit();
		this.setRenderCallbackEnabled(true);
		local b = this.m.BaseProperties;
		b.setValues(::Const.Tactical.Actor.AlpShadow);

		if (!::Tactical.State.isScenarioMode() && ::World.getTime().Days >= 150)
		{
			b.MeleeSkill += 5;
			b.MeleeDefense += 5;
		}

		b.MeleeSkill += 10;
		b.MeleeDefense += 15;
		b.RangedDefense += 15;
		b.Vision = 5;
		b.TargetAttractionMult = 0.75;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToRoot = true;
		b.IsImmuneToDisarm = true;
		b.IsIgnoringArmorOnAttack = true;
		b.IsAffectedByRain = false;
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsMovable = false;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = ::Const.SameMovementAPCost;
		this.m.FatigueCosts = ::Const.DefaultMovementFatigueCost;
		this.m.MaxTraversibleLevels = 3;
		local variant = ::Math.rand(1, 3);
		this.m.Bust = "bust_alp_shadow_0" + variant;
		local blurAlpha = 110;
		local socket = this.addSprite("socket");
		socket.setBrush("bust_base_shadow");
		local body = this.addSprite("body");
		body.setBrush(this.m.Bust);
		body.Alpha = 0;
		body.fadeToAlpha(blurAlpha, 750);
		local head = this.addSprite("head");
		head.setBrush(this.m.Bust);
		head.Alpha = 0;
		head.fadeToAlpha(blurAlpha, 750);
		local blur_1 = this.addSprite("blur_1");
		blur_1.setBrush(this.m.Bust);
		blur_1.Alpha = 0;
		blur_1.fadeToAlpha(blurAlpha, 750);
		local blur_2 = this.addSprite("blur_2");
		blur_2.setBrush(this.m.Bust);
		blur_2.Alpha = 0;
		blur_2.fadeToAlpha(blurAlpha, 750);
		this.addDefaultStatusSprites();
		local morale = this.addSprite("morale");
		morale.Visible = false;
		this.getSprite("status_rooted").Scale = 0.55;
		this.setSpriteOffset("status_rooted", ::createVec(-5, -5));
		this.m.Skills.add(::new("scripts/skills/racial/ghost_racial"));
		this.m.Skills.add(::new("scripts/skills/actives/nightmare_skill"));
		this.m.Skills.add(::new("scripts/skills/actives/nggh_mod_alp_shadow_teleport_skill"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_anticipation"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_underdog"));
		local touch = ::new("scripts/skills/actives/ghastly_touch");
		this.m.Skills.add(touch);
		touch.setOrder(::Const.SkillOrder.First);

		switch (this.Math.rand(0, 4))
		{
	    case 1:
	        this.m.Skills.add(::new("scripts/skills/actives/legend_wither"));
	        break;

	    case 2:
	    	this.m.Skills.add(::new("scripts/skills/actives/horrific_scream"));
	        break;

	    case 3:
	    	this.m.Skills.add(::new("scripts/skills/actives/sleep_skill"));
	        break;

	    default:
	    	local skill = ::new("scripts/skills/actives/legend_hex_skill")
	    	skill.m.Cooldown = 0;
	    	skill.m.Delay = 0;
		    this.m.Skills.add(skill);
		}
	}

	function onActorKilled( _actor, _tile, _skill )
	{
		this.nggh_mod_minion.onActorKilled(_actor, _tile, _skill);

		if (this.m.Link != null && !this.m.Link.isNull())
		{
			this.m.Link.spawnReignOfShadow([_tile]);
		}
	}

	function onRender()
	{
		this.actor.onRender();

		if (this.m.DistortTargetA == null)
		{
			this.m.DistortTargetA = ::createVec(::Math.rand(0, 10) - 5, ::Math.rand(0, 10) - 5);
			this.m.DistortAnimationStartTimeA = ::Time.getVirtualTimeF();
		}

		if (this.moveSpriteOffset("head", this.m.DistortTargetPrevA, this.m.DistortTargetA, 3.8, this.m.DistortAnimationStartTimeA))
		{
			this.m.DistortAnimationStartTimeA = ::Time.getVirtualTimeF();
			this.m.DistortTargetPrevA = this.m.DistortTargetA;
			this.m.DistortTargetA = ::createVec(::Math.rand(0, 10) - 5, ::Math.rand(0, 10) - 5);
		}

		if (this.m.DistortTargetB == null)
		{
			this.m.DistortTargetB = ::createVec(::Math.rand(0, 10) - 5, ::Math.rand(0, 10) - 5);
			this.m.DistortAnimationStartTimeB = ::Time.getVirtualTimeF();
		}

		if (this.moveSpriteOffset("blur_1", this.m.DistortTargetPrevB, this.m.DistortTargetB, 4.9000001, this.m.DistortAnimationStartTimeB))
		{
			this.m.DistortAnimationStartTimeB = ::Time.getVirtualTimeF();
			this.m.DistortTargetPrevB = this.m.DistortTargetB;
			this.m.DistortTargetB = ::createVec(::Math.rand(0, 10) - 5, ::Math.rand(0, 10) - 5);
		}

		if (this.m.DistortTargetC == null)
		{
			this.m.DistortTargetC = ::createVec(::Math.rand(0, 10) - 5, ::Math.rand(0, 10) - 5);
			this.m.DistortAnimationStartTimeC = ::Time.getVirtualTimeF();
		}

		if (this.moveSpriteOffset("body", this.m.DistortTargetPrevC, this.m.DistortTargetC, 4.3, this.m.DistortAnimationStartTimeC))
		{
			this.m.DistortAnimationStartTimeC = ::Time.getVirtualTimeF();
			this.m.DistortTargetPrevC = this.m.DistortTargetC;
			this.m.DistortTargetC = ::createVec(::Math.rand(0, 10) - 5, ::Math.rand(0, 10) - 5);
		}

		if (this.m.DistortTargetD == null)
		{
			this.m.DistortTargetD = ::createVec(::Math.rand(0, 10) - 5, ::Math.rand(0, 10) - 5);
			this.m.DistortAnimationStartTimeD = ::Time.getVirtualTimeF();
		}

		if (this.moveSpriteOffset("blur_2", this.m.DistortTargetPrevD, this.m.DistortTargetD, 5.5999999, this.m.DistortAnimationStartTimeD))
		{
			this.m.DistortAnimationStartTimeD = ::Time.getVirtualTimeF();
			this.m.DistortTargetPrevD = this.m.DistortTargetD;
			this.m.DistortTargetD = ::createVec(::Math.rand(0, 10) - 5, ::Math.rand(0, 10) - 5);
		}
	}

	function onMissed( _attacker, _skill, _dontShake = false )
	{
		this.spawnShadowEffect();
		this.actor.onMissed(_attacker, _skill, _dontShake);
	}

	function onRoundStart()
	{
		if (this.getTile().Properties.Effect == null || this.getTile().Properties.Effect.Timeout == ::Time.getRound() || this.getTile().Properties.Effect.Type != "shadows")
		{
			this.kill(null, null, ::Const.FatalityType.None, false);
		}
		else
		{
			this.actor.onRoundStart();
		}
	}

	function onMovementFinish( _tile )
	{
		if (this.getTile().Properties.Effect == null || this.getTile().Properties.Effect.Type != "shadows")
		{
			this.kill(null, null, ::Const.FatalityType.None, false);
		}
		else
		{
		    this.actor.onMovementFinish(_tile);
		}
	}

});

