this.bomb_bag_blueprint <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.mortar_ammo";
		this.m.Type = this.Const.Items.ItemType.Accessory;
		this.m.PreviewCraftable = this.new("scripts/items/ammo/bomb_bag");
		this.m.Cost = 1000;
		local ingredients = [
			{
				Script = "scripts/items/misc/happy_powder_item",
				Num = 1,
			},
			{
				Script = "scripts/items/misc/sulfurous_rocks_item",
				Num = 2,
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
		_stash.add(this.new("scripts/items/ammo/bomb_bag"));
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

