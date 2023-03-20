this.perk_nggh_alp_hellish_flame <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.hellish_flame";
		this.m.Name = ::Const.Strings.PerkName.NggHAlpHellishFlame;
		this.m.Description = ::Const.Strings.PerkDescription.NggHAlpHellishFlame;
		this.m.Icon = "ui/perks/perk_hellish_flame.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

});

