this.legend_rune_corrosion_blueprint <- this.inherit("scripts/crafting/legend_rune", {
	m = {},
	function create()
	{
		this.m.Rune = 104;
		this.m.Skill = "perk.legend_vala_inscribe_weapon";
		this.legend_rune.create();
		this.m.ID = "blueprint.legend_rune_corrosion";
		this.m.Type = this.Const.Items.ItemType.Misc;
	}

	function getRuneSigilTooltip()
	{
		return "This item has the power of the rune sigil of Corrosion:\n[color=" + this.Const.UI.Color.PositiveValue + "]1 to 2[/color] turn(s) of acid applied, which capable of destroying [color=" + this.Const.UI.Color.NegativeValue + "]10%[/color] of affected target\'s armor per turn.";
	}

	function onEnchant( _stash, _bonus )
	{
		local rune = this.new("scripts/items/rune_sigils/legend_vala_inscription_token");
		rune.setRuneVariant(this.m.Rune);
		rune.updateRuneSigilToken();
		_stash.add(rune);
	}

});

