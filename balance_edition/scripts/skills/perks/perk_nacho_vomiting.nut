this.perk_nacho_vomiting <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.nacho_vomiting";
		this.m.Name = this.Const.Strings.PerkName.NachoVomiting;
		this.m.Description = this.Const.Strings.PerkDescription.NachoVomiting;
		this.m.Icon = "ui/perks/perk_nacho_vomiting.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.m.Container.hasSkill("actives.nacho_vomiting"))
		{
			this.m.Container.add(this.new("scripts/skills/actives/mod_nacho_vomiting_skill"));
		}
	}

	function onRemoved()
	{
		this.m.Container.removeByID("actives.nacho_vomiting");
	}

});

