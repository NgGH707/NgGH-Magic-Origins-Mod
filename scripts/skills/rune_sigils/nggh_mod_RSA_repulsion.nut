this.nggh_mod_RSA_repulsion <- ::inherit("scripts/skills/skill", {
	m = {
		IsForceEnabled = false
	},
	function create()
	{
		this.m.ID = "special.mod_RSA_repulsion";
		this.m.Name = "Rune Sigil: Repulsion";
		this.m.Description = "Rune Sigil: Repulsion";
		this.m.Icon = "ui/rune_sigils/legend_rune_sigil.png";
		this.m.Type = ::Const.SkillType.Special | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
		this.m.IsSerialized = false;
	}

	function onAfterUpdate( _properties )
	{
		if (this.m.IsForceEnabled)
		{
		}
		else if (this.getItem() == null)
		{
			return;
		}

		_properties.IsImmuneToKnockBackAndGrab = true;
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (_attacker == null)
		{
			return;
		}

		if (this.m.IsForceEnabled)
		{
		}
		else if (this.getItem() == null)
		{
			return;
		}

		if (!_attacker.isAlive() || _attacker.isDying())
		{
			return;
		}

		local actor = this.getContainer().getActor()

		if (_attacker.getID() == actor.getID())
		{
			return;
		}

		if (_damageArmor > 0 && ::Math.rand(1, 100) <= 50)
		{
			local knockToTile = this.findTileToKnockBackTo(actor.getTile(), _attacker.getTile());

			if (knockToTile == null)
			{
				return;
			}

			this.applyFatigueDamage(_attacker, 10);

			if ((_attacker.getCurrentProperties().IsImmuneToKnockBackAndGrab && ::Math.rand(1, 100) <= 50) || _attacker.getCurrentProperties().IsRooted)
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_attacker) + " resists being knocked back");
				return;
			}

			if (!actor.isHiddenToPlayer() && (_attacker.getTile().IsVisibleForPlayer || knockToTile.IsVisibleForPlayer))
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_attacker) + " has been knocked back");
			}

			local skills = _attacker.getSkills();
			skills.removeByID("effects.shieldwall");
			skills.removeByID("effects.spearwall");
			skills.removeByID("effects.riposte");

			_attacker.setCurrentMovementType(::Const.Tactical.MovementType.Involuntary);
			local damage = ::Math.max(0, ::Math.abs(knockToTile.Level - _attacker.getTile().Level) - 1) * ::Const.Combat.FallingDamage + 10;

			if (damage == 0)
			{
				::Tactical.getNavigator().teleport(_attacker, knockToTile, null, null, true);
			}
			else
			{
				local p = this.getContainer().getActor().getCurrentProperties();
				local tag = {
					Attacker = actor,
					Skill = this,
					HitInfo = clone ::Const.Tactical.HitInfo,
				};
				tag.HitInfo.DamageRegular = damage;
				tag.HitInfo.DamageFatigue = ::Const.Combat.FatigueReceivedPerHit;
				tag.HitInfo.DamageDirect = 1.0;
				tag.HitInfo.BodyPart = ::Const.BodyPart.Body;
				tag.HitInfo.BodyDamageMult = 1.0;
				tag.HitInfo.FatalityChanceMult = 1.0;

				::Tactical.getNavigator().teleport(_attacker, knockToTile, this.onKnockedDown, tag, true);
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

});

