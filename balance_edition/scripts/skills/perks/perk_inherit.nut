this.perk_inherit <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.inherit";
		this.m.Name = this.Const.Strings.PerkName.EggInherit;
		this.m.Description = this.Const.Strings.PerkDescription.EggInherit;
		this.m.Icon = "ui/perks/perk_inherit.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

});

