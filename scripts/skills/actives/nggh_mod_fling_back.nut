this.nggh_mod_fling_back <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.fling_back";
		this.m.Name = "Fling Back";
		this.m.Description = "Grab a target and throw to a side in order to move forward, deal fall damage to said target.";
		this.m.Icon = "skills/active_111.png";
		this.m.IconDisabled = "skills/active_111_sw.png";
		this.m.Overlay = "active_111";
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
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted + 1;
		this.m.Delay = 250;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}
	
	function getTooltip()
	{
		local p = this.getContainer().getActor().getCurrentProperties();
		local ret = this.getDefaultUtilityTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]Throws[/color] away an enemy and [color=" + ::Const.UI.Color.PositiveValue + "]Steps Forward[/color]"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Deal [color=" + ::Const.UI.Color.NegativeValue + "]Fall Damage[/color] depending on the [color=" + ::Const.UI.Color.NegativeValue + "]Height[/color]"
			}
		]);
		
		return ret;
	}

	function findTileToKnockBackTo( _userTile, _targetTile )
	{
		local dir = _targetTile.getDirectionTo(_userTile);

		if (_userTile.hasNextTile(dir))
		{
			local flingToTile = _userTile.getNextTile(dir);

			if (flingToTile.IsEmpty && ::Math.abs(flingToTile.Level - _userTile.Level) <= 1)
			{
				return flingToTile;
			}
		}

		local altdir = dir - 1 >= 0 ? dir - 1 : 5;

		if (_userTile.hasNextTile(altdir))
		{
			local flingToTile = _userTile.getNextTile(altdir);

			if (flingToTile.IsEmpty && ::Math.abs(flingToTile.Level - _userTile.Level) <= 1)
			{
				return flingToTile;
			}
		}

		altdir = dir + 1 <= 5 ? dir + 1 : 0;

		if (_userTile.hasNextTile(altdir))
		{
			local flingToTile = _userTile.getNextTile(altdir);

			if (flingToTile.IsEmpty && ::Math.abs(flingToTile.Level - _userTile.Level) <= 1)
			{
				return flingToTile;
			}
		}

		return null;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return this.skill.onVerifyTarget(_originTile, _targetTile) && !_targetTile.getEntity().getCurrentProperties().IsRooted && !_targetTile.getEntity().getCurrentProperties().IsImmuneToKnockBackAndGrab && this.findTileToKnockBackTo(_originTile, _targetTile) != null;
	}

	function onUse( _user, _targetTile )
	{
		this.getContainer().setBusy(true);
		local tag = {
			Skill = this,
			User = _user,
			TargetTile = _targetTile
		};

		if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
		{
			if (this.m.SoundOnUse.len() != 0)
			{
				::Sound.play(::MSU.Array.rand(this.m.SoundOnUse), ::Const.Sound.Volume.Skill, _user.getPos());
			}

			::Time.scheduleEvent(::TimeUnit.Virtual, this.m.Delay, this.onPerformAttack.bindenv(this), tag);

			if (!_user.isPlayerControlled() && _targetTile.getEntity().isPlayerControlled())
			{
				_user.getTile().addVisibilityForFaction(::Const.Faction.Player);
			}
		}
		else
		{
			this.onPerformAttack(tag);
		}

		return true;
	}

	function onPerformAttack( _tag )
	{
		local _user = _tag.User;
		local _targetTile = _tag.TargetTile;
		local target = _targetTile.getEntity();
		local flingToTile = this.findTileToKnockBackTo(_user.getTile(), _targetTile);

		if (flingToTile == null)
		{
			return false;
		}

		this.applyFatigueDamage(target, 10);

		if (target.getCurrentProperties().IsImmuneToKnockBackAndGrab)
		{
			return false;
		}

		if (!_user.isHiddenToPlayer() && (_targetTile.IsVisibleForPlayer || flingToTile.IsVisibleForPlayer))
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " flings back " + ::Const.UI.getColorizedEntityName(target));
		}

		local skills = target.getSkills();
		skills.removeByID("effects.shieldwall");
		skills.removeByID("effects.spearwall");
		skills.removeByID("effects.riposte");
		target.setCurrentMovementType(::Const.Tactical.MovementType.Involuntary);
		local damage = ::Math.max(0, ::Math.abs(flingToTile.Level - _targetTile.Level) - 1) * ::Const.Combat.FallingDamage + ::Const.Combat.FallingDamage * 2.5;

		if (damage == 0)
		{
			::Tactical.getNavigator().teleport(target, flingToTile, null, null, true);
		}
		else
		{
			local p = this.getContainer().getActor().getCurrentProperties();
			local tag = {
				Skill = this,
				Container = this.getContainer(),
				Attacker = _user,
				HitInfo = clone ::Const.Tactical.HitInfo
			};
			tag.HitInfo.DamageRegular = damage;
			tag.HitInfo.DamageFatigue = ::Const.Combat.FatigueReceivedPerHit;
			tag.HitInfo.DamageDirect = 1.0;
			tag.HitInfo.BodyPart = ::Const.BodyPart.Body;
			tag.HitInfo.BodyDamageMult = 1.0;
			tag.HitInfo.FatalityChanceMult = 1.0;
			::Tactical.getNavigator().teleport(target, flingToTile, this.onKnockedDown, tag, true);
		}

		local tag = {
			TargetTile = _targetTile,
			Actor = _user
		};
		::Time.scheduleEvent(::TimeUnit.Virtual, 250, this.onFollow, tag);
		return true;
	}

	function onFollow( _tag )
	{
		if (_tag.TargetTile.IsEmpty)
		{
			_tag.Actor.setCurrentMovementType(::Const.Tactical.MovementType.Default);
			::Tactical.getNavigator().teleport(_tag.Actor, _tag.TargetTile, null, null, false);
		}
	}

	function onKnockedDown( _entity, _tag )
	{
		if (_tag.Skill.m.SoundOnHit.len() != 0)
		{
			::Sound.play(::MSU.Array.rand(_tag.Skill.m.SoundOnHit), ::Const.Sound.Volume.Skill, _entity.getPos());
		}

		if (_tag.HitInfo.DamageRegular != 0)
		{
			_entity.onDamageReceived(_tag.Attacker, _tag.Skill, _tag.HitInfo);
			
			if (typeof _tag.Attacker == "instance" && _tag.Attacker.isNull() || !_tag.Attacker.isAlive() || _tag.Attacker.isDying())
			{
				return;
			}
			
			_tag.Container.onTargetHit(_tag.Skill, _entity, _tag.HitInfo.BodyPart, _tag.HitInfo.DamageRegular, 0);
		}
	}

});

