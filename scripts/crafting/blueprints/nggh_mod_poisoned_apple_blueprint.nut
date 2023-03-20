this.nggh_mod_poisoned_apple_blueprint <- ::inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.Type = ::Const.Items.ItemType.Usable;
		this.m.ID = "blueprint.poisoned_apple";
		this.m.PreviewCraftable = ::new("scripts/items/misc/poisoned_apple_item");
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
					"scripts/skills/hexe/nggh_mod_hex_spell"
				]
			}
		];
		this.initSkills(skills);
	}

	function onCraft( _stash )
	{
		_stash.add(::new("scripts/items/misc/poisoned_apple_item"));
	}

	function isQualified()
	{
		return true;
	}

});

