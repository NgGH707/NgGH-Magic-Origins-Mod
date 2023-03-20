this.perk_nggh_hex_misfortune <- ::inherit("scripts/skills/perk_nggh_hex", {
	m = {},
	function create()
	{
		this.perk_nggh_hex.create();
		this.m.ID = "perk.hex_misfortune";
		this.m.HexType = ::Const.Hex.Type.Misfortune;
		this.m.Name = ::Const.Strings.PerkName.NggHHexMisfortune;
		this.m.Description = ::Const.Strings.PerkDescription.NggHHexMisfortune;
		this.m.PerkGroup = ::Const.Perks.HexeSpecializedHexTree;
		this.m.Icon = "ui/perks/perk_hex_green.png";
		this.m.Color =::createColor("#06fd0c");
		this.m.ColorName = "green";
	}

	function getAdditionalTooltips()
	{
		return [
			{
				id = 11,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-15%[/color] of total Hit Chance"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-10%[/color] of total Dodge Chance"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.RerollDefenseChance += 10;
		_properties.RerollMoraleChance += 10;
	}

});

