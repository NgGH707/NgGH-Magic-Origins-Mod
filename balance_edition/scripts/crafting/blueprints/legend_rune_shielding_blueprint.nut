this.legend_rune_shielding_blueprint <- this.inherit("scripts/crafting/legend_rune", {
	m = {},
	function create()
	{
		this.m.Rune = 100;
		this.m.Skill = "perk.legend_vala_inscribe_helmet";
		this.legend_rune.create();
		this.m.ID = "blueprint.legend_rune_shielding";
		this.m.Type = this.Const.Items.ItemType.Misc;
	}

	function getRuneSigilTooltip()
	{
		return "This item has the power of the rune sigil of Shielding:\nGrant a [color=" + this.Const.UI.Color.PositiveValue + "]Protective Barrier[/color] that can repel physical attacks.";
	}

	function onEnchant( _stash, _bonus )
	{
		if (this.LegendsMod.Configs().LegendArmorsEnabled())
		{
			local rune = this.new("scripts/items/legend_helmets/runes/legend_rune_shielding");
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

