this.seductive_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {
		Amount = 0.005,
		Bonus = 5,
	},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.seductive";
		this.m.Name = "Seductive";
		this.m.Icon = "ui/traits/trait_seductive.png";
		this.m.Description = "Although many things can be taken at the point of a sword, some things will always be more potent than cold steel; the flash of an eyelash, the locking of a gaze...";
		this.m.Excluded = [
			"trait.paranoid",
			"trait.cocky"
		];
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/asset_money.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+0.5%[/color] barter skill"
			}
		];
		
		if (this.getContainer().hasSkill("spells.charm"))
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/health.png",
				text = "Increases chance to charm a target by [color=" + this.Const.UI.Color.PositiveValue + "]+5%[/color]"
			});
		}
		
		return ret;
	}
	
	function getBonus()
	{
		return this.m.Bonus;
	}

	function getModifier()
	{
		return this.m.Amount;
	}

	function onAdded()
	{
		if (this.World.State.getPlayer() == null)
		{
			return;
		}

		this.World.State.getPlayer().calculateBarterMult();
	}

	function onRemoved()
	{
		if (this.World.State.getPlayer() == null)
		{
			return;
		}

		this.World.State.getPlayer().calculateBarterMult();
	}

});

