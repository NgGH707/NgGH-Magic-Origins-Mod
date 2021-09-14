this.legend_rune_thorns_blueprint <- this.inherit("scripts/crafting/legend_rune", {
	m = {},
	function create()
	{
		this.m.Rune = 102;
		this.m.Skill = "perk.legend_vala_inscribe_armor";
		this.legend_rune.create();
		this.m.ID = "blueprint.legend_rune_thorns";
		this.m.Type = this.Const.Items.ItemType.Misc;
	}

	function getRuneSigilTooltip()
	{
		return "This item has the power of the rune sigil of Thorns:\n[color=" + this.Const.UI.Color.PositiveValue + "]+25%[/color] Damage taken to armor.\nReflect [color=" + this.Const.UI.Color.PositiveValue + "]35[/color]-[color=" + this.Const.UI.Color.PositiveValue + "]65%[/color] Damage taken to armor back to the attacker.";
	}

	function onEnchant( _stash, _bonus )
	{
		if (this.LegendsMod.Configs().LegendArmorsEnabled())
		{
			local rune = this.new("scripts/items/legend_armor/runes/legend_rune_thorns");
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

