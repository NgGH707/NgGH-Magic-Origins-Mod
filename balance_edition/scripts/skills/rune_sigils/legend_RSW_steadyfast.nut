this.legend_RSW_steadfast <- this.inherit("scripts/skills/skill", {
	m = {
		IsForceEnabled = false
	},
	function create()
	{
		this.m.ID = "special.legend_RSW_steadfast";
		this.m.Name = "Rune Sigil: Steadfast";
		this.m.Description = "Rune Sigil: Steadfast";
		this.m.Icon = "ui/rune_sigils/legend_rune_sigil.png";
		this.m.Type = this.Const.SkillType.Special | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		if (this.m.IsForceEnabled)
		{
		}
		else if (this.getItem() == null)
		{
			return;
		}

		if (_skill == null || !_skill.m.IsWeaponSkill)
		{
			return;
		}

		local actor = this.getContainer().getActor();

		if (!actor.isAlive() || actor.isDying())
		{
			return;
		}

		local refund = this.Math.max(1, this.Math.min(2, _skill.getActionPointCost() / 2));
		actor.setActionPoints(actor.getActionPoints() + refund);
	}

});

