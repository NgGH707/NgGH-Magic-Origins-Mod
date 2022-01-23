this.perk_thick_hide <- this.inherit("scripts/skills/skill", {
	m = {
		BonusArmor = 60
	},
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
		if (this.m.IsNew)
		{
			local b = this.getContainer().getActor().getBaseProperties();
			b.Armor[0] += this.m.BonusArmor;
			b.ArmorMax[0] += this.m.BonusArmor;
			b.Armor[1] += this.m.BonusArmor;
			b.ArmorMax[1] += this.m.BonusArmor;
			this.m.IsNew = false;
		}
	}

	function onRemoved()
	{
		local b = this.getContainer().getActor().getBaseProperties();
		b.Armor[0] = this.Math.max(0, b.Armor[0] - this.m.BonusArmor);
		b.ArmorMax[0] = this.Math.max(0, b.ArmorMax[0] - this.m.BonusArmor);
		b.Armor[1] = this.Math.max(0, b.Armor[1] - this.m.BonusArmor);
		b.ArmorMax[1] = this.Math.max(0, b.ArmorMax[1] - this.m.BonusArmor);
	}

	function onUpdate( _properties )
	{
		_properties.DamageReceivedArmorMult *= 0.8;
	}

});

