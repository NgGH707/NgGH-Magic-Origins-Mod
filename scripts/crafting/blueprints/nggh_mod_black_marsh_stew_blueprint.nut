this.nggh_mod_black_marsh_stew_blueprint <- ::inherit("scripts/crafting/food_blueprint", {
	m = {},
	function create()
	{
		this.food_blueprint.create();
		this.m.ID = "blueprint.black_marsh_stew";
		this.m.PreviewCraftable = ::new("scripts/items/supplies/black_marsh_stew_item");
		local ingredients = [
			{
				Script = "scripts/items/supplies/ground_grains_item",
				Num = 1,
			},
		];
		this.init(ingredients);
		local skills = [
			{
				Scripts = [
					"scripts/skills/hexe/nggh_mod_hex_spell"
				]
			}
		];
		this.initSkills(skills);
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

