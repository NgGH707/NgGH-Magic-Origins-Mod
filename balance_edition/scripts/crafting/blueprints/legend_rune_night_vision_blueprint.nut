this.legend_rune_night_vision_blueprint <- this.inherit("scripts/crafting/legend_rune", {
	m = {},
	function create()
	{
		this.m.Rune = 107;
		this.m.Skill = "perk.legend_vala_inscribe_helmet";
		this.legend_rune.create();
		this.m.ID = "blueprint.legend_rune_night_vision";
		this.m.Type = this.Const.Items.ItemType.Misc;
	}

	function getRuneSigilTooltip()
	{
		return "This item has the power of the rune sigil of Night Vision:\nNot affected by [color=" + this.Const.UI.Color.PositiveValue + "]Nighttime[/color] effect.";
	}

	function onEnchant( _stash, _bonus )
	{
		if (this.LegendsMod.Configs().LegendArmorsEnabled())
		{
			local rune = this.new("scripts/items/legend_helmets/runes/legend_rune_night_vision");
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

