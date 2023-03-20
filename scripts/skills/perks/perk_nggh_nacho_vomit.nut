this.perk_nggh_nacho_vomit <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.nacho_vomit";
		this.m.Name = ::Const.Strings.PerkName.NggHNachoVomit;
		this.m.Description = ::Const.Strings.PerkDescription.NggHNachoVomit;
		this.m.Icon = "ui/perks/perk_nacho_vomiting.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.getContainer().hasSkill("actives.nacho_vomit"))
		{
			this.getContainer().add(::new("scripts/skills/actives/nggh_mod_nacho_vomit_skill"));
		}
	}

	function onRemoved()
	{
		this.getContainer().removeByID("actives.nacho_vomit");
	}

});

