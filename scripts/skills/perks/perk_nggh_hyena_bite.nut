this.perk_nggh_hyena_bite <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.hyena_bite";
		this.m.Name = ::Const.Strings.PerkName.NggHHyenaBite;
		this.m.Description = ::Const.Strings.PerkDescription.NggHHyenaBite;
		this.m.Icon = "ui/perks/perk_hyena_bite.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInCleavers = true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == null || _skill.isRanged())
			return;

		_properties.DamageRegularMin += 10;
		_properties.DamageRegularMax += 30;
		_properties.DamageArmorMult += 0.1;
	}

});

