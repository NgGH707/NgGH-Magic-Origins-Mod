this.perk_nggh_ghost_ghastly_touch <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.ghost_ghastly_touch";
		this.m.Name = ::Const.Strings.PerkName.NggHGhostGhastlyTouch;
		this.m.Description = ::Const.Strings.PerkDescription.NggHGhostGhastlyTouch;
		this.m.Icon = "ui/perks/perk_ghost_ghastly_touch.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill != null && _skill.getID() == "actives.ghastly_touch")
		{
			_properties.MeleeSkill += 5;
			_properties.DamageRegularMax += 5;
		}
	}

});

