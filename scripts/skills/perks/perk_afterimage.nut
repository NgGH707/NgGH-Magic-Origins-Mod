this.perk_afterimage <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.afterimage";
		this.m.Name = this.Const.Strings.PerkName.Afterimage;
		this.m.Description = this.Const.Strings.PerkDescription.Afterimage;
		this.m.Icon = "ui/perks/perk_afterimage.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

});

