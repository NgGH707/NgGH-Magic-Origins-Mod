this.nggh_mod_unhold_hand_to_hand <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.unhold_hand_to_hand";
		this.m.Name = "Hand-to-Hand Attack";
		this.m.Description = "Use your limbs to inflict damage on your enemy. Damage depends on training.";
		this.m.KilledString = "Smashed";
		this.m.Icon = "skills/active_112.png";
		this.m.IconDisabled = "skills/active_112_sw.png";
		this.m.Overlay = "active_112";
		this.m.SoundOnHit = [
			"sounds/enemies/unhold_swipe_hit_01.wav",
			"sounds/enemies/unhold_swipe_hit_02.wav",
			"sounds/enemies/unhold_swipe_hit_04.wav",
			"sounds/enemies/unhold_swipe_hit_05.wav"
		];
		this.m.SoundOnUse = [
			"sounds/combat/hand_01.wav",
			"sounds/combat/hand_02.wav",
			"sounds/combat/hand_03.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.OffensiveTargeted - 1;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.InjuriesOnBody = ::Const.Injury.BluntBody;
		this.m.InjuriesOnHead = ::Const.Injury.BluntHead;
		this.m.HitChanceBonus = 0;
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 66;
	}

	function isHidden()
	{
		return !::MSU.isNull(this.getContainer().getActor().getMainhandItem()) || this.skill.isHidden();
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();

		if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInFists)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "Has [color=" + ::Const.UI.Color.PositiveValue + "]+5%[/color] chance to hit"
			});
		}

		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "Has [color=" + ::Const.UI.Color.NegativeValue + "]100%[/color] to stagger target"
		});

		return ret;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill != this)
			return;

		_properties.DamageRegularMin += 30;
		_properties.DamageRegularMax += 20;

		_skill.resetField("HitChanceBonus");

		if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInFists)
		{
			_properties.FatigueDealtPerHitMult *= 2.5;
			_properties.MeleeSkill += 5;
			this.m.HitChanceBonus += 5;
		}
	}

	function onAfterUpdate( _properties )
	{
		if (!_properties.IsSpecializedInFists)
			return;

		this.m.FatigueCostMult *= ::Const.Combat.WeaponSpecFatigueMult;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local success = this.attackEntity(_user, target);

		if (!_user.isAlive() || _user.isDying())
			return success;

		if (success && _targetTile.IsOccupiedByActor && target.isAlive() && !target.isDying())
			this.applyEffectToTarget(_user, target);

		return success;
	}

	function applyEffectToTarget( _user, _target )
	{
		if (_target.isNonCombatant())
			return;

		_target.getSkills().add(::new("scripts/skills/effects/staggered_effect"));

		if (!_user.isHiddenToPlayer() && _target.getTile().IsVisibleForPlayer)
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " has staggered " + ::Const.UI.getColorizedEntityName(_target) + " for one turn");
	}

});

