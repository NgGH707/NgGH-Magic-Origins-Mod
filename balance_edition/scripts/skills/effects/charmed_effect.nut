this.charmed_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 2,
		OriginalFaction = 0,
		OriginalAgent = null,
		OriginalSocket = null,
		MasterFaction = 0,
		Master = null,
		IsBodyguard = false,
		IsTheLastEnemy = false,
		IsSuicide = false,
	},
	function isTheLastEnemy( _v )
	{
		this.m.IsTheLastEnemy = _v;
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
		this.m.ID = "effects.charmed";
		this.m.Name = "Charmed";
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
		this.m.IsRemovedAfterBattle = true;
	}
	
	function getName()
	{
		if (this.m.TurnsLeft == 0)
		{
			return this.m.Name;
		}
		
		return this.m.Name + " (" + this.m.TurnsLeft + " turns left)";
	}

	function getDescription()
	{
		return "This character has been charmed, and no longer has any control over their actions and is a puppet that has no choice but to obey a master. Wears off in [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] turn(s).\n\nThe higher a character\'s resolve, the higher the chance to resist being charmed.";
	}

	function addTurns( _t )
	{
		this.m.TurnsLeft += _t;
	}

	function onAdded()
	{
		this.m.TurnsLeft = this.Math.max(1, 2 + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);
		local actor = this.getContainer().getActor();
		local brush = "bust_base_beasts";
		
		if (actor.getAIAgent().getBehavior(this.Const.AI.Behavior.ID.Protect) != null)
		{
			this.m.IsBodyguard = true;
			actor.getAIAgent().removeBehavior(this.Const.AI.Behavior.ID.Protect);
		}
		
		if (actor.isPlayerControlled())
		{
			this.m.OriginalAgent = actor.getAIAgent();
			actor.setAIAgent(this.new("scripts/ai/tactical/agents/charmed_player_agent"));
			actor.getAIAgent().setActor(actor);
		}
		
		if (this.m.Master != null && this.m.Master.getContainer() != null && this.m.Master.getContainer().getActor() != null)
		{
			brush = this.m.Master.getContainer().getActor().getSprite("socket").getBrush().Name;
		}
		
		if (!this.m.IsTheLastEnemy)
		{
			this.m.OriginalFaction = actor.getFaction();
			actor.setFaction(this.m.MasterFaction);
			this.m.OriginalSocket = actor.getSprite("socket").getBrush().Name;
			actor.getSprite("socket").setBrush(brush);
			actor.getFlags().set("Charmed", true);
			
			if (!actor.getFlags().has("human"))
			{
				this.onFactionChanged();
			}
			
			actor.setDirty(true);
		}

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
		
		if (this.m.IsTheLastEnemy)
		{
			this.getContainer().getActor().killSilently();
		}
	}
	
	function onFactionChanged()
	{
		local actor = this.getContainer().getActor();
		local flip = actor.isAlliedWithPlayer();
		local sprites = ["surcoat", "body", "tattoo_body", "body_rage", "injury_body", "head", "tattoo_head", "beard", "hair", "beard_top", "injury", "body_blood", "head_frenzy", "accessory_special", "legs_back", "legs_front"];
		
		foreach (i, s in sprites)
		{
		    if (actor.hasSprite(s))
		    {
		    	actor.getSprite(s).setHorizontalFlipping(flip);
		    }
		}
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();

		if (this.m.IsSuicide)
		{
			return;
		}

		if (this.m.SoundOnUse.len() != 0)
		{
			this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill * 1.0, actor.getPos());
		}

		if (this.m.OriginalAgent != null)
		{
			actor.setAIAgent(this.m.OriginalAgent);
		}
		
		if (this.m.IsBodyguard)
		{
			actor.getAIAgent().addBehavior(this.new("scripts/ai/tactical/behaviors/ai_protect"));
		}

		actor.setFaction(this.m.OriginalFaction);
		actor.getSprite("socket").setBrush(this.m.OriginalSocket);
		actor.getFlags().set("Charmed", false);

		if (!actor.getFlags().has("human"))
		{
			this.onFactionChanged();
		}
		
		actor.setDirty(true);

		if (this.m.Master != null)
		{
			this.m.Master.removeSlave(actor.getID());
			this.m.Master = null;
		}
	}

	function onDeath()
	{
		this.onRemoved();
	}

	function onTurnEnd()
	{
		local actor = this.getContainer().getActor();

		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

	function onTurnStart()
	{
		if (this.m.Master != null)
		{
			if (!this.m.Master.isAlive())
			{
				this.removeSelf();
			}
		}
	}

	function onCombatFinished()
	{
		local actor = this.getContainer().getActor();

		if (this.Tactical.Entities.getInstancesNum(this.Const.Faction.Player) == 0)
		{
			actor.kill(null, null, this.Const.FatalityType.Suicide);
		}

		this.skill.onCombatFinished();
	}
	
	function onSuicide()
	{
		this.m.IsSuicide = true;
		actor.kill(null, null, this.Const.FatalityType.Suicide);
	}

	function onUpdate( _properties )
	{
		_properties.IsAffectedByDyingAllies = false;
		_properties.IsAffectedByLosingHitpoints = false;
	}

});

