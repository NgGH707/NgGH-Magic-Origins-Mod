this.sleep_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sleep";
		this.m.Name = "Sleep";
		this.m.Description = "Using unseen force to put a target to sleep. It\'s a mental attack skill.";
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
		this.m.IsSerialized = false;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted + 2;
		this.m.Delay = 600;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = false;
		this.m.IsVisibleTileNeeded = true;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 5;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
		this.m.MaxLevelDifference = 4;
	}
	
	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.MaxRange + "[/color] tiles"
		});
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Puts target to [color=" + this.Const.UI.Color.PositiveValue + "]Sleep[/color]"
		});

		return ret;
	}
	
	function onAfterUpdate( _properties )
	{
		this.m.ActionPointCost = this.getContainer().hasSkill("perk.mastery_sleep") ? 3 : 4;
	}

	function onVerifyTarget( _userTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_userTile, _targetTile))
		{
			return false;
		}

		if (_targetTile.getEntity().getCurrentProperties().IsStunned)
		{
			return false;
		}

		if (_targetTile.getEntity().getMoraleState() == this.Const.MoraleState.Ignore)
		{
			return false;
		}

		if (_targetTile.getEntity().isNonCombatant())
		{
			return false;
		}

		return true;
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

	function onUse( _user, _targetTile )
	{
		local tag = {
			User = _user,
			TargetTile = _targetTile
		};
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 600, this.onDelayedEffect.bindenv(this), tag);
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
		local hasMastery = this.getContainer().hasSkill("perk.mastery_sleep");

		foreach( target in targets )
		{
			local chance = this.getHitchance(target);
			local attempts = target.getFlags().getAsInt("resist_sleep");
			local bonus = (this.m.MaxRange + 1 - myTile.getDistanceTo(target.getTile())) * (1.0 + 0.1 * attempts);
			local difficulty = 0;
			difficulty -= 35 * bonus + (hasMastery ? this.Math.max(1, this.Math.floor(_user.getBravery() * 0.1)) : 0);

			if (_user.isPlayerControlled())
			{
				difficulty += 5;
			}

			if (!this.isViableTarget(_user, target) || target.checkMorale(0, difficulty, this.Const.MoraleCheckType.MentalAttack))
			{
				if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " resists the urge to sleep thanks to his resolve (Chance: " + chance + ", Rolled: " + this.Math.rand(chance + 1, 100) + ")");
				}
				
				target.getFlags().increment("resist_sleep");
				continue;
			}

			if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " falls to sleep (Chance: " + chance + ", Rolled: " + this.Math.rand(1, chance) + ")");
			}

			local sleep = this.new("scripts/skills/effects/sleeping_effect");
			target.getFlags().set("resist_sleep", 0);
			target.getSkills().add(sleep);
			sleep.m.TurnsLeft += hasMastery ? 1 : 0;
		}
	}

	function isViableTarget( _user, _target )
	{
		if (_target.getCurrentProperties().MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] >= 1000.0)
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
			this.Const.EntityType.Alp,
			this.Const.EntityType.AlpShadow,
			this.Const.EntityType.LegendDemonAlp,
		];

		return invalid.find(_target.getType()) == null;
	}

	function getHitchance( _targetEntity )
	{
		if (_targetEntity.getMoraleState() == this.Const.MoraleState.Ignore)
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
		local properties = this.m.Container.buildPropertiesForUse(this, _targetEntity);
		local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(_user, this);

		local bravery = (defenderProperties.getBravery() + defenderProperties.MoraleCheckBravery[this.Const.MoraleCheckType.MentalAttack]) * defenderProperties.MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack];
		local attempts = _targetEntity.getFlags().getAsInt("resist_sleep");
		local bonus = (this.m.MaxRange + 1 - _distance) * (1.0 + 0.1 * attempts);
		local _difficulty = 0;
		_difficulty -= 35 * bonus + (this.getContainer().hasSkill("perk.mastery_sleep") ? this.Math.max(1, this.Math.floor(properties.getBravery() * 0.1)) : 0);
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

				if (tile.IsOccupiedByActor && tile.getEntity().getMoraleState() != this.Const.MoraleState.Fleeing)
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
		chance -= threatBonus + numAlliesAdjacent * this.Const.Morale.AlliesAdjacentMult;
		chance += numOpponentsAdjacent * this.Const.Morale.OpponentsAdjacentMult;
		chance = this.Math.minf(95, this.Math.floor(chance));

		if (chance <= 0)
		{
			return 100;
		}

		return 100 - chance;
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
		local myTile = this.getContainer().getActor().getTile();
		local isSpecialized = this.getContainer().hasSkill("perk.mastery_sleep");
		local _distance = myTile.getDistanceTo(_targetTile);

		local properties = this.m.Container.buildPropertiesForUse(this, _targetEntity);
		local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(_user, this);
		local bravery = (defenderProperties.getBravery() + defenderProperties.MoraleCheckBravery[this.Const.MoraleCheckType.MentalAttack]) * defenderProperties.MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack];

		if (defenderProperties.MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] >= 1000.0 || bravery >= 500)
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
				text = "Can\'t put to sleep right now"
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
		
		if (targetEntity.getMoraleState() == this.Const.MoraleState.Ignore)
		{
			ret.push({
				icon = "ui/icons/cancel.png",
				text = "Can\'t resist"
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
				text = "Default bonus: [color=" + this.Const.UI.Color.PositiveValue + "]30%[/color]"
			}
		]);

		local attempts = _targetEntity.getFlags().getAsInt("resist_sleep");
		local _difficulty = 35;

		if (_distance != this.m.MaxRange)
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "Too close: [color=" + this.Const.UI.Color.NegativeValue + "]35%[/color]"
			});
			_difficulty -= 35;
		}

		if (attempts != 0)
		{
			local add = this.Math.floor(_difficulty * attempts * 0.1);
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "Fail attempts: [color=" + this.Const.UI.Color.PositiveValue + "]" + add + "%[/color]"
			});
			_difficulty += add;
		}

		if (isSpecialized)
		{
			local add = this.Math.floor(this.Math.max(1, properties.getBravery() * 0.1));
			ret.insert(0, 
			{
				icon = "ui/icons/bravery.png",
				text = "Your resolve: [color=#0b0084]" + properties.getBravery() + "[/color]"
			});
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "Overslept perk: [color=" + this.Const.UI.Color.PositiveValue + "]" + add + "%[/color]"
			});
			_difficulty += add;
		}

		if (defenderProperties.MoraleEffectMult > 1.0)
		{
			local add = this.Math.floor(_difficulty * (defenderProperties.MoraleEffectMult - 1.0));
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "Sensitive: [color=" + this.Const.UI.Color.PositiveValue + "]" + add + "%[/color]"
			});
		}
		else if (defenderProperties.MoraleEffectMult < 1.0 && defenderProperties.MoraleEffectMult > 0)
		{
			local add = this.Math.floor(_difficulty * (1.0 - defenderProperties.MoraleEffectMult));
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "Insensitive: [color=" + this.Const.UI.Color.NegativeValue + "]" + add + "%[/color]"
			});
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

				if (tile.IsOccupiedByActor && tile.getEntity().getMoraleState() != this.Const.MoraleState.Fleeing)
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

		if (threatBonus != 0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "Intimidated: [color=" + this.Const.UI.Color.PositiveValue + "]" + threatBonus + "%[/color]"
			});
		}
			
		local modAllies = numAlliesAdjacent * this.Const.Morale.AlliesAdjacentMult;

		if (modAllies != 0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "Surrounded: [color=" + this.Const.UI.Color.PositiveValue + "]" + modAllies + "%[/color]"
			});
		}

		local modEnemies = numOpponentsAdjacent * this.Const.Morale.OpponentsAdjacentMult;

		if (modEnemies != 0)
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "Allies nearby: [color=" + this.Const.UI.Color.NegativeValue + "]" + modEnemies + "%[/color]"
			});
		}

		return ret;
	}

});

