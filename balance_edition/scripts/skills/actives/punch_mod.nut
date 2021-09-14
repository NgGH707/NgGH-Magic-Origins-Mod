this.punch_mod <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.mega_punch";
		this.m.Name = "Rocky Punch";
		this.m.Description = "Deliberately hit an hard with your huge rock hard hand, dealing massive damamge. Do not even think about blocking this with a shield.";
		this.m.Icon = "skills/active_194.png";
		this.m.IconDisabled = "skills/active_194_sw.png";
		this.m.Overlay = "active_194";
		this.m.KilledString = "Smashed";
		this.m.SoundOnHit = [
			"sounds/enemies/dlc6/sand_golem_headbutt_hit_01.wav",
			"sounds/enemies/dlc6/sand_golem_headbutt_hit_02.wav",
			"sounds/enemies/dlc6/sand_golem_headbutt_hit_03.wav",
			"sounds/enemies/dlc6/sand_golem_headbutt_hit_04.wav"
		];
		this.m.SoundOnMiss = [
			"sounds/enemies/dlc6/sand_golem_headbutt_miss_01.wav",
			"sounds/enemies/dlc6/sand_golem_headbutt_miss_02.wav",
			"sounds/enemies/dlc6/sand_golem_headbutt_miss_03.wav",
			"sounds/enemies/dlc6/sand_golem_headbutt_miss_04.wav"
		];
		this.m.SoundOnHitDelay = 0;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.Delay = 0;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsShieldRelevant = false;
		this.m.IsShieldwallRelevant = false;
		this.m.IsAttack = true;
		this.m.IsRanged = false;
		this.m.IsIgnoredAsAOO = false;
		this.m.IsShowingProjectile = true;
		this.m.IsDoingForwardMove = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.DirectDamageMult = 0.4;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.MaxLevelDifference = 1;
		this.m.ChanceSmash = 100;
	}
	
	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "Has [color=" + this.Const.UI.Color.PositiveValue + "]+5%[/color] chance to hit. [color=" + this.Const.UI.Color.NegativeValue + "]Stunned[/color], [color=" + this.Const.UI.Color.NegativeValue + "]Dazed[/color], [color=" + this.Const.UI.Color.NegativeValue + "]Staggered[/color] or [color=" + this.Const.UI.Color.NegativeValue + "]Distracted[/color] target will give you [color=" + this.Const.UI.Color.PositiveValue + "]+5%[/color] more chance to hit that target"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Ignores the bonus to Melee Defense granted by shields"
			}
		]);
		
		return ret;
	}
	
	function findTileToKnockBackTo( _userTile, _targetTile )
	{
		local dir = _userTile.getDirectionTo(_targetTile);

		if (_targetTile.hasNextTile(dir))
		{
			local knockToTile = _targetTile.getNextTile(dir);

			if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= 1)
			{
				return knockToTile;
			}
		}

		local altdir = dir - 1 >= 0 ? dir - 1 : 5;

		if (_targetTile.hasNextTile(altdir))
		{
			local knockToTile = _targetTile.getNextTile(altdir);

			if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= 1)
			{
				return knockToTile;
			}
		}

		altdir = dir + 1 <= 5 ? dir + 1 : 0;

		if (_targetTile.hasNextTile(altdir))
		{
			local knockToTile = _targetTile.getNextTile(altdir);

			if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= 1)
			{
				return knockToTile;
			}
		}

		return null;
	}
	
	function onUse( _user, _targetTile )
	{
		local tag = {
			Skill = this,
			User = _user,
			TargetTile = _targetTile
		};

		if ((!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer) && this.Tactical.TurnSequenceBar.getActiveEntity().getID() == this.getContainer().getActor().getID())
		{
			this.getContainer().setBusy(true);
			local d = _user.getTile().getDirectionTo(_targetTile) + 3;
			d = d > 5 ? d - 6 : d;

			if (_user.getTile().hasNextTile(d))
			{
				this.Tactical.getShaker().shake(_user, _user.getTile().getNextTile(d), 6);
			}

			this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, this.onPerformAttack.bindenv(this), tag);
			return true;
		}
		else
		{
			this.getContainer().setBusy(true);
			return this.onPerformAttack(tag);
		}
	}

	function onPerformAttack( _tag )
	{
		local _targetTile = _tag.TargetTile;
		local _user = _tag.User;
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSwing);
		local ret = false;
		local ownTile = _user.getTile();
		local dir = ownTile.getDirectionTo(_targetTile);
		ret = this.attackEntity(_user, _targetTile.getEntity());

		if (!_user.isAlive() || _user.isDying())
		{
			return ret;
		}

		if (ret && _targetTile.IsOccupiedByActor && _targetTile.getEntity().isAlive() && !_targetTile.getEntity().isDying())
		{
			this.applyEffectToTarget(_user, _targetTile.getEntity(), _targetTile);
		}

		_tag.Skill.getContainer().setBusy(false);
		return ret;
	}
	
	function applyEffectToTarget( _user, _target, _targetTile )
	{
		if (_target.isNonCombatant())
		{
			return;
		}

		if (_target.getCurrentProperties().IsImmuneToKnockBackAndGrab && !_target.getCurrentProperties().IsRooted)
		{
			local knockToTile = this.findTileToKnockBackTo(_user.getTile(), _targetTile);

			if (knockToTile == null)
			{
				return;
			}

			if (!_user.isHiddenToPlayer() && (_targetTile.IsVisibleForPlayer || knockToTile.IsVisibleForPlayer))
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " has knocked back " + this.Const.UI.getColorizedEntityName(_target));
			}

			local skills = _target.getSkills();
			skills.removeByID("effects.shieldwall");
			skills.removeByID("effects.spearwall");
			skills.removeByID("effects.riposte");
			_target.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
			local damage = this.Math.max(0, this.Math.abs(knockToTile.Level - _targetTile.Level) - 1) * this.Const.Combat.FallingDamage + 10;

			if (damage == 0)
			{
				this.Tactical.getNavigator().teleport(_target, knockToTile, null, null, true);
			}
			else
			{
				local p = this.getContainer().getActor().getCurrentProperties();
				local tag = {
					Attacker = _user,
					Skill = this,
					HitInfo = clone this.Const.Tactical.HitInfo
				};
				tag.HitInfo.DamageRegular = damage;
				tag.HitInfo.DamageDirect = 1.0;
				tag.HitInfo.BodyPart = this.Const.BodyPart.Body;
				tag.HitInfo.BodyDamageMult = 1.0;
				tag.HitInfo.FatalityChanceMult = 1.0;
				this.Tactical.getNavigator().teleport(_target, knockToTile, this.onKnockedDown, tag, true);
			}
		}
	}
	
	function onKnockedDown( _entity, _tag )
	{
		if (_tag.HitInfo.DamageRegular != 0)
		{
			_entity.onDamageReceived(_tag.Attacker, _tag.Skill, _tag.HitInfo);
		}
	}
	
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin += 105;
			_properties.DamageRegularMax += 135;
			_properties.DamageArmorMult *= 0.75;
			_properties.MeleeSkill += 5;
			
			if (_targetEntity == null)
			{
				return;
			}
			
			local targetStatus = _targetEntity.getSkills();
			
			if (targetStatus.hasSkill("effects.staggered") || targetStatus.hasSkill("effects.shellshocked") || targetStatus.hasSkill("effects.distracted") || targetStatus.hasSkill("effects.dazed") || targetStatus.hasSkill("effects.stunned") || targetStatus.hasSkill("effects.sleeping"))
			{
				_properties.MeleeSkill += 5;
			}
		}
	}

});

