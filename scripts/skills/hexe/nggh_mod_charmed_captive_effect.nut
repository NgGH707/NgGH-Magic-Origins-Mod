this.nggh_mod_charmed_captive_effect <- ::inherit("scripts/skills/skill", {
	m = {
		Color = ::createColor("#ffffff"),
		Self = null,
		Charm = null,
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

	function setCharm( _c )
	{
		this.m.Charm = ::WeakTableRef(_c);
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
		this.m.Type = ::Const.SkillType.StatusEffect;
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
		local actor = this.getContainer().getActor().get();
		this.getContainer().removeByID("effects.shieldwall");
		this.getContainer().removeByID("effects.spearwall");
		this.getContainer().removeByID("effects.riposte");
		this.getContainer().removeByID("effects.return_favor");

		if (this.m.SoundOnUse.len() != 0)
		{
			::Sound.play(::MSU.Array.rand(this.m.SoundOnUse), ::Const.Sound.Volume.Skill * 1.0, actor.getPos());
		}

		this.spawnHearts();
		
		if (this.m.IsTheLastEnemy)
		{
			this.onCombatFinished();
			this.removeSelf();
			::Tactical.Entities.setLastCombatResult(::Const.Tactical.CombatResult.EnemyRetreated);
      		::Tactical.Entities.checkCombatFinished(true);
			return;
		}
		
		actor.setFaction(::Const.Faction.PlayerAnimals);
		actor.getFlags().set("Charmed", true);

		// prevent the victim from dying in this process
		actor.setIsAlive(false);
		actor.setIsAbleToDie(false);
		
		::Tactical.TurnSequenceBar.removeEntity(actor);
		actor.m.IsActingEachTurn = false;
		actor.m.IsNonCombatant = true;

		// undo the changes
		actor.setIsAlive(true);
		actor.setIsAbleToDie(true);
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		actor.m.IsActingEachTurn = true;

		if (actor.hasSprite("status_stunned"))
		{
			actor.getSprite("status_stunned").Visible = false;
			actor.getSprite("status_stunned").Color = ::createColor("#ffffff");
		}

		actor.setDirty(true);
		
		if (this.m.SoundOnUse.len() != 0)
		{
			::Sound.play(::MSU.Array.rand(this.m.SoundOnUse), ::Const.Sound.Volume.Skill * 1.0, actor.getPos());
		}
		
		this.m.Self = null;
		actor.getFlags().set("Charmed", false);
		actor.setDirty(true);
	}

	function onDeath( _fatalityType )
	{
		if (this.m.IsKillInRightWay)
		{
			local count = ::Tactical.Entities.getFlags().getAsInt("CharmedCount");
			::Tactical.Entities.getFlags().set("CharmedCount", ::Math.max(0, count - 1));
			::Tactical.getTemporaryRoster().remove(this.m.Self);

			if (this.m.Charm != null && !this.m.Charm.isNull())
			{
				local actor = this.getContainer().getActor();
				local id = actor.getID();
				local garbage = [];

				while(garbage.len() != 0)
				{
					foreach(g in garbage)
					{
						this.m.Charm.m.Capture.remove(g);
					}

					garbage = [];

					foreach (i, c in this.m.Charm.m.Capture)
					{
						if (c == null || c.isNull() || c.getID() == id)
						{
							garbage.push(i);
							break;
						}
					}
				}
			}
		}

		this.onRemoved();
	}

	function onCombatFinished()
	{
		local actor = this.getContainer().getActor();
		local troop = actor.getWorldTroop();

		if (this.m.Self != null)
		{
			this.m.Self.setHitpoints(actor.getHitpoints());
			
			local injury = this.getContainer().getAllSkillsOfType(::Const.SkillType.Injury);
			
			foreach ( ini in injury)
			{
				this.m.Self.getSkills().add(ini);
			}
			
			//this.m.Self.getBackground().onAddEquipment();
			::World.getPlayerRoster().add(this.m.Self);
			this.m.Self.setInReserves(true);
			this.m.Self.onHired();
			
			::Tactical.getRetreatRoster().add(this.m.Self);
			::Tactical.getTemporaryRoster().remove(this.m.Self);
			this.m.Self = null;
		}
		
		if (troop != null && ("Party" in troop) && troop.Party != null && !troop.Party.isNull())
		{
			troop.Party.removeTroop(troop);
		}

		this.m.IsKillInRightWay = false;
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
	
	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
		actor.setActionPoints(0);
		this.spawnHearts();
	}

	function onResumeTurn()
	{
		this.onTurnStart();
	}

	function spawnHearts()
	{
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
					ColorMin = ::createColor("fff3e50f"),
					ColorMax = ::createColor("ffffff5f"),
					ScaleMin = 0.5,
					ScaleMax = 0.5,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = ::createVec(-0.5, 0.0),
					DirectionMax = ::createVec(0.5, 1.0),
					SpawnOffsetMin = ::createVec(-30, -70),
					SpawnOffsetMax = ::createVec(30, 30),
					ForceMin = ::createVec(0, 0),
					ForceMax = ::createVec(0, 0)
				},
				{
					LifeTimeMin = 0.1,
					LifeTimeMax = 0.1,
					ColorMin = ::createColor("fff3e500"),
					ColorMax = ::createColor("ffffff00"),
					ScaleMin = 0.1,
					ScaleMax = 0.1,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = ::createVec(-0.5, 0.0),
					DirectionMax = ::createVec(0.5, 1.0),
					ForceMin = ::createVec(0, 0),
					ForceMax = ::createVec(0, 0)
				}
			]
		};
		
		::Tactical.spawnParticleEffect(false, effect.Brushes, this.getContainer().getActor().getTile(), effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, ::createVec(0, 40));
	}

});

