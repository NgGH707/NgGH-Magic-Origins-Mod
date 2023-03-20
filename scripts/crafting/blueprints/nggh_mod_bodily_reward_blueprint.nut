this.nggh_mod_bodily_reward_blueprint <- ::inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.bodily_reward";
		this.m.Type = ::Const.Items.ItemType.Usable;
		this.m.PreviewCraftable = ::new("scripts/items/special/bodily_reward_item");
		this.m.Cost = 1000;
		local ingredients = [
			{
				Script = "scripts/items/misc/unhold_heart_item",
				Num = 1,
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
					"scripts/skills/backgrounds/nggh_mod_hexe_commander_background"
				]
			}
		];
		this.initSkills(skills);
	}

	function onCraft( _stash )
	{
		_stash.add(::new("scripts/items/special/bodily_reward_item"));
	}
	
	function isQualified()
	{
		return true;
	}

});

