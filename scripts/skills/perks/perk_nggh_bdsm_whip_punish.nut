this.perk_nggh_bdsm_whip_punish <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bdsm_whip_punish";
		this.m.Name = ::Const.Strings.PerkName.NggH_BDSM_WhipPunish;
		this.m.Description = ::Const.Strings.PerkDescription.NggH_BDSM_WhipPunish;
		this.m.Icon = "ui/perks/perk_bdsm_bad_boy_must_be_punished.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.getContainer().hasSkill("actives.hexe_whip"))
		{
			this.getContainer().add(::new("scripts/skills/hexe/nggh_mod_hexe_whip"));
		}
	}

	function onRemoved()
	{
		this.getContainer().removeByID("actives.hexe_whip");
	}

});

