this.perk_nggh_charm_mastery <- ::inherit("scripts/skills/skill", {
	m = {
		Bonus = 10,
	},
	function create()
	{
		this.m.ID = "perk.mastery_charm";
		this.m.Name = ::Const.Strings.PerkName.NggHCharmSpec;
		this.m.Description = ::Const.Strings.PerkDescription.NggHCharmSpec;
		this.m.Icon = "ui/perks/perk_charm.png";
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

});

