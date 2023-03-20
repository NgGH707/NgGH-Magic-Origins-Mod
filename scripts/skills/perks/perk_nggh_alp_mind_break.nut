this.perk_nggh_alp_mind_break <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.mind_break";
		this.m.Name = ::Const.Strings.PerkName.NggHAlpMindBreak;
		this.m.Description = ::Const.Strings.PerkDescription.NggHAlpMindBreak;
		this.m.Icon = "ui/perks/perk_mind_break.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.getContainer().hasSkill("actives.mind_break"))
		{
			this.getContainer().add(::new("scripts/skills/actives/nggh_mod_mind_break_skill"));
		}
	}

	function onRemoved()
	{
		this.getContainer().removeByID("actives.mind_break");
	}

});

