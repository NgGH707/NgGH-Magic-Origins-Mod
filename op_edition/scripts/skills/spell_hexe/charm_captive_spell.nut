//For Legends BB version, don't you dare messing with this file. P/S: NgGH707 (Hans)
this.charm_captive_spell <- this.inherit("scripts/skills/mc_magic_skill", {
	m = {
		Capture = [],
		Count = 2,
		IsInBattle = false,
		MaxAttempt = 3,
	},

	function create()
	{
		this.mc_magic_skill.create();
		this.m.ID = "spells.charm_captive";
		this.m.Name = "Captive Charm";
		this.m.Description = "A powerful mind control magic that can permanently turn an enemy into a faithful slave. Affected target will be mesmerized by your charm and unable to to anything for the rest of the battle.";
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
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted + 3;
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

	function getDescription()
	{
		return this.skill.getDescription();
	}
	
	function onBeforeUse( _user , _targetTile )
	{
		if (!_user.getFlags().has("luft"))
		{
			return;
		}
		
		this.Tactical.spawnSpriteEffect("luft_charm_quote_" + this.Math.rand(1, 7), this.createColor("#ffffff"), _user.getTile(), this.Const.Tactical.Settings.SkillOverlayOffsetX, 145, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayStayDuration, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
	}
	
	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		local flag = this.World.Flags.getAsInt("CharmedCount");
		local count = this.m.Count - flag;
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
			text = "Has [color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] chance to charm target that are next to you"
		});
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Permanently [color=" + this.Const.UI.Color.PositiveValue + "]Charms[/color] a target"
		});
		
		if (this.m.Count == 0 || count <= 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]You can not charm any more enemies[/color]"
			});
		}
		else
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "Can charm [color=" + this.Const.UI.Color.NegativeValue + "]" + count + "[/color] enemies in this battle"
			});
		}

		return ret;
	}
	
	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}
		
		local _target = _targetTile.getEntity();
		local charm = _target.getSkills().getSkillByID("effects.charmed");
		
		if (charm != null && charm.m.Master != null && charm.m.Master.getContainer() != null && charm.m.Master.getContainer().getActor().getID() != this.getContainer().getActor().getID())
		{
			return false;
		}
		
		if (charm != null && charm.m.Master == null)
		{
			return false;
		}

		return _target.getFlags().getAsInt("charm_attempt") < this.m.MaxAttempt;
	}

	function isViableTarget( _user, _target )
	{
		if (_target.getMoraleState() == this.Const.MoraleState.Ignore)
		{
			return false;
		}

		if (_target.getCurrentProperties().MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] >= 1000.0)
		{
			return false;
		}
		
		if (_target.getType() == this.Const.EntityType.Hexe || _target.getType() == this.Const.EntityType.LegendHexeLeader)
		{
			return false;
		}
		
		if (_target.isNonCombatant())
		{
			return false;
		}
		
		return this.isCharmableTarget(_target);
	}
	
	function onAfterUpdate( _properties )
	{
		local actor = this.getContainer().getActor().getSkills();
		
		if (actor.hasSkill("perk.fortified_mind"))
		{
			this.m.FatigueCostMult = this.Const.Combat.WeaponSpecFatigueMult;
		}
	}
	
	function isUsable()
	{
		return !this.isHidden() && this.skill.isUsable();
	}

	function onUse( _user, _targetTile )
	{
		local tag = {
			User = _user,
			TargetTile = _targetTile
		};
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, this.onDelayedEffect.bindenv(this), tag);
		return true;
	}

	function onDelayedEffect( _tag )
	{
		local _targetTile = _tag.TargetTile;
		local _user = _tag.User;
		local target = _targetTile.getEntity();
		local time = this.Tactical.spawnProjectileEffect("effect_heart_01", _user.getTile(), _targetTile, 0.33, 2.0, false, false);
		local self = this;
		this.Time.scheduleEvent(this.TimeUnit.Virtual, time, function ( _e )
		{
			local roll = this.Math.rand(1, 100);
			local chance = this.getHitchance(target);

			if (roll > chance)
			{
				if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " resists being charmed thanks to his resolve (Chance: " + chance + ", Rolled: " + roll + ")");
				}
				
				if (chance == 0)
				{
					return;
				}
				
				target.getFlags().increment("charm_attempt");
				return;
			}

			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " has been captive by your charm (Chance: " + chance + ", Rolled: " + roll + ")");
			local unit = this.onCharm(_user, target);
			
			if (unit != null)
			{
				this.World.Flags.increment("CharmedCount");
			}
		}.bindenv(this), this);
	}
	
	function onCharm( _user, _targetEntity )
	{
		if (_targetEntity.getFlags().has("lindwurm") && ( "Body" in _targetEntity.m ))
		{
			_targetEntity = _targetEntity.m.Body;
		}
		
		local roster = this.World.getTemporaryRoster();
		local data = this.Const.HexenOrigin.CharmedSlave[_targetEntity.getFlags().has("human") ? "TypeToInfoHuman" : "TypeToInfoNonHuman"](_targetEntity);
		
		if (data == null)
		{
			this.logError("Error - Can not find data for the targeted charmed slave")
			return 
		}
		
		local background = this.new("scripts/skills/backgrounds/" + data.Background);
		background.transferInfo(_targetEntity, data);
		local CharmedSlave = roster.create("scripts/entity/tactical/" + data.Script);

		if (_targetEntity.getSkills().hasSkill("racial.champion"))
		{
			CharmedSlave.getSkills().add(this.new("scripts/skills/racial/champion_racial"));
		}

		CharmedSlave.improveMood(2.0, "found a new purpose of life, to serve you, of course");
		CharmedSlave.getSkills().add(background);
		background.onSetUp();
		background.buildDescription();
		CharmedSlave.m.Background = background;
		
		this.onFinishCharm(_targetEntity, CharmedSlave);
		return CharmedSlave;
	}
	
	function onFinishCharm( _victim, _charmedSlave )
	{
		local isFinish = this.Tactical.Entities.getHostilesNum() == 1;
		this.m.Capture.push(_victim);
		local charm = this.new("scripts/skills/spell_hexe/w_charmed_captive_effect");
		charm.setSelf(_charmedSlave);
		charm.isTheLastEnemy(isFinish);
		charm.setMaster(this.getContainer().getActor());
		_victim.getSkills().add(charm);
	}
	
	function getHitchance( _targetEntity )
	{
		if (!this.isViableTarget(this.getContainer().getActor(), _targetEntity))
		{
			return 0;
		}

		if (this.m.Count - this.World.Flags.getAsInt("CharmedCount") <= 0)
		{
			return 0;
		}

		local _user = this.getContainer().getActor();
		local myTile = this.getContainer().getActor().getTile();
		local properties = this.m.Container.buildPropertiesForUse(this, _targetEntity);
		local resolve = (properties.Bravery / 1.25) * properties.BraveryMult;
		local res = properties.MoraleCheckBravery[1];
		local CasterPower = resolve + res;
		
		local bonus = _targetEntity.getTile().getDistanceTo(myTile) == 1 ? 10 : 0;
		bonus = bonus + (_targetEntity.getSkills().hasSkill("effects.charmed") ? 20 : 0) + _targetEntity.getFlags().getAsInt("charm_attempt") * 4;
		bonus = bonus + this.getBonus();
		local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(_user, this);
		local resist = (defenderProperties.getBravery() + defenderProperties.MoraleCheckBravery[1]) * defenderProperties.MoraleCheckBraveryMult[1];
		
		if (resist >= 500 && _targetEntity.getType() != 79)
		{
			return 0;
		}
		
		local hpLeft = _targetEntity.getHitpointsPct();
		local toHit = CasterPower * defenderProperties.MoraleEffectMult - (resist * (hpLeft == 1.0 ? 2.0 : this.Math.max(0.4, hpLeft + 0.25)) - this.Const.HexenOrigin.Magic.CountDebuff(_targetEntity) * 2);
		local targetTile = _targetEntity.getTile();
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
		
		local modifier = this.Math.pow(1.13, this.Math.max(0, numAlliesAdjacent - 1));
		local penalty = this.Const.CharmedSlave.getDifficulty(_targetEntity.getType()) * (_targetEntity.getSkills().hasSkill("racial.champion") ? 1.0 : 1.5);
		toHit = toHit + numAlliesAdjacent * this.Const.Morale.OpponentsAdjacentMult - numOpponentsAdjacent * 6;
		toHit = toHit - (penalty < 0 ? penalty * modifier : penalty / modifier);
		toHit = toHit + threatBonus;
		toHit = toHit + bonus;
		
		if (_targetEntity.getType() == 112)
		{
			return this.Math.max(5, this.Math.min(10, toHit));
		}
		
		if (_targetEntity.getType() == 79)
		{
			if (hpLeft >= 1.0)
			{
				return 0;
			}
			
			return this.Math.max(1, this.Math.min(5, toHit));
		}

		return this.Math.max(5, this.Math.min(95, toHit));
	}
	
	function getBonus()
	{
		local affected = [
			"perk.mastery_charm",
			"perk.boobas_charm",
			"trait.seductive",
			"perk.charm_nudist",
		];
		local bonus = 0;
		
		foreach ( id in affected )
		{
			local skill = this.getContainer().getSkillByID(id);
			
			if (skill != null)
			{
				bonus = bonus + skill.getBonus();
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
		local resolve = (properties.Bravery / 1.25) * properties.BraveryMult;
		local res = properties.MoraleCheckBravery[1];
		local CasterPower = this.Math.floor(resolve + res);

		local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(_user, this);
		local resist = this.Math.floor((defenderProperties.getBravery() + defenderProperties.MoraleCheckBravery[1]) * defenderProperties.MoraleCheckBraveryMult[1]);

		local requirements = this.isCharmableTarget(targetEntity, true);
		local attempts = _targetEntity.getFlags().getAsInt("charm_attempt");

		if (this.m.Count - this.World.Flags.getAsInt("CharmedCount") <= 0)
		{
			ret.push({
				icon = "ui/icons/cancel.png",
				text = "Reach limit"
			});
			
			return ret;
		}

		if (targetEntity.getType() != 79 && (defenderProperties.MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] >= 1000.0 || resist >= 500))
		{
			ret.push({
				icon = "ui/icons/cancel.png",
				text = "Extreme high magic resistance"
			});
			
			return ret;
		}
		
		if (targetEntity.getType() == this.Const.EntityType.Hexe || targetEntity.getType() == this.Const.EntityType.LegendHexeLeader)
		{
			ret.push({
				icon = "ui/icons/cancel.png",
				text = "Immune to charm"
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
						text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can\'t be charmed[/color]"
					});
					this.logError("Fail to evaluating " + targetEntity.getName + ", reason is unknown")
					continue;
				}
				
				ret.push({
					icon = "ui/tooltips/warning.png",
					text = "Require [color=" + this.Const.UI.Color.NegativeValue + "]'" + r + "'[/color] perk"
				});
			}
			
			return ret;
		}
		else
		{
			if (attempts != 0)
			{
				ret.push({
					icon = "ui/icons/health.png",
					text = "Fail attempts: [color=" + this.Const.UI.Color.NegativeValue + "]" + attempts + "[/color]/[color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.MaxAttempt + "[/color]"
				});
			}
		}

		ret.extend([
			{
				icon = "ui/icons/bravery.png",
				text = "Your willpower: [color=#0b0084]" + CasterPower + "[/color]"
			},
			{
				icon = "ui/icons/bravery.png",
				text = "Target\'s resistance: [color=#0b0084]" + resist + "[/color]" 
			}
		]);
		
		local targetTile = _targetEntity.getTile();
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
		
		local modifier = this.Math.pow(1.13, this.Math.max(0, numAlliesAdjacent - 1));
		local penalty = this.Const.CharmedSlave.getDifficulty(_targetEntity.getType()) * (_targetEntity.getSkills().hasSkill("racial.champion") ? 1.0 : 1.5);
		local difficultyPenalty = penalty < 0 ? penalty * modifier : penalty / modifier;

		if (difficultyPenalty <= 0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "Difficulty: [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.floor(this.Math.abs(difficultyPenalty)) + "%[/color]"
			});
		}
		else 
		{
		   ret.push({
				icon = "ui/tooltips/negative.png",
				text = "Difficulty: [color=" + this.Const.UI.Color.NegativeValue + "]" + this.Math.floor(this.Math.abs(difficultyPenalty)) + "%[/color]"
			});
		}

		if (attempts != 0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "Bonus from fail attempts: [color=" + this.Const.UI.Color.PositiveValue + "]" + attempts * 4 + "%[/color]"
			});
		}

		local affected = [
			"perk.mastery_charm",
			"perk.boobas_charm",
			"trait.seductive",
			"perk.charm_nudist",
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

		if (_targetEntity.getSkills().hasSkill("effects.charmed"))
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "Temporarily charmed: [color=" + this.Const.UI.Color.PositiveValue + "]20%[/color]"
			});
		}

		local debuff = this.Const.HexenOrigin.Magic.CountDebuff(_targetEntity);

		if (debuff != 0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "Debuff: [color=" + this.Const.UI.Color.PositiveValue + "]" + debuff * 2 + "%[/color]"
			});
		}

		
		local hpLeft = _targetEntity.getHitpointsPct();
		local modInjury = this.Math.max(0.4, hpLeft + 0.25);

		if (hpLeft >= 1.0)
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "Unharmed: [color=" + this.Const.UI.Color.NegativeValue + "]" + resist + "%[/color]"
			});	
		}
		else if (modInjury > 1)
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "Light injury: [color=" + this.Const.UI.Color.NegativeValue + "]" + this.Math.floor(resist * (1 - modInjury)) + "%[/color]"
			});
		}
		else 
		{
		    ret.push({
				icon = "ui/tooltips/positive.png",
				text = "Severe injury: [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.floor(resist * (1 - modInjury)) + "%[/color]"
			});
		}

		if (threatBonus != 0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "Intimidated: [color=" + this.Const.UI.Color.PositiveValue + "]" + threatBonus + "%[/color]"
			});
		}
			
		local modAllies = numAlliesAdjacent * 6;

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

		if (_targetEntity.getTile().getDistanceTo(myTile) == 1)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "Too close: [color=" + this.Const.UI.Color.PositiveValue + "]10%[/color]"
			});
		}

		if (targetEntity.getType() == 79)
		{
			ret.push({
				icon = "ui/tooltips/chance_to_hit_head.png",
				text = "A [color=" + this.Const.UI.Color.NegativeValue + "]God[/color]"
			});
		}

		if (_targetEntity.getType() == 112)
		{
			ret.push({
				icon = "ui/tooltips/chance_to_hit_head.png",
				text = "A [color=" + this.Const.UI.Color.NegativeValue + "]Powerful Beast[/color]"
			});
		}
		
		return ret;
	}
	
	function isCharmableTarget( _targetEntity , _isForToolTips = false )
	{
		local _user = this.getContainer().getActor();
		local isHuman = _targetEntity.getFlags().has("human");
		local requirements = this.Const.HexenOrigin.CharmedSlave[isHuman ? "TypeToInfoHuman" : "TypeToInfoNonHuman"](_targetEntity, true);
		local failToMeet = [];
		
		if (requirements == null || typeof requirements != "array")
		{
			return _isForToolTips ? ["Can\'t be charmed"] : false;
		}
		
		if (_targetEntity.getSkills().hasSkill("racial.champion") && requirements.find("perk.mastery_charm") == null)
		{
			requirements.push("perk.mastery_charm");
		}
		
		if (requirements.len() == 0)
		{
			return _isForToolTips ? [] : true;
		}
		
		foreach ( r in requirements )
		{
			if (!this.getContainer().hasSkill(r))
			{
				if (_isForToolTips)
				{
					failToMeet.push(r);
				}
				else
				{
					return false;
				}
			}
		}
		
		local names = [];
		
		if (_isForToolTips)
		{
			foreach ( f in failToMeet )
			{
				local p = _user.getBackground().getPerk(f);
				
				if (p != null)
				{
					names.push(p.Name);
				}
			}
		}
		
		return _isForToolTips ? names : true;
	}
	
	function onCombatStarted()
	{
		this.World.Flags.set("CharmedCount", 0);
		this.m.IsInBattle = true;
		this.m.Capture = [];
		
		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			this.m.Count = 0;
			return;
		}
		
		local size = this.World.Assets.getBrothersMax() - this.World.getPlayerRoster().getSize();
		local num = this.Tactical.Entities.getHostilesNum();
		this.m.Count = this.Math.max(1, this.Math.floor(num / 5));
		this.m.Count = size > this.m.Count ? this.m.Count : size;
	}
	
	function onCombatFinished()
	{
		this.World.Flags.set("CharmedCount", 0);
		this.m.Count = 0;
		this.m.IsInBattle = false;
		
		if (this.m.Capture.len() != 0)
		{
			foreach (c in this.m.Capture)
			{
				if (c != null && c.isAlive())
				{
					this.logInfo("Trying to enslave - " + c.getName());
					local effect = c.getSkills().getSkillByID("effects.charmed_captive");
					effect.onCombatFinished();
				}
			}
		}
		
		this.m.Capture = [];
		this.World.getTemporaryRoster().clear();
	}

});

