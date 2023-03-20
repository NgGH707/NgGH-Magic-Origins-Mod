this.perk_nggh_charm_basic <- ::inherit("scripts/skills/skill", {
	m = {
		Amount = 0.1,
		Bonus = 5,
	},
	function create()
	{
		this.m.ID = "perk.boobas_charm";
		this.m.Name = ::Const.Strings.PerkName.NggHCharmBasic;
		this.m.Description = ::Const.Strings.PerkDescription.NggHCharmBasic;
		this.m.Icon = "ui/perks/perk_basic_charm.png";
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

