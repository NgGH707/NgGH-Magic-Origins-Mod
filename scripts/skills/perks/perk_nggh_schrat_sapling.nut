perk_nggh_schrat_sapling <- ::inherit("scripts/skills/skill", {
	m = {
		Bonus = 10,
	},
	function getBonus()
	{
		return m.Bonus;
	}

	function create()
	{
		m.ID = "perk.sapling";
		m.Name = ::Const.Strings.PerkName.NggHSchratSapling;
		m.Description = ::Const.Strings.PerkDescription.NggHSchratSapling;
		m.Icon = "ui/perks/perk_sapling.png";
		m.Type = ::Const.SkillType.Perk;
		m.Order = ::Const.SkillOrder.Perk;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = false;
	}

});

