::mods_hookExactClass("skills/actives/nightmare_skill", function ( obj )
{
	obj.m.ConvertRate <- 0.15;

	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Infuses a terrible nightmare that can damage the mind of your target.";
		this.m.Icon = "skills/active_117.png";
		this.m.IconDisabled = "skills/active_117_sw.png";
		this.m.Overlay = "active_117";
		this.m.Order = ::Const.SkillOrder.UtilityTargeted + 1;
		this.m.DirectDamageMult = 1.0;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
		this.m.MaxLevelDifference = 4;
	};
	obj.getTooltip <- function()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "Damage is increased equal to [color=" + ::Const.UI.Color.PositiveValue + "]" + (this.m.ConvertRate * 100) + "%[/color] of current Resolve"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Damage is reduced by target\'s [color=" + ::Const.UI.Color.NegativeValue + "]Resolve[/color]"
			}
		]);
		
		return ret;
	};
	obj.onAfterUpdate <- function( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInMagic ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
		this.m.ConvertRate = _properties.IsSpecializedInMagic ? 0.30 : 0.15;
	};
	obj.getDamage = function( _actor , _properties = null )
	{
		if (_properties == null)
		{
			_properties = _actor.getCurrentProperties();
		}

		local mult = this.getContainer().hasSkill("perk.after_wake") ? ::Math.rand(85, 95) * 0.01 : 1.0;
		return ::Math.max(5, 25 - ::Math.floor(_properties.getBravery() * mult * 0.25));
	};	
	obj.getAdditionalDamage <- function( _properties = null )
	{
		if (_properties == null)
		{
			_properties = this.getContainer().getActor().getCurrentProperties();
		}
		
		return ::Math.floor((_properties.getBravery() + _properties.MoraleCheckBravery[::Const.MoraleCheckType.MentalAttack]) * this.m.ConvertRate);
	};

	local ws_isUsable = obj.isUsable;
	obj.isUsable = function()
	{
		if (this.getContainer().getActor().isPlayerControlled())
		{
			return this.skill.isUsable();
		}

		return ws_isUsable();
	};
	obj.onVerifyTarget = function( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}
		
		return _targetTile.getEntity().getSkills().getSkillByID("effects.sleeping") != null;
	};
	obj.onDelayedEffect = function( _tag )
	{
		local targetTile = _tag.TargetTile;
		local user = _tag.User;
		local target = targetTile.getEntity();
		local properties = this.getContainer().buildPropertiesForUse(this, target);
		local defenderProperties = target.getSkills().buildPropertiesForDefense(user, this);

		local damage = this.getDamage(target, defenderProperties);
		local bonus_damage = this.getAdditionalDamage(properties);
		local total_damage = ::Math.rand(damage + bonus_damage, damage + bonus_damage + 5) * properties.DamageDirectMult * (1.0 + properties.DamageDirectAdd) * properties.DamageTotalMult;
		local hitInfo = clone ::Const.Tactical.HitInfo;
		hitInfo.DamageRegular = total_damage;
		hitInfo.DamageDirect = 1.0;
		hitInfo.BodyPart = ::Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		this.getContainer().onBeforeTargetHit(this, target, hitInfo);
		target.onDamageReceived(user, this, hitInfo);
		this.getContainer().onTargetHit(this, target, hitInfo.BodyPart, hitInfo.DamageInflictedHitpoints, hitInfo.DamageInflictedArmor);
	};
	obj.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local add = this.getAdditionalDamage(_properties);
			_properties.DamageRegularMin = 10 + add;
			_properties.DamageRegularMax = 30 + add;
			_properties.DamageArmorMult = 0;
			_properties.IsIgnoringArmorOnAttack = true;
			
			if (!::Nggh_MagicConcept.IsOPMode)
			{
				_properties.MeleeDamageMult /= ::Const.AlpWeaponDamageMod;
			}

			if (this.getContainer().getActor().isDoubleGrippingWeapon())
			{
				_properties.MeleeDamageMult /= 1.25;
			}
		}
	}
	obj.getHitFactors <- function( _targetTile )
	{
		local ret = [];
		local user = this.getContainer().getActor();
		local myTile = user.getTile();
		local targetEntity = _targetTile.IsOccupiedByActor ? _targetTile.getEntity() : null;
		
		if (targetEntity == null)
		{
			return ret;
		}

		local _targetEntity = targetEntity;
		local _user = this.getContainer().getActor();
		local properties = this.getContainer().buildPropertiesForUse(this, _targetEntity);
		local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(_user, this);
		local damMod = properties.DamageDirectMult * (1.0 + properties.DamageDirectAdd) * properties.DamageTotalMult;
		local defMod = defenderProperties.DamageReceivedTotalMult * defenderProperties.DamageReceivedDirectMult;

		local expectedDamage = this.getDamage(_targetEntity, defenderProperties);
		local bonusDamage = this.getAdditionalDamage(properties);
		local lossDamage = 25 - expectedDamage;
		local totaldamage = ::Math.floor((expectedDamage + bonusDamage) * damMod * defMod);
		local totaldamageMax = ::Math.floor((expectedDamage + bonusDamage + 5) * damMod * defMod);

		ret.extend([
			{
				icon = "ui/icons/bravery.png",
				text = "Target\'s resolve: [color=#0b0084]" + defenderProperties.getBravery() + "[/color]"
			},
			{
				icon = "ui/icons/regular_damage.png",
				text = "Estimated damage: [color=" + ::Const.UI.Color.DamageValue + "]" + totaldamage + "[/color] - [color=" + ::Const.UI.Color.DamageValue + "]" + totaldamageMax + "[/color]" 
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
				text = "HP heals: [color=" + ::Const.UI.Color.PositiveValue + "]" + ::Math.floor(totaldamage * 0.25) + "[/color] - [color=" + ::Const.UI.Color.PositiveValue + "]" + ::Math.floor(totaldamageMax * 0.33) + "[/color]"
			});
		}

		return ret;

		// cringe stuffs, but i haven't wanted to remove yet
		ret.push({
			icon = "ui/icons/special.png",
			text = "[color=#0b0084]Damage modidiers[/color]:"
		});

		if (damMod > 1.0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "From yourself: [color=" + ::Const.UI.Color.PositiveValue + "]" + ::Math.floor(damMod * 100) + "%[/color]"
			});
		}
		else if (damMod > 0 && ::Math.floor(damMod * 100) != 100)
		{
		    ret.push({
				icon = "ui/tooltips/negative.png",
				text = "From yourself: [color=" + ::Const.UI.Color.PositiveValue + "]" + ::Math.floor(damMod * 100) + "%[/color]"
			});
		}

		if (defMod > 1.0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "From target: [color=" + ::Const.UI.Color.PositiveValue + "]" + ::Math.floor(defMod * 100) + "%[/color]"
			});
		}
		else if (defMod < 1.0)
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "From target: [color=" + ::Const.UI.Color.NegativeValue + "]" + ::Math.floor(defMod * 100) + "%[/color]"
			});
		}

		local a = ::Math.floor(damMod * defMod * 100 - 100);

		if (a > 0)
		{
			ret.push({
				icon = "ui/icons/mood_06.png",
				text = "Sum up: [color=" + ::Const.UI.Color.PositiveValue + "]" + a + "%[/color] more damage"
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
				text = "Sum up: [color=" + ::Const.UI.Color.NegativeValue + "]" + ::Math.abs(a) + "%[/color] less damage"
			});
		}
	}
});