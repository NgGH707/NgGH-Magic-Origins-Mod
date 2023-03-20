this.perk_nggh_nacho_frenzy <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.frenzy";
		this.m.Name = ::Const.Strings.PerkName.NggHNachoFrenzy;
		this.m.Description = ::Const.Strings.PerkDescription.NggHNachoFrenzy;
		this.m.Icon = "ui/perks/perk_madden.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.getContainer().hasSkill("actives.frenzy"))
		{
			this.getContainer().add(::new("scripts/skills/actives/nggh_mod_frenzy_skill"));
		}
	}

	function onRemoved()
	{
		this.getContainer().removeByID("actives.frenzy");
	}

});

