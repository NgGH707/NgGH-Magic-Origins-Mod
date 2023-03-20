this.perk_nggh_egg_breeding_machine <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.breeding_machine";
		this.m.Name = ::Const.Strings.PerkName.NggHEggBreedingMachine;
		this.m.Description = ::Const.Strings.PerkDescription.NggHEggBreedingMachine;
		this.m.Icon = "ui/perks/perk_breeding_machine.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

});

