this.perk_nggh_basilisk_aim_head <- ::inherit("scripts/skills/skill", {
	m = {
		Stacks = 0,
		StacksMax = 5,
		SkillCount = 0,
		HeadHunterMult = 2.0,
		BonusPerStack = 0.125,
	},
	function create()
	{
		::Const.Perks.setup(this.m, ::Legends.Perk.NggH_Basilisk_AimTheHead);
		m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		m.Order = ::Const.SkillOrder.Perk | ::Const.SkillOrder.Any;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = false;
	}

	function getName()
	{
		return m.Stacks > 1 ? format("%s (x%i)", m.Name, m.Stacks) : m.Name;
	}

	function getDescription()
	{
		return "This character is aiming at the weakest spot of their opponent and gains an additional [color=" + ::Const.UI.Color.PositiveValue + "]+" + getBonusDamageToHead() * 100.0 + "%[/color] damage on hit to head.";
	}

	function getBonusDamageToHead()
	{
		return getContainer().hasPerk(::Legends.Perk.HeadHunter) ? m.BonusPerStack * m.Stacks * m.HeadHunterMult : m.BonusPerStack * m.Stacks;
	}

	function onUpdate( _properties )
	{
		m.IsHidden = m.Stacks == 0;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill.isAttack() && m.Stacks > 0)
			_properties.DamageAgainstMult[::Const.BodyPart.Head] += getBonusDamageToHead();
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill == null || !_skill.isAttack() || m.SkillCount == ::Const.SkillCounter)
			return;

		m.SkillCount = ::Const.SkillCounter;
		if (_bodyPart != ::Const.BodyPart.Head) m.Stacks = 0;
		else if (m.Stacks >= m.StacksMax) m.Stacks = 1;
		else m.Stacks += 1;
	}

	function onCombatStarted()
	{
		m.Stacks = 0;
		m.SkillCount = 0;
	}

	function onCombatFinished()
	{
		skill.onCombatFinished();
		m.Stacks = 0;
		m.SkillCount = 0;
	}


});

