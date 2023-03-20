this.nggh_mod_rune_brimstone_blueprint <- ::inherit("scripts/crafting/legend_rune", {
	m = {},
	function create()
	{
		this.m.Rune = 106;
		this.m.Skill = "perk.legend_vala_inscribe_shield";
		this.legend_rune.create();
		this.m.ID = "blueprint.legend_rune_brimstone";
		this.m.Type = ::Const.Items.ItemType.Misc;
	}

	function getRuneSigilTooltip()
	{
		return "This item has the power of the rune sigil of Brimstone:\n[color=" + ::Const.UI.Color.PositiveValue + "]Immune[/color] to fire, gain [color=" + ::Const.UI.Color.NegativeValue + "]+10[/color] Fatigue recovery per turn and a slight damage reduction while standing on fire.";
	}

	function onEnchant( _stash, _bonus )
	{
		local rune = ::new("scripts/items/rune_sigils/legend_vala_inscription_token");
		rune.setRuneVariant(this.m.Rune);
		rune.updateRuneSigilToken();
		_stash.add(rune);
	}

});

