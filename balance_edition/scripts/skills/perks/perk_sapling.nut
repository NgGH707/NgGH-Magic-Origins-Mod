this.perk_sapling <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.sapling";
		this.m.Name = this.Const.Strings.PerkName.SchratSapling;
		this.m.Description = this.Const.Strings.PerkDescription.SchratSapling;
		this.m.Icon = "ui/perks/perk_sapling.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

});

