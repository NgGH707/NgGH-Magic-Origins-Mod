this.perk_nggh_hex_weakening <- ::inherit("scripts/skills/perk_nggh_hex", {
	m = {},
	function create()
	{
		this.perk_nggh_hex.create();
		this.m.ID = "perk.hex_weakening";
		this.m.HexType = ::Const.Hex.Type.Weakening;
		this.m.Name = ::Const.Strings.PerkName.NggHHexWeakening;
		this.m.Description = ::Const.Strings.PerkDescription.NggHHexWeakening;
		this.m.PerkGroup = ::Const.Perks.HexeSpecializedHexTree;
		this.m.Icon = "ui/perks/perk_hex_yellow.png";
		this.m.Color = ::createColor("#fff006");
		this.m.ColorName = "yellow";
	}

	function getAdditionalTooltips()
	{
		return [
			{
				id = 11,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-33%[/color] Attack Damage"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-33%[/color] Max Fatigue"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-5[/color] Fatigue Recovery per turn"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.FatigueRecoveryRateMult *= 1.14;
	}

});

