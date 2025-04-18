nggh_mod_rune_night_vision_blueprint <- ::inherit("scripts/crafting/legend_rune", {
	m = {},
	function create()
	{
		m.Rune = ::Legends.Rune.NgGHRshNightVision;
		legend_rune.create();
		m.ID = "blueprint.rune_night_vision";
		m.Type = ::Const.Items.ItemType.Misc;
	}

});

