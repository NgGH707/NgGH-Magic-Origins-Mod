this.perk_nggh_luft_unholy_fruits <- ::inherit("scripts/skills/skill", {
	m = {
		Amount = 0.1,
		Bonus = 5,
	},
	function create()
	{
		this.m.ID = "perk.boobas_charm";
		this.m.Name = ::Const.Strings.PerkName.NggHLuftUnholyFruits;
		this.m.Description = ::Const.Strings.PerkDescription.NggHLuftUnholyFruits;
		this.m.Icon = "ui/perks/perk_unholy_fruits.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
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
		if (::World.State.getPlayer() == null)
		{
			return;
		}

		::World.State.getPlayer().calculateBarterMult();
	}

	function onRemoved()
	{
		if (::World.State.getPlayer() == null)
		{
			return;
		}

		::World.State.getPlayer().calculateBarterMult();
	}

});

