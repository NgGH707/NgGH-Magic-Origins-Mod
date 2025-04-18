nggh_mod_rune_lucky_blueprint <- ::inherit("scripts/crafting/legend_rune", {
	m = {},
	function create()
	{
		m.Rune = ::Legends.Rune.NgGHRswLucky;
		legend_rune.create();
		m.ID = "blueprint.rune_lucky";
		m.Type = ::Const.Items.ItemType.Misc;
	}

});

