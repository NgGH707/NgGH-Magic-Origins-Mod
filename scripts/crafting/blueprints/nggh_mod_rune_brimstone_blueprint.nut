nggh_mod_rune_brimstone_blueprint <- ::inherit("scripts/crafting/legend_rune", {
	m = {},
	function create()
	{
		m.Rune = ::Legends.Rune.NgGHRssBrimstone;
		legend_rune.create();
		m.ID = "blueprint.rune_brimstone";
		m.Type = ::Const.Items.ItemType.Misc;
	}

});

