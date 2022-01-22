this.perk_mind_break <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.mind_break";
		this.m.Name = this.Const.Strings.PerkName.AlpMindBreak;
		this.m.Description = this.Const.Strings.PerkDescription.AlpMindBreak;
		this.m.Icon = "ui/perks/perk_mind_break.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.m.Container.hasSkill("actives.mind_break"))
		{
			this.m.Container.add(this.new("scripts/skills/actives/mod_mind_break_skill"));
		}
	}

	function onRemoved()
	{
		this.m.Container.removeByID("actives.mind_break");
	}

});

