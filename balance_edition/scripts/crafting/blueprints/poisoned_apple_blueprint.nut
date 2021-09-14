this.poisoned_apple_blueprint <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.Type = this.Const.Items.ItemType.Usable;
		this.m.ID = "blueprint.poisoned_apple";
		this.m.PreviewCraftable = this.new("scripts/items/misc/poisoned_apple_item");
		this.m.Cost = 100;
		local ingredients = [
			{
				Script = "scripts/items/supplies/legend_fresh_fruit_item",
				Num = 1,
			},
			{
				Script = "scripts/items/accessory/spider_poison_item",
				Num = 1,
			}
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
		_stash.add(this.new("scripts/items/misc/poisoned_apple_item"));
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

