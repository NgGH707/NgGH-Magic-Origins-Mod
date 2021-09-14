this.perk_basic_charm <- this.inherit("scripts/skills/skill", {
	m = {
		Amount = 0.1,
		Bonus = 5,
	},
	function create()
	{
		this.m.ID = "perk.boobas_charm";
		this.m.Name = this.Const.Strings.PerkName.CharmBasic;
		this.m.Description = this.Const.Strings.PerkDescription.CharmBasic;
		this.m.Icon = "ui/perks/perk_basic_charm.png";
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

