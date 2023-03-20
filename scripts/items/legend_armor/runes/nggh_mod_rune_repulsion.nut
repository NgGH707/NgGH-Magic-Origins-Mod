this.nggh_mod_rune_repulsion <- ::inherit("scripts/items/legend_armor/legend_armor_upgrade", {
	m = {},
	function create()
	{
		this.m.RuneVariant = 103;
		this.legend_armor_upgrade.create();
		this.m.ID = "legend_armor_upgrade.legend_rune_repulsion";
		this.m.Type = ::Const.Items.ArmorUpgrades.Rune;
		this.m.Name = "Armor Rune Sigil: Repulsion";
		this.m.Description = "An inscribed rock that can be attached to a character\'s armor.";
		this.m.ArmorDescription = "Includes An inscribed rock that can see people flying for hitting you.";
		this.m.Icon = "rune_sigils/rune_stone_3.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "layers/glow_runed_icon.png";
		this.m.OverlayIconLarge = "layers/glow_runed_inventory.png";
		this.m.SpriteFront = "";
		this.m.SpriteBack = "";
		this.m.SpriteDamagedFront = "";
		this.m.SpriteDamagedBack = "";
		this.m.SpriteCorpseFront = "";
		this.m.SpriteCorpseBack = "";
		this.m.Value = 1200;
	}

	function getTooltip()
	{
		local result = this.legend_armor_upgrade.getTooltip();
		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "This item has the power of the rune sigil of Repulsion:\n[color=" + ::Const.UI.Color.PositiveValue + "]50%[/color] to knock back your attacker. [color=" + ::Const.UI.Color.PositiveValue + "]Immune[/color] to knockbacks and grabs."
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "This item has the power of the rune sigil of Repulsion:\n[color=" + ::Const.UI.Color.PositiveValue + "]50%[/color] to knock back your attacker. [color=" + ::Const.UI.Color.PositiveValue + "]Immune[/color] to knockbacks and grabs."
		});
	}

	function onEquip()
	{
		this.legend_armor_upgrade.onEquip();
		this.addSkill(::new("scripts/skills/rune_sigils/nggh_mod_RSA_repulsion"));
	}

});

