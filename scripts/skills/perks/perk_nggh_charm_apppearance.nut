this.perk_nggh_charm_apppearance <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.appearance_charm";
		this.m.Name = ::Const.Strings.PerkName.NggHCharmAppearance;
		this.m.Description = ::Const.Strings.PerkDescription.NggHCharmAppearance;
		this.m.Icon = "ui/perks/perk_apppearance_charm.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

});

