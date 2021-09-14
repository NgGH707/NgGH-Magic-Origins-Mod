this.legend_rune_repulsion_blueprint <- this.inherit("scripts/crafting/legend_rune", {
	m = {},
	function create()
	{
		this.m.Rune = 103;
		this.m.Skill = "perk.legend_vala_inscribe_armor";
		this.legend_rune.create();
		this.m.ID = "blueprint.legend_rune_repulsion";
		this.m.Type = this.Const.Items.ItemType.Misc;
	}

	function getRuneSigilTooltip()
	{
		return "This item has the power of the rune sigil of Repulsion:\n[color=" + this.Const.UI.Color.PositiveValue + "]40%[/color] to knock back your attacker. [color=" + this.Const.UI.Color.PositiveValue + "]Immune[/color] to knockbacks and grabs.";
	}

	function onEnchant( _stash, _bonus )
	{
		if (this.LegendsMod.Configs().LegendArmorsEnabled())
		{
			local rune = this.new("scripts/items/legend_armor/runes/legend_rune_repulsion");
			rune.setRuneVariant(this.m.Rune);
			_stash.add(rune);
		}
		else
		{
			local rune = this.new("scripts/items/rune_sigils/legend_vala_inscription_token");
			rune.setRuneVariant(this.m.Rune);
			rune.updateRuneSigilToken();
			_stash.add(rune);
		}
	}

});

