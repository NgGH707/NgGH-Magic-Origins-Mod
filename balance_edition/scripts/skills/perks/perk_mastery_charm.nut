this.perk_mastery_charm <- this.inherit("scripts/skills/skill", {
	m = {
		Bonus = 10,
	},
	function create()
	{
		this.m.ID = "perk.mastery_charm";
		this.m.Name = this.Const.Strings.PerkName.CharmSpec;
		this.m.Description = this.Const.Strings.PerkDescription.CharmSpec;
		this.m.Icon = "ui/perks/perk_charm.png";
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

});

