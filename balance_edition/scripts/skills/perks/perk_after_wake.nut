this.perk_after_wake <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.after_wake";
		this.m.Name = this.Const.Strings.PerkName.AfterWake;
		this.m.Description = this.Const.Strings.PerkDescription.AfterWake;
		this.m.Icon = "ui/perks/perk_after_wake.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

});

