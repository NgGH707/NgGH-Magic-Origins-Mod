::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/nightmare_skill", function ( q )
{
	q.m.BaseDamage <- 25;
	q.m.ConvertRate <- 0.05;

	q.create = @(__original) function()
	{
		__original();
		m.Description = "Infuses a terrible nightmare that can damage the mind of your target.";
		m.Icon = "skills/active_117.png";
		m.IconDisabled = "skills/active_117_sw.png";
		m.Overlay = "active_117";
		m.Order = ::Const.SkillOrder.UtilityTargeted + 1;
		m.IsIgnoringRiposte = true;
	}

	q.getTooltip <- function()
	{
		local ret = getDefaultTooltip();
		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + getMaxRange() + "[/color] tiles"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "Damage is increased equal to [color=" + ::Const.UI.Color.PositiveValue + "]" + (m.ConvertRate * 100) + "%[/color] of current Resolve"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Damage is reduced by target\'s [color=" + ::Const.UI.Color.NegativeValue + "]Resolve[/color]"
			}
		]);
		
		return ret;
	}

	q.softReset <- function()
	{
		resetField("BaseDamage");
		resetField("ConvertRate");
		return skill.softReset();
	}

	q.getDamage = @() function( _actor, _attackerProperties = null, _defenderProperties = null )
	{
		if (_defenderProperties == null)
			_defenderProperties = _actor.getCurrentProperties();

		local mult = 1.0;
		local perk = getContainer().getSkillByID("perk.after_wake");
		if (perk != null) mult *= perk.getMult();
		local damage = m.BaseDamage + getAdditionalDamage(_attackerProperties);
		local loss = ::Math.floor((_defenderProperties.getBravery() + _defenderProperties.MoraleCheckBravery[::Const.MoraleCheckType.MentalAttack] * _defenderProperties.MoraleCheckBraveryMult[::Const.MoraleCheckType.MentalAttack]) * mult * 0.25);
		local min = ::Math.max(5, ::Math.round(damage * 0.15));

		return {
			Result = ::Math.max(min, damage - loss),
			Expected = damage,
			Loss = loss,
			Min = min
		};
	}

	q.getAdditionalDamage <- function( _properties = null )
	{
		if (_properties == null)
			_properties = getContainer().getActor().getCurrentProperties();

		local mult = ::Math.minf(2.0, _properties.MoraleCheckBraveryMult[::Const.MoraleCheckType.MentalAttack]);
		return ::Math.floor((_properties.getBravery() + _properties.MoraleCheckBravery[::Const.MoraleCheckType.MentalAttack] * mult) * m.ConvertRate);
	}

	q.isUsable = @(__original) function()
	{
		return getContainer().getActor().isPlayerControlled() ?  skill.isUsable() : __original();
	}

	q.onVerifyTarget = @() function( _originTile, _targetTile )
	{
		return skill.onVerifyTarget(_originTile, _targetTile) && _targetTile.getEntity().getSkills().hasSkill("effects.sleeping");
	}

	q.onDelayedEffect = @() function( _tag )
	{
		local target = _tag.TargetTile.getEntity();
		local properties = this.getContainer().buildPropertiesForUse(this, target);
		local defenderProperties = target.getSkills().buildPropertiesForDefense(_tag.User, this);
		local damage = this.getDamage(target, properties, defenderProperties);
		local total_damage = ::Math.rand(::Math.max(5, damage.Result / 2), damage.Result) * properties.DamageTotalMult;
		local hitInfo = clone ::Const.Tactical.HitInfo;
		hitInfo.DamageRegular = total_damage;
		hitInfo.DamageDirect = 1.0;
		hitInfo.BodyPart = ::Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		getContainer().onBeforeTargetHit(this, target, hitInfo);
		target.onDamageReceived(_tag.User, this, hitInfo);
		getContainer().onTargetHit(this, target, hitInfo.BodyPart, hitInfo.DamageInflictedHitpoints, hitInfo.DamageInflictedArmor);
	}

	q.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local add = getAdditionalDamage(_properties);
			_properties.DamageRegularMin = ::Math.max(5, (m.BaseDamage + add) / 2);
			_properties.DamageRegularMax = ::Math.max(5, m.BaseDamage + add);
			_properties.DamageArmorMult = 0.0;
			_properties.IsIgnoringArmorOnAttack = true;
			
			if (::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue())
				_properties.MeleeDamageMult /= ::Const.AlpWeaponDamageMod;

			if (getContainer().getActor().isDoubleGrippingWeapon())
				_properties.MeleeDamageMult /= 1.25;
		}
	}

	q.getHitFactors <- function( _targetTile )
	{
		local ret = [], _user = getContainer().getActor();
		local myTile = _user.getTile(), _targetEntity = _targetTile.IsOccupiedByActor ? _targetTile.getEntity() : null;
		
		if (_targetEntity == null)
			return ret;

		local properties = getContainer().buildPropertiesForUse(this, _targetEntity);
		local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(_user, this);
		//local damMod = properties.DamageTotalMult;
		//local defMod = defenderProperties.DamageReceivedTotalMult * defenderProperties.DamageReceivedDirectMult;

		local expectedDamage = getDamage(_targetEntity, defenderProperties);
		local bonusDamage = expectedDamage.Expected - m.BaseDamage;
		local totaldamage = ::Math.max(5, expectedDamage.Result / 2); //::Math.floor((expectedDamage.Result) * damMod * defMod);
		local totaldamageMax = expectedDamage.Result;//::Math.floor((expectedDamage.Result + bonusDamage) * damMod * defMod);

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

		if (bonusDamage != 0) {
			ret.insert(0, {
				icon = "ui/icons/bravery.png",
				text = "Your resolve: [color=#0b0084]" + properties.getBravery() + "[/color]"
			});

			local perk = getContainer().getSkillByID("perk.mastery_nightmare");
			if (perk != null) {
				ret.push({
					icon = "ui/icons/days_wounded.png",
					text = "HP heals: [color=" + ::Const.UI.Color.PositiveValue + "]" + ::Math.max(1, totaldamage * perk.m.HPDrainMin * 0.01) + "[/color] - [color=" + ::Const.UI.Color.PositiveValue + "]" + ::Math.max(1, totaldamageMax * perk.m.HPDrainMax * 0.01) + "[/color]"
				});
			}
		}

		return ret;

		// cringe stuffs, but i haven't decided to completele remove yet
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