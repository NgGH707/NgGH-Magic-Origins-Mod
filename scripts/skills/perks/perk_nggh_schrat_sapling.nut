this.perk_nggh_schrat_sapling <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.sapling";
		this.m.Name = ::Const.Strings.PerkName.NggHSchratSapling;
		this.m.Description = ::Const.Strings.PerkDescription.NggHSchratSapling;
		this.m.Icon = "ui/perks/perk_sapling.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

});

