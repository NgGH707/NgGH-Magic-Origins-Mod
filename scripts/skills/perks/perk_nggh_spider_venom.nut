perk_nggh_spider_venom <- ::inherit("scripts/skills/skill", {
	m = {
		DefaultBonus = 1.1,
	},
	function create()
	{
		m.ID = "perk.spider_venom";
		m.Name = ::Const.Strings.PerkName.NggH_Spider_Venom;
		m.Description =::Const.Strings.PerkDescription.NggH_Spider_Venom;
		m.Icon = "ui/perks/perk_venomous.png";
		m.Type = ::Const.SkillType.Perk;
		m.Order = ::Const.SkillOrder.Perk;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInDaggers = true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == null || !_skill.isAttack() || _targetEntity == null)
			return;
		
		if (_targetEntity.getFlags().has("undead"))
			_properties.DamageTotalMult *= m.DefaultBonus;
	}

});

