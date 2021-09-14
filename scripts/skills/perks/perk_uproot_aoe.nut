this.perk_uproot_aoe <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.uproot_aoe";
		this.m.Name = this.Const.Strings.PerkName.SchratUprootAoE;
		this.m.Description = this.Const.Strings.PerkDescription.SchratUprootAoE;
		this.m.Icon = "ui/perks/perk_uproot_aoe.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.m.Container.hasSkill("actives.uproot_aoe"))
		{
			this.m.Container.add(this.new("scripts/skills/actives/uproot_aoe_skill"));
		}
	}

	function onRemoved()
	{
		this.m.Container.removeByID("actives.uproot_aoe");
	}


});

