this.sleep_spell <- this.inherit("scripts/skills/mc_magic_skill", {
	m = {
		BonusChance = 25
	},
	function create()
	{
		this.mc_magic_skill.create();
		this.m.ID = "spells.sleep";
		this.m.Name = "Sleep";
		this.m.Description = "Using magic to put a target into a deep sleep. The effect lasts for 3 turns.";
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
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted + 2;
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
		this.m.IsIgnoreBlockTarget = true;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 13;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
		this.m.MaxLevelDifference = 4;
		this.m.MaxRangeBonus = 3;
	}

	function getDescription()
	{
		return this.skill.getDescription();
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
			icon = "ui/icons/hitchance.png",
			text = "Has [color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.BonusChance + "%[/color] chance to succeed"
		});
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Puts a target to [color=" + this.Const.UI.Color.PositiveValue + "]Sleep[/color]"
		});
		ret.push({
			id = 9,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Chance is based on [color=" + this.Const.UI.Color.NegativeValue + "]Resolve[/color] points from both the caster and the target"
		});

		return ret;
	}
	
	function onAfterUpdate( _properties )
	{
		local actor = this.getContainer().getActor().getSkills();
		
		if (actor.hasSkill("perk.fortified_mind"))
		{
			this.m.FatigueCostMult = this.Const.Combat.WeaponSpecFatigueMult;
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

	function onUse( _user, _targetTile )
	{
		local tag = {
			Skill = this,
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

		foreach( target in targets )
		{
			local Chance = _tag.Skill.getHitchance(target);
			local roll = this.Math.rand(1, 100);

			if (roll > Chance)
			{
				if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " resists the urge to sleep thanks to his resolve (Chance: " + Chance + ", Rolled: " + roll + ")");
				}

				continue;
			}

			target.getSkills().add(this.new("scripts/skills/effects/sleeping_effect"));

			if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " falls to sleep (Chance: " + Chance + ", Rolled: " + roll + ")");
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
		local properties = this.m.Container.buildPropertiesForUse(this, _targetEntity);
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
		
		toHit = toHit + numAlliesAdjacent * this.Const.Morale.OpponentsAdjacentMult - numOpponentsAdjacent * this.Const.Morale.AlliesAdjacentMult;
		toHit = toHit + threatBonus + bonus + this.m.BonusChance;
		toHit = toHit + this.Const.HexenOrigin.Magic.CountDebuff(_targetEntity) * 2;

		if (dis >= this.m.MaxRange)
		{
			toHit = toHit - 5;
		}
		else if (dis == 1)
		{
			toHit = toHit + 5;
		}

		return this.Math.max(5, this.Math.min(95, toHit));
	}
	
	function getBonus()
	{
		local affected = [
			"perk.charm_enemy_alps",
		];
		local bonus = 0;
		
		foreach ( id in affected )
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

		local properties = this.m.Container.buildPropertiesForUse(this, _targetEntity);
		local resolve = properties.Bravery * properties.BraveryMult;
		local res = properties.MoraleCheckBravery[1];
		local CasterPower = this.Math.floor(resolve + res);

		local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(_user, this);
		local resist = this.Math.floor((defenderProperties.getBravery() + defenderProperties.MoraleCheckBravery[1]) * defenderProperties.MoraleCheckBraveryMult[1]);
		local targetTile = _targetEntity.getTile();
		local dis = targetTile.getDistanceTo(myTile);

		if (defenderProperties.MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] >= 1000.0 || resist >= 500)
		{
			ret.push({
				icon = "ui/icons/cancel.png",
				text = "Extreme high magic resistance"
			});
			
			return ret;
		}

		local invalid = [
			this.Const.EntityType.Alp,
			this.Const.EntityType.AlpShadow,
			this.Const.EntityType.LegendDemonAlp,
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
		
		if (targetEntity.getMoraleState() == this.Const.MoraleState.Ignore)
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
				text = "Default bonus: [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.BonusChance + "%[/color]"
			}
		]);

		if (dis >= this.m.MaxRange)
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "Distance of " + dis + ": [color=" + this.Const.UI.Color.NegativeValue + "]5%[/color]"
			});
		}
		else if (dis == 1)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "Too close: [color=" + this.Const.UI.Color.PositiveValue + "]5%[/color]"
			});
		}
		
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

		local affected = [
			"perk.charm_enemy_alps"
		];
		
		foreach ( id in affected )
		{
			local skill = this.getContainer().getSkillByID(id);
			
			if (skill != null)
			{
				ret.push({
					icon = "ui/tooltips/positive.png",
					text = skill.getName() + ": [color=" + this.Const.UI.Color.PositiveValue + "]" + skill.getBonus() + "%[/color]"
				});
			}
		}

		local debuff = this.Const.HexenOrigin.Magic.CountDebuff(_targetEntity);

		if (debuff != 0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "Debuff: [color=" + this.Const.UI.Color.PositiveValue + "]" + debuff * 2 + "%[/color]"
			});
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

