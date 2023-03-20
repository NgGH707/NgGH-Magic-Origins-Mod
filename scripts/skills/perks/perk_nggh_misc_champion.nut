this.perk_nggh_misc_champion <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.champion";
		this.m.Name = ::Const.Strings.PerkName.NggHMiscChampion;
		this.m.Description = ::Const.Strings.PerkDescription.NggHMiscChampion;
		this.m.Icon = "ui/perks/perk_champion.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.getContainer().hasSkill("racial.champion"))
		{
			local champion = ::new("scripts/skills/racial/champion_racial");
			champion.m.IsSerialized = false;
			this.getContainer().add(champion);
		}
	}

	function onRemoved()
	{
		this.getContainer().removeByID("racial.champion");
	}


});

