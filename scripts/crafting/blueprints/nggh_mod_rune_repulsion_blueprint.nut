nggh_mod_rune_repulsion_blueprint <- ::inherit("scripts/crafting/legend_rune", {
	m = {},
	function create()
	{
		m.Rune = ::Legends.Rune.NgGHRsaRepulsion;
		legend_rune.create();
		m.ID = "blueprint.rune_repulsion";
		m.Type = ::Const.Items.ItemType.Misc;
	}

});

