nggh_mod_rune_unstable_blueprint <- ::inherit("scripts/crafting/legend_rune", {
	m = {},
	function create()
	{
		m.Rune = ::Legends.Rune.NgGHRswUnstable;
		legend_rune.create();
		m.ID = "blueprint.rune_unstable";
		m.Type = ::Const.Items.ItemType.Misc;
	}

});

