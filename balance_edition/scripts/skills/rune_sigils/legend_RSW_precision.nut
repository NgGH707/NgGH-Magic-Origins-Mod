this.legend_RSW_precision <- this.inherit("scripts/skills/skill", {
	m = {
		IsForceEnabled = false,
		TurnsLefts = 1,
		IsSpent = false,
	},
	function create()
	{
		this.m.ID = "special.legend_RSW_precision";
		this.m.Name = "Rune Sigil: Precision";
		this.m.Description = "Rune Sigil: Precision";
		this.m.Icon = "ui/rune_sigils/legend_rune_sigil.png";
		this.m.Type = this.Const.SkillType.Special | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}

	function onTurnStart()
	{
		if (this.m.IsForceEnabled)
		{
		}
		else if (this.getItem() == null)
		{
			return;
		}

		if (++this.m.TurnsLefts >= 4)
		{
			this.m.TurnsLefts = 0;
			this.m.IsSpent = false;
			this.spawnIcon("falcon_circle", this.getContainer().getActor().getTile());
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == null || !_skill.m.IsWeaponSkill)
		{
			return;
		}

		if (this.m.TurnsLefts == 0 && !this.m.IsSpent)
		{
			_properties.MeleeSkill += 999;
			_properties.RangedSkill += 999;
		}
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill == null || !_skill.m.IsWeaponSkill)
		{
			return;
		}

		if (this.m.TurnsLefts == 0 && !this.m.IsSpent)
		{
			this.m.IsSpent = true;
		}
	}

	function onCombatStarted()
	{
		this.m.TurnsLefts = 1;
		this.m.IsSpent = false;
	}

});

