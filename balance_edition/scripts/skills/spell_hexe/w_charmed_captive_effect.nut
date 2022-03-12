this.w_charmed_captive_effect <- this.inherit("scripts/skills/skill", {
	m = {
		Color = this.createColor("#ffffff"),
		Self = null,
		MasterFaction = 0,
		Master = null,
		TurnsLeft = 0,
		IsTheLastEnemy = false,
		IsKillInRightWay = true,
	},
	
	function isTheLastEnemy( _v )
	{
		this.m.IsTheLastEnemy = _v;
	}
	
	function setSelf( _s )
	{
		this.m.Self = _s;
	}
	
	function setMasterFaction( _f )
	{
		this.m.MasterFaction = _f;
	}

	function setMaster( _f )
	{
		this.m.Master = _f;
	}

	function create()
	{
		this.m.ID = "effects.charmed_captive";
		this.m.Name = "Bewitched";
		this.m.Icon = "skills/status_effect_85.png";
		this.m.IconMini = "status_effect_85_mini";
		this.m.Overlay = "status_effect_85";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/hexe_charm_chimes_01.wav",
			"sounds/enemies/dlc2/hexe_charm_chimes_02.wav",
			"sounds/enemies/dlc2/hexe_charm_chimes_03.wav",
			"sounds/enemies/dlc2/hexe_charm_chimes_04.wav"
		];
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
	}

	function getDescription()
	{
		return "This character has been charmed. He no longer has any control over his actions and is a puppet that has no choice but to obey his master. Wears off in [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] turn(s).\n\nThe higher a character\'s resolve, the higher the chance to resist being charmed.";
	}

	function addTurns( _t )
	{
		this.m.TurnsLeft += _t;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		this.getContainer().removeByID("effects.shieldwall");
		this.getContainer().removeByID("effects.spearwall");
		this.getContainer().removeByID("effects.riposte");
		this.getContainer().removeByID("effects.return_favor");

		if (this.m.SoundOnUse.len() != 0)
		{
			this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill * 1.0, actor.getPos());
		}

		local effect = {
			Delay = 0,
			Quantity = 50,
			LifeTimeQuantity = 50,
			SpawnRate = 1000,
			Brushes = [
				"effect_heart_01"
			],
			Stages = [
				{
					LifeTimeMin = 1.0,
					LifeTimeMax = 1.0,
					ColorMin = this.createColor("fff3e50f"),
					ColorMax = this.createColor("ffffff5f"),
					ScaleMin = 0.5,
					ScaleMax = 0.5,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = this.createVec(-0.5, 0.0),
					DirectionMax = this.createVec(0.5, 1.0),
					SpawnOffsetMin = this.createVec(-30, -70),
					SpawnOffsetMax = this.createVec(30, 30),
					ForceMin = this.createVec(0, 0),
					ForceMax = this.createVec(0, 0)
				},
				{
					LifeTimeMin = 0.1,
					LifeTimeMax = 0.1,
					ColorMin = this.createColor("fff3e500"),
					ColorMax = this.createColor("ffffff00"),
					ScaleMin = 0.1,
					ScaleMax = 0.1,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = this.createVec(-0.5, 0.0),
					DirectionMax = this.createVec(0.5, 1.0),
					ForceMin = this.createVec(0, 0),
					ForceMax = this.createVec(0, 0)
				}
			]
		};
		
		this.Tactical.spawnParticleEffect(false, effect.Brushes, actor.getTile(), effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 40));
		
		if (!this.m.IsTheLastEnemy)
		{
			actor.setFaction(this.Const.Faction.PlayerAnimals);
			actor.getFlags().set("Charmed", true);
			actor.setIsAlive(false);
			actor.setIsAbleToDie(false);
			
			local entity = actor.get();
			this.Tactical.TurnSequenceBar.removeEntity(entity);
			entity.m.IsActingEachTurn = false;
			entity.m.IsNonCombatant = true;
			
			if (!actor.getFlags().has("human"))
			{
				this.onFactionChanged();
			}
			
			actor.setDirty(true);
			actor.setIsAlive(true);
			actor.setIsAbleToDie(true);
		}
		else
		{
			this.onCombatFinished();
		}
	}
	
	function onFactionChanged()
	{
		local actor = this.getContainer().getActor();
		local flip = actor.isAlliedWithPlayer();
		actor.getSprite("arrow").setHorizontalFlipping(flip);
		actor.getSprite("status_rooted_back").setHorizontalFlipping(flip);
		actor.getSprite("status_stunned").setHorizontalFlipping(flip);
		actor.getSprite("shield_icon").setHorizontalFlipping(flip);
		actor.getSprite("arms_icon").setHorizontalFlipping(flip);
		actor.getSprite("status_rooted").setHorizontalFlipping(flip);
		actor.getSprite("status_hex").setHorizontalFlipping(flip);

		if (actor.m.MoraleState != this.Const.MoraleState.Ignore)
		{
			local morale = actor.getSprite("morale");
			morale.setHorizontalFlipping(flip);

			if (actor.m.MoraleState == this.Const.MoraleState.Confident)
			{
				morale.setBrush(actor.m.ConfidentMoraleBrush);
			}
		}
		
		local flip = !actor.isAlliedWithPlayer();

		foreach( a in this.Const.CharacterSprites.Helmets )
		{
			if (!actor.hasSprite(a))
			{
				continue;
			}

			actor.getSprite(a).setHorizontalFlipping(flip);
		}
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		actor.m.IsActingEachTurn = true;

		if (actor.hasSprite("status_stunned"))
		{
			actor.getSprite("status_stunned").Visible = false;
			actor.getSprite("status_stunned").Color = this.createColor("#ffffff");
		}

		actor.setDirty(true);
		
		if (this.m.SoundOnUse.len() != 0)
		{
			this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill * 1.0, actor.getPos());
		}
		
		this.m.Self = null;
		actor.getFlags().set("Charmed", false);
		actor.setDirty(true);
	}

	function onDeath( _fatalityType )
	{
		if (this.m.IsKillInRightWay)
		{
			local count = this.World.Flags.getAsInt("CharmedCount");
			this.World.Flags.set("CharmedCount", this.Math.max(0, count - 1));
		}
	}

	function onCombatFinished()
	{
		local actor = this.getContainer().getActor();

		if (this.m.Self != null)
		{
			this.m.Self.setHitpoints(actor.getHitpoints());
			
			local injury = this.getContainer().getAllSkillsOfType(this.Const.SkillType.Injury);
			
			foreach ( ini in injury)
			{
				this.m.Self.getSkills().add(ini);
			}
			
			this.m.Self.getBackground().onAddEquipment();
			this.World.getPlayerRoster().add(this.m.Self);
			this.m.Self.onHired();
			this.m.Self = null;
		}
		
		this.m.IsKillInRightWay = false;
		actor.kill(this.m.Master, this, this.Const.FatalityType.Suicide, true);
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		
		_properties.IsAffectedByDyingAllies = false;
		_properties.IsAffectedByLosingHitpoints = false;
		_properties.IsStunned = true;
		
		if (actor.hasSprite("status_stunned"))
		{
			local charm = actor.getSprite("status_stunned");
			local fadeIn = !charm.Visible;

			if (fadeIn)
			{
				charm.setBrush("bust_captive_charm");
				charm.Color = this.m.Color;
				charm.Alpha = 0;
				charm.Visible = true;
				charm.fadeIn(700);
				actor.setDirty(true);
			}
		}
		else
		{
			local charm = actor.addSprite("status_stunned");
			charm.setBrush("bust_captive_charm");
			charm.Color = this.m.Color;
			charm.Alpha = 0;
			charm.Visible = true;
			charm.fadeIn(700);
			actor.setDirty(true);
		}
	}

	function onResumeTurn()
	{
		this.onTurnStart();
	}
	
	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
		actor.setActionPoints(0);
		
		if (actor.getFaction() != this.Const.Faction.PlayerAnimals)
		{
			actor.setFaction(this.Const.Faction.PlayerAnimals);
			actor.getFlags().set("Charmed", true);
			actor.setDirty(true);
		}
	
		local effect = {
			Delay = 0,
			Quantity = 50,
			LifeTimeQuantity = 50,
			SpawnRate = 1000,
			Brushes = [
				"effect_heart_01"
			],
			Stages = [
				{
					LifeTimeMin = 1.0,
					LifeTimeMax = 1.0,
					ColorMin = this.createColor("fff3e50f"),
					ColorMax = this.createColor("ffffff5f"),
					ScaleMin = 0.5,
					ScaleMax = 0.5,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = this.createVec(-0.5, 0.0),
					DirectionMax = this.createVec(0.5, 1.0),
					SpawnOffsetMin = this.createVec(-30, -70),
					SpawnOffsetMax = this.createVec(30, 30),
					ForceMin = this.createVec(0, 0),
					ForceMax = this.createVec(0, 0)
				},
				{
					LifeTimeMin = 0.1,
					LifeTimeMax = 0.1,
					ColorMin = this.createColor("fff3e500"),
					ColorMax = this.createColor("ffffff00"),
					ScaleMin = 0.1,
					ScaleMax = 0.1,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = this.createVec(-0.5, 0.0),
					DirectionMax = this.createVec(0.5, 1.0),
					ForceMin = this.createVec(0, 0),
					ForceMax = this.createVec(0, 0)
				}
			]
		};
		
		this.Tactical.spawnParticleEffect(false, effect.Brushes, this.getContainer().getActor().getTile(), effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 40));
	}

});

