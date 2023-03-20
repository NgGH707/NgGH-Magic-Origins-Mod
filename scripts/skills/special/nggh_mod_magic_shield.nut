this.nggh_mod_magic_shield <- ::inherit("scripts/skills/skill", {
	m = {
		HitPoints = 50,
		HitPointsMax = 100,
		IsActivated = true,
		IsRegenerate = false,
		Cooldown = 2
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
		return ::Math.minf(1.0, this.getHitpoints() / ::Math.maxf(1.0, this.getHitpointsMax()));
	}

	function setHitpoints( _h )
	{
		this.m.Hitpoints = ::Math.min(::Math.round(_h), this.getHitpointsMax());
	}

	function setHitpointsPct( _h )
	{
		this.m.Hitpoints = ::Math.round(this.getHitpointsMax() * _h);
	}
	
	function create()
	{
		this.m.ID = "special.magic_shield";
		this.m.Name = "Magic Barrier";
		this.m.Description = "An invisible magical barrier that can protect you from most physical attacks.";
		this.m.Icon = "skills/effect_mc_02.png";
		this.m.IconMini = "effect_mc_02_mini";
		this.m.Overlay = "effect_mc_02";
		this.m.Type = ::Const.SkillType.StatusEffect;
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
				value = this.m.Health,
				valueMax = this.m.HealthMax,
				text = "" + this.m.Health + " / " + this.m.HealthMax + "",
				style = "armor-body-slim"
			}
		];
		
		if (this.m.IsRegenerate)
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "The Barrier needs [color=" + ::Const.UI.Color.PositiveValue + "]" + this.m.Cooldown + "[/color] turn(s) to start repairing itself."
			});
		}
		
		return ret;
	}

	function isHidden()
	{
		if (this.getContainer().hasSkill("background.battlemage"))
		{
			return true;
		}

		local helmet = this.getContainer().getActor().getItems().getItemAtSlot(::Const.ItemSlot.Head);

		if (helmet == null || helmet.getArmor() <= 0)
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
		
		local damage = ::Math.max(1, ::Math.floor(_hitInfo.DamageRegular * 0.75));
		local mult = _hitInfo.DamageArmor / ::Math.maxf(1.0, _hitInfo.DamageRegular);
		local shieldBreak = false;

		if (_skill != null && _skill.getID() == "actives.crush_armor")
		{
			damage = ::Math.max(1, ::Math.floor(_hitInfo.DamageArmor * 0.5));
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
			::Tactical.EventLog.log(this.getName() + " absorbs " + damage + " damage");
		}
		else
		{
			_hitInfo.DamageRegular = ::Math.max(1, overflow);
			_hitInfo.DamageArmor = ::Math.max(0, ::Math.floor(overflow * mult));

			if (this.getHitpoints() > 0)
			{
				::Tactical.EventLog.log(this.getName() + " absorbs " + this.getHitpoints() + " damage");
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
		::Tactical.EventLog.log(this.getName() + " is broken");
	}
	
	function onTurnEnd()
	{
		local actor = this.getContainer().getActor();
		local HitpointsMissing = this.getHitpointsMax() - this.getHitpoints();
		local HitPointsAdded = this.m.IsRegenerate ? ::Math.min(HitpointsMissing, 25) : ::Math.min(HitpointsMissing, 10);

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
				::Tactical.EventLog.log(this.getName() + " restores " + HitPointsAdded + " hitpoints");
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
					ColorMin = ::createColor("ffffff5f"),
					ColorMax = ::createColor("ffffff5f"),
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
					LifeTimeMin = 1.0,
					LifeTimeMax = 1.0,
					ColorMin = ::createColor("ffffff2f"),
					ColorMax = ::createColor("ffffff2f"),
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
					ColorMin = ::createColor("ffffff00"),
					ColorMax = ::createColor("ffffff00"),
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
		::Tactical.spawnParticleEffect(false, effect.Brushes, owntile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, ::createVec(0, 40));
	}

	function onCombatStarted()
	{
		this.m.Cooldown = 2;
		this.setHitpoints(50);
	}
	
	function onCombatFinished()
	{
		this.m.IsRegenerate = false;
		this.setHitpoints(50);
	}

});

