this.bodily_reward_blueprint <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.bodily_reward";
		this.m.Type = this.Const.Items.ItemType.Usable;
		this.m.PreviewCraftable = this.new("scripts/items/special/bodily_reward_item");
		this.m.Cost = 500;
		local ingredients = [
			{
				Script = "scripts/items/misc/unhold_heart_item",
				Num = 2,
			},
			{
				Script = "scripts/items/misc/mysterious_herbs_item",
				Num = 1,
			}
		];
		this.init(ingredients);
		local skills = [
			{
				Scripts = [
					"scripts/skills/backgrounds/hexen_background"
				]
			}
		];
		this.initSkills(skills);
	}

	function onCraft( _stash )
	{
		_stash.add(this.new("scripts/items/special/bodily_reward_item"));
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

