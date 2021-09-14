this.perk_control_flame <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.control_flame";
		this.m.Name = this.Const.Strings.PerkName.AlpControlFlame;
		this.m.Description = this.Const.Strings.PerkDescription.AlpControlFlame;
		this.m.Icon = "ui/perks/perk_hellish_flame.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

});

