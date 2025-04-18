nggh_mod_rune_shielding_blueprint <- ::inherit("scripts/crafting/legend_rune", {
	m = {},
	function create()
	{
		m.Rune = ::Legends.Rune.NgGHRshShielding;
		legend_rune.create();
		m.ID = "blueprint.rune_shielding";
		m.Type = ::Const.Items.ItemType.Misc;
	}

});

