this.perk_nggh_hex_hexer <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.hex_hexer";
		this.m.Name = ::Const.Strings.PerkName.NggHHexHexer;
		this.m.Description = ::Const.Strings.PerkDescription.NggHHexHexer;
		this.m.Icon = "ui/perks/perk_hexer.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_targetEntity == null) return;

		foreach (id in [
			"hex_slave",
			"hex_master",
		])
		{
			if (_targetEntity.getSkills().hasSkill("effects." + id))
			{
				_properties.MeleeSkill += 5;
				_properties.RangedSkill += 5;
				_properties.DamageRegularMult *= 1.33;
				break;
			}
		}
	}

});

