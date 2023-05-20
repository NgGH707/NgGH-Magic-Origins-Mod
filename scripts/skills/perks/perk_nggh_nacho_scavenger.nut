this.perk_nggh_nacho_scavenger <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.nacho_scavenger";
		this.m.Name = ::Const.Strings.PerkName.NggHNachoScavenger;
		this.m.Description = ::Const.Strings.PerkDescription.NggHNachoScavenger;
		this.m.Icon = "ui/perks/perk_scavenger.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function applyEffect()
	{
		this.getContainer().add(::new("scripts/skills/effects/nggh_mod_well_fed_effect"));
	}

});

