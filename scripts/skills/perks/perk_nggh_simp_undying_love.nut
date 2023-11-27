this.perk_nggh_simp_undying_love <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.simp_undying_love";
		this.m.Name = ::Const.Strings.PerkName.NggH_Simp_UndyingLove;
		this.m.Description = ::Const.Strings.PerkDescription.NggH_Simp_UndyingLove;
		this.m.Icon = "ui/perks/perk_simp_undying_love.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.m.IsNew)
			return;

		if (!::MSU.isKindOf(this.getContainer().getActor(), "player"))
			return;

		if (this.getContainer().getActor().getBackground() == null)
			return;

		foreach (row in this.getContainer().getActor().getBackground().m.PerkTree)
		{
			foreach (perk in row)
			{
				if (perk.ID != this.m.ID)
					continue;

				perk.IsRefundable = false;
				break;
			}
		}

		local simp = this.getContainer().getSkillByID("effects.simp");

		if (simp != null)
			simp.gainSimpLevel();

		this.getContainer().getActor().m.PerkPointsSpent += 1;
		this.m.IsNew = false;
	}

	function onCombatStarted()
	{
		local actor = this.getContainer().getActor();

		if (!actor.isPlacedOnMap() || actor.getMoraleState() >= ::Const.MoraleState.Confident)
			return;

		local isValid = false;

		foreach (ally in ::Tactical.Entities.getFactionActors(actor.getFaction(), actor.getTile(), 1))
		{
			if (!ally.getFlags().has("Hexe"))
				continue;

			isValid = true;
			break;
		}

		if (!isValid)
			return;

		actor.setMoraleState(::Const.MoraleState.Confident);
	}

});

