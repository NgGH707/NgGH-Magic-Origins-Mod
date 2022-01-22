this.perk_thick_hide <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.thick_hide";
		this.m.Name = this.Const.Strings.PerkName.ThickHide;
		this.m.Description = this.Const.Strings.PerkDescription.ThickHide;
		this.m.Icon = "ui/perks/perk_thick_hide.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		local b = this.getContainer().getActor().getBaseProperties();
		b.ArmorMult[0] *= 1.67;
		b.ArmorMult[1] *= 1.67;
	}

	function onRemoved()
	{
		local b = this.getContainer().getActor().getBaseProperties();
		b.ArmorMult[0] /= 1.67;
		b.ArmorMult[1] /= 1.67;
	}

	function onAfterUpdate( _properties )
	{
		_properties.DamageReceivedArmorMult *= 0.8;
	}

});

