this.perk_mounted_archery <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.mounted_archery";
		this.m.Name = this.Const.Strings.PerkName.GoblinMountedArchery;
		this.m.Description = this.Const.Strings.PerkDescription.GoblinMountedArchery;
		this.m.Icon = "ui/perks/partian_shot_perk.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

});

