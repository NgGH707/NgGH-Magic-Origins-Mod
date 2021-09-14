this.egg_attachment <- this.inherit("scripts/skills/skill", {
	m = {
		Item = null,
		Health = 0,
		HealthMax = 0,
		LastAttacker = null,
		LastAttackSkill = null,
		OldFaction = null,
		IsControlledByPlayer = true,
		IsDeath = false,
	},
	function setItem( _i )
	{
		this.m.Item = this.WeakTableRef(_i);
		local _e = this.getEgg();
		this.m.Health = _e.getHitpoints();
		this.m.HealthMax = _e.getHitpointsMax();
	}

	function getEgg()
	{
		if (this.m.Item == null)
		{
			return null;
		}

		return this.m.Item.getEntity();
	}

	function getHealthPct()
	{
		return this.Math.minf(1.0, this.m.Health / this.Math.maxf(1.0, this.m.HealthMax));
	}

	function loseHealth( _v )
	{
		local a = this.Math.min(this.m.Health, _v);
		this.m.Health = this.Math.max(0, this.m.Health - a);
		return a;
	}
	
	function create()
	{
		this.m.ID = "special.egg_attachment";
		this.m.Name = "Carrying Eggs";
		this.m.Description = "Feel like an Uber driver.";
		this.m.Icon = "skills/status_effect_eggs.png";
		this.m.IconMini = "status_effect_eggs_mini";
		this.m.Overlay = "status_effect_eggs";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsHidden = false;
		this.m.IsSerialized = false;
	}

	function getDescription()
	{
		if (this.getEgg() == null)
		{
			return this.m.Description;
		}

		return "This character is carrying " + this.Const.UI.getColorizedEntityName(this.getEgg()) + " on his back. A little bulky to walk around and easily become a target of your foes."
	}

	function getName()
	{
		if (this.getEgg() != null)
		{
			return "Carrying " + this.Const.UI.getColorizedEntityName(this.getEgg());
		}

		return this.m.Name;
	}

	function getTooltip()
	{
		local currentHealthPct = this.Math.floor(this.getHealthPct() * 100);
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 7,
				type = "progressbar",
				icon = "ui/icons/health.png",
				value = this.m.Health,
				valueMax = this.m.HealthMax,
				text = "" + this.m.Health + " / " + this.m.HealthMax + "",
				style = "hitpoints-slim"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Melee Defense"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20[/color] Ranged Defense"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15[/color] Max Fatigue"
			},
		];
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		local egg = actor.getSprite("egg");
		egg.setBrush("bust_egg_on_spider");
		egg.Visible = true;
		actor.setSize(actor.getSize());
		actor.onFactionChanged();
		actor.setDirty(true);

		if (actor.getFaction() != this.Const.Faction.Player)
		{
			this.m.OldFaction = actor.getFaction();
			this.m.IsControlledByPlayer = actor.m.IsControlledByPlayer;
			actor.m.IsControlledByPlayer = true;
			actor.setFaction(this.Const.Faction.Player);
			actor.setAIAgent(this.new("scripts/ai/tactical/player_agent"));
			actor.getAIAgent().setActor(actor);
		}

		if (this.Tactical.State.m.IsAutoRetreat)
		{
			actor.getAIAgent().setUseHeat(true);
			actor.getAIAgent().getProperties().BehaviorMult[this.Const.AI.Behavior.ID.Retreat] = 1.0;
		}
	}

	function onUpdate( _properties )
	{
		_properties.Stamina -= 15;
		_properties.MeleeDefense -= 10;
		_properties.RangedDefense -= 20;
		_properties.TargetAttractionMult *= 1.25;
	}

	function onTurnStart()
	{
		local e = this.getEgg();

		if (e == null)
		{
			return;
		}

		local p = e.getCurrentProperties();
		this.m.Health = this.Math.min(this.m.HealthMax, this.m.Health + p.HitpointsRecoveryRate * p.HitpointsRecoveryRateMult);
		e.m.Fatigue = this.Math.max(0, this.Math.min(e.getFatigueMax() - 15, this.Math.max(0, e.m.Fatigue - this.Math.max(0, p.FatigueRecoveryRate) * p.FatigueRecoveryRateMult)));
	}
	
	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_hitInfo.DamageRegular == null || _hitInfo.DamageRegular == 0)
		{
			return;
		}

		if (_skill == null || _attacker == null || _hitInfo.BodyPart != this.Const.BodyPart.Body)
		{
			return;
		}
		
		local egg = this.getEgg();
		local defendMod = egg.getSkills().buildPropertiesForBeingHit(_attacker, _skill, _hitInfo).getDamRedMod(_skill.isRanged());
		local expectedDamage = this.Math.floor(_hitInfo.DamageRegular * defendMod);
		
		_properties.DamageReceivedTotalMult = 0.0;
		_hitInfo.DamageRegular = 0;
		_hitInfo.DamageArmor = 0;
		_hitInfo.DamageFatigue = 0;
		_hitInfo.DamageDirect = 0.0;
		this.spawnIcon(this.m.Overlay, this.getContainer().getActor().getTile());
		local ret = this.loseHealth(expectedDamage);
		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(egg) + " is hit for [b]" + this.Math.floor(ret) + "[/b] damage");

		if (this.m.Health == 0)
		{
			this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_attacker) + " has killed " + this.Const.UI.getColorizedEntityName(egg));
			this.m.LastAttacker = _attacker;
			this.m.LastAttackSkill = _skill;
			this.onEggDie();
			this.m.Item.m.Entity = null;
			this.m.Item.onDone();
		}
	}

	function onDeath()
	{
		this.m.IsDeath = true;
	}

	function onRemoved()
	{
		local egg = this.getEgg();
		local actor = this.getContainer().getActor();
		actor.getSprite("egg").Visible = false;
		actor.getSprite("egg").resetBrush();
		actor.setDirty(true);

		if (!this.m.IsControlledByPlayer)
		{
			actor.m.IsControlledByPlayer = false;
		}

		if (this.m.OldFaction != null)
		{
			actor.setFaction(this.m.OldFaction);
		}
	}

	function onEggDie()
	{
		local _skill = this.m.LastAttackSkill;
		local _killer = this.m.LastAttacker;

		if (_killer != null && !_killer.isAlive())
		{
			_killer = null;
		}

		local egg = this.getEgg();
		egg.m.IsDying = true;
		local actor = this.getContainer().getActor();
		local myTile = actor.isPlacedOnMap() ? actor.getTile() : null;
		local tile = actor.findTileToSpawnCorpse(_killer);
		egg.onDeath(_killer, _skill, tile, this.Const.FatalityType.None);

		if (!this.Tactical.State.isFleeing() && _killer != null)
		{
			_killer.onActorKilled(egg, tile, _skill);
		}

		if (!this.Tactical.State.isFleeing() && myTile != null)
		{
			local actors = this.Tactical.Entities.getAllInstances();

			foreach( i in actors )
			{
				foreach( a in i )
				{
					if (a.getID() != egg.getID())
					{
						if (!a.m.IsAlive || a.m.IsDying)
						{
							continue;
						}

						if (egg.getFaction() == a.getFaction() && egg.getCurrentProperties().TargetAttractionMult > 0.5 && a.getCurrentProperties().IsAffectedByDyingAllies)
						{
							local difficulty = this.Const.Morale.AllyKilledBaseDifficulty - egg.getXPValue() * this.Const.Morale.AllyKilledXPMult + this.Math.pow(myTile.getDistanceTo(a.getTile()), this.Const.Morale.AllyKilledDistancePow);

							if (_killer != null)
							{
								difficulty = this.Math.floor((this.Const.Morale.AllyKilledBaseDifficulty - egg.getXPValue() * this.Const.Morale.AllyKilledXPMult + this.Math.pow(myTile.getDistanceTo(a.getTile()), this.Const.Morale.AllyKilledDistancePow)) * _killer.getPercentOnKillOtherActorModifier()) + _killer.getFlatOnKillOtherActorModifier();
							}

							a.checkMorale(-1, difficulty, this.Const.MoraleCheckType.Default, "", true);
						}
						else if (a.getAlliedFactions().find(egg.getFaction()) == null)
						{
							local difficulty = this.Const.Morale.EnemyKilledBaseDifficulty + egg.getXPValue() * this.Const.Morale.EnemyKilledXPMult - this.Math.pow(myTile.getDistanceTo(a.getTile()), this.Const.Morale.EnemyKilledDistancePow);

							if (_killer != null && _killer.isAlive() && _killer.getID() == a.getID())
							{
								difficulty = difficulty + this.Const.Morale.EnemyKilledSelfBonus;
							}

							a.checkMorale(1, difficulty);
						}
					}
				}
			}
		}

		egg.m.IsAlive = false;

		if (!this.Tactical.State.isScenarioMode())
		{
			this.World.Contracts.onActorKilled(egg, _killer, this.Tactical.State.getStrategicProperties().CombatID);
			this.World.Events.onActorKilled(egg, _killer, this.Tactical.State.getStrategicProperties().CombatID);

			if (this.Tactical.State.getStrategicProperties() != null && this.Tactical.State.getStrategicProperties().IsArenaMode)
			{
				if (_killer == null)
				{
					this.Sound.play(this.Const.Sound.ArenaFlee[this.Math.rand(0, this.Const.Sound.ArenaFlee.len() - 1)], this.Const.Sound.Volume.Tactical * this.Const.Sound.Volume.Arena);
				}
				else
				{
					this.Sound.play(this.Const.Sound.ArenaKill[this.Math.rand(0, this.Const.Sound.ArenaKill.len() - 1)], this.Const.Sound.Volume.Tactical * this.Const.Sound.Volume.Arena);
				}
			}
		}

		this.World.getPlayerRoster().remove(egg);
		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			if (bro.isAlive() && !bro.isDying() && bro.getCurrentProperties().IsAffectedByDyingAllies)
			{
				if (this.World.Assets.getOrigin().getID() != "scenario.manhunters")
				{
					bro.worsenMood(this.Const.MoodChange.BrotherDied, egg.getName() + " died in battle");
				}
			}
		}

		egg.die();

		if (egg.m.Items != null)
		{
			egg.m.Items.onActorDied(tile);
			egg.m.Items.setActor(null);
		}
	}

});

