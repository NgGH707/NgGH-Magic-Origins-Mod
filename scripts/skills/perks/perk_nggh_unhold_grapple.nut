this.perk_nggh_unhold_grapple <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.unhold_grapple";
		this.m.Name = ::Const.Strings.PerkName.NggH_Unhold_Grapple;
		this.m.Description = ::Const.Strings.PerkDescription.NggH_Unhold_Grapple;
		this.m.Icon = "ui/perks/grapple_circle.png";
		this.m.IconDisabled = "ui/perks/rapple_circle_bw.png"
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.getContainer().hasSkill("actives.unhold_grapple"))
			this.getContainer().add(::new("scripts/skills/actives/nggh_mod_unhold_grapple"));
	}

	function onRemoved()
	{
		this.getContainer().removeByID("actives.unhold_grapple");
	}


});

