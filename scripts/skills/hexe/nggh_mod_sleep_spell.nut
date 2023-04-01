this.nggh_mod_sleep_spell <- ::inherit("scripts/skills/skill", {
	m = {
		BonusChance = 20
	},
	function getAffectedSkills()
	{
		// skills that help increase the success chance
		return [
			"perk.charm_enemy_alp",
		];
	}

	function create()
	{
		this.m.ID = "spells.sleep";
		this.m.Name = "Sleep";
		this.m.Description = "Using magic to put a target into a deep sleep and lasts for 3 turns. Success chance is based on [color=" + ::Const.UI.Color.NegativeValue + "]Resolve[/color] points from both the caster and the target.";
		this.m.Icon = "skills/active_116.png";
		this.m.IconDisabled = "skills/active_116_sw.png";
		this.m.Overlay = "active_116";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/alp_sleep_01.wav",
			"sounds/enemies/dlc2/alp_sleep_02.wav",
			"sounds/enemies/dlc2/alp_sleep_03.wav",
			"sounds/enemies/dlc2/alp_sleep_04.wav",
			"sounds/enemies/dlc2/alp_sleep_05.wav",
			"sounds/enemies/dlc2/alp_sleep_06.wav",
			"sounds/enemies/dlc2/alp_sleep_07.wav",
			"sounds/enemies/dlc2/alp_sleep_08.wav",
			"sounds/enemies/dlc2/alp_sleep_09.wav",
			"sounds/enemies/dlc2/alp_sleep_10.wav",
			"sounds/enemies/dlc2/alp_sleep_11.wav",
			"sounds/enemies/dlc2/alp_sleep_12.wav"
		];
		this.m.IsUsingActorPitch = true;
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted + 4;
		this.m.IsSerialized = false;
		this.m.Delay = 600;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsUsingHitchance = true;
		this.m.IsDoingForwardMove = false;
		this.m.IsVisibleTileNeeded = true;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 14;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
		this.m.MaxLevelDifference = 4;
		this.m.MaxRangeBonus = 3;
	}
	
	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
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
				icon = "ui/icons/hitchance.png",
				text = "Has [color=" + ::Const.UI.Color.PositiveValue + "]+" + this.m.BonusChance + "%[/color] chance to succeed"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Puts a target to [color=" + ::Const.UI.Color.PositiveValue + "]Sleep[/color]"
			}
		]);
		return ret;
	}
	
	function onAfterUpdate( _properties )
	{
		if (this.getContainer().hasSkill("perk.fortified_mind"))
		{
			this.m.FatigueCostMult = ::Const.Combat.WeaponSpecFatigueMult;
		}
	}

	function isViableTarget( _user, _target )
	{
		if (_target.isAlliedWith(_user))
		{
			return false;
		}
		
		if (_target.getCurrentProperties().IsStunned)
		{
			return false;
		}
		
		if (_target.getCurrentProperties().MoraleCheckBraveryMult[::Const.MoraleCheckType.MentalAttack] >= 1000.0)
		{
			return false;
		}

		if (_target.isNonCombatant())
		{
			return false;
		}

		if (_target.getFlags().has("alp"))
		{
			return false;
		}

		local invalid = [
			::Const.EntityType.Alp,
			::Const.EntityType.AlpShadow,
			::Const.EntityType.LegendDemonAlp,
		];

		return invalid.find(_target.getType()) == null;
	}

	function onUse( _user, _targetTile )
	{
		::Time.scheduleEvent(::TimeUnit.Virtual, 600, this.onDelayedEffect.bindenv(this), {
			User = _user,
			TargetTile = _targetTile
		});
		return true;
	}

	function onDelayedEffect( _tag )
	{
		local targets = [];
		local _targetTile = _tag.TargetTile;
		local _user = _tag.User;

		if (_targetTile.IsOccupiedByActor)
		{
			local entity = _targetTile.getEntity();
			targets.push(entity);
		}

		local myTile = _user.getTile();

		foreach( target in targets )
		{
			local Chance = this.getHitchance(target);
			local roll = ::Math.rand(1, 100);

			if (roll > Chance)
			{
				if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
				{
					::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(target) + " resists the urge to sleep thanks to his resolve (Chance: " + Chance + ", Rolled: " + roll + ")");
				}

				continue;
			}

			target.getSkills().add(::new("scripts/skills/effects/sleeping_effect"));

			if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(target) + " falls to sleep (Chance: " + Chance + ", Rolled: " + roll + ")");
			}
		}
	}
	
	function getHitchance( _targetEntity )
	{
		if (!this.isViableTarget(this.getContainer().getActor(), _targetEntity))
		{
			return 0;
		}
	
		local _user = this.getContainer().getActor();
		local myTile = this.getContainer().getActor().getTile();
		local properties = this.getContainer().buildPropertiesForUse(this, _targetEntity);
		local resolve = properties.Bravery * properties.BraveryMult;
		local res = properties.MoraleCheckBravery[1];
		local CasterPower = resolve + res;
		local bonus = this.getBonus();
		
		local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(_user, this);
		local resist = (defenderProperties.getBravery() + defenderProperties.MoraleCheckBravery[1]) * defenderProperties.MoraleCheckBraveryMult[1];
		
		if (resist >= 500)
		{
			return 0;
		}
		
		local toHit = CasterPower * defenderProperties.MoraleEffectMult - resist;
		local targetTile = _targetEntity.getTile();
		local dis = targetTile.getDistanceTo(myTile);
		local numOpponentsAdjacent = 0;
		local numAlliesAdjacent = 0;
		local threatBonus = 0;

		for( local i = 0; i != 6; i = ++i )
		{
			if (!targetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = targetTile.getNextTile(i);

				if (tile.IsOccupiedByActor && tile.getEntity().getMoraleState() != ::Const.MoraleState.Fleeing)
				{
					if (tile.getEntity().isAlliedWith(_user))
					{
						numAlliesAdjacent = ++numAlliesAdjacent;
						threatBonus = threatBonus + tile.getEntity().getCurrentProperties().Threat;
					}
					else
					{
						numOpponentsAdjacent = ++numOpponentsAdjacent;
						
					}
				}
			}
		}
		
		toHit = toHit + numAlliesAdjacent * ::Const.Morale.OpponentsAdjacentMult - numOpponentsAdjacent * ::Const.Morale.AlliesAdjacentMult;
		toHit = toHit + threatBonus + bonus + this.m.BonusChance;
		toHit = toHit + ::Const.HexeOrigin.Magic.CountDebuff(_targetEntity) * 2;

		if (dis >= this.getMaxRange())
		{
			toHit = toHit - 5;
		}
		else if (dis == 1)
		{
			toHit = toHit + 5;
		}

		return ::Math.max(5, ::Math.min(95, toHit));
	}
	
	function getBonus()
	{
		local bonus = 0;
		
		foreach ( id in this.getAffectedSkills() )
		{
			local skill = this.getContainer().getSkillByID(id);
			
			if (skill != null)
			{
				bonus += skill.getBonus();
			}
		}
		
		return bonus;
	}
	
	function getHitFactors( _targetTile )
	{
		local ret = [];
		local user = this.getContainer().getActor();
		local myTile = user.getTile();
		local targetEntity = _targetTile.IsOccupiedByActor ? _targetTile.getEntity() : null;
		
		if (targetEntity == null)
		{
			return ret;
		}

		local green = function ( _text )
		{
			if (!_text)
			{
				return "";
			}

			return "[color=" + ::Const.UI.Color.PositiveValue + "]" + _text + "[/color]";
		};
		local red = function ( _text )
		{
			if (!_text)
			{
				return "";
			}

			return "[color=" + ::Const.UI.Color.NegativeValue + "]" + _text + "[/color]";
		};
		
		local _targetEntity = targetEntity;
		local _user = this.getContainer().getActor();
		local myTile = this.getContainer().getActor().getTile();

		local properties = this.getContainer().buildPropertiesForUse(this, _targetEntity);
		local resolve = properties.Bravery * properties.BraveryMult;
		local res = properties.MoraleCheckBravery[1];
		local CasterPower = ::Math.floor(resolve + res);

		local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(_user, this);
		local resist = ::Math.floor((defenderProperties.getBravery() + defenderProperties.MoraleCheckBravery[1]) * defenderProperties.MoraleCheckBraveryMult[1]);
		local targetTile = _targetEntity.getTile();
		local dis = targetTile.getDistanceTo(myTile);

		if (defenderProperties.MoraleCheckBraveryMult[::Const.MoraleCheckType.MentalAttack] >= 1000.0 || resist >= 500)
		{
			ret.push({
				icon = "ui/icons/cancel.png",
				text = "Extremely high magic resistance"
			});
			
			return ret;
		}

		local invalid = [
			::Const.EntityType.Alp,
			::Const.EntityType.AlpShadow,
			::Const.EntityType.LegendDemonAlp,
		];
		
		if (targetEntity.getFlags().has("alp") || invalid.find(targetEntity.getType()) != null)
		{
			ret.push({
				icon = "ui/icons/cancel.png",
				text = "Immune to sleep"
			});
		}

		if (targetEntity.getCurrentProperties().IsStunned)
		{
			ret.push({
				icon = "ui/icons/cancel.png",
				text = "Stunned"
			});
			
			return ret;
		}
		
		if (targetEntity.isAlliedWith(this.getContainer().getActor()))
		{
			ret.push({
				icon = "ui/icons/cancel.png",
				text = "Allied"
			});
			
			return ret;
		}
		
		if (targetEntity.getMoraleState() == ::Const.MoraleState.Ignore)
		{
			ret.push({
				icon = "ui/icons/cancel.png",
				text = "Mindless"
			});
			
			return ret;
		}
		
		if (targetEntity.isNonCombatant())
		{
			ret.push({
				icon = "ui/icons/cancel.png",
				text = "Why?"
			});
			
			return ret;
		}

		ret.extend([
			{
				icon = "ui/icons/bravery.png",
				text = "Your resolve: [color=#0b0084]" + CasterPower + "[/color]"
			},
			{
				icon = "ui/icons/bravery.png",
				text = "Target\'s resolve: [color=#0b0084]" + resist + "[/color]" 
			},
			{
				icon = "ui/tooltips/positive.png",
				text = green(this.m.BonusChance + "%") + " Default bonus"
			}
		]);

		if (dis >= this.getMaxRange())
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = red("5%") + " Distance of " + dis
			});
		}
		else if (dis == 1)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = green("5%") + " Too close"
			});
		}
		
		local numOpponentsAdjacent = 0;
		local numAlliesAdjacent = 0;
		local threatBonus = 0;

		for( local i = 0; i != 6; ++i )
		{
			if (!targetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = targetTile.getNextTile(i);

				if (tile.IsOccupiedByActor && tile.getEntity().getMoraleState() != ::Const.MoraleState.Fleeing)
				{
					if (tile.getEntity().isAlliedWith(_user))
					{
						++numAlliesAdjacent;
						threatBonus += tile.getEntity().getCurrentProperties().Threat;
					}
					else
					{
						++numOpponentsAdjacent;
					}
				}
			}
		}

		foreach ( id in this.getAffectedSkills() )
		{
			local skill = this.getContainer().getSkillByID(id);
			
			if (skill != null)
			{
				ret.push({
					icon = "ui/tooltips/positive.png",
					text = green(skill.getBonus() + "%") + " " + skill.getName()
				});
			}
		}

		local debuff = ::Const.HexeOrigin.Magic.CountDebuff(_targetEntity);

		if (debuff != 0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = green((debuff * 2) + "%") + " Debuff"
			});
		}

		if (threatBonus != 0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = green(threatBonus + "%") + " Intimidated"
			});
		}
			
		local modAllies = numAlliesAdjacent * ::Const.Morale.AlliesAdjacentMult;

		if (modAllies != 0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = green(modAllies + "%") + " Surrounded"
			});
		}

		local modEnemies = numOpponentsAdjacent * ::Const.Morale.OpponentsAdjacentMult;

		if (modEnemies != 0)
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = red(modEnemies + "%") + " Allies nearby"
			});
		}

		return ret;
	}

});

