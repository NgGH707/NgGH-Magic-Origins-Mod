this.charm_spell <- this.inherit("scripts/skills/mc_magic_skill", {
	m = {
		SlavesID = [],
		Slaves = [],
		SlavesPet = [],
	},
	function addSlave( _entityID )
	{
		local e = this.Tactical.getEntityByID(_entityID);

		if (e != null)
		{
			this.m.Slaves.push(e);
		}
		else
		{
			this.m.Slaves.push(0);
		}
		
		this.m.SlavesID.push(_entityID);
	}
	
	function removeSlave( _entityID )
	{
		local i = this.m.SlavesID.find(_entityID);

		if (i != null)
		{
			this.m.SlavesID.remove(i);
			this.m.Slaves.remove(i);
		}

		if (this.m.SlavesID.len() == 0 && this.isAlive())
		{
			this.getContainer().getActor().setCharming(false);
		}
	}

	function isAlive()
	{
		return this.getContainer() != null && !this.getContainer().isNull() && this.getContainer().getActor() != null && this.getContainer().getActor().isAlive() && this.getContainer().getActor().getHitpoints() > 0;
	}

	function create()
	{
		this.mc_magic_skill.create();
		this.m.ID = "spells.charm";
		this.m.Name = "Charm";
		this.m.Description = "Simple mind control magic that can make affected foes fight for you. Its effect wears off quickly. Can also be used to capture small pet dog.";
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
		this.m.Order = this.Const.SkillOrder.UtilityTargeted + 1;
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
		this.m.IsIgnoreBlockTarget = true;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 8;
		this.m.MaxLevelDifference = 4;
		this.m.MaxRangeBonus = 2;
	}

	function getDescription()
	{
		return this.skill.getDescription();
	}
	
	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();

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
				icon = "ui/icons/hitchance.png",
				text = "Has [color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] chance to charm target that are next to you"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Temporarily [color=" + this.Const.UI.Color.PositiveValue + "]Charms[/color] a target"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can also be used to [color=" + this.Const.UI.Color.PositiveValue + "]Dispel[/color] charmed effect from a friendly target"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Chance is based on [color=" + this.Const.UI.Color.NegativeValue + "]Resolve[/color] points from both the caster and the target"
			}
		]);

		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local _target = _targetTile.getEntity();
		local skills = [
			"effects.fake_charmed_broken",
			"effects.charmed_captive",
		];

		foreach ( id in skills ) 
		{
		    if (_target.getSkills().hasSkill(id))
		    {
		    	return false;
		    }
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

		return true;
	}
	
	function onBeforeUse( _user , _targetTile )
	{
		if (!_user.getFlags().has("luft"))
		{
			return;
		}
		
		this.Tactical.spawnSpriteEffect("luft_charm_quote_" + this.Math.rand(1, 7), this.createColor("#ffffff"), _user.getTile(), this.Const.Tactical.Settings.SkillOverlayOffsetX, 145, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayStayDuration, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
	}

	function onUse( _user, _targetTile )
	{
		local tag = {
			User = _user,
			TargetTile = _targetTile
		};
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, this.onDelayedEffect.bindenv(this), tag);
		this.getContainer().update();
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
			local Chance = this.getHitchance(target);
			
			if (target.getSkills().hasSkill("effects.charmed") || target.getSkills().hasSkill("effects.legend_intensely_charmed"))
			{
				target.getSkills().removeByID("effects.charmed");
				target.getSkills().removeByID("effects.legend_intensely_charmed");
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " dispels charmed effect from " + this.Const.UI.getColorizedEntityName(target));
				
				return true;
			}

			if (roll > Chance)
			{
				if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " resists being charmed thanks to his resolve (Chance: " + Chance + ", Rolled: " + roll + ")");
				}
				
				target.getFlags().increment("charm_fail");

				return false;
			}

			if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " is charmed (Chance: " + Chance + ", Rolled: " + roll + ")");
			}

			if (this.Const.HexenCharmablePet.find(target.getType()) != null)
			{
				this.onCharmPet(_user, target);
				return;
			}
			
			if (target.getMoraleState() == this.Const.MoraleState.Fleeing)
			{
				target.setMoraleState(this.Const.MoraleState.Steady);
			}

			this.addSlave(target.getID());
			local charmed = this.new("scripts/skills/effects/charmed_effect");
			charmed.setMasterFaction(_user.getFaction() == this.Const.Faction.Player ? this.Const.Faction.PlayerAnimals : _user.getFaction());
			charmed.setMaster(self);
			charmed.isTheLastEnemy(this.Tactical.Entities.getHostilesNum() == 1);
			target.getSkills().add(charmed);
			charmed.m.TurnsLeft = _user.getSkills().hasSkill("perk.appearance_charm") ? this.Math.rand(1, 2) : 1;
			target.getFlags().set("charm_fail", 0);
			_user.setCharming(true);
		}.bindenv(this), this);
	}

	function onCharmPet( _user, _target ) 
	{
	    local type = _target.getType();
	    local script;

	    switch (type) 
	    {
        case this.Const.EntityType.ArmoredWardog:
            script = "armored_wardog_item";
            break;

        case this.Const.EntityType.Warhound:
            script = "warhound_item";
            break;

        case this.Const.EntityType.Wolf:
            script = "wolf_item";
            break;

        case this.Const.EntityType.LegendWhiteWarwolf:
            script = "legend_white_wolf_item";
            break;
    
        default:
        	script = "wardog_item";
	    }

	    local self = this;
	    local item = "scripts/items/accessory/" + script;
	    local effect = this.new("scripts/skills/effects/charmed_pet_effect");
	    effect.m.LootScript = item;
	    effect.m.Master = self;
	    _target.getSkills().add(effect);
		this.m.SlavesPet.push(effect);
		this.Const.HexenOrigin.Magic.SpawnCharmParticleEffect(_target.getTile());
	}

	function onDeath()
	{
		foreach( id in this.m.SlavesID )
		{
			local e = this.Tactical.getEntityByID(id);

			if (e != null)
			{
				e.getSkills().removeByID("effects.charmed");
			}
		}

		this.m.SlavesID = [];
	}

	function onUpdate( _properties )
	{
		if (this.m.SlavesID.len() == 0)
		{
			this.getContainer().getActor().setCharming(false);
		}
	}
	
	function onAfterUpdate( _properties )
	{
		local actor = this.getContainer().getActor().getSkills();
		
		if (actor.hasSkill("perk.fortified_mind"))
		{
			this.m.FatigueCostMult = this.Const.Combat.WeaponSpecFatigueMult;
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
		local properties = this.m.Container.buildPropertiesForUse(this, _targetEntity);
		local resolve = properties.Bravery * properties.BraveryMult;
		local res = properties.MoraleCheckBravery[1];
		local CasterPower = resolve + res;
		
		local bonus = this.getBonus() + this.Const.HexenOrigin.Magic.CountDebuff(_targetEntity) * 3 + _targetEntity.getTile().getDistanceTo(myTile) == 1 ? 5 : 0;
		bonus = bonus + _targetEntity.getFlags().getAsInt("charm_fail") * 5;
		local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(_user, this);
		local resist = (defenderProperties.getBravery() + defenderProperties.MoraleCheckBravery[1]) * defenderProperties.MoraleCheckBraveryMult[1] * (_targetEntity.getSkills().hasSkill("racial.champion") ? 1.25 : 1.0);
		local hpLeft = _targetEntity.getHitpointsPct();
		local toHit = CasterPower * defenderProperties.MoraleEffectMult * (2 - this.Math.max(0.4, hpLeft + 0.25)) - resist;
		
		if (resist >= 500)
		{
			return 0;
		}

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
		
		toHit = toHit + numAlliesAdjacent * this.Const.Morale.OpponentsAdjacentMult - numOpponentsAdjacent * 6;
		toHit = toHit + threatBonus;

		return this.Math.max(5, this.Math.min(95, toHit));
	}
	
	function getBonus()
	{
		local affected = [
			"perk.mastery_charm",
			"perk.boobas_charm",
			"perk.charm_nudist"
			"trait.seductive",
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
		local resist = this.Math.floor((defenderProperties.getBravery() + defenderProperties.MoraleCheckBravery[1]) * defenderProperties.MoraleCheckBraveryMult[1] * (_targetEntity.getSkills().hasSkill("racial.champion") ? 1.25 : 1.0));

		local attempts = _targetEntity.getFlags().getAsInt("charm_fail");

		if (defenderProperties.MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] >= 1000.0 || resist >= 500)
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

		if (this.Const.HexenCharmablePet.find(targetEntity.getType()) != null)
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

		if (attempts != 0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "Bonus from fail attempts: [color=" + this.Const.UI.Color.PositiveValue + "]" + attempts * 5 + "%[/color]"
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

		local debuff = this.Const.HexenOrigin.Magic.CountDebuff(_targetEntity);

		if (debuff != 0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "Debuff: [color=" + this.Const.UI.Color.PositiveValue + "]" + debuff * 3 + "%[/color]"
			});
		}

		local hpLeft = _targetEntity.getHitpointsPct();
		local modInjury = this.Math.max(0.4, hpLeft + 0.25);

		if (hpLeft >= 1.0)
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "Unharmed: [color=" + this.Const.UI.Color.NegativeValue + "]" + this.Math.floor(CasterPower * 0.25) + "%[/color]"
			});	
		}
		else if (modInjury >= 1)
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "Light injury: [color=" + this.Const.UI.Color.NegativeValue + "]" + this.Math.floor(CasterPower * (modInjury - 1)) + "%[/color]"
			});
		}
		else 
		{
		    ret.push({
				icon = "ui/tooltips/positive.png",
				text = "Severe injury: [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.floor(CasterPower * (1 - modInjury)) + "%[/color]"
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
				text = "Too close: [color=" + this.Const.UI.Color.PositiveValue + "]5%[/color]"
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
				local type = typeof slave;

				if (type != "integer")
				{
					slave.kill(this.getContainer().getActor(), null, this.Const.FatalityType.Suicide, true);
				}
			}
		}
		
		this.m.SlavesID = [];
		this.m.Slaves = [];
		this.m.SlavesPet = [];
	}

});

