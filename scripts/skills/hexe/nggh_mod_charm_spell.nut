this.nggh_mod_charm_spell <- ::inherit("scripts/skills/skill", {
	m = {
		SlavesID = [],
		Slaves = [],
		SlavesPet = [],

		Cooldown = 0,
		DefautBonus = 5,
		InjuryBonus = 12,
		ChampionMult = 1.5
	},
	function addSlave( _entityID )
	{
		local e = ::Tactical.getEntityByID(_entityID);

		if (e != null)
		{
			this.m.Slaves.push(::WeakTableRef(e));
		}
		else
		{
			this.m.Slaves.push(0);
		}
		
		this.m.SlavesID.push(_entityID);
		this.updateCharm();
	}
	
	function removeSlave( _entityID )
	{
		local i = this.m.SlavesID.find(_entityID);
		local e;

		if (i != null)
		{
			this.m.SlavesID.remove(i);
			e = this.m.Slaves.remove(i);
		}

		if (this.isAlive())
		{
			this.updateCharm();
		}

		return e;
	}

	function updateCharm()
	{
		this.getContainer().getActor().getBackground().setCharming(this.m.SlavesID.len() != 0);
	}

	function isAlive()
	{
		return this.getContainer() != null && !this.getContainer().isNull() && this.getContainer().getActor() != null && this.getContainer().getActor().isAlive() && this.getContainer().getActor().getHitpoints() > 0;
	}

	function setCooldown( _cd )
	{
		this.m.Cooldown = _cd;
	}

	function create()
	{
		this.m.ID = "spells.charm";
		this.m.Name = "Charm";
		this.m.Description = "Simple charm that can make affected foes fight for you. Can also be used to capture small pet dog. Success chance is based on [color=" + ::Const.UI.Color.NegativeValue + "]Resolve[/color] points from both the caster and the target";
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
		this.m.Order = ::Const.SkillOrder.UtilityTargeted + 3;
		this.m.IsSerialized = false;
		this.m.Delay = 250;
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
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 8;
		this.m.MaxLevelDifference = 4;
		this.m.MaxRangeBonus = 2;
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
				text = "Has [color=" + ::Const.UI.Color.PositiveValue + "]+10%[/color] chance to charm targets that are next to you"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Inflicts a temporary [color=" + ::Const.UI.Color.NegativeValue + "]Charmed[/color] effect on a target"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can also dispel [color=" + ::Const.UI.Color.NegativeValue + "]Charmed[/color] effect on a target"
			}
		]);

		if (this.m.Cooldown != 0)
		{
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can be used again after " + this.m.Cooldown + " turn(s)[/color]"
			});
		}

		if (this.m.Slaves.len() != 0)
		{
			ret.push({
				id = 99,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]You can only temporarily charm one target at the same time[/color]"
			});
		}

		return ret;
	}

	function isUsable()
	{
		return this.m.Cooldown == 0 && this.m.Slaves.len() == 0 && this.skill.isUsable();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local _target = _targetTile.getEntity();
		local simp = _target.getSkills().getSkillByID("effects.simp");

	    if (simp != null && simp.getSimpLevel() == 0 && simp.isMutiny())
		{
			return false;
		}

		if (_target.getSkills().hasSkill("effects.charmed_captive"))
	    {
	    	return false;
	    }
		
		if (_target.getFlags().has("Hexe"))
		{
			return false;
		}

		return true;
	}

	function isViableTarget( _user, _target )
	{
		if (_target.isAlliedWith(_user))
		{
			return false;
		}

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

		return true;
	}
	
	function onBeforeUse( _user , _targetTile )
	{
		if (!_user.getFlags().has("luft"))
		{
			return;
		}
		
		::Nggh_MagicConcept.spawnQuote("luft_charm_quote_" + ::Math.rand(1, 7), _user.getTile());
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
		local isSpecialized = _user.getSkills().hasSkill("perk.appearance_charm");
		local time = ::Tactical.spawnProjectileEffect("effect_heart_01", _user.getTile(), _targetTile, 0.33, 2.0, false, false);
		::Time.scheduleEvent(::TimeUnit.Virtual, time, function ( _idk )
		{
			local roll = ::Math.rand(1, 100);
			local Chance = this.getHitchance(target);
			
			if (target.getSkills().hasSkill("effects.charmed") || target.getSkills().hasSkill("effects.legend_intensely_charmed"))
			{
				target.getSkills().removeByID("effects.charmed");
				target.getSkills().removeByID("effects.legend_intensely_charmed");
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " dispels charmed effect from " + ::Const.UI.getColorizedEntityName(target));
				return true;
			}

			if (roll > Chance)
			{
				if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
				{
					::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(target) + " resists being charmed thanks to his resolve (Chance: " + Chance + ", Rolled: " + roll + ")");
				}
				
				target.getFlags().increment("charm_fail");

				return false;
			}

			if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(target) + " is charmed (Chance: " + Chance + ", Rolled: " + roll + ")");
			}

			if (::Const.HexenCharmablePet.find(target.getType()) != null)
			{
				this.onCharmPet(_user, target);
				return;
			}
			
			if (target.getMoraleState() == ::Const.MoraleState.Fleeing)
			{
				target.setMoraleState(::Const.MoraleState.Steady);
			}

			::Tactical.Entities.setLastCombatResult(::Const.Tactical.CombatResult.EnemyRetreated);
			local charmed = ::new("scripts/skills/hexe/nggh_mod_charmed_effect");
			charmed.setMasterFaction(_user.getFaction() == ::Const.Faction.Player ? ::Const.Faction.PlayerAnimals : _user.getFaction());
			charmed.setMaster(this);
			charmed.isTheLastEnemy(::Tactical.Entities.getHostilesNum() == 1);
			target.getSkills().add(charmed);

			if (isSpecialized)
			{
				charmed.addTurns(1);
			}
			
			target.getFlags().set("charm_fail", 0);
			this.addSlave(target.getID());
		}.bindenv(this), this);
	}

	function onCharmPet( _user, _target ) 
	{
	    local type = _target.getType();
	    local script;

	    switch (type) 
	    {
        case ::Const.EntityType.ArmoredWardog:
            script = "armored_wardog_item";
            break;

        case ::Const.EntityType.Warhound:
            script = "warhound_item";
            break;

        case ::Const.EntityType.Wolf:
            script = "wolf_item";
            break;

        case ::Const.EntityType.LegendWhiteWarwolf:
            script = "legend_white_wolf_item";
            break;
    
        default:
        	script = "wardog_item";
	    }

	    local self = this;
	    local item = "scripts/items/accessory/" + script;
	    local effect = ::new("scripts/skills/hexe/nggh_mod_charmed_pet_effect");
	    effect.m.LootScript = item;
	    effect.m.Master = self;
	    _target.getSkills().add(effect);
		this.m.SlavesPet.push(effect);
		::Const.HexeOrigin.Magic.SpawnCharmParticleEffect(_target.getTile());
	}

	function onTurnEnd()
	{
		this.m.Cooldown = ::Math.max(0, this.m.Cooldown - 1);
	}

	function onDeath( _fatalityType )
	{
		foreach( id in this.m.SlavesID )
		{
			local e = ::Tactical.getEntityByID(id);

			if (e != null)
			{
				e.getSkills().removeByID("effects.charmed");
			}
		}

		this.m.SlavesID = [];
	}

	function onUpdate( _properties )
	{
		if (!::Tactical.isActive())
		{
			return;
		}
		
		this.updateCharm();
	}
	
	function onAfterUpdate( _properties )
	{
		if (this.getContainer().hasSkill("perk.fortified_mind"))
		{
			this.m.FatigueCostMult = ::Const.Combat.WeaponSpecFatigueMult;
		}
	}
	
	function getHitchance( _targetEntity )
	{
		if (!this.isViableTarget(this.getContainer().getActor(), _targetEntity))
		{
			return 0;
		}
		
		if (_targetEntity.getSkills().hasSkill("effects.charmed") || _targetEntity.getSkills().hasSkill("effects.legend_intensely_charmed"))
		{
			return 100;
		}
	
		local _user = this.getContainer().getActor();
		local myTile = this.getContainer().getActor().getTile();
		local properties = this.getContainer().buildPropertiesForUse(this, _targetEntity);
		local resolve = properties.Bravery * properties.BraveryMult;
		local res = properties.MoraleCheckBravery[1] * 0.67;
		local CasterPower = resolve + res;
		
		local bonus = this.getBonus() + (_targetEntity.getTile().getDistanceTo(myTile) == 1 ? 5 : 0); // ::Const.HexeOrigin.Magic.CountDebuff(_targetEntity) * 3
		bonus += this.getContainer().hasSkill("perk.bdsm_bondage") && _targetEntity.getCurrentProperties().IsRooted ? 10 : 0;
		bonus += this.getContainer().hasSkill("perk.bdsm_whip_love") ? ::Math.min(20, _targetEntity.getFlags().getAsInt("whipped") * 4) : 0;
		bonus += _targetEntity.getFlags().getAsInt("charm_fail") * 2;
		local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(_user, this);
		local resist = (defenderProperties.getBravery() + defenderProperties.MoraleCheckBravery[1]) * defenderProperties.MoraleCheckBraveryMult[1] * (_targetEntity.getSkills().hasSkill("racial.champion") ? this.m.ChampionMult : 1.0);
		local hpLeft = _targetEntity.getHitpointsPct();

		if (hpLeft <= 0.1)
		{
			return 0;
		}

		local mult = ::Math.maxf(0.1, hpLeft + this.m.InjuryBonus * 0.01);
		local toHit = (this.m.DefautBonus + CasterPower * defenderProperties.MoraleEffectMult) * mult - resist;
		
		if (resist >= 500)
		{
			return 0;
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
						threatBonus = threatBonus + tile.getEntity().getCurrentProperties().Threat;
					}
					else
					{
						++numOpponentsAdjacent;
						
					}
				}
			}
		}
		
		toHit += numAlliesAdjacent * ::Const.Morale.OpponentsAdjacentMult - numOpponentsAdjacent * 6;
		toHit += threatBonus;
		toHit += bonus;

		return ::Math.max(5, ::Math.min(95, toHit));
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
		local resolve = properties.Bravery * properties.BraveryMult;
		local res = properties.MoraleCheckBravery[1] * 0.67;
		local CasterPower = ::Math.floor(resolve + res);

		local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(_user, this);
		local resist = ::Math.floor((defenderProperties.getBravery() + defenderProperties.MoraleCheckBravery[1]) * defenderProperties.MoraleCheckBraveryMult[1] * (_targetEntity.getSkills().hasSkill("racial.champion") ? this.m.ChampionMult : 1.0));

		local attempts = _targetEntity.getFlags().getAsInt("charm_fail");

		if (defenderProperties.MoraleCheckBraveryMult[::Const.MoraleCheckType.MentalAttack] >= 1000.0 || resist >= 500)
		{
			ret.push({
				icon = "ui/icons/cancel.png",
				text = "Extremely high magic resistance"
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

		if (_targetEntity.getSkills().hasSkill("effects.ghost_possessed"))
		{
			ret.push({
				icon = "ui/icons/cancel.png",
				text = "Possessed"
			});
			
			return ret;
		}

		if (_targetEntity.getSkills().hasSkill("effects.charmed") || _targetEntity.getSkills().hasSkill("effects.legend_intensely_charmed"))
		{
			ret.push({
				icon = "ui/icons/cancel.png",
				text = "Charmed"
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

		if (targetEntity.getHitpointsPct() <= 0.1)
		{
			ret.push({
				icon = "ui/icons/cancel.png",
				text = "Too weak to simp"
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
			}
		]);

		if (::Const.HexenCharmablePet.find(targetEntity.getType()) != null)
		{
			ret.push({
				icon = "ui/icons/special.png",
				text = "Can be charmed as pet"
			});
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

		if (attempts != 0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = green((attempts * 2) + "%") + " Failed attempt(s)"
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

		/*
		local debuff = ::Const.HexeOrigin.Magic.CountDebuff(_targetEntity);

		if (debuff != 0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = green((debuff * 3) + "%") + " Debuff"
			});
		}
		*/

		local hpLeft = _targetEntity.getHitpointsPct();
		local modInjury = ::Math.maxf(0.1, hpLeft + this.m.InjuryBonus * 0.01);

		ret.push({
			icon = "ui/tooltips/positive.png",
			text = green(::Math.floor(this.m.DefautBonus * modInjury) + "%") + " Default Bonus"
		});

		if (modInjury >= 1.0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = green(::Math.floor(CasterPower * (modInjury - 1.0)) + "%") + " " + (hpLeft >= 1.0 ? "Unharmed" : "Light injury")
			});
		}
		else 
		{
		    ret.push({
				icon = "ui/tooltips/negative.png",
				text = red(::Math.floor(CasterPower * (1.0 - modInjury)) + "%") + " Severe injury"
			});
		}

		if (threatBonus != 0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = green(threatBonus + "%") + " Intimidated"
			});
		}
			
		local modAllies = numAlliesAdjacent * 3;

		if (modAllies != 0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = green(modAllies + "%") + " Surrounded"
			});
		}

		local modEnemies = numOpponentsAdjacent * 6;

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
				text = green("5%") + " Too close"
			});
		}

		return ret;
	}

	function removeSlavePet( _s )
	{
		local index = this.m.SlavesPet.find(_s);

		if (index != null)
		{
			this.m.SlavesPet.remove(index);
		}
	}
	
	function onCombatStarted()
	{
		this.m.Cooldown = 0;
		this.m.SlavesID = [];
		this.m.Slaves = [];
		this.m.SlavesPet = [];
	}
	
	function onCombatFinished()
	{
		foreach ( slave in this.m.Slaves )
		{
			if (slave != null)
			{
				if (typeof slave == "instance")
				{
					slave.kill(this.getContainer().getActor(), this, ::Const.FatalityType.Suicide, true);
				}
			}
		}
		
		this.m.Cooldown = 0;
		this.m.SlavesID = [];
		this.m.Slaves = [];
		this.m.SlavesPet = [];
	}

	function onTargetSelected( _targetTile ) {}

});

