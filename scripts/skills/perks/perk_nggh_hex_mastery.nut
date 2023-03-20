this.perk_nggh_hex_mastery <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.hex_mastery";
		this.m.Name = ::Const.Strings.PerkName.NggHHexMastery;
		this.m.Description = ::Const.Strings.PerkDescription.NggHHexMastery;
		this.m.Icon = "ui/perks/perk_hex_mastery.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInHex = true;
		_properties.XPGainMult *= 1.05;
	}

	function onHex( _targetEntity, _masterHex, _slaveHex )
	{
	}

	function onAfterHex( _targetEntity, _masterHex, _slaveHex )
	{
	}

});

