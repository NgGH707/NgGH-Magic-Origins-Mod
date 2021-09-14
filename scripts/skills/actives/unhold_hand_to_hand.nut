this.unhold_hand_to_hand <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.unhold_hand_to_hand";
		this.m.Name = "Hand-to-Hand Attack";
		this.m.Description = "Let them fly! Use your limbs to inflict damage on your enemy. Damage depends on training.";
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
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted - 1;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.1;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 66;
	}

	function getMods()
	{
		local ret = {
			Min = 10,
			Max = 15,
			HasTraining = false
		};
		local actor = this.getContainer().getActor();

		if (actor.getSkills().hasSkill("perk.legend_unarmed_training"))
		{
			local average = actor.getHitpoints() * 0.05;

			ret.Min += average;
			ret.Max += average;
			ret.HasTraining = true;
		}

		ret.Min = this.Math.max(10, this.Math.floor(ret.Min));
		ret.Max = this.Math.max(15, this.Math.floor(ret.Max));
		return ret;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "Can cause [color=" + this.Const.UI.Color.NegativeValue + "]Stagger[/color] on hit"
		});

		return ret;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill != this)
		{
			return;
		}

		local mods = this.getMods();
		_properties.DamageRegularMin += mods.Min;
		_properties.DamageRegularMax += mods.Max;

		if (!mods.HasTraining)
		{
			_properties.DamageArmorMult = 0.5;
		}
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInFists ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		this.m.ActionPointCost = _properties.IsSpecializedInFists ? 4 : 5;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local success = this.attackEntity(_user, target);

		if (!_user.isAlive() || _user.isDying())
		{
			return success;
		}

		if (this.Math.rand(1, 100) <= 25 && success && _targetTile.IsOccupiedByActor && !target.isNonCombatant() && target.isAlive() && !target.isDying())
		{
			target.getSkills().add(this.new("scripts/skills/effects/staggered_effect"));

			if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " has staggered " + this.Const.UI.getColorizedEntityName(target) + " for one turn");
			}
		}

		return success;
	}

});

