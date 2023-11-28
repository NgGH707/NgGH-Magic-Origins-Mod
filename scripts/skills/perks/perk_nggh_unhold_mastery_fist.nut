this.perk_nggh_unhold_mastery_fist <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.unhold_mastery_fist";
		this.m.Name = ::Const.Strings.PerkName.NggH_Unhold_SpecFists;
		this.m.Description = ::Const.Strings.PerkDescription.NggH_Unhold_SpecFists;
		this.m.Icon = "ui/perks/unarmed_mastery_circle.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInFists = true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == null || _skill.getID() != "actives.unhold_grapple")
			return;

		_properties.MeleeSkill += 10;
	}

});

