this.alp_racial <- this.inherit("scripts/skills/skill", {
	m = {
		TimesWaited = 0
	},
	function create()
	{
		this.m.ID = "racial.alp";
		this.m.Name = "Partly Exist In Dreams";
		this.m.Description = "Has strong resistance against ranged and piercing attacks due to part of its real body only existing in a dream. It has the habbit to haunt and stalk its prey.";
		this.m.Icon = "skills/status_effect_102.png";
		this.m.IconMini = "status_effect_102_mini";
		this.m.SoundOnUse = [
			"sounds/enemies/ghost_death_01.wav",
			"sounds/enemies/ghost_death_02.wav"
		];
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}
	
	function getTooltip()
	{
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
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Causes all Alps to teleport after taking damage"
			}
		];
	}
	
	function onAdded()
	{
		if (!this.getContainer().getActor().isPlayerControlled())
		{
			return;
		}
		
		local AI = this.getContainer().getActor().getAIAgent();
		AI.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_alp_teleport"));
		
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.First + 1;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
		this.getContainer().update();
	}
	
	function onUpdate( _properties )
	{
		_properties.MeleeDamageMult *= 0.9;
		_properties.RangedDamageMult *= 0.9;
	}

	function onTurnStart()
	{
		this.m.TimesWaited = 0;
	}

	function onResumeTurn()
	{
		if (++this.m.TimesWaited <= 1 && this.getContainer().getActor().getActionPoints() >= 4)
		{
			this.getContainer().getActor().setWaitActionSpent(false);
		}
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_skill == null)
		{
			return;
		}

		if (_skill.getID() == "actives.aimed_shot" || _skill.getID() == "actives.quick_shot")
		{
			_properties.DamageReceivedRegularMult *= 0.1;
		}
		else if (_skill.getID() == "actives.shoot_bolt" || _skill.getID() == "actives.shoot_stake" || _skill.getID() == "actives.sling_stone")
		{
			_properties.DamageReceivedRegularMult *= 0.33;
		}
		else if (_skill.getID() == "actives.throw_javelin")
		{
			_properties.DamageReceivedRegularMult *= 0.25;
		}
		else if (_skill.getID() == "actives.puncture" || _skill.getID() == "actives.thrust" || _skill.getID() == "actives.stab" || _skill.getID() == "actives.impale" || _skill.getID() == "actives.prong" || _skill.getID() == "actives.rupture" || _skill.getID() == "actives.lunge" || _skill.getID() == "actives.fire_handgonne")
		{
			_properties.DamageReceivedRegularMult *= 0.5;
		}
		else if (_skill.hasDamageType(this.Const.Damage.DamageType.Piercing))
		{
			_properties.DamageReceivedRegularMult *= 0.33;
		}
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		local actor = this.getContainer().getActor();

		if (_damageHitpoints >= actor.getHitpoints())
		{
			return;
		}
		
		local tag = {
			Faction = this.getContainer().getActor().getFaction(),
		};

		this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill);
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 30, this.teleport.bindenv(this), tag);
	}

	function onDeath()
	{
		local tag = {
			Faction = this.getContainer().getActor().getFaction(),
		};
		
		this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill);
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 30, this.teleport.bindenv(this), tag);
	}

	function teleport( _tag )
	{
		local allies = this.Tactical.Entities.getInstancesOfFaction(_tag.Faction);

		foreach( a in allies )
		{
			if (a.isAlive() && a.getHitpoints() > 0 && a.getSkills().hasSkill("actives.alp_teleport"))
			{
				if (a.getFlags().get("disable_auto_teleport"))
				{
					continue;
				}

				if (!a.getAIAgent().hasKnownOpponent())
				{
					local strategy = a.getAIAgent().getStrategy().update();

					do
					{
					}
					while (!resume strategy);
				}

				local b = a.getAIAgent().getBehavior(this.Const.AI.Behavior.ID.AlpTeleport);
				b.onEvaluate(a);
				b.onExecute(a);
			}
		}
	}

});

