//For Legends BB version, don't you dare messing with this file. P/S: NgGH707 (Hans)
this.nggh_mod_charm_captive_spell <- ::inherit("scripts/skills/skill", {
	m = {
		IsInBattle = false,
		Capture = [],

		Count = 2,
		MaxAttempt = 3,
		ChampionMult = 1.25
	},

	function create()
	{
		this.m.ID = "spells.charm_captive";
		this.m.Name = "Captive Charm";
		this.m.Description = "A powerful charm that can permanently turn an enemy into a faithful slave. Affected target will be mesmerized by your charm and unable to do anything for the rest of the battle.";
		this.m.Icon = "skills/active_120.png";
		this.m.IconDisabled = "skills/active_120_sw.png";
		this.m.Overlay = "active_120";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/hexe_charm_kiss_01.wav",
			"sounds/enemies/dlc2/hexe_charm_kiss_02.wav",
			"sounds/enemies/dlc2/hexe_charm_kiss_03.wav",
			"sounds/enemies/dlc2/hexe_charm_kiss_04.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/dlc2/hexe_charm_chimes_01.wav",
			"sounds/enemies/dlc2/hexe_charm_chimes_02.wav",
			"sounds/enemies/dlc2/hexe_charm_chimes_03.wav",
			"sounds/enemies/dlc2/hexe_charm_chimes_04.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted + 5;
		this.m.Delay = 250;
		this.m.IsSerialized = true;
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
		this.m.ActionPointCost = 7;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 6;
		this.m.MaxLevelDifference = 4;
		this.m.MaxRangeBonus = 2;
	}
	
	function onBeforeUse( _user , _targetTile )
	{
		if (!_user.getFlags().has("luft"))
		{
			return;
		}
		
		::Nggh_MagicConcept.spawnQuote("luft_charm_quote_" + ::Math.rand(1, 7), _user.getTile());
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
				text = "Has [color=" + ::Const.UI.Color.PositiveValue + "]+10%[/color] chance to charm any target that is next to you"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Inflicts a permanent [color=" + ::Const.UI.Color.NegativeValue + "]Charmed[/color] effect on a target"
			}
		]);

		if (!::Nggh_MagicConcept.IsAbleToCharmInArena && ::Tactical.isActive() && ("StrategicProperties" in ::Tactical.State.m) && ::Tactical.State.m.StrategicProperties != null && ::Tactical.State.m.StrategicProperties.IsArenaMode)
		{
			ret.push({
				id = 99,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]You are not allowed to use this in the arena[/color]"
			});

			return ret;
		}

		local flag = ::Tactical.isActive() ? ::Tactical.Entities.getFlags().getAsInt("CharmedCount") : 0;
		local count = this.m.Count - flag;
		
		if (this.m.Count == 0 || count <= 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]You can not charm any more foe[/color]"
			});
		}
		else
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "Can charm [color=" + ::Const.UI.Color.NegativeValue + "]" + count + "[/color] foe(s) in this battle"
			});
		}

		return ret;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.getContainer().hasSkill("effects.cursed_badly");
	}
	
	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}
		
		local _target = _targetTile.getEntity();
		local simp = _target.getSkills().getSkillByID("effects.simp");

	    if (simp != null)
		{
			return false;
		}

		local charm = _target.getSkills().getSkillByID("effects.charmed");

		if (charm != null)
		{
			if (charm.m.Master == null)
			{
				return false;
			}

			if (charm.m.Master.getContainer() != null && charm.m.Master.getContainer().getActor().getID() != this.getContainer().getActor().getID())
			{
				return false;
			}
		}

		return _target.getFlags().getAsInt("charm_attempt") < this.m.MaxAttempt;
	}

	function isViableTarget( _user, _target )
	{
		if (_target.getMoraleState() == ::Const.MoraleState.Ignore)
		{
			return false;
		}

		if (_target.getCurrentProperties().MoraleCheckBraveryMult[::Const.MoraleCheckType.MentalAttack] >= 1000.0)
		{
			return false;
		}
		
		if (_target.getType() == ::Const.EntityType.Hexe || _target.getType() == ::Const.EntityType.LegendHexeLeader)
		{
			return false;
		}
		
		if (_target.isNonCombatant())
		{
			return false;
		}

		if (_target.getSkills().hasSkill("effects.ghost_possessed"))
		{
			return false;
		}
		
		return this.checkRequirement(_target);
	}
	
	function onAfterUpdate( _properties )
	{
		if (this.getContainer().hasSkill("perk.fortified_mind"))
		{
			this.m.FatigueCostMult = ::Const.Combat.WeaponSpecFatigueMult;
		}
	}

	function onUse( _user, _targetTile )
	{
		::Time.scheduleEvent(::TimeUnit.Virtual, 500, this.onDelayedEffect.bindenv(this), {
			User = _user,
			TargetTile = _targetTile
		});
		return true;
	}

	function onDelayedEffect( _tag )
	{
		local _targetTile = _tag.TargetTile;
		local _user = _tag.User;
		local target = _targetTile.getEntity();
		local time = ::Tactical.spawnProjectileEffect("effect_heart_01", _user.getTile(), _targetTile, 0.33, 2.0, false, false);
		::Time.scheduleEvent(::TimeUnit.Virtual, time, function ( _lol )
		{
			local roll = ::Math.rand(1, 100);
			local chance = this.getHitchance(target);

			if (roll > chance)
			{
				if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
				{
					::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(target) + " resists being charmed thanks to his resolve (Chance: " + chance + ", Rolled: " + roll + ")");
				}
				
				if (chance == 0)
				{
					return;
				}
				
				target.getFlags().increment("charm_attempt");
				return;
			}

			/*
			local simp = target.getSkills().getSkillByID("effects.simp");

		    if (simp != null && simp.m.StartMutiny)
			{
				simp.reset();
				return;
			}
			*/

			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(target) + " has been captive by your charm (Chance: " + chance + ", Rolled: " + roll + ")");
			if (this.onCharm(_user, target) != null)
			{
				::Tactical.Entities.getFlags().increment("CharmedCount");
			}
		}.bindenv(this), this);
	}
	
	function onCharm( _user, _targetEntity )
	{
		local isLindwurm = _targetEntity.getFlags().has("lindwurm");

		if (isLindwurm && ("Body" in _targetEntity.m))
		{
			_targetEntity = _targetEntity.m.Body;
		}
		
		local roster = ::World.getTemporaryRoster();
		local func = _targetEntity.getFlags().has("human") ? "TypeToInfoHuman" : "TypeToInfoNonHuman";
		local data = ::Const.CharmedUtilities[func](_targetEntity);
		
		if (data == null)
		{
			::logError("Failed to retrieve the data of charmed target. Reason: Data doesn\'t exist or invalid \'EntityType\'");
			return null;
		}
		
		local background = ::new("scripts/skills/backgrounds/" + data.Background);
		local victim = roster.create("scripts/entity/tactical/" + data.Script);
		victim.improveMood(2.0, "found a new purpose of life, to serve you, of course");
		background.setTempData(data);
		victim.getSkills().add(background);
		background.setup(false);
		background.buildDescription();
		victim.m.Background = background;
		
		this.onFinishCharm(_targetEntity, victim, isLindwurm);
		return victim;
	}
	
	function onFinishCharm( _targetEntity, _victim , _isAFuckingLindwurm = false )
	{
		local isFinish = _isAFuckingLindwurm ? ::Tactical.Entities.getHostilesNum() <= 2 : ::Tactical.Entities.getHostilesNum() == 1;
		this.m.Capture.push(::WeakTableRef(_targetEntity));
		local charm = ::new("scripts/skills/hexe/nggh_mod_charmed_captive_effect");
		charm.setSelf(_victim);
		charm.isTheLastEnemy(isFinish);
		charm.setCharm(this);
		charm.setMaster(this.getContainer().getActor());
		_targetEntity.getSkills().add(charm);
	}
	
	function getHitchance( _targetEntity )
	{
		if (!this.isViableTarget(this.getContainer().getActor(), _targetEntity))
		{
			return 0;
		}

		if (this.m.Count - ::Tactical.Entities.getFlags().getAsInt("CharmedCount") <= 0)
		{
			return 0;
		}

		local _user = this.getContainer().getActor();
		local myTile = this.getContainer().getActor().getTile();
		local properties = this.getContainer().buildPropertiesForUse(this, _targetEntity);
		local resolve = (properties.Bravery / 1.25) * properties.BraveryMult;
		local res = properties.MoraleCheckBravery[1] * 0.5;
		local CasterPower = resolve + res;
		
		local bonus = _targetEntity.getTile().getDistanceTo(myTile) == 1 ? 10 : 0;
		bonus += (_targetEntity.getSkills().hasSkill("effects.charmed") ? 15 : 0) + _targetEntity.getFlags().getAsInt("charm_attempt") * 4;
		bonus += this.getContainer().hasSkill("perk.bdsm_bondage") && _targetEntity.getCurrentProperties().IsRooted ? 10 : 0;
		bonus += this.getContainer().hasSkill("perk.bdsm_whip_love") ? ::Math.min(20, _targetEntity.getFlags().getAsInt("whipped") * 4) : 0;
		bonus += this.getBonus();
		local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(_user, this);
		local resist = (defenderProperties.getBravery() + defenderProperties.MoraleCheckBravery[1]) * defenderProperties.MoraleCheckBraveryMult[1] * (_targetEntity.getSkills().hasSkill("racial.champion") ? this.m.ChampionMult : 1.0);
		local isFullHP = _targetEntity.getHitpoints() == _targetEntity.getHitpointsMax();

		if (resist >= 500 && isFullHP)
		{
			return 0;
		}

		local hpMod = 0;

		if (isFullHP)
		{
			hpMod += resist * 0.75;
		}
		else
		{
			local missingHitpointsPct = 1.0 - _targetEntity.getHitpointsPct();
			hpMod -= resist * (missingHitpointsPct / 2);
		}

		local toHit = CasterPower * defenderProperties.MoraleEffectMult - (resist + hpMod - ::Const.HexeOrigin.Magic.CountDebuff(_targetEntity) * 2);
		local targetTile = _targetEntity.getTile();
		local numOpponentsAdjacent = 0;
		local numAlliesAdjacent = 0;
		local threatBonus = 0;0

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
		
		local modifier = ::Math.pow(1.13, ::Math.max(0, numAlliesAdjacent - 1));
		local penalty = ::Const.CharmedUnits.getDifficulty(_targetEntity.getType());
		toHit += numAlliesAdjacent * ::Const.Morale.OpponentsAdjacentMult - numOpponentsAdjacent * 6;
		toHit -= penalty <= 0 ? penalty * modifier : penalty / modifier;
		toHit += threatBonus;
		toHit += bonus;

		switch (_targetEntity.getType()) 
		{
	    case ::Const.EntityType.LegendStollwurm:
	        return ::Math.max(5, ::Math.min(10, toHit));

	    case ::Const.EntityType.TricksterGod:
			return ::Math.max(2, ::Math.min(7, toHit));

	    case ::Const.EntityType.Kraken:
	        return ::Math.max(1, ::Math.min(10, toHit));
	
	    default:
	    	return ::Math.max(5, ::Math.min(95, toHit));
		}
	}

	function getAffectedSkills()
	{
		return [
			"perk.mastery_charm",
			"perk.boobas_charm",
			"perk.charm_nudist",
			"trait.gift_of_people",
			"trait.seductive",
		];
	}
	
	function getBonus()
	{
		local bonus = 0;
		
		foreach (id in this.getAffectedSkills())
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
		local resolve = (properties.Bravery / 1.25) * properties.BraveryMult;
		local res = properties.MoraleCheckBravery[1] * 0.5;
		local CasterPower = ::Math.floor(resolve + res);

		local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(_user, this);
		local resist = ::Math.floor((defenderProperties.getBravery() + defenderProperties.MoraleCheckBravery[1]) * defenderProperties.MoraleCheckBraveryMult[1] * (_targetEntity.getSkills().hasSkill("racial.champion") ? this.m.ChampionMult : 1.0));

		local requirements = this.checkRequirement(targetEntity, true);
		local attempts = _targetEntity.getFlags().getAsInt("charm_attempt");
		local isFullHP = _targetEntity.getHitpoints() == _targetEntity.getHitpointsMax();

		if (this.m.Count - ::Tactical.Entities.getFlags().getAsInt("CharmedCount") <= 0)
		{
			ret.push({
				icon = "ui/icons/cancel.png",
				text = "Reach limit"
			});
			
			return ret;
		}

		if (defenderProperties.MoraleCheckBraveryMult[::Const.MoraleCheckType.MentalAttack] >= 1000.0 || (resist >= 500 && isFullHP))
		{
			ret.push({
				icon = "ui/icons/cancel.png",
				text = "Extremely high resistance"
			});
			
			return ret;
		}
		
		if (targetEntity.getType() == ::Const.EntityType.Hexe || targetEntity.getType() == ::Const.EntityType.LegendHexeLeader)
		{
			ret.push({
				icon = "ui/icons/cancel.png",
				text = "Immune to charm"
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

		if (targetEntity.getSkills().hasSkill("effects.ghost_possessed"))
		{
			ret.push({
				icon = "ui/icons/cancel.png",
				text = "Possessed"
			});
			
			return ret;
		}
		
		if (targetEntity.getSkills().hasSkill("effects.charmed_captive"))
		{
			ret.push({
				icon = "ui/icons/cancel.png",
				text = "Already charmed"
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
		
		if (requirements.len() != 0)
		{
			foreach ( r in requirements )
			{
				if (r == "Can\'t be charmed")
				{
					ret.push({
						icon = "ui/tooltips/warning.png",
						text = red("Can\'t be charmed")
					});

					::logError("Fail to evaluating " + targetEntity.getName() + ". Reason is unknown")
					continue;
				}
				
				ret.push({
					icon = "ui/tooltips/warning.png",
					text = "Require " + red(r) + " perk"
				});
			}
			
			return ret;
		}
	
		if (attempts != 0)
		{
			ret.push({
				icon = "ui/icons/mood_02.png",
				text = "Failed attempt(s): " + red(attempts) + "/" + red(this.m.MaxAttempt)
			});
		}

		ret.extend([
			{
				icon = "ui/icons/bravery.png",
				text = "Your charm strength: [color=#0b0084]" + CasterPower + "[/color]"
			},
			{
				icon = "ui/icons/bravery.png",
				text = "Target\'s resistance: [color=#0b0084]" + resist + "[/color]" 
			}
		]);

		switch (_targetEntity.getType()) 
		{
	    case ::Const.EntityType.LegendStollwurm:
	        ret.push({
				icon = "ui/icons/chance_to_hit_head.png",
				text = "A " + red("Fearsome Monster")
			});
			break;

	    case ::Const.EntityType.TricksterGod:
	       	ret.push({
				icon = "ui/icons/chance_to_hit_head.png",
				text = "A " + red("God")
			});
			break;

	    case ::Const.EntityType.Kraken:
	        ret.push({
				icon = "ui/icons/chance_to_hit_head.png",
				text = "A " + red("Eldritch Horror")
			});
	        break;
		}
		
		local targetTile = _targetEntity.getTile();
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
		
		local modifier = ::Math.pow(1.13, ::Math.max(0, numAlliesAdjacent - 1));
		local penalty = ::Const.CharmedUnits.getDifficulty(_targetEntity.getType());
		local difficultyPenalty = ::Math.floor(penalty <= 0 ? penalty * modifier : penalty / modifier);

		if (difficultyPenalty <= 0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = green(::Math.abs(difficultyPenalty) + "%") + " Difficulty"
			});
		}
		else 
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = red(::Math.abs(difficultyPenalty) + "%") + " Difficulty"
			});
		}

		if (attempts != 0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = green((attempts * 4) + "%") + " Failed attempt(s)"
			});
		}
		
		foreach (id in this.getAffectedSkills())
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

		if (this.getContainer().hasSkill("perk.bdsm_bondage") && _targetEntity.getCurrentProperties().IsRooted)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = green("10%") + "" + ::Const.Strings.PerkName.NggH_BDSM_Bondage
			});
		}

		local count = _targetEntity.getFlags().getAsInt("whipped");

		if (this.getContainer().hasSkill("perk.bdsm_whip_love") && count > 0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = green(::Math.min(20, count * 4) + "%") + " Whipped (x" + count + ")"
			});
		}

		if (_targetEntity.getSkills().hasSkill("effects.charmed"))
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = green("15%") + " Temporarily charmed"
			});
		}

		local debuff = ::Const.HexeOrigin.Magic.CountDebuff(_targetEntity);

		if (debuff != 0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = green((debuff * 2) + "%") + " Debuff"
			});
		}

		if (isFullHP)
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = red(::Math.floor(resist * 0.75) + "%") + " Unharmed"
			});	
		}
		else
		{
			local hpLeft = _targetEntity.getHitpointsPct();
			local missingHitpointsPct = 1.0 - hpLeft;
			local hpMod = ::Math.floor(resist * (missingHitpointsPct / 2));
			
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = green(hpMod + "%") + " " + (hpLeft <= 0.6 ? "Severe injury" : "Light injury") 
			});
		}

		if (threatBonus != 0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = green(threatBonus + "%") + " Intimidated"
			});
		}
			
		local modAllies = numAlliesAdjacent * 6;

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

		if (_targetEntity.getTile().getDistanceTo(myTile) == 1)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = green("10%") + " Too close"
			});
		}
		
		return ret;
	}
	
	function checkRequirement( _targetEntity , _isForToolTips = false )
	{
		local _user = this.getContainer().getActor();
		local func = _targetEntity.getFlags().has("human") ? "TypeToInfoHuman" : "TypeToInfoNonHuman";
		local requirements = ::Const.CharmedUtilities[func](_targetEntity, true);
		
		if (requirements == null || typeof requirements != "array")
		{
			return _isForToolTips ? ["Can\'t be charmed"] : false;
		}
		
		if (_targetEntity.getSkills().hasSkill("racial.champion") && requirements.find("NggHCharmSpec") == null)
		{
			requirements.push("NggHCharmSpec");
		}
		
		if (requirements.len() == 0)
		{
			return _isForToolTips ? [] : true;
		}

		local failToMeet = [];
		
		foreach ( _const in requirements )
		{
			local def = ::Const.Perks.PerkDefObjects[::Const.Perks.PerkDefs[_const]];

			if (this.getContainer().hasSkill(def.ID))
			{
				continue;
			}

			if (!_isForToolTips)
			{
				return false;
			}

			failToMeet.push(def.Name);
		}
		
		return _isForToolTips ? failToMeet : true;
	}
	
	function onCombatStarted()
	{
		::Tactical.Entities.getFlags().set("CharmedCount", 0);
		this.m.IsInBattle = true;
		this.m.Capture = [];
		
		if (::World.getPlayerRoster().getSize() >= ::World.Assets.getBrothersMax())
		{
			this.m.Count = 0;
			return;
		}

		if (!::Nggh_MagicConcept.IsAbleToCharmInArena && ("StrategicProperties" in ::Tactical.State.m) && ::Tactical.State.m.StrategicProperties != null && ::Tactical.State.m.StrategicProperties.IsArenaMode)
		{
			this.m.Count = 0;
			return;
		}
		
		local size = ::World.Assets.getBrothersMax() - ::World.getPlayerRoster().getSize();
		local num = ::Tactical.Entities.getHostilesNum();
		this.m.Count = ::Math.max(1, ::Math.floor(num / 5));
		this.m.Count = size > this.m.Count ? this.m.Count : size;
	}
	
	function onCombatFinished()
	{
		this.m.Count = 0;
		this.m.IsInBattle = false;
		local isVictory = ::Tactical.Entities.getCombatResult() == ::Const.Tactical.CombatResult.EnemyDestroyed || ::Tactical.Entities.getCombatResult() == ::Const.Tactical.CombatResult.EnemyRetreated;
		
		if (isVictory && this.m.Capture.len() != 0)
		{
			foreach (c in this.m.Capture)
			{
				if (c != null && !c.isNull() && c.isAlive())
				{
					::logInfo("Trying to enslave - " + c.getName());

					local charm = c.getSkills().getSkillByID("effects.charmed_captive");

					if (charm != null && !charm.isGarbage())
					{
						charm.onCombatFinished();
					}
				}
			}
		}
		
		this.m.Capture = [];
		//::World.getTemporaryRoster().clear();
	}

	function onTargetSelected( _targetTile ) {}

});

