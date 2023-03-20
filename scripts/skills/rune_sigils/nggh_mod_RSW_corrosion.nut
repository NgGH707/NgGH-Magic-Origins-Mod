this.nggh_mod_RSW_corrosion <- ::inherit("scripts/skills/skill", {
	m = {
		IsForceEnabled = false
	},
	function create()
	{
		this.m.ID = "special.mod_RSW_corrosion";
		this.m.Name = "Rune Sigil: Corrosion";
		this.m.Description = "Rune Sigil: Corrosion";
		this.m.Icon = "ui/rune_sigils/legend_rune_sigil.png";
		this.m.Type = ::Const.SkillType.Special | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
		this.m.IsSerialized = false;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (this.m.IsForceEnabled)
		{
		}
		else if (this.getItem() == null || _skill == null || !_skill.m.IsWeaponSkill)
		{
			return;
		}

		local actor = this.getContainer().getActor();

		if (!actor.isAlive() || actor.isDying())
		{
			return;
		}

		if (!_targetEntity.isAlive() || _targetEntity.isDying())
		{
			return;
		}

		if (_targetEntity.getFlags().has("lindwurm"))
		{
			return;
		}

		if ((_targetEntity.getFlags().has("body_immune_to_acid") || _targetEntity.getArmor(::Const.BodyPart.Body) <= 0) && (_targetEntity.getFlags().has("head_immune_to_acid") || _targetEntity.getArmor(::Const.BodyPart.Head) <= 0))
		{
			return;
		}

		local poison = _targetEntity.getSkills().getSkillByID("effects.lindwurm_acid");

		if (poison == null)
		{
			poison = ::new("scripts/skills/effects/lindwurm_acid_effect");
			_targetEntity.getSkills().add(poison);
			poison.m.TurnsLeft = 1;
		}
		else
		{
			poison.resetTime();
			poison.m.TurnsLeft = ::Math.min(2, poison.m.TurnsLeft);
		}

		this.spawnIcon("status_effect_78", _targetEntity.getTile());
	}

});

