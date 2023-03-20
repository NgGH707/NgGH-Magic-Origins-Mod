this.perk_nggh_schrat_uproot <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.uproot";
		this.m.Name = ::Const.Strings.PerkName.NggHSchratUproot;
		this.m.Description = ::Const.Strings.PerkDescription.NggHSchratUproot;
		this.m.Icon = "ui/perks/perk_uproot.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInSpears = true;
	}

});

