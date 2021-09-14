this.perk_ghoulish_beauty <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.appearance_charm";
		this.m.Name = this.Const.Strings.PerkName.GhoulBeauty;
		this.m.Description = this.Const.Strings.PerkDescription.GhoulBeauty;
		this.m.Icon = "ui/perks/perk_ghoulish_beauty.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

});

