this.perk_natural_selection <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.natural_selection";
		this.m.Name = this.Const.Strings.PerkName.EggNaturalSelection;
		this.m.Description = this.Const.Strings.PerkDescription.EggNaturalSelection;
		this.m.Icon = "ui/perks/perk_natural_selection.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

});

