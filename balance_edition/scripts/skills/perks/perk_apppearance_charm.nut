this.perk_apppearance_charm <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.appearance_charm";
		this.m.Name = this.Const.Strings.PerkName.CharmAppearance;
		this.m.Description = this.Const.Strings.PerkDescription.CharmAppearance;
		this.m.Icon = "ui/perks/perk_apppearance_charm.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

});

