this.mc_BAT_energy_drain <- this.inherit("scripts/skills/mc_magic_skill", {
	m = {
		DamageMin = 15,
		DamageMax = 35,
		CriticalChance = 5,
		Efficiency = [60, 90],
		IsUsingEnergy = false,
	},
	
	function create()
	{
		this.m.ID = "actives.mc_energy_drain";
		this.m.Name = "Energy Drain";
		this.m.Description = "Absorbing the life energy of your foes and using it for a 'greater purposes'. Accuracy based on melee skill. Efficiency based on resolve.";
		this.m.KilledString = "Sucked all life";
		this.m.Icon = "skills/active_mc_01.png";
		this.m.IconDisabled = "skills/active_mc_01_sw.png";
		this.m.Overlay = "active_mc_01";
		this.m.SoundOnHit = [
			"sounds/enemies/vampire_life_drain_01.wav",
			"sounds/enemies/vampire_life_drain_02.wav",
			"sounds/enemies/vampire_life_drain_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.TemporaryInjury + 1;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.DirectDamageMult = 1.0;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
	}
	
	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		local properties = this.getContainer().getActor().getCurrentProperties()
		local mult = this.getBonusDamageFromResolve(properties);
		local damage_max = this.Math.floor(this.m.DamageMax * mult * properties.FatigueDealtPerHitMult);
		local damage_min = this.Math.floor(this.m.DamageMin * mult * properties.FatigueDealtPerHitMult);
		ret.extend([
			{
				id = 9,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "Inflicts [color=" + this.Const.UI.Color.DamageValue + "]" + damage_min + "[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + damage_max + "[/color] fatigue damage"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
			}
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.Efficiency[0] + "[/color] - [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.Efficiency[1] + "%[/color] of fatigue damage done is turned into [color=" + this.Const.UI.Color.NegativeValue + "]Energy[/color]"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Gains less energy for target that is not in melee range"
			}
		]);

		local e = this.getContainer().getSkillByID("effects.mc_stored_energy");

		if (e != null)
		{
			ret.extend(e.getEnergyTooltips(false));
		}

		return ret;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local ret = this.attackEntity(_user, target);
		this.spawnEffect(_targetTile);

		if (ret)
		{
			local dis = _user.getTile().getDistanceTo(_targetTile);
			local properties = _user.getCurrentProperties();
			local mult = this.getBonusDamageFromResolve(properties);
			local damage = this.Math.rand(this.m.DamageMin, this.m.DamageMax) * mult * properties.FatigueDealtPerHitMult;

			if (this.Math.rand(1, 100) <= this.m.CriticalChance)
			{
				damage *= 1.5;
			}

			damage = this.Math.floor(damage);
			local efficiency = this.Math.rand(this.m.Efficiency[0], this.m.Efficiency[1]) * 0.01;

			if (dis > 1)
			{
				efficiency *= 0.67;
			}

			local energy = this.Math.max(1, this.Math.floor(damage * efficiency));
			local effect = this.getContainer().getSkillByID("effects.mc_stored_energy");

			if (effect == null)
			{
				effect = this.new("scripts/skills/mc_effects/mc_stored_energy_effect");
				this.getContainer().add(effect);
			}
			
			local added = effect.addEnergy(energy);

			if (!_user.isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " dealt [b]" + damage + "[/b] fatigue damage to " + this.Const.UI.getColorizedEntityName(target));

				if (added != 0)
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " absorbed [b]" + added + "[/b] energy from " + this.Const.UI.getColorizedEntityName(target));
				}
			}

			this.applyFatigueDamage(target, this.Math.floor(damage));
			this.spawnEffect(_user.getTile());
		}

		return ret;
	}
	
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageTotalMult = 0.0;
			_properties.HitChanceMult[this.Const.BodyPart.Head] = 0.0;
		}
	}
	
	function spawnEffect( _tile )
	{
		local effect = {
			Delay = 0,
			Quantity = 12,
			LifeTimeQuantity = 12,
			SpawnRate = 100,
			Brushes = [
				"bust_ghost_fog_02"
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
		this.Tactical.spawnParticleEffect(false, effect.Brushes, _tile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 40));
	}
	
});