this.perk_nggh_goblin_mounted_archery <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.mounted_archery";
		this.m.Name = ::Const.Strings.PerkName.NggHGoblinMountedArchery;
		this.m.Description = ::Const.Strings.PerkDescription.NggHGoblinMountedArchery;
		this.m.Icon = "ui/perks/partian_shot_perk.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

});

