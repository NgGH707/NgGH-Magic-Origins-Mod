this.perk_nggh_lindwurm_intimidate <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.intimidate";
		this.m.Name = ::Const.Strings.PerkName.NggHLindwurmIntimidate;
		this.m.Description = ::Const.Strings.PerkDescription.NggHLindwurmIntimidate;
		this.m.Icon = "ui/perks/perk_intimidate.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.getContainer().hasSkill("actives.intimidate"))
		{
			this.getContainer().add(::new("scripts/skills/actives/nggh_mod_intimidate_skill"));
		}
	}

	function onRemoved()
	{
		this.getContainer().removeByID("actives.intimidate");
	}

});

