this.perk_nggh_ghost_phase_through <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.ghost_phase";
		this.m.Name = ::Const.Strings.PerkName.NggHGhostPhase;
		this.m.Description = ::Const.Strings.PerkDescription.NggHGhostPhase;
		this.m.Icon = "ui/perks/perk_ghost_phase.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.getContainer().hasSkill("actives.ghost_phase"))
		{
			this.getContainer().add(::new("scripts/skills/actives/nggh_mod_ghost_phase_through"));
		}
	}

	function onRemoved()
	{
		this.getContainer().removeByID("actives.ghost_phase");
	}

});

