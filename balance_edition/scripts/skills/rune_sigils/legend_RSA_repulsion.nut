this.legend_RSA_repulsion <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "special.legend_RSA_repulsion";
		this.m.Name = "Rune Sigil: Repulsion";
		this.m.Description = "Rune Sigil: Repulsion";
		this.m.Icon = "ui/rune_sigils/legend_rune_sigil.png";
		this.m.Type = this.Const.SkillType.Special | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}

	function onAfterUpdate( _properties )
	{
		if (this.getItem() == null)
		{
			return;
		}

		_properties.IsImmuneToKnockBackAndGrab = true;
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (this.getItem() == null || _attacker == null)
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

		if (_damageArmor > 0 && this.Math.rand(1, 100) <= 40)
		{
			local knockToTile = this.findTileToKnockBackTo(actor.getTile(), _attacker.getTile());

			if (knockToTile == null)
			{
				return;
			}

			this.applyFatigueDamage(_attacker, 10);

			if (_attacker.getCurrentProperties().IsImmuneToKnockBackAndGrab || _attacker.getCurrentProperties().IsRooted)
			{
				return;
			}

			if (!actor.isHiddenToPlayer() && (_attacker.getTile().IsVisibleForPlayer || knockToTile.IsVisibleForPlayer))
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_attacker) + " has been knocked back");
			}

			local skills = _attacker.getSkills();
			skills.removeByID("effects.shieldwall");
			skills.removeByID("effects.spearwall");
			skills.removeByID("effects.riposte");

			_attacker.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
			local damage = this.Math.max(0, this.Math.abs(knockToTile.Level - _attacker.getTile().Level) - 1) * this.Const.Combat.FallingDamage;

			if (damage == 0)
			{
				this.Tactical.getNavigator().teleport(_attacker, knockToTile, null, null, true);
			}
			else
			{
				local p = this.getContainer().getActor().getCurrentProperties();
				local tag = {
					Attacker = actor,
					Skill = this,
					HitInfo = clone this.Const.Tactical.HitInfo,
				};
				tag.HitInfo.DamageRegular = damage;
				tag.HitInfo.DamageFatigue = this.Const.Combat.FatigueReceivedPerHit;
				tag.HitInfo.DamageDirect = 1.0;
				tag.HitInfo.BodyPart = this.Const.BodyPart.Body;
				tag.HitInfo.BodyDamageMult = 1.0;
				tag.HitInfo.FatalityChanceMult = 1.0;

				this.Tactical.getNavigator().teleport(_attacker, knockToTile, this.onKnockedDown, tag, true);
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

