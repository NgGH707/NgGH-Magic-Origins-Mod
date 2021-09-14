this.perk_mounted_charge <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.perk_mounted_charge";
		this.m.Name = this.Const.Strings.PerkName.LegendHorseCharge;
		this.m.Description = this.Const.Strings.PerkDescription.LegendHorseCharge;
		this.m.Icon = "ui/perks/charge_perk.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.m.Container.hasSkill("actives.nggh_mounted_charge"))
		{
			this.m.Container.add(this.new("scripts/skills/actives/nggh_mounted_charge"));
		}
	}

	function onUpdate( _properties )
    {
        if (this.getContainer().getActor().isMounted())
        {
        	_properties.TargetAttractionMult *= 1.25;
        }
    }

	function onRemoved()
	{
		this.m.Container.removeByID("actives.nggh_mounted_charge");
	}

});

