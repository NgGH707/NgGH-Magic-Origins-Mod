perk_nggh_alp_after_wake <- ::inherit("scripts/skills/skill", {
	m = {
		Mult = 0.9
	},
	function getMult()
	{
		return m.Mult;
	}

	function create()
	{
		m.ID = "perk.after_wake";
		m.Name = ::Const.Strings.PerkName.NggHAlpAfterWake;
		m.Description = ::Const.Strings.PerkDescription.NggHAlpAfterWake;
		m.Icon = "ui/perks/perk_after_wake.png";
		m.Type = ::Const.SkillType.Perk;
		m.Order = ::Const.SkillOrder.Perk;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = false;
	}

});

