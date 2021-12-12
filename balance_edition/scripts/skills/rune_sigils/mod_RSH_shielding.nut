this.mod_RSH_shielding <- this.inherit("scripts/skills/skill", {
	m = {
		Hitpoints = 50,
		HitpointsMax = 100,
		HitpointsThreshold = 50,
		IsActivated = true,
		IsRegenerate = false,
		Cooldown = 2,
		IsForceEnabled = false
	},
	
	function getCooldown()
	{
		return this.m.Cooldown;
	}
	
	function getHitpoints()
	{
		return this.m.Hitpoints;
	}

	function getHitpointsMax()
	{
		return this.m.HitpointsMax;
	}

	function getHitpointsPct()
	{
		return this.Math.minf(1.0, this.getHitpoints() / this.Math.maxf(1.0, this.getHitpointsMax()));
	}

	function setHitpoints( _h )
	{
		this.m.Hitpoints = this.Math.min(this.Math.round(_h), this.getHitpointsMax());
	}

	function setHitpointsPct( _h )
	{
		this.m.Hitpoints = this.Math.round(this.getHitpointsMax() * _h);
	}
	
	function create()
	{
		this.m.ID = "special.magic_shield";
		this.m.Name = "Magic Barrier";
		this.m.Description = "An invisible magical barrier that can protect you from most physical attacks.";
		this.m.Icon = "skills/effect_mc_02.png";
		this.m.IconMini = "effect_mc_02_mini";
		this.m.Overlay = "effect_mc_02";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsSerialized = false;
	}

	function getTooltip()
	{
		local ret = [
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
				icon = "ui/icons/sturdiness.png",
				value = this.getHitpoints(),
				valueMax = this.getHitpointsMax(),
				text = "" + this.getHitpoints() + " / " + this.getHitpointsMax() + "",
				style = "armor-body-slim"
			}
		];
		
		if (this.m.IsRegenerate)
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "The Barrier needs [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.Cooldown + "[/color] turn(s) to start repairing itself."
			});
		}
		
		return ret;
	}

	function onAdded()
	{
		if (this.getContainer().getActor().getFlags().getAsInt("mc_mage") == this.Const.MC_Job.BattleMage)
		{
			this.m.HitpointsMax = 125;
			this.m.HitpointsThreshold = 75;
			this.m.Hitpoints = this.m.HitpointsThreshold;
		}
	}

	function isHidden()
	{
		if (this.getContainer().getActor().getArmor(this.Const.BodyPart.Head) <= 0)
		{
			return true;
		}

		return false;
	}

	function isActivated()
	{
		return !this.isHidden() && this.getHitpoints() > 0;
	}
	
	function onAfterUpdate( _properties )
	{
		if (this.isActivated())
		{
			_properties.IsImmuneToBleeding = true;
			_properties.IsImmuneToPoison = true;
			_properties.IsImmuneToStun = true;
		}
	}
	
	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (!this.isActivated() || (_hitInfo.DamageRegular == 0 && _hitInfo.DamageArmor == 0))
		{
			return;
		}
		
		local damage = this.Math.max(1, this.Math.floor(_hitInfo.DamageRegular * 0.75));
		local mult = _hitInfo.DamageArmor / this.Math.maxf(1.0, _hitInfo.DamageRegular);
		local shieldBreak = false;
		local isArmorDamage = false;

		if (_skill != null && _skill.getID() == "actives.crush_armor")
		{
			isArmorDamage = true;
			damage = this.Math.max(1, this.Math.floor(_hitInfo.DamageArmor * 0.75));
			mult = 1.0;
		}

		local overflow = damage - this.getHitpoints();
		this.spawnIcon("status_effect_322a", this.getContainer().getActor().getTile());
		this.spawnEffect();
			
		if (overflow <= 0)
		{
			_properties.DamageReceivedTotalMult = 0.0;
			_hitInfo.DamageRegular = 0;
			_hitInfo.DamageArmor = 0;
			_hitInfo.DamageFatigue = 0;
			_hitInfo.DamageDirect = 0.0;
			this.setHitpoints(-overflow);
			this.Tactical.EventLog.log(this.getName() + " absorbs " + damage + " damage");
		}
		else
		{
			_hitInfo.DamageRegular = isArmorDamage ? 0 : this.Math.max(1, overflow);
			_hitInfo.DamageArmor = this.Math.max(0, this.Math.floor(overflow * mult));

			if (this.getHitpoints() > 0)
			{
				this.Tactical.EventLog.log(this.getName() + " absorbs " + this.getHitpoints() + " damage");
			}

			shieldBreak = true;
		}

		if (this.getHitpoints() <= 0 || shieldBreak)
		{
			this.onShieldBreak();
		}
	}

	function onShieldBreak()
	{
		this.setHitpoints(0);
		this.m.IsRegenerate = true;
		this.m.Cooldown = 3;
		this.Tactical.EventLog.log(this.getName() + " is broken");
	}
	
	function onTurnEnd()
	{
		local actor = this.getContainer().getActor();
		local HitpointsMissing = this.getHitpointsMax() - this.getHitpoints();
		local HitPointsAdded = this.m.IsRegenerate ? this.Math.min(HitpointsMissing, 25) : this.Math.min(HitpointsMissing, 10);

		if (HitPointsAdded <= 0)
		{
			return;
		}
		
		if (--this.m.Cooldown <= 0)
		{
			this.m.Cooldown = 2;
			this.setHitpoints(this.getHitpoints() + HitPointsAdded);
			
			if (this.m.IsRegenerate)
			{
				this.m.IsRegenerate = false;
			}
			
			if (!actor.isHiddenToPlayer() && HitPointsAdded != 0)
			{
				this.spawnIcon("status_effect_322a", this.getContainer().getActor().getTile());
				this.Tactical.EventLog.log(this.getName() + " restores " + HitPointsAdded + " hitpoints");
			}
		}
	}
	
	function spawnEffect()
	{
		local owntile = this.getContainer().getActor().getTile();
		
		local effect = {
			Delay = 0,
			Quantity = 12,
			LifeTimeQuantity = 12,
			SpawnRate = 100,
			Brushes = [
				"bust_lich_aura_01"
			],
			Stages = [
				{
					LifeTimeMin = 1.0,
					LifeTimeMax = 1.0,
					ColorMin = this.createColor("ffffff5f"),
					ColorMax = this.createColor("ffffff5f"),
					ScaleMin = 1.0,
					ScaleMax = 1.0,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = this.createVec(-1.0, -1.0),
					DirectionMax = this.createVec(1.0, 1.0),
					SpawnOffsetMin = this.createVec(-10, -10),
					SpawnOffsetMax = this.createVec(10, 10),
					ForceMin = this.createVec(0, 0),
					ForceMax = this.createVec(0, 0)
				},
				{
					LifeTimeMin = 1.0,
					LifeTimeMax = 1.0,
					ColorMin = this.createColor("ffffff2f"),
					ColorMax = this.createColor("ffffff2f"),
					ScaleMin = 0.9,
					ScaleMax = 0.9,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = this.createVec(-1.0, -1.0),
					DirectionMax = this.createVec(1.0, 1.0),
					ForceMin = this.createVec(0, 0),
					ForceMax = this.createVec(0, 0)
				},
				{
					LifeTimeMin = 0.1,
					LifeTimeMax = 0.1,
					ColorMin = this.createColor("ffffff00"),
					ColorMax = this.createColor("ffffff00"),
					ScaleMin = 0.1,
					ScaleMax = 0.1,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = this.createVec(-1.0, -1.0),
					DirectionMax = this.createVec(1.0, 1.0),
					ForceMin = this.createVec(0, 0),
					ForceMax = this.createVec(0, 0)
				}
			]
		};
		this.Tactical.spawnParticleEffect(false, effect.Brushes, owntile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 40));
	}

	function onCombatStarted()
	{
		this.m.Cooldown = 2;
		this.setHitpoints(this.m.HitpointsThreshold);
	}
	
	function onCombatFinished()
	{
		this.m.IsRegenerate = false;
		this.setHitpoints(this.m.HitpointsThreshold);
	}

});

