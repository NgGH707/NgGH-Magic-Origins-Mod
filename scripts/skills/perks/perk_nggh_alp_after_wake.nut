this.perk_nggh_alp_after_wake <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.after_wake";
		this.m.Name = ::Const.Strings.PerkName.NggHAlpAfterWake;
		this.m.Description = ::Const.Strings.PerkDescription.NggHAlpAfterWake;
		this.m.Icon = "ui/perks/perk_after_wake.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

});

