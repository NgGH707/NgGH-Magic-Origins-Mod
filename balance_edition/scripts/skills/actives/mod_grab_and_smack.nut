this.mod_grab_and_smack <- this.inherit("scripts/skills/skill", {
	m = {
		Count = 3
	},
	
	function create()
	{
		this.m.ID = "actives.grab_and_smack";
		this.m.Name = "Grab \'n\' Smack";
		this.m.Description = "Grabs a target and smacks that target to the side 3 times, dealing consistent damage and may stun said target.";
		this.m.Icon = "skills/active_111_a.png";
		this.m.IconDisabled = "skills/active_111_a_sw.png";
		this.m.Overlay = "active_111_a";
		this.m.SoundOnUse = [
			"sounds/enemies/unhold_fling_01.wav",
			"sounds/enemies/unhold_fling_02.wav",
			"sounds/enemies/unhold_fling_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/unhold_fling_hit_01.wav",
			"sounds/enemies/unhold_fling_hit_02.wav",
			"sounds/enemies/unhold_fling_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 1;
		this.m.Delay = 250;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsShieldRelevant = false;
		this.m.IsShieldwallRelevant = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = true;
		this.m.DirectDamageMult = 0.6;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}
	
	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "Has [color=" + this.Const.UI.Color.PositiveValue + "]+15%[/color] chance to hit. "
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Stunned[/color] target can never escape your grab"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "A [color=" + this.Const.UI.Color.PositiveValue + "]3[/color] hits smacking combo"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Deals [color=" + this.Const.UI.Color.NegativeValue + "]Fall Damage[/color] depending on the [color=" + this.Const.UI.Color.NegativeValue + "]Height[/color]"
			}
		]);
		
		return ret;
	}
	
	function onTurnStart()
	{
		this.m.Count = 3;
	}

	function findTileToKnockBackTo( _userTile, _targetTile )
	{
		//local dir = _targetTile.getDirectionTo(_userTile);
		local availableTiles = [];

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_userTile.hasNextTile(i))
			{
			}
			else
			{
				local flingToTile = _userTile.getNextTile(i);

				if (flingToTile.IsEmpty && flingToTile.Level <= _userTile.Level)
				{
					availableTiles.push(flingToTile);
				}
			}
		}
		
		if (availableTiles.len() != 0)
		{
			return availableTiles[this.Math.rand(0, availableTiles.len() - 1)];
		}

		return null;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return this.skill.onVerifyTarget(_originTile, _targetTile) && !_targetTile.getEntity().getCurrentProperties().IsRooted && !_targetTile.getEntity().getCurrentProperties().IsImmuneToKnockBackAndGrab && this.findTileToKnockBackTo(_originTile, _targetTile) != null;
	}

	function onUse( _user, _targetTile )
	{
		if (this.Math.rand(1, 100) <= 10)
		{
			++this.m.Count;
		}

		if (_targetTile.getEntity().getCurrentProperties().IsImmuneToKnockBackAndGrab)
		{
			this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSwing);
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " can\'t grab " + this.Const.UI.getColorizedEntityName(target));
			return false;
		}

		this.getContainer().setBusy(true);
		local target = _targetTile.getEntity();
		local tag = {
			Skill = this,
			User = _user,
			TargetTile = _targetTile
		};

		local roll = this.Math.rand(1, 100);
		local hitChance = this.getHitchance(_targetTile.getEntity());
		
		if (roll > hitChance)
		{
			this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSwing);
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " fails to grab " + this.Const.UI.getColorizedEntityName(target) + " (Chance: " + hitChance + ", Rolled: " + roll + ")");
			return false;
		}
		
		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " grabs " + this.Const.UI.getColorizedEntityName(target) + " and starts to smacking around (Chance: " + hitChance + ", Rolled: " + roll + ")");

		if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
		{
			if (this.m.SoundOnUse.len() != 0)
			{
				this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill, _user.getPos());
			}

			this.Time.scheduleEvent(this.TimeUnit.Virtual, this.m.Delay, this.onPerformAttack.bindenv(this), tag);

			if (!_user.isPlayerControlled() && _targetTile.getEntity().isPlayerControlled())
			{
				_user.getTile().addVisibilityForFaction(this.Const.Faction.Player);
			}
		}
		else
		{
			this.onPerformAttack(tag);
		}

		return true;
	}
	
	function applyEffectToTarget( _user, _target, _targetTile )
	{
		if (_target.isNonCombatant() || _target.getCurrentProperties().IsImmuneToStun)
		{
			return;
		}

		switch (this.Math.rand(1, 10))
		{
		case 1:
			_target.getSkills().add(this.new("scripts/skills/effects/stunned_effect"));

			if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " has stunned " + this.Const.UI.getColorizedEntityName(_target) + " for one turn");
			}
			break;

		case 2:
			_target.getSkills().add(this.new("scripts/skills/effects/dazed_effect"));

			if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " has staggered " + this.Const.UI.getColorizedEntityName(_target) + " for one turn");
			}
			break;

		case 3:
			_target.getSkills().add(this.new("scripts/skills/effects/debilitated_effect"));

			if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " has debilitated " + this.Const.UI.getColorizedEntityName(_target) + " for one turn");
			}
			break;
		}
	}

	function onPerformAttack( _tag )
	{
		local _user = _tag.User;
		local _targetTile = _tag.TargetTile;
		local target = _targetTile.getEntity();
		local flingToTile = this.findTileToKnockBackTo(_user.getTile(), _targetTile);
		
		_tag.Skill.m.Count -= 1;

		if (flingToTile == null)
		{
			return false;
		}

		this.applyFatigueDamage(target, 10);

		if (!_user.isHiddenToPlayer() && (_targetTile.IsVisibleForPlayer || flingToTile.IsVisibleForPlayer))
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " flings back " + this.Const.UI.getColorizedEntityName(target));
		}

		local skills = target.getSkills();
		skills.removeByID("effects.shieldwall");
		skills.removeByID("effects.spearwall");
		skills.removeByID("effects.riposte");
		target.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
		local p = this.getContainer().buildPropertiesForUse(_tag.Skill, target);
		local damageDirect = this.Math.minf(1.0, p.DamageDirectMult * (_tag.Skill.m.DirectDamageMult + p.DamageDirectAdd));
		local damage = this.Math.max(0, this.Math.abs(flingToTile.Level - _targetTile.Level) - 1) * this.Const.Combat.FallingDamage + p.DamageRegularMax * p.MeleeDamageMult * p.DamageTotalMult;

		if (damage == 0)
		{
			this.Tactical.getNavigator().teleport(target, flingToTile, null, null, true);
		}
		else
		{
			local tag = {
				Skill = this,
				Container = this.getContainer(),
				User = _user,
				TargetTile = flingToTile,
				HitInfo = clone this.Const.Tactical.HitInfo
			};
			tag.HitInfo.DamageRegular = this.Math.max(20, damage) * p.DamageRegularMult;
			tag.HitInfo.DamageArmor = this.Math.max(20, damage) * p.DamageArmorMult;
			tag.HitInfo.DamageMinimum = p.DamageMinimum;
			tag.HitInfo.DamageFatigue = this.Const.Combat.FatigueReceivedPerHit * p.FatigueDealtPerHitMult;
			tag.HitInfo.DamageDirect = damageDirect;
			tag.HitInfo.BodyPart = this.Math.rand(0, 1);
			tag.HitInfo.BodyDamageMult = 1.0;
			tag.HitInfo.FatalityChanceMult = 1.0;
			tag.HitInfo.Injuries = tag.HitInfo.BodyPart == 0 ? this.Const.Injury.BluntBody : this.Const.Injury.BluntHead;
			tag.HitInfo.InjuryThresholdMult = 0.7;
	
			this.Tactical.getNavigator().teleport(target, flingToTile, this.onKnockedDown, tag, true);
		}
		
		return true;
	}

	function onFollowUp( _tag )
	{
		if (_tag.Skill.m.Count > 0 && _tag.Skill.onVerifyTarget(_tag.User.getTile(), _tag.TargetTile))
		{
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 150, _tag.Skill.onPerformAttack.bindenv(_tag.Skill), _tag);
		}
		else
		{
			_tag.Skill.getContainer().setBusy(false);
			_tag.Skill.m.Count = 3;
		}
	}

	function onKnockedDown( _entity, _tag )
	{
		if (_tag.Skill.m.SoundOnHit.len() != 0)
		{
			this.Sound.play(_tag.Skill.m.SoundOnHit[this.Math.rand(0, _tag.Skill.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, _entity.getPos());
		}
		
		_entity.onDamageReceived(_tag.User, _tag.Skill, _tag.HitInfo);
		
		if (typeof _tag.User == "instance" && _tag.User.isNull() || !_tag.User.isAlive() || _tag.User.isDying())
		{
			return;
		}
		
		_tag.Container.onTargetHit(_tag.Skill, _entity, _tag.HitInfo.BodyPart, _tag.HitInfo.DamageRegular, 0);
		
		if (_entity.isAlive() || !_entity.isDying())
		{
			_tag.Skill.applyEffectToTarget(_tag.User, _entity, _entity.getTile());

			if (this.Math.abs(_entity.getTile().Level - _tag.User.getTile().Level) <= 1)
			{
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 115, _tag.Skill.onFollowUp, _tag);
			}
		}
	}
	
	function getExpectedDamage( _target )
	{
		local ret = this.skill.getExpectedDamage(_target);
		ret.HitpointDamage = this.Math.max(10, ret.HitpointDamage);
		ret.TotalDamage = this.Math.max(10, ret.TotalDamage);
		return ret;
	}
	
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin = 25 + this.Math.max(1, _properties.DamageRegularMin / 3);
			_properties.DamageRegularMax = 25 + this.Math.max(1, _properties.DamageRegularMax / 3);
			_properties.DamageArmorMult = 1.0;
			_properties.DamageMinimum += 10;
			_properties.MeleeSkill += 15;
			
			this.m.IsUsingHitchance = true;
			
			if (_targetEntity == null)
			{
				return;
			}
			
			local targetStatus = _targetEntity.getSkills();
			local effects = [
				"effects.staggered",
				"effects.shellshocked",
				"effects.distracted",
				"effects.dazed",
				"effects.horrified",
				"effects.legend_dazed",
			];

			foreach (idx, id in effects) 
			{
			    if (targetStatus.hasSkill(id))
				{
					_properties.MeleeSkill += 10;
				}
			}
			
			this.m.IsUsingHitchance = !_targetEntity.getCurrentProperties().IsStunned;
		}
	}

});

