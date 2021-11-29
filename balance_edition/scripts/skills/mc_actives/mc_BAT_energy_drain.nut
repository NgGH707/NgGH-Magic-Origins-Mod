this.mc_BAT_energy_drain <- this.inherit("scripts/skills/mc_magic_skill", {
	m = {
		Efficiency = [33, 67],
		IsUsingEnergy = false,
	},
	
	function create()
	{
		this.m.ID = "actives.mc_energy_drain";
		this.m.Name = "Energy Drain";
		this.m.Description = "Absorbing the life energy of your foes and using it for a 'greater purposes'. Accuracy based on melee skill. Damage based on resolve, deal reduced damage if you don\'t have a magic staff.";
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
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.DirectDamageMult = 1.0;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 12;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}
	
	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Completely ignores armor"
		});

		/*local e = this.getContainer().getSkillByID("special.mc_focus");

		if (e != null)
		{
			ret.extend([
				{
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Is enhanced by [color=" + this.Const.UI.Color.PositiveValue + "]Concentrate[/color] effect"
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]100%[/color] of damage done is turned into [color=" + this.Const.UI.Color.NegativeValue + "]Energy[/color]"
				}
			]);
		}
		else 
		{
		    
		}*/

		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.Efficiency[0] + "[/color] - [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.Efficiency[1] + "%[/color] of damage done is turned into [color=" + this.Const.UI.Color.NegativeValue + "]Energy[/color]"
		});

		local e = this.getContainer().getSkillByID("effects.mc_stored_energy");

		if (e != null)
		{
			ret.extend(e.getEnergyTooltips());
		}

		return ret;
	}

	function onUse( _user, _targetTile )
	{
		local e = this.getContainer().getSkillByID("effects.mc_stored_energy");

		if (e != null)
		{
			e.activate();
		}

		local ret = this.attackEntity(_user, _targetTile.getEntity());
		this.spawnEffect(_targetTile);
		return ret;
	}
	
	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill == this)
		{
			local actor = this.getContainer().getActor();
			local efficiency = this.Math.rand(this.m.Efficiency[0], this.m.Efficiency[1]) * 0.01;

			if (this.m.IsEnhanced)
			{
				efficiency = 1.0;
			}

			local energy = this.Math.max(1, this.Math.floor(_damageInflictedHitpoints * efficiency));
			local effect = this.getContainer().getSkillByID("effects.mc_stored_energy");

			if (effect == null)
			{
				effect = this.new("scripts/skills/mc_effects/mc_stored_energy_effect");
				this.getContainer().add(effect);
			}
			
			local ret = effect.addEnergy(energy);

			if (!this.getContainer().getActor().isHiddenToPlayer() && ret != 0)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " absorbed [b]" + ret + "[/b] energy from " + this.Const.UI.getColorizedEntityName(_targetEntity));
			}

			this.spawnEffect(actor.getTile());
			this.m.IsEnhanced = false;
		}
		
		this.getContainer().update();
	}
	
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin += 25;
			_properties.DamageRegularMax += 35;
			_properties.DamageArmorMult *= 0.0;
			_properties.HitChance[this.Const.BodyPart.Body] += 100.0;
			_properties.IsIgnoringArmorOnAttack = true;

			if (this.getContainer().hasSkill("special.mc_focus"))
			{
				_properties.DamageRegularMin += 5;
				_properties.DamageRegularMax += 5;
			}

			_properties.DamageTotalMult *= this.getBonusDamageFromResolve(_properties);
			this.removeBonusesFromWeapon(_properties);
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