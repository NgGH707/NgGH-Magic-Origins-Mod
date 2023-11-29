this.perk_nggh_spider_venom <- ::inherit("scripts/skills/skill", {
	m = {
		DefaultBonus = 0.1,
		ExtraBonus = 0.15
	},
	function create()
	{
		this.m.ID = "perk.spider_venom";
		this.m.Name = ::Const.Strings.PerkName.NggH_Spider_Venom;
		this.m.Description =::Const.Strings.PerkDescription.NggH_Spider_Venom;
		this.m.Icon = "ui/perks/perk_venomous.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInDaggers = true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == null || !_skill.isAttack() || _targetEntity == null)
			return;
		
		if (!_targetEntity.getFlags().has("undead"))
			return;

		local mult = 1.0 + this.m.DefaultBonus;

		if (_targetEntity.getCurrentProperties().IsRooted)
			mult += this.m.ExtraBonus;
		
		_properties.DamageTotalMult *= mult;
	}

});

