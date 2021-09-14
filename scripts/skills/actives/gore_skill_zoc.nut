this.gore_skill_zoc <- this.inherit("scripts/skills/skill", {
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
		this.m.Type = this.Const.SkillType.Active;
		this.m.IsSerialized = false;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.Delay = 500;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsHidden = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
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
		return this.m.IsUsable && this.m.Container.getActor().getCurrentProperties().IsAbleToUseSkills && (!this.m.IsWeaponSkill || this.m.Container.getActor().getCurrentProperties().IsAbleToUseWeaponSkills);
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
			this.attackEntity(_user, _targetTile.getEntity());
			
			if (_targetTile.getEntity().isAlive())
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
		this.attackEntity(_tag.User, _tag.TargetTile.getEntity());
		_tag.Skill.getContainer().setBusy(false);
		
		if (_tag.TargetTile.getEntity().isAlive())
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

		_target.getSkills().add(this.new("scripts/skills/effects/staggered_effect"));

		if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " has staggered " + this.Const.UI.getColorizedEntityName(_target) + " for one turn");
		}

		local knockToTile = this.findTileToKnockBackTo(_user.getTile(), _targetTile);

		if (knockToTile == null)
		{
			return;
		}

		this.m.TilesUsed.push(knockToTile.ID);

		if (!_user.isHiddenToPlayer() && (_targetTile.IsVisibleForPlayer || knockToTile.IsVisibleForPlayer))
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " has knocked back " + this.Const.UI.getColorizedEntityName(_target));
		}

		local skills = _target.getSkills();
		skills.removeByID("effects.shieldwall");
		skills.removeByID("effects.spearwall");
		skills.removeByID("effects.riposte");
		_target.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
		local damage = this.Math.max(0, this.Math.abs(knockToTile.Level - _targetTile.Level) - 1) * this.Const.Combat.FallingDamage;

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

