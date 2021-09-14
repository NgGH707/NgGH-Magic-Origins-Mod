this.perk_champion <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.champion";
		this.m.Name = this.Const.Strings.PerkName.HexenChampion;
		this.m.Description = this.Const.Strings.PerkDescription.HexenChampion;
		this.m.Icon = "ui/perks/perk_champion.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.m.Container.hasSkill("racial.champion"))
		{
			local champion = this.new("scripts/skills/racial/champion_racial");
			champion.m.IsSerialized = false;
			this.m.Container.add(champion);
		}
	}

	function onRemoved()
	{
		this.m.Container.removeByID("racial.champion");
	}


});

