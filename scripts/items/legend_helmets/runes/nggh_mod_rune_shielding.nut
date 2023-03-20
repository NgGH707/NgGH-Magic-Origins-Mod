this.nggh_mod_rune_shielding <- ::inherit("scripts/items/legend_helmets/legend_helmet_upgrade", {
	m = {},
	function create()
	{
		this.m.RuneVariant = 100;
		this.legend_helmet_upgrade.create();
		this.m.ID = "legend_helmet_upgrade.legend_rune_shielding";
		this.m.Type = ::Const.Items.HelmetUpgrades.Rune;
		this.m.Name = "Helmet Rune Sigil: Shielding";
		this.m.Description = "An inscribed rock that can be attached to a character\'s helmet.";
		this.m.ArmorDescription = "Includes An inscribed rock that grants an invisible protective barrier around you.";
		this.m.Icon = "rune_sigils/rune_stone_2.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "layers/glow_runed_icon.png";
		this.m.OverlayIconLarge = "layers/glow_runed_icon.png";
		this.m.Sprite = "bust_legend_helmet_runed";
		this.m.Value = 1200;
	}

	function updateVariant()
	{
	}

	function getTooltip()
	{
		local result = this.legend_helmet_upgrade.getTooltip();
		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "This item has the power of the rune sigil of Shielding:\nGrant a [color=" + ::Const.UI.Color.PositiveValue + "]Protective Barrier[/color]."
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "This item has the power of the rune sigil of Shielding:\nGrant a [color=" + ::Const.UI.Color.PositiveValue + "]Protective Barrier[/color]."
		});
	}

	function onEquip()
	{
		this.legend_helmet_upgrade.onEquip();
		this.addSkill(::new("scripts/skills/rune_sigils/nggh_mod_RSH_shielding"));
	}

});

