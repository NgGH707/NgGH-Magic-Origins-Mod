this.mod_RSW_unstable <- this.inherit("scripts/skills/skill", {
	m = {
		IsForceEnabled = false
	},
	function create()
	{
		this.m.ID = "special.mod_RSW_unstable";
		this.m.Name = "Rune Sigil: Unstable";
		this.m.Description = "Rune Sigil: Unstable";
		this.m.Icon = "ui/rune_sigils/legend_rune_sigil.png";
		this.m.Type = this.Const.SkillType.Special | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (_targetEntity == null || _skill == null)
		{
			return;
		}

		if (this.m.IsForceEnabled)
		{
		}
		else if (this.getItem() == null)
		{
			return;
		}

		if (this.Math.rand(1, 100) < 90)
		{
			return;
		}

		_hitInfo.DamageRegular *= 2.0;
		_hitInfo.DamageArmor *= 2.0;
		this.spawnIcon("status_effect_106", _targetEntity.getTile());
		this.Tactical.EventLog.logEx("It\'s a devastating strike thanks to the rune on your weapon");
	}

});

