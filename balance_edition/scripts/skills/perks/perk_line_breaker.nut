this.perk_line_breaker <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.line_breaker";
		this.m.Name = this.Const.Strings.PerkName.BearLineBreaker;
		this.m.Description = this.Const.Strings.PerkDescription.BearLineBreaker;
		this.m.Icon = "ui/perks/perk_line_breaker.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.m.Container.hasSkill("actives.line_breaker"))
		{
			this.m.Container.add(this.new("scripts/skills/actives/line_breaker"));
		}
	}

	function onRemoved()
	{
		this.m.Container.removeByID("actives.line_breaker");
	}

});

