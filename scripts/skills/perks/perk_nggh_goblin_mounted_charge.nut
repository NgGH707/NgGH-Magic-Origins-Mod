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

	function onUpdate( _properties )
    {
    	_properties.IsSpecializedInMountedCharge = true;

        if (this.getContainer().getActor().isMounted())
        	_properties.TargetAttractionMult *= 1.1;
    }

});

