this.getroottable().HexenHooks.hookSkills <- function ()
{
	if (::mods_getRegisteredMod("mod_AC") != null)
	{
		::mods_hookExactClass("companions/onequip/companions_leash", function(obj) 
		{
			obj.onUse <- function(_user, _targetTile)
			{
				local entity = _targetTile.getEntity();

				if (this.isKindOf(entity, "companions_noodle") && entity.m.Tail != null && !entity.m.Tail.isNull() && entity.m.Tail.isAlive())
				{
					entity.m.Tail.removeFromMap();
				}

				if (_user.getFlags().has("can_mount") && _user.getFlags().has("goblin"))
				{
					_user.m.Mount.onLeashMount();
					this.getContainer().update();
				}

				this.m.Item.m.Wounds = this.Math.floor((1.0 - entity.getHitpointsPct()) * 100.0);
				entity.removeFromMap();
				this.m.Item.setEntity(null);
				this.m.IsHidden = !this.m.Item.isUnleashed();
				return true;
			}
		});

		::mods_hookExactClass("companions/onequip/companions_unleash", function(obj) 
		{
			local onUse = ::mods_getMember(obj, "onUse");
			obj.onUse = function(_user, _targetTile)
			{
				local ret = onUse(_user, _targetTile);

				if (ret && ("isMounted" in _user.get()))
				{
					_user.m.Mount.onDismountPet();
				}

				return ret;
			}
		});
	}

	local dismount_skills = [
		"unleash_wardog",
		"unleash_wolf",
		"legend_unleash_white_wolf",
		"legend_unleash_warbear"
	];

	foreach ( active in dismount_skills )
	{
		::mods_hookExactClass("skills/actives/" + active, function(obj) 
		{
			local onUse = ::mods_getMember(obj, "onUse");
			obj.onUse = function(_user, _targetTile)
			{
				local ret = onUse(_user, _targetTile);

				if (ret && ("isMounted" in _user.get()))
				{
					_user.m.Mount.onDismountPet();
				}

				return ret;
			}
		});
	}

	::mods_hookExactClass("skills/actives/kraken_ensnare_skill", function(obj) 
	{
		obj.onVerifyTarget = function( _originTile, _targetTile )
		{
			if (!this.skill.onVerifyTarget(_originTile, _targetTile))
			{
				return false;
			}

			if (_targetTile.getEntity().getCurrentProperties().IsRooted || _targetTile.getEntity().getCurrentProperties().IsImmuneToRoot)
			{
				return false;
			}

			if (_targetTile.getEntity().getFlags().has("kraken_tentacle"))
			{
				return false;
			}

			return true;
		}
	});

	//Make huge and small trait to affect spider size
	::mods_hookExactClass("skills/traits/huge_trait", function(obj) 
	{
	    obj.onAdded <- function()
	    {
	       if (this.isKindOf(this.getContainer().getActor().get(), "spider_player") && this.getContainer().getActor().getSize() < 0.9)
			{
				this.getContainer().getActor().setSize(0.9);
			}
	    }
	});
	::mods_hookExactClass("skills/traits/tiny_trait", function(obj) 
	{
	  	obj.onAdded <- function()
	    {
	       if (this.isKindOf(this.getContainer().getActor().get(), "spider_player") && this.getContainer().getActor().getSize() > 0.65)
			{
				this.getContainer().getActor().setSize(0.65);
			}
	    }
	});
	::mods_hookNewObject("skills/traits/seductive_trait", function ( obj )
	{
		obj.m.Bonus <- 5;
		obj.getBonus <- function()
		{
			return this.m.Bonus;
		};
		local tooltip = obj.getTooltip;
		obj.getTooltip = function()
		{
			local ret = tooltip();

			if (this.getContainer().hasSkill("spells.charm"))
			{
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/health.png",
					text = "Increases chance to charm a target by [color=" + this.Const.UI.Color.PositiveValue + "]+5%[/color]"
				});
			}

			return ret;
		};
	});

	//Disallow the use of footwork while mounting
	::mods_hookExactClass("skills/actives/footwork", function(obj) 
	{
	    obj.isHidden <- function()
	    {
	        local skill = this.getContainer().getSkillByID("special.goblin_rider");

	        if (skill != null)
	        {
	        	return skill.isMounted();
	        }

	        return this.m.IsHidden;
	    }
	});

	//A slight buff for goblin balls
	::mods_hookNewObject("skills/actives/throw_balls", function ( obj )
	{
		obj.onTargetHit = function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
		{
			if (_skill != this && _targetEntity.isAlive() && this.Math.rand(1, 100) <= 33)
			{
				_targetEntity.getSkills().add(this.new("scripts/skills/effects/staggered_effect"));
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.m.Container.getActor()) + " has staggered " + this.Const.UI.getColorizedEntityName(_targetEntity) + " for one turn");
			}
		}
	});

	//Change to work with mounting system of goblin
	::mods_hookExactClass("skills/perks/perk_horse_liberty", function(obj) 
	{
	    obj.onUpdate <- function( _properties )
	    {
	        if (this.getContainer().getActor().isMounted())
	        {
	        	_properties.MovementFatigueCostMult *= 0.75;
	        	_properties.BraveryMult *= 1.25;
	        }
	    }
	});

	//Add the general properties a ghost should have
	::mods_hookExactClass("skills/racial/ghost_racial", function(obj) 
	{
	    obj.onUpdate <- function( _properties )
	    {
	    	_properties.IsImmuneToZoneOfControl = true;
	    	_properties.IsImmuneToBleeding = true;
			_properties.IsImmuneToPoison = true;
			_properties.IsImmuneToKnockBackAndGrab = true;
			_properties.IsImmuneToStun = true;
			_properties.IsImmuneToRoot = true;
			_properties.IsImmuneToDisarm = true;
			_properties.IsIgnoringArmorOnAttack = true;
			_properties.IsAffectedByRain = false;
			_properties.IsAffectedByNight = false;
			_properties.IsAffectedByInjuries = false;
			_properties.IsMovable = false;
			_properties.MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] *= 1000.0;
	    }
	});

	//Allow all humans or atleast intelligent enough creatures to use siege weapon
	::mods_hookExactClass("skills/special/double_grip", function(obj) 
	{
	    obj.onAdded <- function()
	    {
	        this.getContainer().add(this.new("scripts/skills/actives/manning_siege_weapon_skill"));
	    }
	});

	//Allow all none-mindless ai to wake up their allies
	::mods_hookNewObject("skills/special/morale_check", function (obj)
	{
		obj.onAdded <- function()
		{
			local AI = this.getContainer().getActor().getAIAgent();

			if (AI.getID() != this.Const.AI.Agent.ID.Player)
			{
				AI.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_wake_up_ally"));
			}
		}
	});

	//fix non-human has human body sprite
	::mods_hookNewObject("skills/traits/fat_trait", function ( obj )
	{
		local oldFunction = obj.onAdded;
		obj.onAdded <- function()
		{
			if (!this.getContainer().getActor().getFlags().has("human"))
			{
				return;
			}
			
			oldFunction();
		}
	});

	//Fixed issue with morale change when you has a character with unbreakable morale
	::mods_hookNewObject("skills/traits/gift_of_people_trait", function (obj)
	{
		obj.onCombatStarted = function()
		{
			this.skill.onCombatStarted();

			if (this.Math.rand(1, 10) < 10)
			{
				return;
			}

			local allies = this.Tactical.Entities.getInstancesOfFaction(this.getContainer().getActor().getFaction());
			local ownID = this.getContainer().getActor().getID();

			foreach( ally in allies )
			{
				if (ally.getID() == ownID)
				{
					continue;
				}

				local ally_morale = ally.getMoraleState();

				if (ally_morale == this.Const.MoraleState.Ignore)
				{
					continue;
				}

				if (ally_morale < this.Const.MoraleState.Confident)
				{
					ally.setMoraleState(ally_morale + 1);
				}
			}
		}
	});

	//Fixed issue with morale change when you has a character with unbreakable morale
	::mods_hookNewObject("skills/traits/double_tongued_trait", function (obj)
	{
		obj.onCombatStarted = function()
		{
			this.skill.onCombatStarted();

			if (this.Math.rand(1, 10) < 10)
			{
				return;
			}

			local allies = this.Tactical.Entities.getInstancesOfFaction(this.getContainer().getActor().getFaction());
			local ownID = this.getContainer().getActor().getID();

			foreach( ally in allies )
			{
				if (ally.getID() == ownID)
				{
					continue;
				}

				local ally_morale = ally.getMoraleState();

				if (ally_morale == this.Const.MoraleState.Ignore)
				{
					continue;
				}

				if (ally_morale > this.Const.MoraleState.Fleeing)
				{
					ally.setMoraleState(ally_morale - 1);
				}
			}
		}
	});

	//Fix tooltip bug when character has properties.AdditionalActionPointCost
	::mods_hookBaseClass("skills/skill", function (obj)
	{
		obj = obj[obj.SuperName];
		obj.getActionPointCost <- function()
		{
			if (this.m.Container.getActor().getCurrentProperties().IsSkillUseFree)
			{
				return 0;
			}
			else if (this.m.Container.getActor().getCurrentProperties().IsSkillUseHalfCost)
			{
				return this.Math.max(1, this.Math.floor(this.m.ActionPointCost / 2));
			}
			else if (( "IsRestrained" in this.m ) && this.m.IsRestrained)
			{
				return 0;
			}
			else
			{
				return this.m.ActionPointCost + this.m.Container.getActor().getCurrentProperties().AdditionalActionPointCost;
			}
		}
		
		obj.isAffordable <- function()
		{
			return this.getActionPointCost() <= this.m.Container.getActor().getActionPoints() && this.getFatigueCost() + this.m.Container.getActor().getFatigue() <= this.m.Container.getActor().getFatigueMax();
		}
		
		obj.use <- function( _targetTile, _forFree = false )
		{
			if (!_forFree && !this.isAffordable() || !this.isUsable())
			{
				return false;
			}

			local user = this.m.Container.getActor();

			if (!_forFree)
			{
				this.logDebug(user.getName() + " uses skill " + this.getName());
			}

			if (this.isTargeted())
			{
				if (this.m.IsVisibleTileNeeded && !_targetTile.IsVisibleForEntity)
				{
					return false;
				}

				if (!this.onVerifyTarget(user.getTile(), _targetTile))
				{
					return false;
				}

				local d = user.getTile().getDistanceTo(_targetTile);
				local levelDifference = user.getTile().Level - _targetTile.Level;

				if (d < this.m.MinRange || !this.m.IsRanged && d > this.getMaxRange())
				{
					return false;
				}

				if (this.m.IsRanged && d > this.getMaxRange() + this.Math.min(this.m.MaxRangeBonus, this.Math.max(0, levelDifference)))
				{
					return false;
				}
			}

			this.onBeforeUse(user, _targetTile);

			if (!_forFree)
			{
				++this.Const.SkillCounter;
			}

			if ((this.m.IsAudibleWhenHidden || user.getTile().IsVisibleForPlayer) && this.m.SoundOnUse.len() != 0)
			{
				if (!this.m.IsUsingActorPitch)
				{
					this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, user.getPos());
				}
				else
				{
					this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, user.getPos(), user.getSoundPitch());
				}

				if (this.m.IsAttack)
				{
					user.playAttackSound();
				}
			}

			this.spawnOverlay(user, _targetTile);

			if (!_forFree)
			{
				user.setActionPoints(user.getActionPoints() - this.getActionPointCost());
				user.setFatigue(user.getFatigue() + this.getFatigueCost());
			}

			if (this.m.Item != null && !this.m.Item.isNull())
			{
				this.m.Item.onUse(this);
			}

			user.setPreviewSkillID("");
			return this.onUse(user, _targetTile);
		}
	});

	delete this.HexenHooks.hookSkills;
}