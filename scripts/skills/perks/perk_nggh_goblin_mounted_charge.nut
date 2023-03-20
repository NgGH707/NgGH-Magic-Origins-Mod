this.perk_nggh_goblin_mounted_charge <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.mounted_charge";
		this.m.Name = ::Const.Strings.PerkName.LegendHorseCharge;
		this.m.Description = ::Const.Strings.PerkDescription.LegendHorseCharge;
		this.m.Icon = "ui/perks/charge_perk.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.getContainer().hasSkill("actives.nggh_mounted_charge"))
		{
			this.getContainer().add(::new("scripts/skills/actives/nggh_mod_mounted_charge"));
		}
	}

	function onUpdate( _properties )
    {
        if (this.getContainer().getActor().isMounted())
        {
        	_properties.TargetAttractionMult *= 1.1;
        }
    }

	function onRemoved()
	{
		this.getContainer().removeByID("actives.nggh_mounted_charge");
	}

});

