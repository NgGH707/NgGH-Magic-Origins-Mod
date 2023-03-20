this.perk_nggh_egg_natural_selection <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.natural_selection";
		this.m.Name = ::Const.Strings.PerkName.NggHEggNaturalSelection;
		this.m.Description = ::Const.Strings.PerkDescription.NggHEggNaturalSelection;
		this.m.Icon = "ui/perks/perk_natural_selection.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

});

