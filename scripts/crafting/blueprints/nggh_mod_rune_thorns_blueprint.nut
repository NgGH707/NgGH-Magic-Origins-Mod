nggh_mod_rune_thorns_blueprint <- ::inherit("scripts/crafting/legend_rune", {
	m = {},
	function create()
	{
		m.Rune = ::Legends.Rune.NgGHRsaThorns;
		legend_rune.create();
		m.ID = "blueprint.rune_thorns";
		m.Type = ::Const.Items.ItemType.Misc;
	}

});

