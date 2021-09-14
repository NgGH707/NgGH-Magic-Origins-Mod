this.perk_nacho_eat <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.nacho_eat";
		this.m.Name = this.Const.Strings.PerkName.NachoEat;
		this.m.Description = this.Const.Strings.PerkDescription.NachoEat;
		this.m.Icon = "ui/perks/perk_energize_meal.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

});

