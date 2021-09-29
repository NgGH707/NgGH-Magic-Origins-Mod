this.perk_kraken_move <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.kraken_move";
		this.m.Name = this.Const.Strings.PerkName.KrakenMove;
		this.m.Description = this.Const.Strings.PerkDescription.KrakenMove;
		this.m.Icon = "ui/perks/perk_kraken_move.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsFleetfooted = true;
	}

});

