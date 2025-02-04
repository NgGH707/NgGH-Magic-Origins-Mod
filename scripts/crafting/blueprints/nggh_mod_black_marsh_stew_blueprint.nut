this.nggh_mod_black_marsh_stew_blueprint <- ::inherit("scripts/crafting/legend_food_blueprint", {
	m = {},
	function create()
	{
		this.legend_food_blueprint.create();
		this.m.ID = "blueprint.black_marsh_stew";
		this.m.PreviewCraftable = ::new("scripts/items/supplies/black_marsh_stew_item");
		this.init([
			{
				Script = "scripts/items/supplies/ground_grains_item",
				Num = 1,
			},
		]);
		this.initSkills([
			{
				Scripts = [
					"scripts/skills/hexe/nggh_mod_hex_spell"
				]
			}
		]);
	}

	function onCraft( _stash )
	{
		_stash.add(::new("scripts/items/supplies/black_marsh_stew_item"));
	}
	
	function isQualified()
	{
		return true;
	}

});

