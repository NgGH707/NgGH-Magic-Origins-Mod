nggh_mod_RSW_corrosion <- ::inherit("scripts/skills/skill", {
	m = {
		IsForceEnabled = false
	},
	function create()
	{
		::Legends.Effects.onCreate(this, ::Legends.Effect.NgGHRswCorrosion);
		m.Description = "Rune Sigil: Corrosion";
		m.Icon = "ui/rune_sigils/legend_rune_sigil.png";
		m.Type = ::Const.SkillType.Special | ::Const.SkillType.StatusEffect;
		m.Order = ::Const.SkillOrder.VeryLast;
		m.IsActive = false;
		m.IsStacking = false;
		m.IsHidden = true;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (!m.IsForceEnabled && (this.getItem() == null || _skill == null || !_skill.m.IsWeaponSkill))
			return;

		local actor = this.getContainer().getActor();

		if (!actor.isAlive() || actor.isDying())
			return;

		if (!_targetEntity.isAlive() || _targetEntity.isDying())
			return;

		if (_targetEntity.getFlags().has("lindwurm"))
			return;

		if ((_targetEntity.getFlags().has("body_immune_to_acid") || _targetEntity.getArmor(::Const.BodyPart.Body) <= 0) && (_targetEntity.getFlags().has("head_immune_to_acid") || _targetEntity.getArmor(::Const.BodyPart.Head) <= 0))
			return;

		local poison = _targetEntity.getSkills().getSkillByID("effects.lindwurm_acid");

		if (poison == null) {
			poison = ::new("scripts/skills/effects/lindwurm_acid_effect");
			_targetEntity.getSkills().add(poison);
			poison.m.TurnsLeft = 1;
		}
		else {
			poison.resetTime();
			poison.m.TurnsLeft = ::Math.min(2, poison.m.TurnsLeft);
		}

		spawnIcon("status_effect_78", _targetEntity.getTile());
	}

});

