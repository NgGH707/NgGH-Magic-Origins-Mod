this.eggs_special <- this.inherit("scripts/skills/skill", {
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
		this.m.Eggs = this.Math.max(0, this.m.Eggs - 1);
	}
	
	function addEggs( _v )
	{
		this.m.Eggs = this.Math.min(3, this.m.Eggs + this.Math.abs(_v));
	}
	
	function usedEggs( _v )
	{
		this.m.Eggs = this.Math.max(0, this.m.Eggs - this.Math.abs(_v));
	}
	
	function create()
	{
		this.m.ID = "special.egg_special";
		this.m.Name = "Webknecht Eggs";
		this.m.Description = "Show you how many eggs are left in this hive.";
		this.m.Icon = "skills/status_effect_eggs.png";
		this.m.IconMini = "status_effect_eggs_mini";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
		this.m.Type = this.Const.SkillType.Special | this.Const.SkillType.StatusEffect;
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
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Currently has [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.Eggs + "[/color]/[color=" + this.Const.UI.Color.NegativeValue + "]3[/color] egg(s)"
			}
		];
		
		return ret;
	}

	function onTurnStart()
	{
		if (!this.getContainer().hasSkill("perk.breeding_machine"))
		{
			return;
		}

		if (this.Math.rand(1, 100) > 10)
		{
			return;
		}

		this.addEggs(1);
		this.spawnIcon("status_effect_eggs", this.getContainer().getActor().getTile());
	}
	
});

