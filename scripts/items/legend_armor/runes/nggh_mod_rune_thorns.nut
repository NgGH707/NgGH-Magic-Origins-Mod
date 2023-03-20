this.nggh_mod_rune_thorns <- ::inherit("scripts/items/legend_armor/legend_armor_upgrade", {
	m = {},
	function create()
	{
		this.m.RuneVariant = 102;
		this.legend_armor_upgrade.create();
		this.m.ID = "legend_armor_upgrade.legend_rune_thorns";
		this.m.Type = ::Const.Items.ArmorUpgrades.Rune;
		this.m.Name = "Armor Rune Sigil: Thorns";
		this.m.Description = "An inscribed rock that can be attached to a character\'s armor.";
		this.m.ArmorDescription = "Includes An inscribed rock that can punish those put a dent to your armor.";
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
			text = "This item has the power of the rune sigil of Thorns:\n[color=" + ::Const.UI.Color.PositiveValue + "]+25%[/color] Damage taken to armor.\nReflect [color=" + ::Const.UI.Color.PositiveValue + "]35[/color]-[color=" + ::Const.UI.Color.PositiveValue + "]65%[/color] Damage taken to armor back to the attacker."
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "This item has the power of the rune sigil of Thorns:\n[color=" + ::Const.UI.Color.PositiveValue + "]+25%[/color] Damage taken to armor.\nReflect [color=" + ::Const.UI.Color.PositiveValue + "]35[/color]-[color=" + ::Const.UI.Color.PositiveValue + "]65%[/color] Damage taken to armor back to the attacker."
		});
	}

	function onEquip()
	{
		this.legend_armor_upgrade.onEquip();
		this.addSkill(::new("scripts/skills/rune_sigils/nggh_mod_RSA_thorns"));
	}

});

