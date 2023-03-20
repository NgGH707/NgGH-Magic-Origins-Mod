this.perk_nggh_alp_afterimage <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.afterimage";
		this.m.Name = ::Const.Strings.PerkName.NggHAlpAfterimage;
		this.m.Description = ::Const.Strings.PerkDescription.NggHAlpAfterimage;
		this.m.Icon = "ui/perks/perk_afterimage.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

});

