this.mortar_blueprint <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.mortar";
		this.m.Type = this.Const.Items.ItemType.Accessory;
		this.m.PreviewCraftable = this.new("scripts/items/tools/mortar_item");
		this.m.Cost = 2500;
		local ingredients = [
			{
				Script = "scripts/items/trade/quality_wood_item",
				Num = 5,
			},
			{
				Script = "scripts/items/misc/unhold_bones_item",
				Num = 3,
			},
			{
				Script = "scripts/items/misc/glistening_scales_item",
				Num = 1,
			}
		];
		this.init(ingredients);
		local skills = [
			{
				Scripts = [
					"scripts/skills/backgrounds/charmed_human_engineer_background"
				]
			}
		];
		this.initSkills(skills);
	}

	function onCraft( _stash )
	{
		_stash.add(this.new("scripts/items/tools/mortar_item"));
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

