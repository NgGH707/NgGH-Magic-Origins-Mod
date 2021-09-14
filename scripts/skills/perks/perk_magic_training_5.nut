this.perk_magic_training_5 <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.magic_training_5";
		this.m.Name = this.Const.Strings.PerkName.MC_MagicTraining5;
		this.m.Description = this.Const.Strings.PerkDescription.MC_MagicTraining5;
		this.m.Icon = "ui/perks/perk_magic_training_5.png";
		this.m.IconMini = "perk_magic_training_5_mini";
		this.m.Overlay = "perk_magic_training_5";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.BraveryMult *= 1.05;
		_properties.IsSpecializedInMC_Magic = true;
	}

});

