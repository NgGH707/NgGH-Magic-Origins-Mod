this.perk_nggh_misc_line_breaker <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.line_breaker";
		this.m.Name = ::Const.Strings.PerkName.NggHMiscLineBreaker;
		this.m.Description = ::Const.Strings.PerkDescription.NggHMiscLineBreaker;
		this.m.Icon = "ui/perks/perk_line_breaker.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.getContainer().hasSkill("actives.line_breaker"))
		{
			this.getContainer().add(::new("scripts/skills/actives/line_breaker"));
		}
	}

	function onRemoved()
	{
		this.getContainer().removeByID("actives.line_breaker");
	}

});

