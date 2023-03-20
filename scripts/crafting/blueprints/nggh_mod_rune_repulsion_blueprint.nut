this.nggh_mod_rune_repulsion_blueprint <- ::inherit("scripts/crafting/legend_rune", {
	m = {},
	function create()
	{
		this.m.Rune = 103;
		this.m.Skill = "perk.legend_vala_inscribe_armor";
		this.legend_rune.create();
		this.m.ID = "blueprint.legend_rune_repulsion";
		this.m.Type = ::Const.Items.ItemType.Misc;
	}

	function getRuneSigilTooltip()
	{
		return "This item has the power of the rune sigil of Repulsion:\n[color=" + ::Const.UI.Color.PositiveValue + "]40%[/color] to knock back your attacker. [color=" + ::Const.UI.Color.PositiveValue + "]Immune[/color] to knockbacks and grabs.";
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

		local rune = ::new("scripts/items/legend_armor/runes/nggh_mod_rune_repulsion");
		rune.setRuneVariant(this.m.Rune);
		_stash.add(rune);
	}

});

