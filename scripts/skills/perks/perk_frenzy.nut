this.perk_frenzy <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.frenzy";
		this.m.Name = this.Const.Strings.PerkName.NachoFrenzy;
		this.m.Description = this.Const.Strings.PerkDescription.NachoFrenzy;
		this.m.Icon = "ui/perks/perk_madden.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.m.Container.hasSkill("actives.frenzy"))
		{
			this.m.Container.add(this.new("scripts/skills/actives/frenzy_skill"));
		}
	}

	function onRemoved()
	{
		this.m.Container.removeByID("actives.frenzy");
	}

});

