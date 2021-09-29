this.perk_kraken_ensnare <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.kraken_ensnare";
		this.m.Name = this.Const.Strings.PerkName.KrakenEnsnare;
		this.m.Description = this.Const.Strings.PerkDescription.KrakenEnsnare;
		this.m.Icon = "ui/perks/perk_kraken_ensnare.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInNets = true;
	}

});

