this.legend_rune_lucky_blueprint <- this.inherit("scripts/crafting/legend_rune", {
	m = {},
	function create()
	{
		this.m.Rune = 105;
		this.m.Skill = "perk.legend_vala_inscribe_weapon";
		this.legend_rune.create();
		this.m.ID = "blueprint.legend_rune_lucky";
		this.m.Type = this.Const.Items.ItemType.Misc;
	}

	function getRuneSigilTooltip()
	{
		return "This item has the power of the rune sigil of Lucky:\nKilled enemy has [color=" + this.Const.UI.Color.PositiveValue + "](XP / 7)%[/color] to drop a random item, you may get a free named item if you are super lucky!";
	}

	function onEnchant( _stash, _bonus )
	{
		local rune = this.new("scripts/items/rune_sigils/legend_vala_inscription_token");
		rune.setRuneVariant(this.m.Rune);
		rune.updateRuneSigilToken();
		_stash.add(rune);
	}

});

