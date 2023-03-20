this.perk_nggh_alp_sleep_mastery <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.mastery_sleep";
		this.m.Name = ::Const.Strings.PerkName.NggHAlpSleepSpec;
		this.m.Description = ::Const.Strings.PerkDescription.NggHAlpSleepSpec;
		this.m.Icon = "ui/perks/perk_mastery_sleep.png";
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

});

