this.perk_intimidate <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.intimidate";
		this.m.Name = this.Const.Strings.PerkName.LindwurmIntimidate;
		this.m.Description = this.Const.Strings.PerkDescription.LindwurmIntimidate;
		this.m.Icon = "ui/perks/perk_intimidate.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.m.Container.hasSkill("actives.intimidate"))
		{
			this.m.Container.add(this.new("scripts/skills/actives/intimidate_skill"));
		}
	}

	function onRemoved()
	{
		this.m.Container.removeByID("actives.intimidate");
	}

});

