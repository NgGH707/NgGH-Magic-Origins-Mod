this.mc_hand_to_hand <- this.inherit("scripts/skills/mc_magic_skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.mc_hand_to_hand";
		this.m.Name = "Hand-to-Hand Magic Attack";
		this.m.Description = "Use your limbs and magic to inflict damage on your enemy. Damage depends on resolve.";
		this.m.KilledString = "Pummeled to death";
		this.m.Icon = "skills/active_42.png";
		this.m.IconDisabled = "skills/active_42_sw.png";
		this.m.Overlay = "active_42";
		this.m.SoundOnUse = [
			"sounds/combat/hand_01.wav",
			"sounds/combat/hand_02.wav",
			"sounds/combat/hand_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/hand_hit_01.wav",
			"sounds/combat/hand_hit_02.wav",
			"sounds/combat/hand_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.First;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsSerialized = false;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 12;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		return this.getDefaultTooltip();
	}

	function isUsable()
	{
		return (this.m.Container.getActor().getMainhandItem() == null || this.getContainer().hasSkill("effects.disarmed")) && this.skill.isUsable();
	}

	function isHidden()
	{
		return this.m.Container.getActor().getMainhandItem() != null && !this.getContainer().hasSkill("effects.disarmed") || this.skill.isHidden() || this.m.Container.getActor().isStabled();
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill != this)
		{
			return;
		}

		local actor = this.getContainer().getActor();
		_properties.DamageRegularMin += 10;
		_properties.DamageRegularMax += 20;
		_properties.DamageArmorMult *= 1.0;

		if (this.m.Container.hasSkill("disarmed_effect"))
		{
			local mhand = actor.getMainhandItem();

			if (mhand != null)
			{
				_properties.DamageRegularMin -= main.m.RegularDamage;
				_properties.DamageRegularMax -= main.m.RegularDamageMax;
				_properties.DamageArmorMult /= main.m.ArmorDamageMult;
				_properties.DamageDirectAdd -= main.m.DirectDamageAdd;
			}
		}

		_properties.DamageTotalMult *= this.getBonusDamageFromResolve(_properties, true) * 1.2;
	}

	function onUse( _user, _targetTile )
	{
		return this.attackEntity(_user, _targetTile.getEntity());
	}

});

