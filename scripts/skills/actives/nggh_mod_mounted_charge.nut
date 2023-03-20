this.nggh_mod_mounted_charge <- ::inherit("scripts/skills/skill", {
	m = {
		IsSpent = false,
		//IsCharging = false,
		//ChargeDis = 1,
	},
	function create()
	{
		this.m.ID = "actives.nggh_mounted_charge";
		this.m.Name = "Mounted Charge";
		this.m.Description = "Push your mount forward with speed, ending in an impact that staggers an enemy.";
		this.m.Icon = "skills/horse_charge.png";
		this.m.IconDisabled = "skills/horse_charge_bw.png";
		this.m.Overlay = "horse_charge";
		this.m.SoundOnUse = [];
		this.m.SoundOnHit = [
			"sounds/combat/knockback_hit_01.wav",
			"sounds/combat/knockback_hit_02.wav",
			"sounds/combat/knockback_hit_03.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 15;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

	function getActionPointCost()
	{
		return 0;
	}

	function getFatigueCost()
	{
		if (this.getContainer() != null && this.getContainer().getActor().getCurrentProperties().FatigueEffectMult <= 0.0)
		{
			return 0;
		}

		return this.m.FatigueCost;
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Improves your next mounted charge attack within this round"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Mounted charge attack may knock back, stagger or daze on hit"
			},
		]);

		local actor = this.getContainer().getActor();

		if (actor.getCurrentProperties().IsRooted)
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can not be used while rooted[/color]"
			});
		}

		if (actor.isArmedWithRangedWeapon())
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]You are using a ranged weapon[/color]"
			});
		}

		if (::Tactical.isActive() && actor.getTile().hasZoneOfControlOtherThan(actor.getAlliedFactions()))
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can not be used while engaging in melee[/color]"
			});
		}

		return ret;
	}

	function isHidden()
    {
        return !this.getContainer().getActor().isMounted();
    }

    function isUsable()
	{
		if (!::Tactical.isActive())
		{
			return false;
		}

		local actor = this.getContainer().getActor();

		if (actor.getCurrentProperties().IsRooted || actor.isArmedWithRangedWeapon())
		{
			return false;
		}

		if (this.m.IsSpent)
		{
			return false;
		}

		if (actor.getTile().hasZoneOfControlOtherThan(actor.getAlliedFactions()))
		{
			return false;
		}

		return this.skill.isUsable();
	}

	function onTurnStart()
	{
		this.m.IsSpent = false;
	}

	function onMovementFinished( _tile )
	{
		this.m.IsSpent = true;
	}

	function onUse( _user, _targetTile )
	{
		this.m.IsSpent = true;
		local charge = this.getContainer().getSkillByID("special.nggh_mounted_charge");

		if (charge == null)
		{
			return false;
		}

		charge.setImproveChargeEffect();
		return true;
	}

	/*function findTileToKnockBackTo( _userTile, _targetTile )
	{
		local dir = _userTile.getDirectionTo(_targetTile);

		if (_targetTile.hasNextTile(dir))
		{
			local knockToTile = _targetTile.getNextTile(dir);

			if (knockToTile.IsEmpty && this.Math.abs(knockToTile.Level - _userTile.Level) <= 1)
			{
				return knockToTile;
			}
		}

		local altdir = dir - 1 >= 0 ? dir - 1 : 5;

		if (_targetTile.hasNextTile(altdir))
		{
			local knockToTile = _targetTile.getNextTile(altdir);

			if (knockToTile.IsEmpty && this.Math.abs(knockToTile.Level - _userTile.Level) <= 1)
			{
				return knockToTile;
			}
		}

		altdir = dir + 1 <= 5 ? dir + 1 : 0;

		if (_targetTile.hasNextTile(altdir))
		{
			local knockToTile = _targetTile.getNextTile(altdir);

			if (knockToTile.IsEmpty && this.Math.abs(knockToTile.Level - _userTile.Level) <= 1)
			{
				return knockToTile;
			}
		}

		return null;
	}*/

	function onVerifyTarget( _originTile, _targetTile )
	{
		return true;

		/*if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (_originTile.getDistanceTo(_targetTile) < this.m.MinRange)
		{
			return false;
		}

		local actor = this.getContainer().getActor();
		local myTile = actor.getTile();

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _targetTile.getNextTile(i);

				if (tile.IsEmpty && tile.getDistanceTo(myTile) < this.m.MaxRange && tile.getDistanceTo(myTile) >= 1 && this.Math.abs(myTile.Level - tile.Level) <= 1 && this.Math.abs(_targetTile.Level - tile.Level) <= 1)
				{
					return true;
				}
			}
		}

		return false;*/
	}

	/*function onUse( _user, _targetTile )
	{
		local myTile = _user.getTile();
		local tiles = [];
		local destTile;

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _targetTile.getNextTile(i);

				if (tile.IsEmpty && tile.getDistanceTo(myTile) < this.m.MaxRange && tile.getDistanceTo(myTile) >= 1 && this.Math.abs(myTile.Level - tile.Level) <= 1 && this.Math.abs(_targetTile.Level - tile.Level) <= 1)
				{
					tiles.push({
						T = tile,
						Dis = tile.getDistanceTo(myTile),
					});
				}
			}
		}

		if (tiles.len() != 0)
		{
			tiles.sort(sortAscendingByDistance);
			destTile = tiles[0].T;
		}

		if (destTile == null)
		{
			return false;
		}

		local s = _user.m.Sound[this.Const.Sound.ActorEvent.Move]

		if (s.len() != 0)
		{
			this.Sound.play(s[this.Math.rand(0, s.len() - 1)], this.Const.Sound.Volume.Skill, _user.getPos());
		}

		this.getContainer().setBusy(true);
		local tag = {
			Skill = this,
			User = _user,
			OldTile = _user.getTile(),
			TargetTile = _targetTile,
		};

		_user.spawnTerrainDropdownEffect(myTile);
		_user.setCurrentMovementType(this.Const.Tactical.MovementType.Default);
		this.Tactical.getNavigator().teleport(_user, destTile, this.onTeleportDone.bindenv(this), tag, false, 3.0);
		return true;
	}

	function onTeleportDone( _entity, _tag )
	{
		local myTile = _entity.getTile();
		local ZOC = [];
		this.getContainer().setBusy(false);

		for( local i = 0; i != 6; i = ++i )
		{
			if (!myTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = myTile.getNextTile(i);

				if (!tile.IsOccupiedByActor)
				{
				}
				else
				{
					local actor = tile.getEntity();

					if (actor.isAlliedWith(_entity) || actor.getCurrentProperties().IsStunned)
					{
					}
					else
					{
						ZOC.push(actor);
					}
				}
			}
		}

		foreach( actor in ZOC )
		{
			if (!actor.onMovementInZoneOfControl(_entity, true))
			{
				continue;
			}

			if (actor.onAttackOfOpportunity(_entity, true))
			{
				if (!_entity.isAlive() || _entity.isDying())
				{
					return;
				}
			}
		}

		_tag.Skill.m.IsCharging = true;
		_tag.Skill.m.ChargeDis = _tag.OldTile.getDistanceTo(_tag.TargetTile);
		local skill = _tag.Skill.getContainer().getAttackOfOpportunity();
		local target = _tag.TargetTile.getEntity();

		if (skill != null)
		{
			skill.useForFree(_tag.TargetTile);
		}

		_tag.Skill.onFinishCharging();

		if (!target.isAlive() || target.isDying())
		{
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 250, _tag.Skill.onFollow, _tag);
		}
		else
		{
			target.getSkills().add(this.new("scripts/skills/effects/staggered_effect"));

			if (!_tag.User.isHiddenToPlayer() && _tag.TargetTile.IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " is staggered for one turn");
			}

			local knockToTile = _tag.Skill.findTileToKnockBackTo(myTile, _tag.TargetTile);

			if (knockToTile == null)
			{
				return;
			}

			_tag.Skill.applyFatigueDamage(target, 10);

			if (target.getCurrentProperties().IsImmuneToKnockBackAndGrab || target.getCurrentProperties().IsRooted)
			{
				return;
			}

			if (!_tag.User.isHiddenToPlayer() && (_tag.TargetTile.IsVisibleForPlayer || knockToTile.IsVisibleForPlayer))
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_tag.User) + " pushes through " + this.Const.UI.getColorizedEntityName(target));
			}

			local skills = target.getSkills();
			skills.removeByID("effects.shieldwall");
			skills.removeByID("effects.spearwall");
			skills.removeByID("effects.riposte");

			if (_tag.Skill.m.SoundOnHit.len() != 0)
			{
				this.Sound.play(_tag.Skill.m.SoundOnHit[this.Math.rand(0, _tag.Skill.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, _tag.User.getPos());
			}

			target.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
			local damage = this.Math.max(0, this.Math.abs(knockToTile.Level - _tag.TargetTile.Level) - 1) * this.Const.Combat.FallingDamage;

			if (damage == 0)
			{
				this.Tactical.getNavigator().teleport(target, knockToTile, null, null, true);
			}
			else 
			{
				local tag = {
					Attacker = _tag.User,
					Skill = _tag.Skill,
					HitInfo = clone this.Const.Tactical.HitInfo
				};
				tag.HitInfo.DamageRegular = damage;
				tag.HitInfo.DamageFatigue = this.Const.Combat.FatigueReceivedPerHit;
				tag.HitInfo.DamageDirect = 1.0;
				tag.HitInfo.BodyPart = this.Const.BodyPart.Body;
				tag.HitInfo.BodyDamageMult = 1.0;
				tag.HitInfo.FatalityChanceMult = 1.5;
				this.Tactical.getNavigator().teleport(target, knockToTile, _tag.Skill.onKnockedDown, tag, true);
			}

			this.Time.scheduleEvent(this.TimeUnit.Virtual, 250, _tag.Skill.onFollow, _tag);
		}
	}

	function onFollow( _tag )
	{
		if (_tag.TargetTile.IsEmpty)
		{
			_tag.User.setCurrentMovementType(this.Const.Tactical.MovementType.Default);
			this.Tactical.getNavigator().teleport(_tag.User, _tag.TargetTile, null, null, false);
		}
	}

	function onKnockedDown( _entity, _tag )
	{
		if (_tag.HitInfo.DamageRegular != 0)
		{
			_entity.onDamageReceived(_tag.Attacker, _tag.Skill, _tag.HitInfo);
		}
	}

	function getHitchance( _targetEntity )
	{
		if (!_targetEntity.isAttackable())
		{
			return 0;
		}

		return 95;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (this.m.IsCharging)
		{
			_properties.MeleeSkill += 999;

			if (this.m.ChargeDis >= 1)
			{
				_properties.MeleeDamageMult *= 1.0 + this.m.ChargeDis * 0.25;
				_properties.DamageDirectMult *= 1.0 + this.m.ChargeDis * 0.025;
			}
		}
	}

	function onFinishCharging()
	{
		this.m.IsCharging = false;
		this.m.ChargeDis = 0;
	}

	function sortAscendingByDistance( _a, _b )
	{
	    if (_a.Dis < _b.Dis)
	    {
	        return -1;
	    }
	    else if (_a.Dis > _b.Dis)
	    {
	        return 1;
	    }

	    return 0;
	}*/

});

