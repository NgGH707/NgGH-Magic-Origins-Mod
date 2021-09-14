this.perk_shadow_copy <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.shadow_copy";
		this.m.Name = this.Const.Strings.PerkName.AlpShadowCopy;
		this.m.Description = this.Const.Strings.PerkDescription.AlpShadowCopy;
		this.m.Icon = "ui/perks/perk_afterimage.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.m.Container.hasSkill("actives.shadow_copy"))
		{
			this.m.Container.add(this.new("scripts/skills/actives/shadow_copy_skill"));
		}
	}

	function onRemoved()
	{
		this.m.Container.removeByID("actives.shadow_copy");
	}

});

