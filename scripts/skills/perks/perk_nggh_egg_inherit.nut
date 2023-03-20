this.perk_nggh_egg_inherit <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.inherit";
		this.m.Name = ::Const.Strings.PerkName.NggHEggInherit;
		this.m.Description = ::Const.Strings.PerkDescription.NggHEggInherit;
		this.m.Icon = "ui/perks/perk_inherit.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

});

