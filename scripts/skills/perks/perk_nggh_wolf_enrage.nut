this.perk_nggh_wolf_enrage <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.enrage_wolf";
		this.m.Name = ::Const.Strings.PerkName.NggHWolfEnrage;
		this.m.Description = ::Const.Strings.PerkDescription.NggHWolfEnrage;
		this.m.Icon = "ui/perks/perk_enrage_wolf.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == null)
		{
			return;
		}
		
		if (_targetEntity == null)
		{
			return;
		}
		
		local overwhelm = _targetEntity.getSkills().getSkillByID("effects.overwhelmed");
		
		if (overwhelm == null)
		{
			return;
		}
		
		local num = overwhelm.m.Count;
		_properties.MeleeSkill += num * 5;
		_properties.DamageDirectAdd += num * 0.02;
		_properties.DamageTotalMult += num * 0.05;
	}
});

