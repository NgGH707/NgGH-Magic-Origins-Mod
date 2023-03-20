this.perk_nggh_nacho_eat <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.nacho_eat";
		this.m.Name = ::Const.Strings.PerkName.NggHNachoEat;
		this.m.Description = ::Const.Strings.PerkDescription.NggHNachoEat;
		this.m.Icon = "ui/perks/perk_energize_meal.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

});

