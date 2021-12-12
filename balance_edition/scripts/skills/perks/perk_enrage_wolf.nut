this.perk_enrage_wolf <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.enrage_wolf";
		this.m.Name = this.Const.Strings.PerkName.EnrageWolf;
		this.m.Description = this.Const.Strings.PerkDescription.EnrageWolf;
		this.m.Icon = "ui/perks/perk_enrage_wolf.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
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
		_properties.DamageDirectAdd += num * 0.05;
		_properties.DamageTotalMult += num * 0.05;
	}
});

