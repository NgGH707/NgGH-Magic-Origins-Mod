this.perk_nggh_alp_shadow_copy <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.shadow_copy";
		this.m.Name = ::Const.Strings.PerkName.NggHAlpShadowCopy;
		this.m.Description = ::Const.Strings.PerkDescription.NggHAlpShadowCopy;
		this.m.Icon = "ui/perks/perk_afterimage.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.getContainer().hasSkill("actives.shadow_copy"))
		{
			this.getContainer().add(::new("scripts/skills/actives/nggh_mod_shadow_copy_skill"));
		}
	}

	function onRemoved()
	{
		this.getContainer().removeByID("actives.shadow_copy");
	}

});

