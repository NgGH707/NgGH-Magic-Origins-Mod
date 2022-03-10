this.getroottable().Nggh_MagicConcept.hookSkills <- function ()
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

				if ("isMounted" in _user.get())
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


	//
	::mods_hookBaseClass("skills/injury_permanent/permanent_injury", function (obj)
	{
		obj = obj[obj.SuperName];
		local ws_onAdded = obj.onAdded;
		obj.onAdded = function()
		{
			if (!this.getContainer().getActor().getFlags().has("human"))
			{
				return;
			}

			ws_onAdded();
		};
		local ws_showInjury = obj.showInjury;
		obj.showInjury = function()
		{
			if (!this.getContainer().getActor().getFlags().has("human"))
			{
				return;
			}

			ws_showInjury();
		};
		local ws_onCombatFinished = obj.onCombatFinished;
		obj.onCombatFinished = function()
		{
			if (!this.getContainer().getActor().getFlags().has("human"))
			{
				return;
			}

			ws_onCombatFinished();
		};
	});


	//
	::mods_hookBaseClass("skills/injury/injury", function (obj)
	{
		obj = obj[obj.SuperName];
		local ws_showInjury = obj.showInjury;
		obj.showInjury = function()
		{
			if (!this.getContainer().getActor().getFlags().has("human"))
			{
				return;
			}

			ws_showInjury();
		};
	});
	

	//Fix tooltip bug when character has properties.AdditionalActionPointCost
	::mods_hookBaseClass("skills/skill", function (obj)
	{
		obj = obj[obj.SuperName];
		obj.getActionPointCost <- function()
		{
			local actor = this.getContainer().getActor();

			if (actor.getCurrentProperties().IsSkillUseFree)
			{
				return 0;
			}
			else if (actor.getCurrentProperties().IsSkillUseHalfCost)
			{
				return this.Math.max(1, this.Math.floor(this.m.ActionPointCost / 2));
			}
			else if (( "IsRestrained" in this.m ) && this.m.IsRestrained)
			{
				return 0;
			}
			else
			{
				return this.Math.max(0, this.m.ActionPointCost + actor.getCurrentProperties().AdditionalActionPointCost);
			}
		}
		
		obj.isAffordable <- function()
		{
			return this.getActionPointCost() <= this.getContainer().getActor().getActionPoints() && this.getFatigueCost() + this.m.Container.getActor().getFatigue() <= this.m.Container.getActor().getFatigueMax();
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

	delete this.Nggh_MagicConcept.hookSkills;
}