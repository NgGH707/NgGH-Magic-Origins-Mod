this.mysterious_herbs_blueprint <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.Type = this.Const.Items.ItemType.Usable;
		this.m.ID = "blueprint.mysterious_herbs";
		this.m.PreviewCraftable = this.new("scripts/items/misc/mysterious_herbs_item");
		this.m.Cost = 100;
		local ingredients = [
			{
				Script = "scripts/items/supplies/roots_and_berries_item",
				Num = 1
			},
			{
				Script = "scripts/items/misc/legend_mistletoe_item",
				Num = 1
			}
		];
		this.init(ingredients);
		local skills = [
			{
				Scripts = [
					"scripts/skills/spell_hexe/hex_spell",
					"scripts/skills/perks/perk_legend_herbcraft"
				],
			}
		];
		this.initSkills(skills);
	}

	function onCraft( _stash )
	{
		_stash.add(this.new("scripts/items/misc/mysterious_herbs_item"));
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

