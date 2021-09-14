this.perk_fiece_flame <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.fiece_flame";
		this.m.Name = this.Const.Strings.PerkName.AlpFieceFlame;
		this.m.Description = this.Const.Strings.PerkDescription.AlpFieceFlame;
		this.m.Icon = "ui/perks/perk_hellish_flame.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

});

