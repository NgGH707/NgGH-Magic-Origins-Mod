this.legend_rune_unstable_blueprint <- this.inherit("scripts/crafting/legend_rune", {
	m = {},
	function create()
	{
		this.m.Rune = 101;
		this.m.Skill = "perk.legend_vala_inscription_mastery";
		this.legend_rune.create();
		this.m.ID = "blueprint.legend_rune_unstable";
		this.m.Type = this.Const.Items.ItemType.Misc;
	}

	function getRuneSigilTooltip()
	{
		return "This item has the power of the rune sigil of Unstable:\nAttacks have [color=" + this.Const.UI.Color.PositiveValue + "]10%[/color] to either deal triple or a third of the original damage.";
	}

	function onEnchant( _stash, _bonus )
	{
		local rune = this.new("scripts/items/rune_sigils/legend_vala_inscription_token");
		rune.setRuneVariant(this.m.Rune);
		rune.updateRuneSigilToken();
		_stash.add(rune);
	}

});

