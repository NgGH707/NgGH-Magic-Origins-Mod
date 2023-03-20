this.perk_nggh_nacho_big_tummy <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.nacho_big_tummy";
		this.m.Name = ::Const.Strings.PerkName.NggHNachoBigTummy;
		this.m.Description = ::Const.Strings.PerkDescription.NggHNachoBigTummy;
		this.m.Icon = "ui/perks/perk_nacho_big_tummy.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

});

