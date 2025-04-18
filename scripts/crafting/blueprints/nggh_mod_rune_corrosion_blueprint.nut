nggh_mod_rune_corrosion_blueprint <- ::inherit("scripts/crafting/legend_rune", {
	m = {},
	function create()
	{
		m.Rune = ::Legends.Rune.NgGHRswCorrosion;
		legend_rune.create();
		m.ID = "blueprint.rune_corrosion";
		m.Type = ::Const.Items.ItemType.Misc;
	}

});

