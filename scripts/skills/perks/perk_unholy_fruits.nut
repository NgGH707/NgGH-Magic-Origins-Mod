this.perk_unholy_fruits <- this.inherit("scripts/skills/skill", {
	m = {
		Amount = 0.1,
		Bonus = 5,
	},
	function create()
	{
		this.m.ID = "perk.boobas_charm";
		this.m.Name = this.Const.Strings.PerkName.UnholyFruits;
		this.m.Description = this.Const.Strings.PerkDescription.UnholyFruits;
		this.m.Icon = "ui/perks/perk_unholy_fruits.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
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

