this.perk_nggh_kraken_move <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.kraken_move";
		this.m.Name = ::Const.Strings.PerkName.NggHKrakenMove;
		this.m.Description = ::Const.Strings.PerkDescription.NggHKrakenMove;
		this.m.Icon = "ui/perks/perk_kraken_move.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsFleetfooted = true;
	}

});

