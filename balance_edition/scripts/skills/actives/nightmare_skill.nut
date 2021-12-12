this.nightmare_skill <- this.inherit("scripts/skills/skill", {
	m = {
		ConvertRate = 0.15,
	},
	function create()
	{
		this.m.ID = "actives.nightmare";
		this.m.Name = "Nightmare";
		this.m.Description = "Infuses a terrible nightmare that can damage the mind of your target.";
		this.m.KilledString = "Died of nightmares";
		this.m.Icon = "skills/active_117.png";
		this.m.IconDisabled = "skills/active_117_sw.png";
		this.m.Overlay = "active_117";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/alp_nightmare_01.wav",
			"sounds/enemies/dlc2/alp_nightmare_02.wav",
			"sounds/enemies/dlc2/alp_nightmare_03.wav",
			"sounds/enemies/dlc2/alp_nightmare_04.wav",
			"sounds/enemies/dlc2/alp_nightmare_05.wav",
			"sounds/enemies/dlc2/alp_nightmare_06.wav"
		];
		this.m.IsUsingActorPitch = true;
		this.m.IsSerialized = false;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted + 1;
		this.m.Delay = 400;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsUsingHitchance = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = true;
		this.m.IsVisibleTileNeeded = false;
		this.m.DirectDamageMult = 1.0;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
		this.m.MaxLevelDifference = 4;
	}
	
	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.MaxRange + "[/color] tiles"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "Damage is increased equal to [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.ConvertRate * 100 + "%[/color] of yourself current Resolve"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Damage is reduced by target\'s [color=" + this.Const.UI.Color.NegativeValue + "]Resolve[/color]"
			}
		]);
		
		return ret;
	}
	
	function onAfterUpdate( _properties )
	{
		local isSpecialized = this.getContainer().hasSkill("perk.mastery_nightmare");
		this.m.FatigueCostMult = isSpecialized ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		this.m.ConvertRate = isSpecialized ? 0.3 : 0.15;
	}
	
	function getDamage( _actor , _properties = null )
	{
		if (_properties == null)
		{
			_properties = _actor.getCurrentProperties();
		}

		local mult = this.getContainer().hasSkill("perk.after_wake") ? this.Math.rand(85, 95) * 0.01 : 1.0;
		return this.Math.max(5, 25 - this.Math.floor(_properties.getBravery() * mult * 0.25));
	}
	
	function getAdditionalDamage( _properties = null )
	{
		if (_properties == null)
		{
			_properties = this.getContainer().getActor().getCurrentProperties();
		}
		
		return this.Math.floor((_properties.getBravery() + _properties.MoraleCheckBravery[this.Const.MoraleCheckType.MentalAttack]) * this.m.ConvertRate);
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}
		
		if (this.getContainer().getActor().isPlayerControlled())
		{
			return true;
		}

		local b = this.getContainer().getActor().getAIAgent().getBehavior(this.Const.AI.Behavior.ID.AttackDefault);
		local targets = b.queryTargetsInMeleeRange(this.getMinRange(), this.getMaxRange());
		local myTile = this.getContainer().getActor().getTile();

		foreach( t in targets )
		{
			if (this.onVerifyTarget(myTile, t.getTile()))
			{
				return true;
			}
		}

		return false;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}
		
		return _targetTile.getEntity().getSkills().getSkillByID("effects.sleeping") != null;
	}

	function onUse( _user, _targetTile )
	{
		local tag = {
			Skill = this,
			User = _user,
			TargetTile = _targetTile
		};

		if (_targetTile.IsVisibleForPlayer || !_user.isHiddenToPlayer())
		{
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 400, this.onDelayedEffect.bindenv(this), tag);
		}
		else
		{
			this.onDelayedEffect(tag);
		}

		return true;
	}

	function onDelayedEffect( _tag )
	{
		local targetTile = _tag.TargetTile;
		local user = _tag.User;
		local target = targetTile.getEntity();
		local properties = this.getContainer().buildPropertiesForUse(this, target);
		local defenderProperties = target.getSkills().buildPropertiesForDefense(user, this);

		local damage = this.getDamage(target, defenderProperties);
		local bonus_damage = this.getAdditionalDamage(properties);

		if (this.isKindOf(target, "player") && bonus_damage > 0)
		{
			bonus_damage = this.Math.max(1, bonus_damage - this.Math.floor(defenderProperties.getBravery() * 0.25));
		}

		local total_damage = this.Math.rand(damage + bonus_damage, damage + bonus_damage + 5) * properties.DamageDirectMult * (1.0 + properties.DamageDirectAdd) * properties.DamageTotalMult;
		local hitInfo = clone this.Const.Tactical.HitInfo;
		hitInfo.DamageRegular = total_damage;
		hitInfo.DamageDirect = 1.0;
		hitInfo.BodyPart = this.Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		this.getContainer().onBeforeTargetHit(this, target, hitInfo);
		target.onDamageReceived(user, this, hitInfo);
		this.getContainer().onTargetHit(this, target, hitInfo.BodyPart, hitInfo.DamageInflictedHitpoints, hitInfo.DamageInflictedArmor);
	}
	
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin = 25 + this.getAdditionalDamage(_properties);
			_properties.DamageRegularMax = 30 + this.getAdditionalDamage(_properties);
			_properties.DamageArmorMult = 0;
			_properties.IsIgnoringArmorOnAttack = true;
			_properties.MeleeDamageMult = 1.0;
		}
	}

	function getHitFactors( _targetTile )
	{
		local ret = [];
		local user = this.m.Container.getActor();
		local myTile = user.getTile();
		local targetEntity = _targetTile.IsOccupiedByActor ? _targetTile.getEntity() : null;
		
		if (targetEntity == null)
		{
			return ret;
		}

		local _targetEntity = targetEntity;
		local _user = this.getContainer().getActor();
		local properties = this.m.Container.buildPropertiesForUse(this, _targetEntity);
		local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(_user, this);
		local damMod = properties.DamageDirectMult * (1.0 + properties.DamageDirectAdd) * properties.DamageTotalMult;
		local defMod = defenderProperties.DamageReceivedTotalMult * defenderProperties.DamageReceivedDirectMult;

		local expectedDamage = this.getDamage(_targetEntity, defenderProperties);
		local bonusDamage = this.getAdditionalDamage(properties);
		local lossDamage = 25 - expectedDamage;
		local totaldamage = this.Math.floor((expectedDamage + bonusDamage) * damMod * defMod);
		local totaldamageMax = this.Math.floor((expectedDamage + bonusDamage + 5) * damMod * defMod);

		ret.extend([
			{
				icon = "ui/icons/bravery.png",
				text = "Target\'s resolve: [color=#0b0084]" + defenderProperties.getBravery() + "[/color]"
			},
			{
				icon = "ui/icons/regular_damage.png",
				text = "Total damage: [color=" + this.Const.UI.Color.DamageValue + "]" + totaldamage + "[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + totaldamageMax + "[/color]" 
			},
		]);

		if (bonusDamage != 0)
		{
			ret.insert(0, {
				icon = "ui/icons/bravery.png",
				text = "Your resolve: [color=#0b0084]" + properties.getBravery() + "[/color]"
			});
			ret.push({
				icon = "ui/icons/days_wounded.png",
				text = "HP heals: [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.floor(totaldamage * 0.25) + "[/color] - [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.floor(totaldamageMax * 0.33) + "[/color]"
			});
		}

		return ret;

		ret.push({
			icon = "ui/icons/special.png",
			text = "[color=#0b0084]Damage modidiers[/color]:"
		});

		if (damMod > 1.0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "From yourself: [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.floor(damMod * 100) + "%[/color]"
			});
		}
		else if (damMod > 0 && this.Math.floor(damMod * 100) != 100)
		{
		    ret.push({
				icon = "ui/tooltips/negative.png",
				text = "From yourself: [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.floor(damMod * 100) + "%[/color]"
			});
		}

		if (defMod > 1.0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "From target: [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.floor(defMod * 100) + "%[/color]"
			});
		}
		else if (defMod > 0 && this.Math.floor(defMod * 100) != 100)
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "From target: [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.floor(defMod * 100) + "%[/color]"
			});
		}

		local a = this.Math.floor(damMod * defMod * 100 - 100);

		if (a > 0)
		{
			ret.push({
				icon = "ui/icons/mood_06.png",
				text = "Sum up: [color=" + this.Const.UI.Color.PositiveValue + "]" + a + "%[/color] more damage"
			});
		}
		else if (a == 0)
		{
			ret.push({
				icon = "ui/icons/mood_04.png",
				text = "Sum up: Unchanged"
			});
		}
		else 
		{
		    ret.push({
				icon = "ui/icons/mood_02.png",
				text = "Sum up: [color=" + this.Const.UI.Color.NegativeValue + "]" + this.Math.abs(a) + "%[/color] less damage"
			});
		}
	}

});

