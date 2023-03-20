this.perk_nggh_schrat_uproot_aoe <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.uproot_aoe";
		this.m.Name = ::Const.Strings.PerkName.NggHSchratUprootAoE;
		this.m.Description = ::Const.Strings.PerkDescription.NggHSchratUprootAoE;
		this.m.Icon = "ui/perks/perk_uproot_aoe.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.getContainer().hasSkill("actives.uproot_aoe"))
		{
			this.getContainer().add(::new("scripts/skills/actives/nggh_mod_uproot_aoe_skill"));
		}
	}

	function onRemoved()
	{
		this.getContainer().removeByID("actives.uproot_aoe");
	}


});

