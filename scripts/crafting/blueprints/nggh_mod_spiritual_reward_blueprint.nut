this.nggh_mod_spiritual_reward_blueprint <- ::inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.spiritual_reward";
		this.m.Type = ::Const.Items.ItemType.Usable;
		this.m.PreviewCraftable = ::new("scripts/items/special/spiritual_reward_item");
		this.m.Cost = 1000;
		local ingredients = [
			{
				Script = "scripts/items/misc/potion_of_knowledge_item",
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
					"scripts/skills/backgrounds/nggh_mod_hexe_commander_background",
					"scripts/skills/perks/perk_legend_potion_brewer"
				],
			}
		];
		this.initSkills(skills);
	}

	function onCraft( _stash )
	{
		_stash.add(::new("scripts/items/special/spiritual_reward_item"));
	}
	
	function isQualified()
	{
		return true;
	}

});

