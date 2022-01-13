this.perk_nacho_big_tummy <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.nacho_big_tummy";
		this.m.Name = this.Const.Strings.PerkName.NachoBigTummy;
		this.m.Description = this.Const.Strings.PerkDescription.NachoBigTummy;
		this.m.Icon = "ui/perks/perk_nacho_big_tummy.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

});

