::mods_hookExactClass("skills/actives/sleep_skill", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.IconDisabled = "skills/active_116_sw.png";
		this.m.Order =  ::Const.SkillOrder.UtilityTargeted + 2;
	};
	obj.getTooltip <- function()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Has a range of [color=" +  ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
		});
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Puts target to [color=" +  ::Const.UI.Color.PositiveValue + "]Sleep[/color]"
		});

		return ret;
	};
	obj.onAdded <- function()
	{
		if (this.getContainer().getActor().isPlayerControlled())
		{
			this.m.FatigueCostMult = 2.0;
		}
	};
	obj.onAfterUpdate <- function( _properties )
	{
		if (this.getContainer().hasSkill("perk.mastery_sleep"))
		{
			this.m.ActionPointCost -= 1;
		}
	};
	obj.isViableTarget <- function( _user, _target )
	{
		if (_target.getCurrentProperties().MoraleCheckBraveryMult[ ::Const.MoraleCheckType.MentalAttack] >= 1000.0)
		{
			return false;
		}

		if (_target.getFlags().has("alp"))
		{
			return false;
		}

		return [
			::Const.EntityType.Alp,
			::Const.EntityType.AlpShadow,
			::Const.EntityType.LegendDemonAlp,
		].find(_target.getType()) == null;
	};
	obj.onDelayedEffect = function( _tag )
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
		local hasMastery = this.getContainer().hasSkill("perk.mastery_sleep");

		foreach( target in targets )
		{
			if (!this.isViableTarget(_user, target))
			{
				if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
				{
					::Tactical.EventLog.log( ::Const.UI.getColorizedEntityName(target) + " can not be put to sleep.");
				}
				
				continue;
			}

			local chance = this.getHitchance(target);
			local attempts = target.getFlags().getAsInt("resist_sleep");
			local bonus = (this.getMaxRange() + 1 - myTile.getDistanceTo(target.getTile())) * (1.0 + 0.1 * attempts);
			local difficulty = 0;
			difficulty -= 35 * bonus + (hasMastery ? ::Math.max(1, ::Math.floor(_user.getBravery() * 0.1)) : 0);

			if (_user.isPlayerControlled())
			{
				difficulty += 25;
			}

			if (target.checkMorale(0, difficulty, ::Const.MoraleCheckType.MentalAttack))
			{
				if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
				{
					::Tactical.EventLog.log( ::Const.UI.getColorizedEntityName(target) + " resists the urge to sleep thanks to his resolve (Chance: " + chance + ", Rolled: " +  ::Math.rand(chance + 1, 100) + ")");
				}
				
				target.getFlags().increment("resist_sleep");
				continue;
			}

			if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
			{
				::Tactical.EventLog.log( ::Const.UI.getColorizedEntityName(target) + " falls to sleep (Chance: " + chance + ", Rolled: " +  ::Math.rand(1, chance) + ")");
			}

			local sleep =  ::new("scripts/skills/effects/sleeping_effect");
			target.getFlags().set("resist_sleep", 0);
			target.getSkills().add(sleep);
			sleep.m.TurnsLeft += hasMastery ? 1 : 0;
		}
	};
	// a rough estimated of the chance to put target to sleep, may not 100% accurate
	obj.getHitchance <- function( _targetEntity )
	{
		if (_targetEntity.getMoraleState() == ::Const.MoraleState.Ignore)
		{
			return 100;
		}

		local _user = this.getContainer().getActor();

		if (!this.isViableTarget(_user, _targetEntity))
		{
			return 0;
		}

		local _targetTile = _targetEntity.getTile();
		local _distance = _user.getTile().getDistanceTo(_targetTile);
		local properties = this.getContainer().buildPropertiesForUse(this, _targetEntity);
		local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(_user, this);

		local bravery = (defenderProperties.getBravery() + defenderProperties.MoraleCheckBravery[::Const.MoraleCheckType.MentalAttack]) * defenderProperties.MoraleCheckBraveryMult[::Const.MoraleCheckType.MentalAttack];
		local attempts = _targetEntity.getFlags().getAsInt("resist_sleep");
		local bonus = (this.getMaxRange() + 1 - _distance) * (1.0 + 0.1 * attempts);
		local _difficulty = 0;
		_difficulty -= 35 * bonus + (this.getContainer().hasSkill("perk.mastery_sleep") ? ::Math.max(1, ::Math.floor(properties.getBravery() * 0.1)) : 0);
		
		if (_user.isPlayerControlled())
		{
			_difficulty += 25;
		}

		_difficulty *= defenderProperties.MoraleEffectMult;

		if (bravery > 500)
		{
			return 0;
		}

		local numOpponentsAdjacent = 0;
		local numAlliesAdjacent = 0;
		local threatBonus = 0;

		for( local i = 0; i != 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _targetTile.getNextTile(i);

				if (tile.IsOccupiedByActor && tile.getEntity().getMoraleState() != ::Const.MoraleState.Fleeing)
				{
					if (tile.getEntity().isAlliedWith(_targetEntity))
					{
						numOpponentsAdjacent = ++numOpponentsAdjacent;
					}
					else
					{
						numAlliesAdjacent = ++numAlliesAdjacent;
						threatBonus = threatBonus + tile.getEntity().getCurrentProperties().Threat;
					}
				}
			}
		}

		local chance = bravery + _difficulty;
		chance -= threatBonus + numAlliesAdjacent * ::Const.Morale.AlliesAdjacentMult;
		chance += numOpponentsAdjacent * ::Const.Morale.OpponentsAdjacentMult;
		chance = ::Math.min(95, ::Math.floor(chance));

		if (chance <= 0)
		{
			return 100;
		}

		return 100 - chance;
	};
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
		local isSpecialized = this.getContainer().hasSkill("perk.mastery_sleep");
		local _distance = myTile.getDistanceTo(_targetTile);

		local properties = this.getContainer().buildPropertiesForUse(this, _targetEntity);
		local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(_user, this);
		local bravery = (defenderProperties.getBravery() + defenderProperties.MoraleCheckBravery[::Const.MoraleCheckType.MentalAttack]) * defenderProperties.MoraleCheckBraveryMult[::Const.MoraleCheckType.MentalAttack];

		if (defenderProperties.MoraleCheckBraveryMult[::Const.MoraleCheckType.MentalAttack] >= 1000.0 || bravery >= 500)
		{
			ret.push({
				icon = "ui/icons/cancel.png",
				text = "Extremely high magic resistance"
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
		
		if (!this.isViableTarget(_user, _targetEntity))
		{
			ret.push({
				icon = "ui/icons/cancel.png",
				text = "Immune to sleep"
			});
			
			return ret;
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

		ret.extend([
			{
				icon = "ui/icons/bravery.png",
				text = "Target\'s resolve: [color=#0b0084]" + bravery + "[/color]"
			},
			{
				icon = "ui/tooltips/positive.png",
				text = green("30%") + " Default bonus"
			}
		]);

		local attempts = _targetEntity.getFlags().getAsInt("resist_sleep");
		local _difficulty = 10;

		if (_distance != this.getMaxRange())
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = red(_difficulty + "%") + " Too close"
			});

			_difficulty -= 10;
		}

		if (attempts != 0 && _difficulty != 0)
		{
			local add = ::Math.floor(_difficulty * attempts * 0.1);
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = green(add + "%") + " Failed attempt(s)"
			});

			_difficulty += add;
		}

		if (isSpecialized)
		{
			local add = ::Math.floor(::Math.max(1, properties.getBravery() * 0.1));
			ret.insert(0, 
			{
				icon = "ui/icons/bravery.png",
				text = "Your resolve: [color=#0b0084]" + properties.getBravery() + "[/color]"
			});
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = green(add + "%") + " Overslept perk"
			});

			_difficulty += add;
		}

		if (defenderProperties.MoraleEffectMult > 1.0)
		{
			local add = ::Math.floor(_difficulty * (defenderProperties.MoraleEffectMult - 1.0));
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = green(add + "%") + " Sensitive"
			});
		}
		else if (defenderProperties.MoraleEffectMult < 1.0 && defenderProperties.MoraleEffectMult > 0)
		{
			local add = ::Math.floor(_difficulty * (1.0 - defenderProperties.MoraleEffectMult));
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = red(add + "%") + " Insensitive"
			});
		}

		local numOpponentsAdjacent = 0;
		local numAlliesAdjacent = 0;
		local threatBonus = 0;

		for( local i = 0; i != 6; ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _targetTile.getNextTile(i);

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
	};
});