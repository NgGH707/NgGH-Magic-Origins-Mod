this.black_marsh_stew_blueprint <- this.inherit("scripts/crafting/food_blueprint", {
	m = {},
	function create()
	{
		this.food_blueprint.create();
		this.m.ID = "blueprint.black_marsh_stew";
		this.m.PreviewCraftable = this.new("scripts/items/supplies/black_marsh_stew_item");
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
					"scripts/skills/spell_hexe/hex_spell"
				]
			}
		];
		this.initSkills(skills);
	}

	function onCraft( _stash )
	{
		_stash.add(this.new("scripts/items/supplies/black_marsh_stew_item"));
	}
	
	function isCraftable()
	{
		local hasTheMaterials = this.blueprint.isCraftable();
		return hasTheMaterials;
	}
	
	function isQualified()
	{
		if (this.LegendsMod.Configs().LegendAllBlueprintsEnabled())
		{
			return true;
		}

		return true;
	}

});

