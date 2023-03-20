this.perk_nggh_kraken_ensnare <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.kraken_ensnare";
		this.m.Name = ::Const.Strings.PerkName.NggHKrakenEnsnare;
		this.m.Description = ::Const.Strings.PerkDescription.NggHKrakenEnsnare;
		this.m.Icon = "ui/perks/perk_kraken_ensnare.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInNets = true;
	}

});

