this.perk_breeding_machine <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.breeding_machine";
		this.m.Name = this.Const.Strings.PerkName.EggBreedingMachine;
		this.m.Description = this.Const.Strings.PerkDescription.EggBreedingMachine;
		this.m.Icon = "ui/perks/perk_breeding_machine.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

});

