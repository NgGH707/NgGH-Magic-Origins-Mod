this.nggh_mod_eggs_special <- ::inherit("scripts/skills/skill", {
	m = {
		Eggs = 3,
	},
	
	function hasEggs()
	{
		return this.m.Eggs != 0;
	}
	
	function getEggs()
	{
		return this.m.Eggs;
	}
	
	function usedOneEgg()
	{
		this.m.Eggs = ::Math.max(0, this.m.Eggs - 1);
	}
	
	function addEggs( _v )
	{
		this.m.Eggs = ::Math.min(3, this.m.Eggs + ::Math.abs(_v));
	}
	
	function usedEggs( _v )
	{
		this.m.Eggs = ::Math.max(0, this.m.Eggs - ::Math.abs(_v));
	}
	
	function create()
	{
		this.m.ID = "special.egg_special";
		this.m.Name = "Webknecht Eggs";
		this.m.Description = "Show you how many ready-to-hatch eggs are available.";
		this.m.Icon = "skills/status_effect_eggs.png";
		this.m.IconMini = "status_effect_eggs_mini";
		this.m.Order = ::Const.SkillOrder.Trait - 1;
		this.m.Type = ::Const.SkillType.Special | ::Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsHidden = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
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
				id = 7,
				type = "progressbar",
				icon = "ui/icons/special.png",
				value = this.getEggs(),
				valueMax = 3,
				text = "" + this.getEggs() + " / 3",
				style = "armor-body-slim"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/relations.png",
				text = "Currently has [color=" + ::Const.UI.Color.PositiveValue + "]" + this.countSpiderlingNum() + "[/color] spiderling(s)"
			},
		];
		
		return ret;
	}

	function countSpiderlingNum()
	{
		local num = 0;
		local actorID = this.getContainer().getActor().getID();

		foreach (a in ::Tactical.Entities.getAllInstancesAsArray())
		{
		    if (!a.getFlags().has("Source") || a.getFlags().get("Source") != actorID)
		    {
		    	continue;
		    }

			++num;
		}

		return num;
	}

	function onTurnStart()
	{
		if (!this.getContainer().hasSkill("perk.breeding_machine"))
		{
			return;
		}

		if (::Math.rand(1, 100) > 10)
		{
			return;
		}

		this.addEggs(1);
		this.spawnIcon("status_effect_eggs", this.getContainer().getActor().getTile());
	}
	
});

