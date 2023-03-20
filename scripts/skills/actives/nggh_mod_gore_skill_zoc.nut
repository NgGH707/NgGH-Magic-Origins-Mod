this.nggh_mod_gore_skill_zoc <- ::inherit("scripts/skills/skill", {
	m = {
		TilesUsed = []
	},
	function create()
	{
		this.m.ID = "actives.gore_zoc";
		this.m.Name = "Gore";
		this.m.Icon = "skills/active_166.png";
		this.m.IconDisabled = "skills/active_166_sw.png";
		this.m.Overlay = "active_166";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc4/thing_charge_01.wav",
			"sounds/enemies/dlc4/thing_charge_02.wav",
			"sounds/enemies/dlc4/thing_charge_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/unhold_swipe_hit_01.wav",
			"sounds/enemies/unhold_swipe_hit_02.wav",
			"sounds/enemies/unhold_swipe_hit_04.wav",
			"sounds/enemies/unhold_swipe_hit_05.wav"
		];
		this.m.IsSerialized = false;
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.OffensiveTargeted;
		this.m.Delay = 500;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsHidden = true;
		this.m.InjuriesOnBody = ::Const.Injury.BluntBody;
		this.m.InjuriesOnHead = ::Const.Injury.BluntHead;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.MaxLevelDifference = 4;
		this.m.DirectDamageMult = 0.4;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 25;
		this.m.ChanceSmash = 25;
	}
	
	function isUsable()
	{
		return this.m.IsUsable && this.getContainer().getActor().getCurrentProperties().IsAbleToUseSkills && (!this.m.IsWeaponSkill || this.getContainer().getActor().getCurrentProperties().IsAbleToUseWeaponSkills);
	}
	
	function getTooltip()
	{
		return this.getDefaultTooltip();
	}

	function onUse( _user, _targetTile )
	{
		this.m.TilesUsed = [];
		local tag = {
			Skill = this,
			User = _user,
			TargetTile = _targetTile
		};

		if ((!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer) && ::Tactical.TurnSequenceBar.getActiveEntity().getID() == this.getContainer().getActor().getID())
		{
			this.getContainer().setBusy(true);
			local d = _user.getTile().getDirectionTo(_targetTile) + 3;
			d = d > 5 ? d - 6 : d;

			if (_user.getTile().hasNextTile(d))
			{
				::Tactical.getShaker().shake(_user, _user.getTile().getNextTile(d), 6);
			}

			::Time.scheduleEvent(::TimeUnit.Virtual, 500, this.onPerformAttack.bindenv(this), tag);
			return true;
		}
		else
		{
			local hit = this.attackEntity(_user, _targetTile.getEntity());

			if (!hit)
			{
				return false;
			}
			
			if (_targetTile.IsOccupiedByActor && _targetTile.getEntity().isAlive())
			{
				this.applyEffectToTarget(_user, _targetTile.getEntity(), _targetTile);
			}
			else
			{
				_user.getSprite("head").setBrush("bust_trickster_god_head_02");
			}
			
			return true;
		}
	}

	function onPerformAttack( _tag )
	{
		local hit = this.attackEntity(_tag.User, _tag.TargetTile.getEntity());
		_tag.Skill.getContainer().setBusy(false);

		if (!hit)
		{
			return false;
		}
		
		if (_tag.TargetTile.IsOccupiedByActor && _tag.TargetTile.getEntity().isAlive())
		{
			_tag.Skill.applyEffectToTarget(_tag.User, _tag.TargetTile.getEntity(), _tag.TargetTile);
		}
		else
		{
			_tag.User.getSprite("head").setBrush("bust_trickster_god_head_02");
		}
	}
	
	function applyEffectToTarget( _user, _target, _targetTile )
	{
		if (_target.isNonCombatant())
		{
			return;
		}

		_target.getSkills().add(::new("scripts/skills/effects/staggered_effect"));

		if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " has staggered " + ::Const.UI.getColorizedEntityName(_target) + " for one turn");
		}

		local knockToTile = this.findTileToKnockBackTo(_user.getTile(), _targetTile);

		if (knockToTile == null)
		{
			return;
		}

		this.m.TilesUsed.push(knockToTile.ID);

		if (!_user.isHiddenToPlayer() && (_targetTile.IsVisibleForPlayer || knockToTile.IsVisibleForPlayer))
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " has knocked back " + ::Const.UI.getColorizedEntityName(_target));
		}

		local skills = _target.getSkills();
		skills.removeByID("effects.shieldwall");
		skills.removeByID("effects.spearwall");
		skills.removeByID("effects.riposte");
		_target.setCurrentMovementType(::Const.Tactical.MovementType.Involuntary);
		local damage = ::Math.max(0, ::Math.abs(knockToTile.Level - _targetTile.Level) - 1) * ::Const.Combat.FallingDamage;

		if (damage == 0)
		{
			::Tactical.getNavigator().teleport(_target, knockToTile, null, null, true);
		}
		else
		{
			local p = this.getContainer().getActor().getCurrentProperties();
			local tag = {
				Attacker = _user,
				Skill = this,
				HitInfo = clone ::Const.Tactical.HitInfo
			};
			tag.HitInfo.DamageRegular = damage;
			tag.HitInfo.DamageDirect = 1.0;
			tag.HitInfo.BodyPart = ::Const.BodyPart.Body;
			tag.HitInfo.BodyDamageMult = 1.0;
			tag.HitInfo.FatalityChanceMult = 1.0;
			::Tactical.getNavigator().teleport(_target, knockToTile, this.onKnockedDown, tag, true);
		}
	}

	function findTileToKnockBackTo( _userTile, _targetTile )
	{
		local dir = _userTile.getDirectionTo(_targetTile);

		if (_targetTile.hasNextTile(dir))
		{
			local knockToTile = _targetTile.getNextTile(dir);

			if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= 1 && this.m.TilesUsed.find(knockToTile.ID) == null)
			{
				return knockToTile;
			}
		}

		local altdir = dir - 1 >= 0 ? dir - 1 : 5;

		if (_targetTile.hasNextTile(altdir))
		{
			local knockToTile = _targetTile.getNextTile(altdir);

			if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= 1 && this.m.TilesUsed.find(knockToTile.ID) == null)
			{
				return knockToTile;
			}
		}

		altdir = dir + 1 <= 5 ? dir + 1 : 0;

		if (_targetTile.hasNextTile(altdir))
		{
			local knockToTile = _targetTile.getNextTile(altdir);

			if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= 1 && this.m.TilesUsed.find(knockToTile.ID) == null)
			{
				return knockToTile;
			}
		}

		return null;
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
			_properties.DamageMinimum = 15;
			_properties.DamageRegularMin = 50;
			_properties.DamageRegularMax = 65;
		}
	}

});

