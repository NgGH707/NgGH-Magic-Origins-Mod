this.legend_RSA_diehard <- this.inherit("scripts/skills/skill", {
	m = {
		IsForceEnabled = false,
		IsSpent = false,
		AddedNineLives = false,
	},
	function create()
	{
		this.m.ID = "special.legend_RSA_diehard";
		this.m.Name = "Rune Sigil: Die Hard";
		this.m.Description = "Rune Sigil: Die Hard";
		this.m.Icon = "ui/rune_sigils/legend_rune_sigil.png";
		this.m.Type = this.Const.SkillType.Special | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
		this.m.IsSerialized = false;
	}

	function onAdded()
	{
		this.removeSelf();
		return;

		if (this.m.IsForceEnabled)
		{
		}
		else if (this.getItem() == null || !this.Tactical.isActive())
		{
			return;
		}

		if (!this.getContainer().hasSkill("perk.nine_lives"))
		{
			this.getContainer().add(this.new("scripts/skills/perks/perk_nine_lives"));
			this.m.AddedNineLives = true;
		}
	}

	function activate()
	{
		if (this.m.IsForceEnabled)
		{
		}
		else if (this.getItem() == null)
		{
			return;
		}

		if (this.m.IsSpent)
		{
			return;
		}

		if (this.getContainer().hasSkill("effects.stunned"))
		{
			this.getContainer().removeByID("effects.stunned");
		}
		if (this.getContainer().hasSkill("effects.dazed"))
		{
			this.getContainer().removeByID("effects.dazed");
		}
		if (this.getContainer().hasSkill("effects.legend_dazed"))
		{
			this.getContainer().removeByID("effects.legend_dazed");
		}
		if (this.getContainer().hasSkill("effects.staggered"))
		{
			this.getContainer().removeByID("effects.staggered");
		}
		if (this.getContainer().hasSkill("effects.legend_baffled"))
		{
			this.getContainer().removeByID("effects.legend_baffled");
		}
		if (this.getContainer().hasSkill("effects.charmed"))
		{
			this.getContainer().removeByID("effects.charmed");
		}
		if (this.getContainer().hasSkill("effects.sleeping"))
		{
			this.getContainer().removeByID("effects.sleeping");
		}

		local actor = this.getContainer().getActor();
		actor.m.Hitpoints = this.Math.round(actor.getHitpointsMax() * 0.5);
		this.getContainer().add(this.new("scripts/skills/effects/diehard_effect"));
		this.m.IsSpent = true;
	}

	function onRemoved()
	{
		if (this.m.AddedNineLives)
		{
			this.getContainer().removeByID("perk.nine_lives");
			this.m.AddedNineLives = false;
		}
	}

	function onCombatStarted()
	{
		this.onAdded();
		this.m.IsSpent = false;
	}

	function onCombatFinished()
	{
		this.onRemoved();
		this.m.IsSpent = false;
	}

});

