this.mc_BAT_silver_lance <- this.inherit("scripts/skills/mc_magic_skill", {
	m = {
		AdditionalAccuracy = 0,
		AdditionalHitChance = 0,
		ShieldDamage = 5, 
		SoundOnMissTarget = [
			"sounds/combat/dlc2/throwing_spear_miss_01.wav",
			"sounds/combat/dlc2/throwing_spear_miss_02.wav",
			"sounds/combat/dlc2/throwing_spear_miss_03.wav",
			"sounds/combat/dlc2/throwing_spear_miss_04.wav"
		],
		IsUsingEnergy = false,
	},
	function create()
	{
		this.mc_magic_skill.create();
		this.m.ID = "actives.mc_silver_lance";
		this.m.Name = "Silver Lance";
		this.m.Description = "Hurling a lance make out of silver that can even pierce through shield if enhanced, Accuracy based on ranged skill. Or thrusting it at target in melee range, accuracy based on melee skill. Damage based on resolve, deal reduced damage if you don\'t have a magic staff.";
		this.m.KilledString = "Impaled";
		this.m.Icon = "skills/active_mc_02.png";
		this.m.IconDisabled = "skills/active_mc_02_sw.png";
		this.m.Overlay = "active_mc_02";
		this.m.SoundOnUse = [];
		this.m.SoundOnHit = [
			"sounds/combat/dlc2/throwing_spear_hit_01.wav",
			"sounds/combat/dlc2/throwing_spear_hit_02.wav",
			"sounds/combat/dlc2/throwing_spear_hit_03.wav",
			"sounds/combat/dlc2/throwing_spear_hit_04.wav"
		];
		this.m.SoundOnHitShield = [
			"sounds/combat/dlc2/throwing_spear_hit_shield_01.wav",
			"sounds/combat/dlc2/throwing_spear_hit_shield_02.wav",
			"sounds/combat/dlc2/throwing_spear_hit_shield_03.wav",
			"sounds/combat/dlc2/throwing_spear_hit_shield_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.TemporaryInjury + 2;
		this.m.Delay = 0;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsDoingForwardMove = false;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.DirectDamageMult = 0.45;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 20;
		this.m.MaxRangeBonus = 9;
		this.m.MinRange = 1;
		this.m.MaxRange = 6;
		this.m.IsRanged = true;
		this.m.IsShowingProjectile = true;
		this.m.ProjectileType = this.Const.ProjectileType.Javelin;
	}

	function addResources()
	{
		this.skill.addResources();

		foreach( r in this.m.SoundOnMissTarget )
		{
			this.Tactical.addResource(r);
		}
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();

		//Ranged part
		ret.extend([
			{
				id = 3,
				type = "text",
				text = "[u][size=14]When Throwing[/size][/u]"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]2[/color]-[color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles on even ground, more if throwing downhill"
			}
		]);

		if (10 + this.m.AdditionalAccuracy >= 0)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "Has [color=" + this.Const.UI.Color.PositiveValue + "]+" + (10 + this.m.AdditionalAccuracy) + "%[/color] chance to hit, and [color=" + this.Const.UI.Color.NegativeValue + "]" + (-5 + this.m.AdditionalHitChance) + "%[/color] per tile of distance"
			});
		}
		else
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "Has [color=" + this.Const.UI.Color.NegativeValue + "]+" + (10 + this.m.AdditionalAccuracy) + "%[/color] chance to hit, and [color=" + this.Const.UI.Color.NegativeValue + "]" + (-5 + this.m.AdditionalHitChance) + "%[/color] per tile of distance"
			});
		}

		//Melee part
		ret.extend([
			{
				id = 3,
				type = "text",
				text = "[u][size=14]When Thrusting[/size][/u]"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "Has [color=" + this.Const.UI.Color.PositiveValue + "]+20%[/color] chance to hit"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has [color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] damage on hit"
			}
		]);

		local mastery = this.getContainer().getSkillByID("perk.legend_smashing_shields");
		local mult = mastery != null ? mastery.getModifier() : 1.0;
		local damage = this.Math.floor(this.m.ShieldDamage * mult);

		ret.extend([
			{
				id = 3,
				type = "text",
				text = "[u][size=14]Special Properties[/size][/u]"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/shield_damage.png",
				text = "Inflicts [color=" + this.Const.UI.Color.DamageValue + "]" + damage + "[/color] damage to shields"
			}
		]);

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
					text = "Can penetrate shield and hit the shieldbearer"
				}
			]);
		}*/

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
		
		local dis = _user.getTile().getDistanceTo(_targetTile);
		local isMelee = dis == 1;
		local ret = false;
		local sounds = isMelee ? this.setToMelee() : [
			"sounds/combat/dlc2/throwing_spear_throw_01.wav",
			"sounds/combat/dlc2/throwing_spear_throw_02.wav",
			"sounds/combat/dlc2/throwing_spear_throw_03.wav"
		];
		
		if ((this.m.IsAudibleWhenHidden || _user.getTile().IsVisibleForPlayer) && sounds.len() != 0)
		{
			if (!this.m.IsUsingActorPitch)
			{
				this.Sound.play(sounds[this.Math.rand(0, sounds.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, _user.getPos());
			}
			else
			{
				this.Sound.play(sounds[this.Math.rand(0, sounds.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, _user.getPos(), _user.getSoundPitch());
			}
		}

		if (isMelee)
		{
			this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectThrust);
		}

		ret = this.attackEntity(_user, _targetTile.getEntity());
	
		if (!ret && !isMelee && this.m.SoundOnMissTarget.len() != 0)
		{
			this.Sound.play(this.m.SoundOnMissTarget[this.Math.rand(0, this.m.SoundOnMissTarget.len() - 1)], this.Const.Sound.Volume.Skill, _targetTile.getEntity().getPos());
		}

		this.resetParameters();
		return ret;
	}

	function setToMelee()
	{
		this.m.IsRanged = false;
		this.m.IsShowingProjectile = false;
		this.m.ProjectileType = this.Const.ProjectileType.None;
		return [
			"sounds/combat/thrust_01.wav",
			"sounds/combat/thrust_02.wav",
			"sounds/combat/thrust_03.wav"
		];
	}

	function resetParameters()
	{
		this.m.IsRanged = true;
		this.m.IsShowingProjectile = true;
		this.m.ProjectileType = this.Const.ProjectileType.Javelin;
	}

	function onShieldHit( _info )
	{
		local shield = _info.Shield;
		local user = _info.User;
		local targetEntity = _info.TargetEntity;
		local perk = _info.Skill.getContainer().getSkillByID("perk.legend_smashing_shields");
		local mult = 1.0;

		if (perk != null && ("getModifier" in perk))
		{
			mult *= perk.getModifier();
		}

		if (_info.Skill.m.SoundOnHitShield.len() != 0)
		{
			this.Sound.play(_info.Skill.m.SoundOnHitShield[this.Math.rand(0, _info.Skill.m.SoundOnHitShield.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, user.getPos());
		}

		shield.applyShieldDamage(_info.Skill.m.ShieldDamage * mult, _info.Skill.m.SoundOnHitShield.len() == 0);

		if (shield.getCondition() == 0)
		{
			if (!user.isHiddenToPlayer())
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(user) + " has destroyed " + this.Const.UI.getColorizedEntityName(targetEntity) + "\'s shield");
			}
		}
		else
		{
			if (!user.isHiddenToPlayer())
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(user) + " has hit " + this.Const.UI.getColorizedEntityName(targetEntity) + "\'s shield for 1 damage");
			}

			if (!this.Tactical.getNavigator().isTravelling(targetEntity))
			{
				this.Tactical.getShaker().shake(targetEntity, user.getTile(), 2, this.Const.Combat.ShakeEffectSplitShieldColor, this.Const.Combat.ShakeEffectSplitShieldHighlight, this.Const.Combat.ShakeEffectSplitShieldFactor, 1.0, [
					"shield_icon"
				], 1.0);
			}
		}

		_info.TargetEntity.getItems().onShieldHit(_info.User, this);

		if (this.Math.rand(1, 100) <= 50)
		{
			_info.Container <- _info.Skill.getContainer();
			_info.DistanceToTarget <- _info.User.getTile().getDistanceTo(_info.TargetEntity.getTile());
			_info.Properties <- _info.Container.buildPropertiesForUse(_info.Skill, _info.TargetEntity);
			_info.Properties.DamageTotalMult *= 0.33;
			_info.Skill.onScheduledTargetHit(_info);
			_info.Skill.m.IsEnhanced = false;
		}
	}

	function getHitchance( _targetEntity )
	{
		local dis = this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile());
		this.m.IsRanged = dis > 1;
		return this.skill.getHitchance(_targetEntity);
	}

	function getHitFactors( _targetTile )
	{
		local dis = this.getContainer().getActor().getTile().getDistanceTo(_targetTile);
		this.m.IsRanged = dis > 1;
		return this.skill.getHitFactors(_targetTile);
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin += 45;
			_properties.DamageRegularMax += 65;
			_properties.DamageArmorMult *= 0.75;
			_properties.MeleeSkill += 20;
			_properties.RangedSkill += 10 + this.m.AdditionalAccuracy;
				
			if (_targetEntity != null)
			{
				local dis = this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile());

				if (dis > 1)
				{
					_properties.HitChanceAdditionalWithEachTile -= 5 + this.m.AdditionalHitChance;
				}
				else
				{
				    _properties.DamageRegularMin += 10;
					_properties.DamageRegularMax += 10;
				}
			}

			if (this.getContainer().hasSkill("special.mc_focus"))
			{
				_properties.DamageDirectAdd += 0.2;
				_properties.DamageArmorMult += 0.1;
			}

			_properties.DamageTotalMult *= this.getBonusDamageFromResolve(_properties);
			this.removeBonusesFromWeapon(_properties);
		}
	}
	

});

