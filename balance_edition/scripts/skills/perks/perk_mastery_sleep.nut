this.perk_mastery_sleep <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.mastery_sleep";
		this.m.Name = this.Const.Strings.PerkName.SleepSpec;
		this.m.Description = this.Const.Strings.PerkDescription.SleepSpec;
		this.m.Icon = "ui/perks/perk_mastery_sleep.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInDaggers = true;
	}

});

