this.nggh_mod_rune_thorns_blueprint <- ::inherit("scripts/crafting/legend_rune", {
	m = {},
	function create()
	{
		this.m.Rune = 102;
		this.m.Skill = "perk.legend_vala_inscribe_armor";
		this.legend_rune.create();
		this.m.ID = "blueprint.legend_rune_thorns";
		this.m.Type = ::Const.Items.ItemType.Misc;
	}

	function getRuneSigilTooltip()
	{
		return "This item has the power of the rune sigil of Thorns:\n[color=" + ::Const.UI.Color.PositiveValue + "]+25%[/color] Damage taken to armor.\nReflect [color=" + ::Const.UI.Color.PositiveValue + "]35[/color]-[color=" + ::Const.UI.Color.PositiveValue + "]65%[/color] Damage taken to armor back to the attacker.";
	}

	function onEnchant( _stash, _bonus )
	{
		if (::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
		{
			local rune = ::new("scripts/items/rune_sigils/legend_vala_inscription_token");
			rune.setRuneVariant(this.m.Rune);
			rune.updateRuneSigilToken();
			_stash.add(rune);
			return;
		}

		local rune = ::new("scripts/items/legend_armor/runes/nggh_mod_rune_thorns");
		rune.setRuneVariant(this.m.Rune);
		_stash.add(rune);
	}

});

